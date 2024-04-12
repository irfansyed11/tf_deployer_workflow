################################################################################
# Transit Gateway
################################################################################

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway
resource "aws_ec2_transit_gateway" "tgw_prod-us-west-2" {
  description = "This is the production Transit Gateway for the ${local.region} region"

  #amazon_side_asn =
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable" # This will eventually be disable, but for now enable and just use this one route table
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  tags = {
    Name = "TGW Prod ${local.region}"
  }
  #transit_gateway_cidr_blocks = 
}

resource "aws_flow_log" "tgw-flow-log-main-us-west-2" {
  iam_role_arn             = aws_iam_role.tgw-flow-log-main-us-west-2.arn
  log_destination          = aws_cloudwatch_log_group.tgw-flow-log-main-us-west-2.arn
  traffic_type             = "ALL"
  transit_gateway_id       = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  max_aggregation_interval = 60
  tags = {
    "Name" = "tgw-flow-logs-${aws_ec2_transit_gateway.tgw_prod-us-west-2.id}"
  }
}

resource "aws_flow_log" "tgw-flow-log-central-us-west-2" {
  log_destination          = "arn:aws:s3:::centralized-vpc-flow-logs-algt-logarchive-${data.aws_ssm_parameter.log_archive_account_id.value}"
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  transit_gateway_id       = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  max_aggregation_interval = 60
  tags = {
    "Name" = "tgw-flow-logs-${aws_ec2_transit_gateway.tgw_prod-us-west-2.id}"
  }
}

resource "aws_cloudwatch_log_group" "tgw-flow-log-main-us-west-2" {
  name              = "tgw-flow-logs/${aws_ec2_transit_gateway.tgw_prod-us-west-2.id}"
  retention_in_days = 30
}

resource "aws_iam_role" "tgw-flow-log-main-us-west-2" {
  name = "tgw-flow-logs-policy-${aws_ec2_transit_gateway.tgw_prod-us-west-2.id}"

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

resource "aws_iam_role_policy" "tgw-flow-log-main-us-west-2" {
  name = "tgw-flow-logs-policy-${aws_ec2_transit_gateway.tgw_prod-us-west-2.id}"
  role = aws_iam_role.tgw-flow-log-main-us-west-2.id

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
        "arn:aws:logs:us-west-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.tgw-flow-log-main-us-west-2.name}",
        "arn:aws:logs:us-west-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.tgw-flow-log-main-us-west-2.name}:log-stream:*"
        ]
    }
  ]
}
EOF
}

resource "aws_ec2_transit_gateway" "tgw_prod-us-east-2" {
  description = "This is the production Transit Gateway for the us-east-2 region"
  provider    = aws.us-east-2

  #amazon_side_asn =
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable" # This will eventually be disable, but for now enable and just use this one route table
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  tags = {
    Name = "TGW Prod us-east-2"
  }
  #transit_gateway_cidr_blocks = 
}

resource "aws_flow_log" "tgw-flow-log-main-us-east-2" {
  provider                 = aws.us-east-2
  iam_role_arn             = aws_iam_role.tgw-flow-log-main-us-east-2.arn
  log_destination          = aws_cloudwatch_log_group.tgw-flow-log-main-us-east-2.arn
  traffic_type             = "ALL"
  transit_gateway_id       = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  max_aggregation_interval = 60
  tags = {
    "Name" = "tgw-flow-logs-${aws_ec2_transit_gateway.tgw_prod-us-east-2.id}"
  }
}

resource "aws_flow_log" "tgw-flow-log-central-us-east-2" {
  provider                 = aws.us-east-2
  log_destination          = "arn:aws:s3:::centralized-vpc-flow-logs-algt-logarchive-${data.aws_ssm_parameter.log_archive_account_id.value}"
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  transit_gateway_id       = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  max_aggregation_interval = 60
  tags = {
    "Name" = "tgw-flow-logs-${aws_ec2_transit_gateway.tgw_prod-us-east-2.id}"
  }
}

resource "aws_cloudwatch_log_group" "tgw-flow-log-main-us-east-2" {
  provider          = aws.us-east-2
  name              = "tgw-flow-logs/${aws_ec2_transit_gateway.tgw_prod-us-east-2.id}"
  retention_in_days = 30
}

resource "aws_iam_role" "tgw-flow-log-main-us-east-2" {
  provider = aws.us-east-2
  name     = "tgw-flow-logs-policy-${aws_ec2_transit_gateway.tgw_prod-us-east-2.id}"

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

resource "aws_iam_role_policy" "tgw-flow-log-main-us-east-2" {
  provider = aws.us-east-2
  name     = "tgw-flow-logs-policy-${aws_ec2_transit_gateway.tgw_prod-us-east-2.id}"
  role     = aws_iam_role.tgw-flow-log-main-us-east-2.id

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
        "arn:aws:logs:us-east-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.tgw-flow-log-main-us-east-2.name}",
        "arn:aws:logs:us-east-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.tgw-flow-log-main-us-east-2.name}:log-stream:*"
      ]
    }
  ]
}
EOF
}

################################################################################
# Route Tables
################################################################################

# us-west-2

# The TGW automatically creates the progagation route table, but does not give it a name tag
# This resource rectifies that
# resource "aws_ec2_tag" "tgw_prod_propagation_route_table_tag-us-west-2" {
#   resource_id = aws_ec2_transit_gateway.tgw_prod-us-west-2.propagation_default_route_table_id
#   key         = "Name"
#   value       = "default"
# }

# Route Table to be applied to all "prod" IPAM managed VPC's that forces all traffic to traverse the Firewall
# A route table created on the TGW called “prod-spoke-associate-route” where all Prod spoke accounts will be directed to the firewall 
resource "aws_ec2_transit_gateway_route_table" "tgw_prod_to_fw-us-west-2" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  tags = {
    Name = "prod-spoke-associate-route"
  }
}

# Route Table to be applied to the "prod" Firewall VPC to bring traffic back to the spoke accounts or Internet VPC
# A route table created on the TGW called “prod-spoke-propagate-route” where all Prod spoke account traffic flows leaving the firewall can communicate with each other 
resource "aws_ec2_transit_gateway_route_table" "tgw_prod_fw_to_spokes-us-west-2" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  tags = {
    Name = "prod-spoke-propagate-route"
  }
}

# Route Table to be applied to all "corp" IPAM managed VPC's that forces all traffic to traverse the Firewall
# A route table created on the TGW called “corp-spoke-associate-route” where all Corp spoke accounts will be directed to the firewall 
resource "aws_ec2_transit_gateway_route_table" "tgw_corp_to_fw-us-west-2" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  tags = {
    Name = "corp-spoke-associate-route"
  }
}

# Route Table to be applied to the "corp" Firewall VPC to bring traffic back to the spoke accounts or Internet VPC
# A route table created on the TGW called “corp-spoke-propagate-route” where all Corp spoke account traffic flows leaving the firewall can communicate with each other 
resource "aws_ec2_transit_gateway_route_table" "tgw_corp_fw_to_spokes-us-west-2" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  tags = {
    Name = "corp-spoke-propagate-route"
  }
}

# Route Table to handle inter region and datacenter traffic
# A route table created on the TGW called “common-route” where peering connection attachments will be associated 
resource "aws_ec2_transit_gateway_route_table" "tgw_to_tgw-us-west-2" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  tags = {
    Name = "common-route"
  }
}

# Associate the "fw to spokes" Route Table to Firewall VPC for "prod"
# Firewall VPC attachments should be associated with the “xxxx-spoke-propagate-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_fw_to_spokes_association-us-west-2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Associate the "fw to spokes" Route Table to Firewall VPC for "corp"
# Firewall VPC attachments should be associated with the “xxxx-spoke-propagate-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_fw_to_spokes_corp_association-us-west-2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Associate the "common-route" Route Table to TGW Peering us-west-2 
# Attachments should be associated with the “common-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_common_tgw_peering_association-us-west-2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Associate the "common-route" Route Table to DXGW us-west-2 
# Attachments should be associated with the “common-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_common_dxgw-us-west-2" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}
# Associate the "common-route" Route Table to G4AWS-Master(Legacy) Prod_TGW_us-west-2 
# Attachments should be associated with the “common-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_common_g4aws_master_prod_tgw-us-west-2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_g4aws_master_prod_tgw_west-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# us-east-2

# The TGW automatically creates the progagation route table, but does not give it a name tag
# This resource rectifies that
# resource "aws_ec2_tag" "tgw_prod_propagation_route_table_tag-us-east-2" {
#   provider    = aws.us-east-2
#   resource_id = aws_ec2_transit_gateway.tgw_prod-us-east-2.propagation_default_route_table_id
#   key         = "Name"
#   value       = "default"
# }

# Route Table to be applied to all "prod" IPAM managed VPC's that forces all traffic to traverse the Firewall
# A route table created on the TGW called “prod-spoke-associate-route” where all Prod spoke accounts will be directed to the firewall
resource "aws_ec2_transit_gateway_route_table" "tgw_prod_to_fw-us-east-2" {
  provider           = aws.us-east-2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  tags = {
    Name = "prod-spoke-associate-route"
  }
}

# Route Table to be applied to the "prod" Firewall VPC to bring traffic back to the spoke accounts or Internet VPC
# A route table created on the TGW called “prod-spoke-propagate-route” where all Prod spoke account traffic flows leaving the firewall can communicate with each other 
resource "aws_ec2_transit_gateway_route_table" "tgw_prod_fw_to_spokes-us-east-2" {
  provider           = aws.us-east-2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  tags = {
    Name = "prod-spoke-propagate-route"
  }
}

# Route Table to be applied to all "corp" IPAM managed VPC's that forces all traffic to traverse the Firewall
# A route table created on the TGW called “corp-spoke-associate-route” where all Corp spoke accounts will be directed to the firewall 
resource "aws_ec2_transit_gateway_route_table" "tgw_corp_to_fw-us-east-2" {
  provider           = aws.us-east-2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  tags = {
    Name = "corp-spoke-associate-route"
  }
}

# Route Table to be applied to the "corp" Firewall VPC to bring traffic back to the spoke accounts or Internet VPC
# A route table created on the TGW called “corp-spoke-propagate-route” where all Corp spoke account traffic flows leaving the firewall can communicate with each other 
resource "aws_ec2_transit_gateway_route_table" "tgw_corp_fw_to_spokes-us-east-2" {
  provider           = aws.us-east-2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  tags = {
    Name = "corp-spoke-propagate-route"
  }
}

# Route Table to handle inter region and datacenter traffic
# A route table created on the TGW called “common-route” where peering connection attachments will be associated 
resource "aws_ec2_transit_gateway_route_table" "tgw_to_tgw-us-east-2" {
  provider           = aws.us-east-2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  tags = {
    Name = "common-route"
  }
}

# Propagate the "fw to spokes" Route Table to Firewall VPC for "prod"
# Firewall VPC attachments should be associated with the “xxxx-spoke-propagate-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_fw_to_spokes_association-us-east-2" {
  provider                       = aws.us-east-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Propagate the "fw to spokes" Route Table to Firewall VPC for "corp"
# Firewall VPC attachments should be associated with the “xxxx-spoke-propagate-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_fw_to_spokes_corp_association-us-east-2" {
  provider                       = aws.us-east-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Associate the "common-route" Route Table to TGW Peering us-east-2
# Attachments should be associated with the “common-route” table
resource "aws_ec2_transit_gateway_route_table_association" "tgw_prod_common_tgw_peering_association-us-east-2" {
  provider                       = aws.us-east-2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

################################################################################
# Transit Gateway Peering
################################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_prod_west-2_to_east-2_peer" {
  peer_account_id         = aws_ec2_transit_gateway.tgw_prod-us-east-2.owner_id
  peer_region             = "us-east-2"
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-east-2.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_prod-us-west-2.id

  tags = {
    Name = "TGW Peering Requestor from west-2 to east-2"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_prod_west-2_to_east-2_peer_accept" {
  provider                      = aws.us-east-2
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id

  tags = {
    Name = "Cross-account attachment west-2 to east-2"
  }
}
resource "aws_ec2_transit_gateway_peering_attachment" "tgw_prod_west-2_to_g4aws_master_prod_tgw_west-2_peer" {
  peer_account_id         = "759062848102"
  peer_region             = "us-west-2"
  peer_transit_gateway_id = "tgw-0cc1e897a72512f91"
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_prod-us-west-2.id

  tags = {
    Name = "TGW Peering Requestor from west-2 to G4aws_master_prod_tgw_west-2"
  }
}

################################################################################
# Resource Access Manager
################################################################################

# us-west-2

# RAM resource to share TGW to spokes governed by IPAM
resource "aws_ram_resource_share" "tgw_prod-us-west-2" {
  name                      = "TGW Prod ${local.region}"
  allow_external_principals = true
  permission_arns           = ["arn:aws:ram::aws:permission/AWSRAMDefaultPermissionTransitGateway"]
}

# RAM resource to associate TGW to RAM Share
resource "aws_ram_resource_association" "tgw_prod-us-west-2" {
  resource_arn       = aws_ec2_transit_gateway.tgw_prod-us-west-2.arn
  resource_share_arn = aws_ram_resource_share.tgw_prod-us-west-2.id
}

# # RAM share to prod OU
resource "aws_ram_principal_association" "tgw_prod-us-west-2" {
  for_each = local.prod_and_prod_pci_ous

  principal          = each.value.arn
  resource_share_arn = aws_ram_resource_share.tgw_prod-us-west-2.id
}

# RAM share to non-prod OU
resource "aws_ram_principal_association" "tgw_non-prod-us-west-2" {
  for_each = local.nonprod_and_corp_ous

  principal          = each.value.arn
  resource_share_arn = aws_ram_resource_share.tgw_prod-us-west-2.id
}

# RAM share to current master
resource "aws_ram_principal_association" "tgw_prod-us-west-2-master" {

  principal          = "759062848102"
  resource_share_arn = aws_ram_resource_share.tgw_prod-us-west-2.id
}

# DXG Association and Attachment from existing footprint
resource "aws_dx_gateway_association_proposal" "tgw_prod-us-west-2-dxgw-asso" {
  dx_gateway_id               = "169fbfe4-9893-4022-ba49-8cd26d2a46c3"
  dx_gateway_owner_account_id = "759062848102"
  associated_gateway_id       = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  allowed_prefixes            = var.algt_aws_cidr_blocks
}

data "aws_ec2_transit_gateway_dx_gateway_attachment" "dxgw_corp_tgw-us-west-2_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw_prod-us-west-2.id
  dx_gateway_id      = "169fbfe4-9893-4022-ba49-8cd26d2a46c3"
}

# us-east-2

# RAM resource to share TGW to spokes governed by IPAM
resource "aws_ram_resource_share" "tgw_prod-us-east-2" {
  provider                  = aws.us-east-2
  name                      = "TGW Prod ${local.region}"
  allow_external_principals = false
  permission_arns           = ["arn:aws:ram::aws:permission/AWSRAMDefaultPermissionTransitGateway"]
}

# RAM resource to associate TGW to RAM Share
resource "aws_ram_resource_association" "tgw_prod-us-east-2" {
  provider           = aws.us-east-2
  resource_arn       = aws_ec2_transit_gateway.tgw_prod-us-east-2.arn
  resource_share_arn = aws_ram_resource_share.tgw_prod-us-east-2.id
}

# RAM share to prod OU
resource "aws_ram_principal_association" "tgw_prod-us-east-2" {
  provider = aws.us-east-2
  for_each = local.prod_and_prod_pci_ous

  principal          = each.value.arn
  resource_share_arn = aws_ram_resource_share.tgw_prod-us-east-2.id
}

# RAM share to non-prod OU
resource "aws_ram_principal_association" "tgw_non-prod-us-east-2" {
  provider = aws.us-east-2
  for_each = local.nonprod_and_corp_ous

  principal          = each.value.arn
  resource_share_arn = aws_ram_resource_share.tgw_prod-us-east-2.id
}

################################################################################
# Outputs
################################################################################

output "tgw_prod-us-west-2" {
  value = aws_ec2_transit_gateway.tgw_prod-us-west-2
}

output "tgw_prod-us-east-2" {
  value = aws_ec2_transit_gateway.tgw_prod-us-east-2
}
