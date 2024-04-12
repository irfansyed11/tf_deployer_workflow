public_management_cidr      = "98.187.3.0/24"
management_server           = "AWS-CMA243"
prod_configuration_template = "PRODCT-PROD-ASG"
corp_configuration_template = "PRODCT-CORP-ASG"
gateway_instance_type       = "c5.2xlarge"
key_name                    = "infosec-asg-kp"
gateway_version             = "R81.20-BYOL"
allocate_public_IP          = false
enable_cloudwatch           = true
gw_provision_address_type   = "private"
log_archive_account_id      = "509987883410"
chkp_template_url           = "https://cgi-cfts.s3.amazonaws.com/gwlb/autoscale-gwlb.yaml"
s3_template_url             = "https://chkp-autoscale-cft-330705608308-us-west-2.s3.us-west-2.amazonaws.com/autoscale-gwlb.yaml"


# --------------
# Firewall VPC
# --------------

prod_firewall_cidr_usw2            = "10.209.128.0/23"
prod_firewall_private_subnets_usw2 = ["10.209.128.0/28", "10.209.128.16/28"]
prod_firewall_public_subnets_usw2  = ["10.209.129.0/26", "10.209.129.64/26"]


corp_firewall_cidr_usw2            = "10.209.130.0/23"
corp_firewall_private_subnets_usw2 = ["10.209.130.0/28", "10.209.130.16/28"]
corp_firewall_public_subnets_usw2  = ["10.209.131.0/26", "10.209.131.64/26"]

prod_firewall_cidr_use2            = "10.217.128.0/23"
prod_firewall_private_subnets_use2 = ["10.217.128.0/28", "10.217.128.16/28"]
prod_firewall_public_subnets_use2  = ["10.217.129.0/26", "10.217.129.64/26"]

corp_firewall_cidr_use2            = "10.217.130.0/23"
corp_firewall_public_subnets_use2  = ["10.217.130.0/28", "10.217.130.16/28"]
corp_firewall_private_subnets_use2 = ["10.217.131.64/26", "10.217.131.128/26"]


# --------------
# Domain Services VPC
# --------------

domain_services_cidr_usw2            = "10.209.144.0/24"
domain_services_private_subnets_usw2 = ["10.209.144.0/26", "10.209.144.64/26", "10.209.144.128/26"]

domain_services_corp_cidr_usw2            = "10.209.145.0/24"
domain_services_corp_private_subnets_usw2 = ["10.209.145.0/26", "10.209.145.64/26", "10.209.145.128/26"]

domain_services_cidr_use2            = "10.217.144.0/24"
domain_services_private_subnets_use2 = ["10.217.144.0/26", "10.217.144.64/26", "10.217.144.128/26"]

domain_services_corp_cidr_use2            = "10.217.145.0/24"
domain_services_corp_private_subnets_use2 = ["10.217.145.0/26", "10.217.145.64/26", "10.217.145.128/26"]


# --------------
# Internet VPC
# --------------
internet_cidr_usw2            = "10.209.132.0/23"
internet_private_subnets_usw2 = ["10.209.132.0/28", "10.209.132.16/28"]
internet_public_subnets_usw2  = ["10.209.133.0/26", "10.209.133.64/26"]

internet_corp_cidr_usw2            = "10.209.134.0/23"
internet_corp_private_subnets_usw2 = ["10.209.134.0/28", "10.209.134.16/28"]
internet_corp_public_subnets_usw2  = ["10.209.135.0/26", "10.209.135.64/26"]

internet_cidr_use2            = "10.217.132.0/23"
internet_private_subnets_use2 = ["10.217.132.0/28", "10.217.132.16/28"]
internet_public_subnets_use2  = ["10.217.133.0/26", "10.217.133.64/26"]

internet_corp_cidr_use2            = "10.217.134.0/23"
internet_corp_private_subnets_use2 = ["10.217.134.0/28", "10.217.134.16/28"]
internet_corp_public_subnets_use2  = ["10.217.135.0/26", "10.217.135.64/26"]


# ---------------
# ALGT ProdCT CIDR 
# ---------------

algt_aws_cidr_blocks = ["10.208.0.0/12", "10.188.0.0/16", "10.173.0.0/16"]

# ---------------
# Corporate CIDR - Production
# ---------------
corporate_cidr_usw2          = "10.173.0.0/18"
corporate_standard_cidr_usw2 = "10.173.0.0/20"
corporate_dmz_cidr_usw2      = "10.173.16.0/20"

corporate_cidr_use2          = "10.173.128.0/18"
corporate_standard_cidr_use2 = "10.173.128.0/20"
corporate_dmz_cidr_use2      = "10.173.144.0/20"
# ---------------
# PCI CIDR - Production
# ---------------

pci_cidr_usw2                     = "10.188.0.0/18"
pci_production_cidr_usw2          = "10.188.0.0/20"
pci_production_internal_cidr_usw2 = "10.188.0.0/21"
pci_production_external_cidr_usw2 = "10.188.8.0/21"

pci_cidr_use2                     = "10.188.128.0/18"
pci_production_cidr_use2          = "10.188.128.0/19"
pci_production_internal_cidr_use2 = "10.188.128.0/21"
pci_production_external_cidr_use2 = "10.188.136.0/21"

# ---------------
# ProdCT CIDR - Production - US-West-2
# ---------------

ipam_pool_cidr_usw2 = "10.208.0.0/14"

production_cidr_usw2                                  = "10.208.0.0/15"
production_standard_cidr_usw2                         = "10.208.0.0/16"
production_confidential_cidr_usw2                     = "10.209.96.0/19"
production_infrastructure_cidr_usw2                   = "10.209.128.0/19"
production_infrastructure_exemption_block_1_cidr_usw2 = "10.209.128.0/20"
production_infrastructure_exemption_block_2_cidr_usw2 = "10.209.144.0/23"
production_infosec_cidr_usw2                          = "10.209.160.0/20"
production_deployments_cidr_usw2                      = "10.209.176.0/20"
production_vendor_cidr_usw2                           = "10.209.192.0/20"
production_exemptions_cidr_usw2                       = "10.209.208.0/20"

nonprod_cidr_usw2                                  = "10.210.0.0/15"
nonprod_dev_cidr_usw2                              = "10.210.0.0/17"
nonprod_dev_standard_cidr_usw2                     = "10.210.0.0/18"
nonprod_dev_confidential_cidr_usw2                 = "10.210.96.0/19"
nonprod_stage_cidr_usw2                            = "10.210.128.0/17"
nonprod_stage_standard_cidr_usw2                   = "10.210.128.0/18"
nonprod_stage_confidential_cidr_usw2               = "10.210.224.0/19"
nonprod_infrastructure_cidr_usw2                   = "10.211.96.0/19"
nonprod_infrastructure_exemption_block_1_cidr_usw2 = "10.211.96.0/20"
nonprod_infrastructure_exemption_block_2_cidr_usw2 = "10.211.112.0/23"
nonprod_infosec_cidr_usw2                          = "10.211.128.0/20"
nonprod_deployments_cidr_usw2                      = "10.211.144.0/20"
nonprod_training_cidr_usw2                         = "10.211.160.0/20"
nonprod_sandbox_cidr_usw2                          = "10.211.192.0/19"

nonprodpci_cidr_usw2                = "10.211.224.0/19"
nonprodpci_dev_cidr_usw2            = "10.211.224.0/20"
nonprodpci_dev_internal_cidr_usw2   = "10.211.224.0/21"
nonprodpci_dev_external_cidr_usw2   = "10.211.232.0/21"
nonprodpci_stage_cidr_usw2          = "10.211.240.0/20"
nonprodpci_stage_internal_cidr_usw2 = "10.211.240.0/21"
nonprodpci_stage_external_cidr_usw2 = "10.211.248.0/21"

# ---------------
# ProdCT CIDR - Production - US-East-2
# ---------------

ipam_pool_cidr_use2 = "10.216.0.0/14"

production_cidr_use2                                  = "10.216.0.0/15"
production_standard_cidr_use2                         = "10.216.0.0/16"
production_confidential_cidr_use2                     = "10.217.96.0/19"
production_infrastructure_cidr_use2                   = "10.217.128.0/19"
production_infrastructure_exemption_block_1_cidr_use2 = "10.217.128.0/20"
production_infrastructure_exemption_block_2_cidr_use2 = "10.217.144.0/23"
production_infosec_cidr_use2                          = "10.217.160.0/20"
production_deployments_cidr_use2                      = "10.217.176.0/20"
production_vendor_cidr_use2                           = "10.217.192.0/20"
production_exemptions_cidr_use2                       = "10.217.208.0/20"

nonprod_cidr_use2                                  = "10.218.0.0/15"
nonprod_dev_cidr_use2                              = "10.218.0.0/17"
nonprod_dev_standard_cidr_use2                     = "10.218.0.0/18"
nonprod_dev_confidential_cidr_use2                 = "10.218.96.0/19"
nonprod_stage_cidr_use2                            = "10.218.128.0/17"
nonprod_stage_standard_cidr_use2                   = "10.218.128.0/18"
nonprod_stage_confidential_cidr_use2               = "10.218.224.0/19"
nonprod_infrastructure_cidr_use2                   = "10.219.96.0/19"
nonprod_infrastructure_exemption_block_1_cidr_use2 = "10.219.96.0/20"
nonprod_infrastructure_exemption_block_2_cidr_use2 = "10.219.112.0/23"
nonprod_infosec_cidr_use2                          = "10.219.128.0/20"
nonprod_deployments_cidr_use2                      = "10.219.144.0/20"
nonprod_training_cidr_use2                         = "10.219.160.0/20"
nonprod_sandbox_cidr_use2                          = "10.219.192.0/19"

nonprodpci_cidr_use2                = "10.219.224.0/19"
nonprodpci_dev_cidr_use2            = "10.219.224.0/20"
nonprodpci_dev_internal_cidr_use2   = "10.219.224.0/21"
nonprodpci_dev_external_cidr_use2   = "10.219.232.0/21"
nonprodpci_stage_cidr_use2          = "10.219.240.0/20"
nonprodpci_stage_internal_cidr_use2 = "10.219.240.0/21"
nonprodpci_stage_external_cidr_use2 = "10.219.248.0/21"

# ---------------
# Legacy PROD (G4AWS-Master) CIDR US-West-2
# ---------------
legacy_aws_prod_cidr_usw2 = "10.174.0.0/16"

ct_environment = "prod-ct"
r53_domains = [
  "aws.allegiant.com",
  "dev01.aws.allegiant.com",
  "dev02.aws.allegiant.com",
  "stg01.aws.allegiant.com",
  "stg02.aws.allegiant.com",
  "prd01.aws.allegiant.com",
  "infra.aws.allegiant.com",
  "infra-np.aws.allegiant.com"
]
onprem_ad_dns_inbound = [ # we are limited to a total of 6 outbound targets, R53 Limitation
  # {
  #   ip_address  = "10.172.137.237"
  #   description = "AWSPRDADSDC01"
  # },
  # {
  #   ip_address  = "10.172.137.23"
  #   description = "AWSPRDADSDC02"
  # },
  # {
  #   ip_address  = "10.88.4.71"
  #   description = "LHQCRPADSDC01"
  # },
  # {
  #   ip_address  = "10.88.4.72"
  #   description = "LHQCRPADSDC02"
  # },
  {
    ip_address  = "10.14.132.72"
    description = "NDDCRPADSDC02"
  },
  # {
  #   ip_address  = "10.14.132.105"
  #   description = "NDDCRPADSDC03"
  # },
  # {
  #   ip_address  = "10.14.132.71"
  #   description = "NDDCRPADSDC04"
  # },
  {
    ip_address  = "10.209.145.10"
    description = "UW2CRPADSDC01"
  },
  # {
  #   ip_address  = "10.209.145.90"
  #   description = "UW2CRPADSDC02"
  # },
  {
    ip_address  = "10.209.144.10"
    description = "UW2PRDADSDC01"
  },
  {
    ip_address  = "10.209.144.90"
    description = "UW2PRDADSDC02"
  },
  {
    ip_address  = "10.12.132.71"
    description = "VSWCRPADSDC01"
  },
  # {
  #   ip_address  = "10.12.132.105"
  #   description = "VSWCRPADSDC03"
  # },
  {
    ip_address  = "10.12.132.72"
    description = "VSWCRPADSDC05"
  },
  # {
  #   ip_address  = "10.12.132.79"
  #   description = "VSWCRPADSDC07"
  # },
  # {
  #   ip_address  = "10.12.158.208"
  #   description = "VSWCRPFLGDC01"
  # },
  # {
  #   ip_address  = "10.12.158.209"
  #   description = "VSWCRPFLGDC02"
  # },
  # {
  #   ip_address  = "10.14.132.30"
  #   description = "NDDCRPFLGDC01"
  # },
  # {
  #   ip_address  = "10.14.132.31"
  #   description = "NDDCRPFLGDC02"
  # }
]
onprem_ad_dns_outbound = [
  {
    ip_address  = "10.172.137.237"
    description = "AWSPRDADSDC01"
  },
  {
    ip_address  = "10.172.137.23"
    description = "AWSPRDADSDC02"
  },
  {
    ip_address  = "10.88.4.71"
    description = "LHQCRPADSDC01"
  },
  {
    ip_address  = "10.88.4.72"
    description = "LHQCRPADSDC02"
  },
  {
    ip_address  = "10.14.132.72"
    description = "NDDCRPADSDC02"
  },
  {
    ip_address  = "10.14.132.105"
    description = "NDDCRPADSDC03"
  },
  {
    ip_address  = "10.14.132.71"
    description = "NDDCRPADSDC04"
  },
  {
    ip_address  = "10.209.145.10"
    description = "UW2CRPADSDC01"
  },
  {
    ip_address  = "10.209.145.90"
    description = "UW2CRPADSDC02"
  },
  {
    ip_address  = "10.209.144.10"
    description = "UW2PRDADSDC01"
  },
  {
    ip_address  = "10.209.144.90"
    description = "UW2PRDADSDC02"
  },
  {
    ip_address  = "10.12.132.71"
    description = "VSWCRPADSDC01"
  },
  {
    ip_address  = "10.12.132.105"
    description = "VSWCRPADSDC03"
  },
  {
    ip_address  = "10.12.132.72"
    description = "VSWCRPADSDC05"
  },
  {
    ip_address  = "10.12.132.79"
    description = "VSWCRPADSDC07"
  },
  {
    ip_address  = "10.12.158.208"
    description = "VSWCRPFLGDC01"
  },
  {
    ip_address  = "10.12.158.209"
    description = "VSWCRPFLGDC02"
  },
  {
    ip_address  = "10.14.132.30"
    description = "NDDCRPFLGDC01"
  },
  {
    ip_address  = "10.14.132.31"
    description = "NDDCRPFLGDC02"
  }
]
