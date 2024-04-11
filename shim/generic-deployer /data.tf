data "aws_organizations_organization" "org" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ssm_parameter" "dns_domain" {
  name = "/env_info/dns_domain"
}

data "aws_ssm_parameter" "dns_wildcard_ssl_cert_arn" {
  name = "/env_info/dns_wildcard_ssl_cert_arn"
}

data "aws_iam_policy" "full_s3" {
  name = "AmazonS3FullAccess"
}

data "aws_ssm_parameter" "infosec_fw_cidrs" {
  name = "/env_info/infosec_fw_cidrs"
}

data "aws_ssm_parameter" "jump_host_cidrs" {
  name = "/env_info/jump_host_cidrs"
}

data "aws_ssm_parameter" "nexpose_cidrs" {
  name = "/env_info/nexpose_cidrs"
}

data "aws_ssm_parameter" "pci_ext_web_cidrs" {
  name = "/env_info/pci_ext_web_cidrs"
}

data "aws_ssm_parameter" "pci_int_app_cidrs" {
  name = "/env_info/pci_int_app_cidrs"
}

data "aws_ssm_parameter" "std_app_cidrs" {
  name = "/env_info/std_app_cidrs"
}

data "aws_ssm_parameter" "std_web_cidrs" {
  name = "/env_info/std_web_cidrs"
}

data "aws_ssm_parameter" "std_db_cidrs" {
  name = "/env_info/std_db_cidrs"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/env_info/vpc_id"
}

data "aws_ssm_parameter" "vpc_name" {
  name = "/env_info/vpc_name"
}

data "aws_ssm_parameter" "working_environment" {
  name = "/env_info/working_environment"
}

data "aws_ssm_parameter" "sub_env" {
  name = "/aft/account-request/custom-fields/account/sub_env"
}

data "aws_ssm_parameter" "sb_lb_listener_arn" {
  count = var.use_external_load_balancer_listner == true ? 1 : 0
  name  = "/springboot/lb_listener_arn"
}

data "aws_ssm_parameter" "g4pwa_lb_listener_arn" {
  count = var.use_path_based_listener == true ? 1 : 0
  name  = "/g4pwa/lb_listener_arn"
}

data "aws_ssm_parameter" "deployment_tools_cidrs" {
  name = "/org/accounts/aws-Prd-Deployments-Tools/vpc-cidr-block"  
}
