variable "vip_name" {
  description = "The name of the external elb(vip)"
  type        = string
  default     = null
}

variable "jboss_application_name" {
  description = "application name"
  type=string
  default = "jboss_standalone"
}

variable "jboss_scheduler" {
  description = "Indicates if its jboss scheduler"
  type        = bool
  default     = false
}
