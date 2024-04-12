# Firewall variables

variable "chkp_template_url" {
  type        = string
  description = "URL for Check Point Public Template"
}

variable "s3_template_url" {
  type        = string
  description = "URL for Cloud Formation Template stored in s3 bucket"
}

variable "public_management_cidr" {
  type        = string
  description = "Public CIDR for Firewall Management Server"
}

variable "management_server" {
  type        = string
  description = "Firewall Management Server"
}

variable "prod_configuration_template" {
  type        = string
  description = "Configuration Template for Prod Management Server"
}

variable "corp_configuration_template" {
  type        = string
  description = "Configuration Template for Prod Management Server"
}
variable "gateway_instance_type" {
  type        = string
  description = "Instance Type for Gateway Server"
}

variable "key_name" {
  type        = string
  description = "Key Pair name for Gateway Servers"
}

variable "gateway_version" {
  type        = string
  description = "Firewall Gateway version"
}

variable "gw_provision_address_type" {
  type        = string
  description = "Determines if the gateways are provisioned using their private or public address"
  default     = "private"
}

variable "allocate_public_IP" {
  type        = bool
  description = "Allocate an Elastic IP for security gateway."
  default     = false
}

variable "enable_cloudwatch" {
  type        = bool
  description = "Report Check Point specific CloudWatch metrics"
  default     = false
}

variable "gateway_min_size" {
  type        = number
  description = "Minimum Gateway group size"
  default     = 2
}

variable "gateway_max_size" {
  type        = number
  description = "Maximum Gateway group size"
  default     = 10
}

variable "gateway_warm_pool" {
  type        = bool
  description = "Enable Auto Scale Warm Pools"
  default     = false
}

variable "gateway_warm_pool_max_size" {
  type        = number
  description = "Maximum Gateway warm pool size"
  default     = 4
}

variable "gateway_warm_pool_min_size" {
  type        = number
  description = "Maximum Gateway warm pool maintenance size"
  default     = 1
}

# Firewall VPC variables - us-west-2
variable "prod_firewall_cidr_usw2" {
  type        = string
  description = "CIDR for Firewall VPC in us-west-2"
}

variable "prod_firewall_public_subnets_usw2" {
  type        = list(any)
  description = "Public Subnets for Firewall VPC in us-west-2"
}

variable "prod_firewall_private_subnets_usw2" {
  type        = list(any)
  description = "Private Subnets for Firewall VPC in us-west-2"
}

variable "corp_firewall_cidr_usw2" {
  type        = string
  description = "Corp CIDR for Firewall VPC in us-west-2"
}

variable "corp_firewall_public_subnets_usw2" {
  type        = list(any)
  description = "Corp Public Subnets for Firewall VPC in us-west-2"
}

variable "corp_firewall_private_subnets_usw2" {
  type        = list(any)
  description = "Corp Private Subnets for Firewall VPC in us-west-2"
}

# Firewall VPC variables - us-east-2
variable "prod_firewall_cidr_use2" {
  type        = string
  description = "CIDR for Firewall VPC in us-east-2"
}

variable "prod_firewall_public_subnets_use2" {
  type        = list(any)
  description = "Public Subnets for Firewall VPC in us-east-2"
}

variable "prod_firewall_private_subnets_use2" {
  type        = list(any)
  description = "Private Subnets for Firewall VPC in us-east-2"
}

variable "corp_firewall_cidr_use2" {
  type        = string
  description = "Corp CIDR for Firewall VPC in us-east-2"
}

variable "corp_firewall_public_subnets_use2" {
  type        = list(any)
  description = "Corp Public Subnets for Firewall VPC in us-east-2"
}

variable "corp_firewall_private_subnets_use2" {
  type        = list(any)
  description = "Corp Private Subnets for Firewall VPC in us-east-2"
}

# Network VPC
variable "domain_services_cidr_usw2" {
  type        = string
  description = "Domain Services CIDR us-west-2"
}

variable "domain_services_private_subnets_usw2" {
  type        = list(any)
  description = "Domain Services private subnets us-west-2"
}

variable "domain_services_corp_cidr_usw2" {
  type        = string
  description = "Domain Services Corp CIDR us-west-2"
}

variable "domain_services_corp_private_subnets_usw2" {
  type        = list(any)
  description = "Domain Services Corp private subnets us-west-2"
}

variable "internet_cidr_usw2" {
  type        = string
  description = "Internet CIDR us-west-2"
}

variable "internet_private_subnets_usw2" {
  type        = list(any)
  description = "Internet private subnets us-west-2"
}

variable "internet_public_subnets_usw2" {
  type        = list(any)
  description = "Internet public subnets us-west-2"
}

variable "internet_corp_cidr_usw2" {
  type        = string
  description = "Internet Corp CIDR us-west-2"
}

variable "internet_corp_private_subnets_usw2" {
  type        = list(any)
  description = "Internet Corp private subnets us-west-2"
}

variable "internet_corp_public_subnets_usw2" {
  type        = list(any)
  description = "Internet Corp public subnets us-west-2"
}

variable "domain_services_cidr_use2" {
  type        = string
  description = "Domain Services CIDR us-east-2"
}

variable "domain_services_private_subnets_use2" {
  type        = list(any)
  description = "Domain Services private subnets us-east-2"
}

variable "domain_services_corp_cidr_use2" {
  type        = string
  description = "Domain Services Corp CIDR us-east-2"
}

variable "domain_services_corp_private_subnets_use2" {
  type        = list(any)
  description = "Domain Services Corp private subnets us-east-2"
}

variable "internet_cidr_use2" {
  type        = string
  description = "Internet CIDR us-east-2"
}

variable "internet_private_subnets_use2" {
  type        = list(any)
  description = "Internet private subnets us-east-2"
}

variable "internet_public_subnets_use2" {
  type        = list(any)
  description = "Internet public subnets us-east-2"
}

variable "internet_corp_cidr_use2" {
  type        = string
  description = "Internet Corp CIDR us-east-2"
}

variable "internet_corp_private_subnets_use2" {
  type        = list(any)
  description = "Internet Corp private subnets us-east-2"
}

variable "internet_corp_public_subnets_use2" {
  type        = list(any)
  description = "Internet Corp public subnets us-east-2"
}

variable "ct_environment" {
  type        = string
  description = "Control Tower Environment"
}


# IPAM Variables

variable "ipam_pool_cidr_use2" {
  type        = string
  description = "CT CIDR us-east-2"
}

# Corporate US-EAST-2 
variable "corporate_cidr_use2" {
  type        = string
  description = "Corporate OU CIDR us-east-2"
}

variable "corporate_standard_cidr_use2" {
  type        = string
  description = "Corporate Standard OU CIDR us-east-2"
}

variable "corporate_dmz_cidr_use2" {
  type        = string
  description = "Corporate DMZ OU CIDR us-east-2"
}

# PCI US-EAST-2

variable "pci_cidr_use2" {
  type        = string
  description = "PCI OU CIDR us-east-2"
}

variable "pci_production_cidr_use2" {
  type        = string
  description = "PCI Prod OU CIDR us-east-2"
}

variable "pci_production_internal_cidr_use2" {
  type        = string
  description = "PCI Prod Internal OU CIDR us-east-2"
}

variable "pci_production_external_cidr_use2" {
  type        = string
  description = "PCI Prod External OU CIDR us-east-2"
}

# Production US-EAST-2
variable "production_cidr_use2" {
  type        = string
  description = "Production OU CIDR us-east-2"
}

variable "production_standard_cidr_use2" {
  type        = string
  description = "Production Standard OU CIDR us-east-2"
}

variable "production_confidential_cidr_use2" {
  type        = string
  description = "Production Confidential OU CIDR us-east-2"
}

variable "production_infrastructure_cidr_use2" {
  type        = string
  description = "Production Infrastructure OU CIDR us-east-2"
}

variable "production_infrastructure_exemption_block_1_cidr_use2" {
  type        = string
  description = "Production Infrastructure Exemption Block-1 OU CIDR us-east-2"
}

variable "production_infrastructure_exemption_block_2_cidr_use2" {
  type        = string
  description = "Production Infrastructure Exemption Block-2 OU CIDR us-east-2"
}

variable "production_infosec_cidr_use2" {
  type        = string
  description = "Production Infosec OU CIDR us-east-2"
}

variable "production_deployments_cidr_use2" {
  type        = string
  description = "Production Deployments OU CIDR us-east-2"
}

variable "production_vendor_cidr_use2" {
  type        = string
  description = "Production Vendor OU CIDR us-east-2"
}

variable "production_exemptions_cidr_use2" {
  type        = string
  description = "Production Exemptions OU CIDR us-east-2"
}

# NonProd US-EAST-2
variable "nonprod_cidr_use2" {
  type        = string
  description = "NonProd OU CIDR us-east-2"
}

variable "nonprod_dev_cidr_use2" {
  type        = string
  description = "NonProd Dev OU CIDR us-east-2"
}

variable "nonprod_dev_standard_cidr_use2" {
  type        = string
  description = "NonProd Dev Standard OU CIDR us-east-2"
}

variable "nonprod_dev_confidential_cidr_use2" {
  type        = string
  description = "NonProd Dev Confidential OU CIDR us-east-2"
}

variable "nonprod_stage_cidr_use2" {
  type        = string
  description = "NonProd Stage OU CIDR us-east-2"
}

variable "nonprod_stage_standard_cidr_use2" {
  type        = string
  description = "NonProd Stage Standard OU CIDR us-east-2"
}

variable "nonprod_stage_confidential_cidr_use2" {
  type        = string
  description = "NonProd Confidential Standard OU CIDR us-east-2"
}

variable "nonprod_sandbox_cidr_use2" {
  type        = string
  description = "NonProd Sandbox OU CIDR us-east-2"
}

variable "nonprod_training_cidr_use2" {
  type        = string
  description = "NonProd Training OU CIDR us-east-2"
}

variable "nonprod_infosec_cidr_use2" {
  type        = string
  description = "NonProd Infosec OU CIDR us-east-2"
}

variable "nonprod_deployments_cidr_use2" {
  type        = string
  description = "NonProd Deployments OU CIDR us-east-2"
}

variable "nonprod_infrastructure_cidr_use2" {
  type        = string
  description = "NonProd Infrastructure OU CIDR us-east-2"
}

variable "nonprod_infrastructure_exemption_block_1_cidr_use2" {
  type        = string
  description = "NonProd Infrastructure Exemption Block-1 OU CIDR us-east-2"
}

variable "nonprod_infrastructure_exemption_block_2_cidr_use2" {
  type        = string
  description = "NonProd Infrastructure Exemption Block-2 OU CIDR us-east-2"
}

# NonProdPCI US-EAST-2
variable "nonprodpci_cidr_use2" {
  type        = string
  description = "NonProdPCI OU CIDR us-east-2"
}

variable "nonprodpci_dev_cidr_use2" {
  type        = string
  description = "NonProdPCI Dev OU CIDR us-east-2"
}

variable "nonprodpci_dev_internal_cidr_use2" {
  type        = string
  description = "NonProdPCI Dev Internal OU CIDR us-east-2"
}

variable "nonprodpci_dev_external_cidr_use2" {
  type        = string
  description = "NonProdPCI Dev External OU CIDR us-east-2"
}

variable "nonprodpci_stage_cidr_use2" {
  type        = string
  description = "NonProdPCI Stage OU CIDR us-east-2"
}

variable "nonprodpci_stage_internal_cidr_use2" {
  type        = string
  description = "NonProdPCI Stage Internal OU CIDR us-east-2"
}

variable "nonprodpci_stage_external_cidr_use2" {
  type        = string
  description = "NonProdPCI Stage External OU CIDR us-east-2"
}


# ----------------------------
# CIDRs for US-WEST-2 OUs
# ----------------------------

variable "ipam_pool_cidr_usw2" {
  type        = string
  description = "CT CIDR us-west-2"
}

# Corporate US-WEST-2 
variable "corporate_cidr_usw2" {
  type        = string
  description = "Corporate OU CIDR us-west-2"
}

variable "corporate_standard_cidr_usw2" {
  type        = string
  description = "Corporate Standard OU CIDR us-west-2"
}

variable "corporate_dmz_cidr_usw2" {
  type        = string
  description = "Corporate DMZ OU CIDR us-west-2"
}


# PCI US-WEST-2

variable "pci_cidr_usw2" {
  type        = string
  description = "PCI OU CIDR us-west-2"
}

variable "pci_production_cidr_usw2" {
  type        = string
  description = "PCI Prod OU CIDR us-west-2"
}

variable "pci_production_internal_cidr_usw2" {
  type        = string
  description = "PCI Prod Internal OU CIDR us-west-2"
}

variable "pci_production_external_cidr_usw2" {
  type        = string
  description = "PCI Prod External OU CIDR us-west-2"
}

# Production US-WEST-2
variable "production_cidr_usw2" {
  type        = string
  description = "Production OU CIDR us-west-2"
}

variable "production_standard_cidr_usw2" {
  type        = string
  description = "Production Standard OU CIDR us-west-2"
}

variable "production_confidential_cidr_usw2" {
  type        = string
  description = "Production Confidential OU CIDR us-west-2"
}

variable "production_infrastructure_cidr_usw2" {
  type        = string
  description = "Production Infrastructure OU CIDR us-west-2"
}

variable "production_infrastructure_exemption_block_1_cidr_usw2" {
  type        = string
  description = "Production Infrastructure Exemption Block-1 OU CIDR us-west-2"
}

variable "production_infrastructure_exemption_block_2_cidr_usw2" {
  type        = string
  description = "Production Infrastructure Exemption Block-2 OU CIDR us-west-2"
}

variable "production_infosec_cidr_usw2" {
  type        = string
  description = "Production Infosec OU CIDR us-west-2"
}

variable "production_deployments_cidr_usw2" {
  type        = string
  description = "Production Deployments OU CIDR us-west-2"
}

variable "production_vendor_cidr_usw2" {
  type        = string
  description = "Production Vendor OU CIDR us-west-2"
}

variable "production_exemptions_cidr_usw2" {
  type        = string
  description = "Production Exemptions OU CIDR us-west-2"
}

# NonProd us-west-2
variable "nonprod_cidr_usw2" {
  type        = string
  description = "NonProd OU CIDR us-west-2"
}

variable "nonprod_dev_cidr_usw2" {
  type        = string
  description = "NonProd Dev OU CIDR us-west-2"
}

variable "nonprod_dev_standard_cidr_usw2" {
  type        = string
  description = "NonProd Dev Standard OU CIDR us-west-2"
}

variable "nonprod_dev_confidential_cidr_usw2" {
  type        = string
  description = "NonProd Dev Confidential OU CIDR us-west-2"
}

variable "nonprod_stage_cidr_usw2" {
  type        = string
  description = "NonProd Stage OU CIDR us-west-2"
}

variable "nonprod_stage_standard_cidr_usw2" {
  type        = string
  description = "NonProd Stage Standard OU CIDR us-west-2"
}

variable "nonprod_stage_confidential_cidr_usw2" {
  type        = string
  description = "NonProd Confidential Standard OU CIDR us-west-2"
}

variable "nonprod_sandbox_cidr_usw2" {
  type        = string
  description = "NonProd Sandbox OU CIDR us-west-2"
}

variable "nonprod_training_cidr_usw2" {
  type        = string
  description = "NonProd Training OU CIDR us-west-2"
}

variable "nonprod_infosec_cidr_usw2" {
  type        = string
  description = "NonProd Infosec OU CIDR us-west-2"
}

variable "nonprod_deployments_cidr_usw2" {
  type        = string
  description = "NonProd Deployments OU CIDR us-west-2"
}

variable "nonprod_infrastructure_cidr_usw2" {
  type        = string
  description = "NonProd Infrastructure OU CIDR us-west-2"
}

variable "nonprod_infrastructure_exemption_block_1_cidr_usw2" {
  type        = string
  description = "NonProd Infrastructure Exemption Block-1 OU CIDR us-west-2"
}

variable "nonprod_infrastructure_exemption_block_2_cidr_usw2" {
  type        = string
  description = "NonProd Infrastructure Exemption Block-2 OU CIDR us-west-2"
}

# NonProdPCI us-west-2
variable "nonprodpci_cidr_usw2" {
  type        = string
  description = "NonProdPCI OU CIDR us-west-2"
}

variable "nonprodpci_dev_cidr_usw2" {
  type        = string
  description = "NonProdPCI Dev OU CIDR us-west-2"
}

variable "nonprodpci_dev_internal_cidr_usw2" {
  type        = string
  description = "NonProdPCI Dev Internal OU CIDR us-west-2"
}

variable "nonprodpci_dev_external_cidr_usw2" {
  type        = string
  description = "NonProdPCI Dev External OU CIDR us-west-2"
}

variable "nonprodpci_stage_cidr_usw2" {
  type        = string
  description = "NonProdPCI Stage OU CIDR us-west-2"
}

variable "nonprodpci_stage_internal_cidr_usw2" {
  type        = string
  description = "NonProdPCI Stage Internal OU CIDR us-west-2"
}

variable "nonprodpci_stage_external_cidr_usw2" {
  type        = string
  description = "NonProdPCI Stage External OU CIDR us-west-2"
}

# R53 Zones
variable "r53_domains" {
  type        = list(any)
  description = "Route53 Private Hosted Zone Domains"
}

variable "onprem_ad_dns_inbound" {
  type = set(object({
    ip_address  = string
    description = string
  }))
  description = "On Prem AD DNS servers to target for Route53 Forwarders"
}

variable "onprem_ad_dns_outbound" {
  type = set(object({
    ip_address  = string
    description = string
  }))
  description = "On Prem AD DNS that traffic will originate from to Route53 Resolvers"
}

variable "rfc1918_generic_private_cidr_1" {
  type        = string
  default     = "10.0.0.0/8"
  description = "Generic Private IP CIDR"

}

variable "rfc1918_generic_private_cidr_2" {
  type        = string
  default     = "172.16.0.0/12"
  description = "Generic Private IP CIDR"

}

variable "rfc1918_generic_private_cidr_3" {
  type        = string
  default     = "192.168.0.0/16"
  description = "Generic Private IP CIDR"

}
variable "generic_public_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Generic Private IP CIDR"

}
variable "legacy_aws_prod_cidr_usw2" {
  type        = string
  description = "Generic Private IP CIDR"

}

variable "algt_aws_cidr_blocks" {
  type        = list(any)
  description = "List of CIDR Blocks for AWS CT environment"
}

variable "log_archive_account_id" {
  type        = string
  description = "ID of the LogArchive account for specifying the R53 resolver log destination."
}
