##########################
#         Locals         #
##########################
locals {
  system_rule_association  = length(var.forward_excluded_domains) > 0 ? {for p in setproduct(keys(aws_route53_resolver_rule.system), var.rule_bound_vpc_ids): "${p[0]}-sys" => {rule = aws_route53_resolver_rule.system[p[0]], vpc_id = p[1]}} : {}
  forward_rule_association = length(var.forward_domains) > 0 ? {for p in setproduct(keys(aws_route53_resolver_rule.forward), var.rule_bound_vpc_ids): "${p[0]}-fwd" => {rule = aws_route53_resolver_rule.forward[p[0]], vpc_id = p[1]}} : {}
  system_resolver_rules    = [for rule_index, rule_value in aws_route53_resolver_rule.system : rule_value.id]
  forward_resolver_rules   = [for rule_index, rule_value in aws_route53_resolver_rule.forward : rule_value.id]
  all_resolver_rules       = concat(local.system_resolver_rules, local.forward_resolver_rules)
}

##########################
#          Data          #
##########################
data "aws_vpc" "selected" {
  count = length(var.rule_bound_vpc_ids)

  id = var.rule_bound_vpc_ids[count.index]
}

##########################
# R53 Resolver Endpoints #
##########################
resource "aws_route53_resolver_endpoint" "inbound" {
  name      = var.inbound_endpoint_name
  direction = "INBOUND"

  security_group_ids = aws_security_group.r53-resolver-sg[*].id

  dynamic "ip_address" {
    for_each = var.inbound_destinations
    iterator = destination

    content {
      subnet_id = lookup(destination.value, "subnet_id", null)
      ip        = lookup(destination.value, "ip_address", null)
    }
  }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  name      = var.outbound_endpoint_name
  direction = "OUTBOUND"

  security_group_ids = aws_security_group.r53-resolver-sg[*].id

  dynamic "ip_address" {
    for_each = var.outbound_destinations
    iterator = destination

    content {
      subnet_id = lookup(destination.value, "subnet_id", null)
      ip        = lookup(destination.value, "ip_address", null)
    }
  }
}

##########################
#   R53 Resolver Rules   #
##########################
resource "aws_route53_resolver_rule" "system" {
  for_each = toset(var.forward_excluded_domains)

  domain_name = each.value
  rule_type   = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id 
  dynamic "target_ip" {
    for_each = aws_route53_resolver_endpoint.inbound.ip_address
    iterator = target

    content {
      ip   = target.value.ip
      # port = lookup(target.value, "port", null)
    }
  }
}

resource "aws_route53_resolver_rule" "forward" {
  for_each = toset(var.forward_domains)

  domain_name          = each.value
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id
  dynamic "target_ip" {
    for_each = var.forward_targets
    iterator = target

    content {
      ip   = lookup(target.value, "ip_address", null)
      port = lookup(target.value, "port", null)
    }
  }
}

############################
# R53 Resolver Association #
############################
# resource "aws_route53_resolver_rule_association" "system" {
#   for_each = local.system_rule_association

#   resolver_rule_id = each.value.rule.id
#   vpc_id           = each.value.vpc_id
# }

resource "aws_route53_resolver_rule_association" "forward" {
  for_each = local.forward_rule_association

  resolver_rule_id = each.value.rule.id
  vpc_id           = each.value.vpc_id
}

##########################
#   R53 Security Group   #
##########################
resource "aws_security_group" "r53-resolver-sg" {
  count = length(data.aws_vpc.selected)

  name        = "r53-resolver-sg-${var.ram_share_name}"
  description = "Allow inbound and outbound on port 53"
  vpc_id      = var.rule_bound_vpc_ids[count.index]

  ingress {
    description      = "DNS Inbound UDP"
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    cidr_blocks      = [data.aws_vpc.selected[count.index].cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "DNS Inbound TCP"
    from_port        = 53
    to_port          = 53
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected[count.index].cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "DNS Inbound TCP From Windows DCs"
    from_port        = 53
    to_port          = 53
    protocol         = "tcp"
    prefix_list_ids = [var.windows_dc_prefix_list]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "DNS Inbound UDP From Windows DCs"
    from_port        = 53
    to_port          = 53
    protocol         = "udp"
    prefix_list_ids = [var.windows_dc_prefix_list]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    description      = "Allow All Outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  # tags = {
  #   Name = "allow_tls"
  # }
}

##########################
#   R53 Query Logging    #
##########################
resource "aws_route53_resolver_query_log_config" "send_to_logarchive" {
  name            = "send_to_logarchive"
  destination_arn = "arn:aws:s3:::${var.r53_log_bucket_name}"
}
    
resource "aws_route53_resolver_query_log_config_association" "query_logging" {
  for_each = toset(var.rule_bound_vpc_ids)
  
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.send_to_logarchive.id
  resource_id                  = each.value
}
    
##########################
#    RAM association     #
##########################
resource "aws_ram_resource_share" "ram_share" {
  name                      = var.ram_share_name
  allow_external_principals = false
}

resource "aws_ram_principal_association" "ram_principal_association" {
  for_each	         = toset(var.ram_share_principal)

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.ram_share.arn
}

resource "aws_ram_resource_association" "ram_resource_association-r53forward" {
  for_each = aws_route53_resolver_rule.forward

  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.ram_share.arn
}

resource "aws_ram_resource_association" "ram_resource_association-r53system" {
  for_each = aws_route53_resolver_rule.system

  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.ram_share.arn
}

##########################
#    Outputs             #
##########################
output "system_rules" {
  value = local.system_resolver_rules
}

output "forward_rules" {
  value = local.forward_resolver_rules
}

output "all_rules" {
  value = local.all_resolver_rules
}
