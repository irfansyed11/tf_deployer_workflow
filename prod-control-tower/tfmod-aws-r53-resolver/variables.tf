variable "inbound_endpoint_name" {
  description = "A name to assign the inbound endpoint"
  type        = string
  default     = null
}

variable "inbound_destinations" {
  description = <<-EOT
    "Define the subnets and/or IP address that DNS queries originating from
    on-prem will be forwarded. Required key: 'subnet_id'. Optional key: 'ip_address'."
  EOT
  type        = list(map(string))
  default     = []

  validation {
    condition     = length(var.inbound_destinations) >= 2
    error_message = "At least two destinations must be specified for redundancy."
  }
}

variable "outbound_endpoint_name" {
  description = "A name to assign the outbound endpoint"
  type        = string
  default     = null
}

variable "outbound_destinations" {
  description = <<-EOT
    "Define the subnets and/or IP address that DNS queries originating from
    the VPC will be forwarded. Required key: 'subnet_id'. Optional key: 'ip_address'."
  EOT
  type        = list(map(string))
  default     = []

  validation {
    condition     = length(var.outbound_destinations) >= 2
    error_message = "At least two destinations must be specified for redundancy."
  }
}

variable "forward_domains" {
  description = "Specify which domains should be forwarded"
  type        = list(string)
  default     = []

  validation {
    condition     = var.forward_domains != null
    error_message = "This variable is required. Empty list or otherwise."
  }
}

variable "forward_excluded_domains" {
  description = "Specify which domains should not be forwarded"
  type        = list(string)
  default     = []

  validation {
    condition     = var.forward_excluded_domains != null
    error_message = "This variable is required. Empty list or otherwise."
  }
}

variable "forward_targets" {
  description = <<-EOT
    "The target IPs when queries are forwarded. Required key: ip_address. Optional key: port.
    Initial implementation applies the same target to all forwarded domains."
  EOT
  type = list(map(string))
  default = [
    {
      ip_address = "10.172.137.237"
    },
    {
      ip_address = "10.172.137.23"
    }
  ]
}

variable "rule_bound_vpc_ids" {
  description = "The IDs of the VPCs that will be governed by the resolver rules"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to add to created AWS resources"
  type        = map(string)
  default     = {}
}

variable "tags_template" {
  description = "Expected tags for resources"
  type        = map(string)
  default     = {
    owner                = ""
    terraform            = "True"
    terraform_repo       = ""
    sub_env              = ""
    exp_date             = ""
    product              = ""
    jira                 = ""
    description          = ""
    prod                 = ""
    working_environment  = ""
  }
}

variable "r53_log_bucket_name" {
  description = "Name of the S3 bucket to send R53 resolver logs to"
  type        = string
}

variable "ram_share_name" {
    description = "RAM resource share name"
    type	= string
    default	= null
}

variable "ram_share_principal" {
    description = "Principals such AWS Account Id or Org ARN to share RAM resource with"
    type	= list(string)
    default	= []
}

variable "windows_dc_prefix_list" {
    description = "Principals such AWS Account Id or Org ARN to share RAM resource with"
    type	= string
}
