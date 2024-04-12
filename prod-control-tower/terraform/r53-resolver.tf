module "r53-resolver-us-west-2-prod" {
  source                   = "git::git@github.com:AllegiantTravelCo/tfmod-aws-r53-resolver.git?ref=1.0.6"
  inbound_endpoint_name    = "inbound"
  inbound_destinations     = [for x in module.vpc-west-2["domain-services"].private_subnets : { "subnet_id" = x }]
  outbound_endpoint_name   = "outbound"
  outbound_destinations    = [for x in module.vpc-west-2["domain-services"].private_subnets : { "subnet_id" = x }]
  forward_domains          = ["."]
  forward_excluded_domains = concat(local.domains, ["amazonaws.com"])
  forward_targets          = var.onprem_ad_dns_inbound
  rule_bound_vpc_ids = [
    module.vpc-west-2["domain-services"].vpc_id
  ]
  ram_share_name         = "prod-R53-resolver-rules"
  ram_share_principal    = [for x, y in local.prod_and_prod_pci_ous : y.arn]
  r53_log_bucket_name    = "centralized-r53-logs-algt-${var.log_archive_account_id}-us-west-2"
  windows_dc_prefix_list = aws_ec2_managed_prefix_list.domain_controllers-us-west-2.id
}

module "r53-resolver-us-west-2-nonprod" {
  source                   = "git::git@github.com:AllegiantTravelCo/tfmod-aws-r53-resolver.git?ref=1.0.6"
  inbound_endpoint_name    = "inbound"
  inbound_destinations     = [for x in module.vpc-west-2["domain-services-corp"].private_subnets : { "subnet_id" = x }]
  outbound_endpoint_name   = "outbound"
  outbound_destinations    = [for x in module.vpc-west-2["domain-services-corp"].private_subnets : { "subnet_id" = x }]
  forward_domains          = ["."]
  forward_excluded_domains = concat(local.domains, ["amazonaws.com"])
  forward_targets          = var.onprem_ad_dns_inbound
  rule_bound_vpc_ids = [
    module.vpc-west-2["domain-services-corp"].vpc_id
  ]
  ram_share_name         = "nonprod-R53-resolver-rules"
  ram_share_principal    = [for x, y in local.nonprod_and_corp_ous : y.arn]
  r53_log_bucket_name    = "centralized-r53-logs-algt-${var.log_archive_account_id}-us-west-2"
  windows_dc_prefix_list = aws_ec2_managed_prefix_list.domain_controllers-us-west-2.id
}

module "r53-resolver-us-east-2-prod" {
  source = "git::git@github.com:AllegiantTravelCo/tfmod-aws-r53-resolver.git?ref=1.0.6"
  providers = {
    aws = aws.us-east-2
  }
  inbound_endpoint_name    = "inbound"
  inbound_destinations     = [for x in module.vpc-east-2["domain-services"].private_subnets : { "subnet_id" = x }]
  outbound_endpoint_name   = "outbound"
  outbound_destinations    = [for x in module.vpc-east-2["domain-services"].private_subnets : { "subnet_id" = x }]
  forward_domains          = ["."]
  forward_excluded_domains = concat(local.domains, ["amazonaws.com"])
  forward_targets          = var.onprem_ad_dns_inbound
  rule_bound_vpc_ids = [
    module.vpc-east-2["domain-services"].vpc_id
  ]
  ram_share_name         = "prod-R53-resolver-rules"
  ram_share_principal    = [for x, y in local.prod_and_prod_pci_ous : y.arn]
  r53_log_bucket_name    = "centralized-r53-logs-algt-${var.log_archive_account_id}-us-west-2"
  windows_dc_prefix_list = aws_ec2_managed_prefix_list.domain_controllers-us-east-2.id
}

module "r53-resolver-us-east-2-nonprod" {
  source = "git::git@github.com:AllegiantTravelCo/tfmod-aws-r53-resolver.git?ref=1.0.6"
  providers = {
    aws = aws.us-east-2
  }
  inbound_endpoint_name    = "inbound"
  inbound_destinations     = [for x in module.vpc-east-2["domain-services-corp"].private_subnets : { "subnet_id" = x }]
  outbound_endpoint_name   = "outbound"
  outbound_destinations    = [for x in module.vpc-east-2["domain-services-corp"].private_subnets : { "subnet_id" = x }]
  forward_domains          = ["."]
  forward_excluded_domains = concat(local.domains, ["amazonaws.com"])
  forward_targets          = var.onprem_ad_dns_inbound
  rule_bound_vpc_ids = [
    module.vpc-east-2["domain-services-corp"].vpc_id
  ]
  ram_share_name         = "nonprod-R53-resolver-rules"
  ram_share_principal    = [for x, y in local.nonprod_and_corp_ous : y.arn]
  r53_log_bucket_name    = "centralized-r53-logs-algt-${var.log_archive_account_id}-us-west-2"
  windows_dc_prefix_list = aws_ec2_managed_prefix_list.domain_controllers-us-east-2.id
}
