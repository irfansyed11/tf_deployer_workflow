locals {
  us-west-2 = {
    domain-services = {
      tgw             = "prod"
      env             = "prod"
      tgw_attachment  = true
      cidr            = var.domain_services_cidr_usw2
      azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
      private_subnets = var.domain_services_private_subnets_usw2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
    domain-services-corp = {
      tgw             = "prod"
      env             = "corp"
      tgw_attachment  = true
      cidr            = var.domain_services_corp_cidr_usw2
      azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
      private_subnets = var.domain_services_corp_private_subnets_usw2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
    # endpoints = {
    #   tgw             = "prod"
    #   env             = "prod"
    #   tgw_attachment  = true
    #   cidr            = "10.175.40.0/22"
    #   azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
    #   private_subnets = ["10.175.40.0/24", "10.175.41.0/24", "10.175.42.0/24"]
    #   tags = {
    #     Terraform   = "true"
    #     ou_name     = data.aws_ssm_parameter.ou_name.value
    #     Environment = var.ct_environment
    #   }
    # }
    # endpoints-corp = {
    #   tgw             = "prod"
    #   env             = "corp"
    #   tgw_attachment  = true
    #   cidr            = "10.175.44.0/22"
    #   azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
    #   private_subnets = ["10.175.44.0/24", "10.175.45.0/24", "10.175.46.0/24"]
    #   tags = {
    #     Terraform   = "true"
    #     ou_name     = data.aws_ssm_parameter.ou_name.value
    #     Environment = var.ct_environment
    #   }
    # }
    internet = {
      tgw                = "prod"
      env                = "prod"
      tgw_attachment     = true
      enable_nat_gateway = true
      cidr               = var.internet_cidr_usw2
      azs                = ["us-west-2a", "us-west-2b"]
      create_igw         = true
      public_subnets     = var.internet_public_subnets_usw2
      private_subnets    = var.internet_private_subnets_usw2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
    internet-corp = {
      tgw                = "prod"
      env                = "corp"
      tgw_attachment     = true
      enable_nat_gateway = true
      cidr               = var.internet_corp_cidr_usw2
      azs                = ["us-west-2a", "us-west-2b"]
      create_igw         = true
      public_subnets     = var.internet_corp_public_subnets_usw2
      private_subnets    = var.internet_corp_private_subnets_usw2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
  }
  us-east-2 = {
    domain-services = {
      tgw             = "prod"
      env             = "prod"
      tgw_attachment  = true
      cidr            = var.domain_services_cidr_use2
      azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
      create_igw      = false
      private_subnets = var.domain_services_private_subnets_use2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
    domain-services-corp = {
      tgw             = "prod"
      env             = "corp"
      tgw_attachment  = true
      cidr            = var.domain_services_corp_cidr_use2
      azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
      create_igw      = false
      private_subnets = var.domain_services_corp_private_subnets_use2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
    # endpoints = {
    #   tgw             = "prod"
    #   env             = "prod"
    #   tgw_attachment  = true
    #   cidr            = "10.175.168.0/22"
    #   azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
    #   private_subnets = ["10.175.168.0/24", "10.175.169.0/24", "10.175.170.0/24"]
    #   tags = {
    #     Terraform   = "true"
    #     ou_name     = data.aws_ssm_parameter.ou_name.value
    #     Environment = var.ct_environment
    #   }
    # }
    # endpoints-corp = {
    #   tgw             = "prod"
    #   env             = "corp"
    #   tgw_attachment  = true
    #   cidr            = "10.175.172.0/22"
    #   azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
    #   private_subnets = ["10.175.172.0/24", "10.175.173.0/24", "10.175.174.0/24"]
    #   tags = {
    #     Terraform   = "true"
    #      ou_name     = data.aws_ssm_parameter.ou_name.value
    #     Environment = var.ct_environment
    #   }
    # }
    internet = {
      tgw                = "prod"
      env                = "prod"
      tgw_attachment     = true
      enable_nat_gateway = true
      cidr               = var.internet_cidr_use2
      azs                = ["us-east-2a", "us-east-2b"]
      create_igw         = true
      public_subnets     = var.internet_public_subnets_use2
      private_subnets    = var.internet_private_subnets_use2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
    internet-corp = {
      tgw                = "prod"
      env                = "corp"
      tgw_attachment     = true
      enable_nat_gateway = true
      cidr               = var.internet_corp_cidr_use2
      azs                = ["us-east-2a", "us-east-2b"]
      create_igw         = true
      public_subnets     = var.internet_corp_public_subnets_use2
      private_subnets    = var.internet_corp_private_subnets_use2
      tags = {
        Terraform   = "true"
        ou_name     = data.aws_ssm_parameter.ou_name.value
        Environment = var.ct_environment
      }
    }
  }
  route_table_vpcs_west-2 = {
    for k, v in local.us-west-2 : k => v
    if try(lookup(local.us-west-2, k, null).tgw_attachment, false) && try(lookup(local.us-west-2, k, null).enable_nat_gateway, false) == false
  }
  route_tables_to_populate_west-2 = flatten([
    for k, v in local.route_table_vpcs_west-2 : [
      for x in module.vpc-west-2[k].private_route_table_ids : merge(v, {
        name = k
        id   = x
      })
    ]
  ])
  route_table_vpcs_east-2 = {
    for k, v in local.us-east-2 : k => v
    if try(lookup(local.us-east-2, k, null).tgw_attachment, false) && try(lookup(local.us-east-2, k, null).enable_nat_gateway, false) == false
  }
  route_tables_to_populate_east-2 = flatten([
    for k, v in local.route_table_vpcs_east-2 : [
      for x in module.vpc-east-2[k].private_route_table_ids : merge(v, {
        name = k
        id   = x
      })
    ]
  ])
  us-west-2-production-rules-internet = flatten([
    for rule_index, rule_value in module.r53-resolver-us-west-2-prod.all_rules : [
      for vpc_key, vpc_value in module.vpc-west-2 : {
        "rule_id"  = rule_value
        "vpc_name" = vpc_value.name
        "vpc_id"   = vpc_value.vpc_id
      } if vpc_value.name == "internet"
    ]
  ])
  us-west-2-nonprod-rules-internet = flatten([
    for rule_index, rule_value in module.r53-resolver-us-west-2-nonprod.all_rules : [
      for vpc_key, vpc_value in module.vpc-west-2 : {
        "rule_id"  = rule_value
        "vpc_name" = vpc_value.name
        "vpc_id"   = vpc_value.vpc_id
      } if vpc_value.name == "internet-corp"
    ]
  ])
  us-east-2-production-rules-internet = flatten([
    for rule_index, rule_value in module.r53-resolver-us-east-2-prod.all_rules : [
      for vpc_key, vpc_value in module.vpc-east-2 : {
        "rule_id"  = rule_value
        "vpc_name" = vpc_value.name
        "vpc_id"   = vpc_value.vpc_id
      } if vpc_value.name == "internet"
    ]
  ])
  us-east-2-nonprod-rules-internet = flatten([
    for rule_index, rule_value in module.r53-resolver-us-east-2-nonprod.all_rules : [
      for vpc_key, vpc_value in module.vpc-east-2 : {
        "rule_id"  = rule_value
        "vpc_name" = vpc_value.name
        "vpc_id"   = vpc_value.vpc_id
      } if vpc_value.name == "internet-corp"
    ]
  ])
}

####################################################################################
# us-west-2
####################################################################################

module "vpc-west-2" {
  source                        = "terraform-aws-modules/vpc/aws"
  for_each                      = local.us-west-2
  manage_default_security_group = true
  name                          = each.key
  cidr                          = each.value.cidr

  azs                        = each.value.azs
  create_igw                 = try(each.value.create_igw, false)
  public_subnets             = try(can(each.value.public_subnets), false) ? each.value.public_subnets : []
  private_subnets            = try(can(each.value.private_subnets), false) ? each.value.private_subnets : []
  intra_subnets              = try(can(each.value.intra_subnets), false) ? each.value.intra_subnets : []
  default_route_table_routes = try(can(each.value.default_route_table_routes), false) ? each.value.default_route_table_routes : []
  enable_dns_hostnames       = true

  enable_nat_gateway     = try(can(each.value.enable_nat_gateway), false) ? each.value.enable_nat_gateway : false
  single_nat_gateway     = false
  one_nat_gateway_per_az = try(can(each.value.enable_nat_gateway), false) ? each.value.enable_nat_gateway : false
  enable_vpn_gateway     = false

  tags = each.value.tags
}

resource "aws_route53_resolver_rule_association" "us-west-2-production-resolver-rules" {
  for_each = { for rule_k, rule in local.us-west-2-production-rules-internet : rule_k => rule }

  resolver_rule_id = each.value.rule_id
  vpc_id           = each.value.vpc_id
}

resource "aws_route53_resolver_rule_association" "us-west-2-nonprod-resolver-rules" {
  for_each = { for rule_k, rule in local.us-west-2-nonprod-rules-internet : rule_k => rule }

  resolver_rule_id = each.value.rule_id
  vpc_id           = each.value.vpc_id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "us-west-2" {
  for_each = {
    for k, v in module.vpc-west-2 : k => v
    if try(lookup(local.us-west-2, k, null).tgw_attachment, false)
  }

  subnet_ids             = concat(each.value.private_subnets, each.value.intra_subnets)
  transit_gateway_id     = lookup(local.us-west-2, each.key, null).tgw == "prod" ? aws_ec2_transit_gateway.tgw_prod-us-west-2.id : each.value.tgw == "nonprod" ? aws_ec2_transit_gateway.tgw_prod-us-west-2.id : null
  vpc_id                 = each.value.vpc_id
  appliance_mode_support = try(lookup(local.us-west-2, each.key, null).appliance_mode_support, false) == "enable" ? "enable" : "disable"
  tags = {
    "Name" = "${each.key} vpc attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "us-west-2" {
  for_each = {
    for k, v in local.us-west-2 : k => v
    if try(lookup(local.us-west-2, k, null).tgw_attachment, false)
  }

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2["${each.key}"].id
  transit_gateway_route_table_id = each.value.env == "prod" ? aws_ec2_transit_gateway_route_table.tgw_prod_to_fw-us-west-2.id : aws_ec2_transit_gateway_route_table.tgw_corp_to_fw-us-west-2.id
}

resource "aws_ec2_transit_gateway_route" "us-west-2" {
  for_each = {
    for k, v in local.us-west-2 : k => v
    if try(lookup(local.us-west-2, k, null).tgw_attachment, false)
  }

  destination_cidr_block         = module.vpc-west-2["${each.key}"].vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2["${each.key}"].id
  transit_gateway_route_table_id = each.value.env == "prod" ? aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id : aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

resource "aws_ec2_transit_gateway_route" "us-west-2-propagate" {
  for_each = {
    for k, v in local.us-west-2 : k => v
    if try(lookup(local.us-west-2, k, null).tgw_attachment, false) && try(lookup(local.us-west-2, k, null).env, false) == "prod"
  }

  destination_cidr_block         = module.vpc-west-2["${each.key}"].vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

resource "aws_route" "route_to_tgw_us-west-2" {
  count = length(local.route_tables_to_populate_west-2)

  route_table_id         = local.route_tables_to_populate_west-2[count.index].id
  destination_cidr_block = var.generic_public_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
}

resource "aws_route" "inet_return_route_us-west-2" {
  route_table_id         = module.vpc-west-2["internet"].public_route_table_ids[0]
  destination_cidr_block = var.rfc1918_generic_private_cidr_1
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
}

resource "aws_route" "inet_return_route_corp_us-west-2" {
  route_table_id         = module.vpc-west-2["internet-corp"].public_route_table_ids[0]
  destination_cidr_block = var.rfc1918_generic_private_cidr_1
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
}

resource "aws_flow_log" "us-west-2-main" {
  for_each = {
    for k, v in module.vpc-west-2 : k => v
  }
  vpc_id          = each.value.vpc_id
  iam_role_arn    = aws_iam_role.us-west-2-main[each.key].arn
  log_destination = aws_cloudwatch_log_group.us-west-2-main[each.key].arn
  traffic_type    = "ALL"
  tags = {
    "Name" = "${each.key}-flow-logs"
  }
}

resource "aws_flow_log" "us-west-2-central" {
  for_each = {
    for k, v in module.vpc-west-2 : k => v
  }
  log_destination      = "arn:aws:s3:::centralized-vpc-flow-logs-algt-logarchive-${data.aws_ssm_parameter.log_archive_account_id.value}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = each.value.vpc_id
  tags = {
    "Name" = "${each.key}-flow-logs"
  }
}

resource "aws_cloudwatch_log_group" "us-west-2-main" {
  for_each = {
    for k, v in module.vpc-west-2 : k => v
  }
  name              = "vpc-flow-logs/${each.value.vpc_id}"
  retention_in_days = 30
}

resource "aws_iam_role" "us-west-2-main" {
  for_each = {
    for k, v in module.vpc-west-2 : k => v
  }
  name               = "flow-logs-policy-${each.value.vpc_id}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "us-west-2-main" {
  for_each = {
    for k, v in module.vpc-west-2 : k => v
  }
  name   = "flow-logs-policy-${each.value.vpc_id}"
  role   = aws_iam_role.us-west-2-main[each.key].id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:CreateLogDelivery",
        "logs:DeleteLogDelivery"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:us-west-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.us-west-2-main[each.key].name}",
        "arn:aws:logs:us-west-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.us-west-2-main[each.key].name}:log-stream:*"
      ]
    }
  ]
}
EOF
}

####################################################################################
# us-east-2
####################################################################################

module "vpc-east-2" {
  source   = "terraform-aws-modules/vpc/aws"
  for_each = local.us-east-2
  providers = {
    aws = aws.us-east-2
  }
  manage_default_security_group = true
  name                          = each.key
  cidr                          = each.value.cidr

  azs                        = each.value.azs
  create_igw                 = try(each.value.create_igw, false)
  public_subnets             = try(can(each.value.public_subnets), false) ? each.value.public_subnets : []
  private_subnets            = try(can(each.value.private_subnets), false) ? each.value.private_subnets : []
  intra_subnets              = try(can(each.value.intra_subnets), false) ? each.value.intra_subnets : []
  default_route_table_routes = try(can(each.value.default_route_table_routes), false) ? each.value.default_route_table_routes : []
  enable_dns_hostnames       = true

  enable_nat_gateway     = try(can(each.value.enable_nat_gateway), false) ? each.value.enable_nat_gateway : false
  single_nat_gateway     = false
  one_nat_gateway_per_az = try(can(each.value.enable_nat_gateway), false) ? each.value.enable_nat_gateway : false
  enable_vpn_gateway     = false

  tags = each.value.tags
}

resource "aws_route53_resolver_rule_association" "us-east-2-production-resolver-rules" {
  for_each = { for rule_k, rule in local.us-east-2-production-rules-internet : rule_k => rule }
  provider = aws.us-east-2

  resolver_rule_id = each.value.rule_id
  vpc_id           = each.value.vpc_id
}

resource "aws_route53_resolver_rule_association" "us-east-2-nonprod-resolver-rules" {
  for_each = { for rule_k, rule in local.us-east-2-nonprod-rules-internet : rule_k => rule }
  provider = aws.us-east-2

  resolver_rule_id = each.value.rule_id
  vpc_id           = each.value.vpc_id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "us-east-2" {
  for_each = {
    for k, v in module.vpc-east-2 : k => v
    if try(lookup(local.us-east-2, k, null).tgw_attachment, false)
  }
  provider = aws.us-east-2

  subnet_ids             = concat(each.value.private_subnets, each.value.intra_subnets)
  transit_gateway_id     = lookup(local.us-east-2, each.key, null).tgw == "prod" ? aws_ec2_transit_gateway.tgw_prod-us-east-2.id : each.value.tgw == "nonprod" ? aws_ec2_transit_gateway.tgw_prod-us-west-2.id : null
  vpc_id                 = each.value.vpc_id
  appliance_mode_support = try(lookup(local.us-east-2, each.key, null).appliance_mode_support, false) == "enable" ? "enable" : "disable"
  tags = {
    "Name" = "${each.key} vpc attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "us-east-2" {
  for_each = {
    for k, v in local.us-east-2 : k => v
    if try(lookup(local.us-east-2, k, null).tgw_attachment, false)
  }
  provider = aws.us-east-2

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2["${each.key}"].id
  transit_gateway_route_table_id = each.value.env == "prod" ? aws_ec2_transit_gateway_route_table.tgw_prod_to_fw-us-east-2.id : aws_ec2_transit_gateway_route_table.tgw_corp_to_fw-us-east-2.id
}

resource "aws_ec2_transit_gateway_route" "us-east-2" {
  for_each = {
    for k, v in local.us-east-2 : k => v
    if try(lookup(local.us-east-2, k, null).tgw_attachment, false)
  }
  provider = aws.us-east-2

  destination_cidr_block         = module.vpc-east-2["${each.key}"].vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2["${each.key}"].id
  transit_gateway_route_table_id = each.value.env == "prod" ? aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id : aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

resource "aws_ec2_transit_gateway_route" "us-east-2-propagate" {
  for_each = {
    for k, v in local.us-east-2 : k => v
    if try(lookup(local.us-east-2, k, null).tgw_attachment, false) && try(lookup(local.us-east-2, k, null).env, false) == "prod"
  }
  provider = aws.us-east-2

  destination_cidr_block         = module.vpc-east-2["${each.key}"].vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

resource "aws_route" "route_to_tgw_us-east-2" {
  count    = length(local.route_tables_to_populate_east-2)
  provider = aws.us-east-2

  route_table_id         = local.route_tables_to_populate_east-2[count.index].id
  destination_cidr_block = var.generic_public_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
}

resource "aws_route" "inet_return_route_us-east-2" {
  provider = aws.us-east-2

  route_table_id         = module.vpc-east-2["internet"].public_route_table_ids[0]
  destination_cidr_block = var.rfc1918_generic_private_cidr_1
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
}

resource "aws_route" "inet_return_route_corp_us-east-2" {
  provider = aws.us-east-2

  route_table_id         = module.vpc-east-2["internet-corp"].public_route_table_ids[0]
  destination_cidr_block = var.rfc1918_generic_private_cidr_1
  transit_gateway_id     = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
}

resource "aws_flow_log" "us-east-2-main" {
  for_each = {
    for k, v in module.vpc-east-2 : k => v
  }
  provider = aws.us-east-2

  vpc_id          = each.value.vpc_id
  iam_role_arn    = aws_iam_role.us-east-2-main[each.key].arn
  log_destination = aws_cloudwatch_log_group.us-east-2-main[each.key].arn
  traffic_type    = "ALL"
  tags = {
    "Name" = "${each.key}-flow-logs"
  }
}

resource "aws_flow_log" "us-east-2-central" {
  for_each = {
    for k, v in module.vpc-east-2 : k => v
  }
  provider = aws.us-east-2

  log_destination      = "arn:aws:s3:::centralized-vpc-flow-logs-algt-logarchive-${data.aws_ssm_parameter.log_archive_account_id.value}"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = each.value.vpc_id
  tags = {
    "Name" = "${each.key}-flow-logs"
  }
}

resource "aws_cloudwatch_log_group" "us-east-2-main" {
  for_each = {
    for k, v in module.vpc-east-2 : k => v
  }
  provider = aws.us-east-2

  name              = "vpc-flow-logs/${each.value.vpc_id}"
  retention_in_days = 30
}

resource "aws_iam_role" "us-east-2-main" {
  for_each = {
    for k, v in module.vpc-east-2 : k => v
  }
  provider = aws.us-east-2

  name               = "flow-logs-policy-${each.value.vpc_id}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "us-east-2-main" {
  for_each = {
    for k, v in module.vpc-east-2 : k => v
  }
  provider = aws.us-east-2

  name   = "flow-logs-policy-${each.value.vpc_id}"
  role   = aws_iam_role.us-east-2-main[each.key].id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:CreateLogDelivery",
        "logs:DeleteLogDelivery"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:us-east-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.us-east-2-main[each.key].name}",
        "arn:aws:logs:us-east-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.us-east-2-main[each.key].name}:log-stream:*"
      ]
    }
  ]
}
EOF
}

####################################################################################
# Outputs
####################################################################################

output "tgw_attachment_network-us-west-2" {
  value = aws_ec2_transit_gateway_vpc_attachment.us-west-2
}

output "tgw_attachment_network-us-east-2" {
  value = aws_ec2_transit_gateway_vpc_attachment.us-east-2
}
