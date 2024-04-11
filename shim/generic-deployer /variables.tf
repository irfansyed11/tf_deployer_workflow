variable "ansible_group" {
  description = "Automation Tags, used in Ansible playbook - Ex Val(s): aisap"
  type        = string
  default     = null
}

variable "ansible_groups" {
  description = "Automation Tags, used in Ansible playbook - Ex Val(s): [g4www,combo,cmbap]"
  type        = string
  default     = null
}

variable "ansible_vault" {
  description = "Ansible vault devops/uppers or devops/lowers"
  type        = string
  default     = null
}

variable "backup_schedule" {
  description = "Automation Tags, identifies backups/snapshots schedule - Ex Val(s): 6h|daily|weekly|monthly"
  type        = string
  default     = "weekly"
}

variable "build_info" {
  description = "Build Information Tag, We will start with Terraform repo but idea is to later replace it with Build info of the package used for the stack - Ex Val(s): Terraform Repo"
  type        = string
  default     = null
}

variable "business_unit" {
  description = "Business Unit Tag, Ex Val(s): Marketing/Stations/Teesnap"
  type        = string
}

variable "change_ticket" {
  description = "CM Ticket/Release Key Tag, Ex Val(s): CM123455"
  type        = string
  default     = null
}

variable "compliance_status" {
  description = "Compliance Tag, dynamic tag applied by Security Automation - Ex Val(s): compliant/non-compliant"
  type        = string
}

variable "cost_center" {
  description = "Cost Center Tag, Ex Val(s): 459/460/461"
  type        = string
}

variable "dns_cnames" {
  description = "List of host names for alb"
  type        = list(string)
  default     = []
}

variable "dns_check" {
  description = "DNS check for load balancer listener certificate allegiant.com|allegiantair.com"
  type        = string
  default     = "allegiant.com"
}

variable "deployment_instance_type" {
  description = "AWS EC2 Instance type and size"
  type        = string
  default     = "t3a.medium"
}

variable "deployment_name" {
  description = "Name of deployed app"
  type        = string
}

variable "domain_name" {
  description = "Domain Information Tag, Ex Val: Digital Customer System/Flight Operations System"
  type        = string
}

variable "external_load_balancer" {
  description = "The (Optional) ARN of the external load balancer (already create not by deployer)"
  type        = string
  default     = null
}

variable "ec2_schedule" {
  description = "Automation Tags, used with auto on/off lambdas for cost management - Ex Val(s): las_vegas_office_hours"
  type        = string
  default     = "always-on"
}

variable "feature_version" {
  description = "Feature Version Tag, Version of a specific Feature - Ex Val(s}: v1.5.10"
  type        = string
}

variable "fqdn" {
  description = "Fully qualified domain for deploy"
  type        = string
  default     = null
}

variable "health_check_type" {
  description = "The type of health check the autoscaling group will use on the instance: EC2 or ELB"
  type        = string
  default     = "EC2"
}

variable "health_check_down_thresh" {
  description = "On the ELB, number of consecutive health check fails before marking target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_enabled" {
  description = "Flag to enable ELB health check on target hosts"
  type        = bool
  default     = true
}

variable "preserve_client_ip" {
  description = "Flag to enable/disable preserve client IP"
  type        = bool
  default     = true
}

variable "health_check_interval" {
  description = "ELB health check interval in seconds"
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "ELB health check path"
  type        = string
  default     = "/"
}

variable "health_check_ret_vals" {
  description = "ELB health check HTTP return value range from target"
  type        = string
  default     = "200-299"
}

variable "health_check_timeout" {
  description = "ELB health check timeout in seconds"
  type        = number
  default     = 4
}

variable "health_check_up_tresh" {
  description = "On the ELB, number of consecutive health check successes before marking target healthy"
  type        = number
  default     = 3
}

variable "hostname_override" {
  description = "Hostname override for application which has more than 255 bytes in the deployment_name"
  type        = string
  default     = null
}

variable "http_service_port" {
  description = "The (optional) HTTP service port used by the elb listener"
  type        = string
  default     = null
}

variable "initiative_id" {
  description = "Jira Initiative ID Tag, Ex Val(s): san_123435"
  type        = string
}

variable "allow_stickiness" {
  description = "allow whether sticiness should enabled or disbaled for LB"
  type        = bool
  default     = true
}

variable "os" {
  description = "Operating System Tag, Ex Val(s): linux|windows"
  type        = string
  default     = "linux"
}

variable "patch_group" {
  description = "Automation Tags, identifiies patch group - Ex Val(s): awstbedpstest_test_dps_tbe_hours"
  type        = string
  default     = null
}

variable "persistent_team_name" {
  description = "Persistent Team Tag, Ex Val(s): partywolves/clouddoctors"
  type        = string
}

variable "load_balancer_type" {
  description = "Selects whether to use a network or application load balancer. Valid values: network, application."
  type        = string
  default     = "application"

  validation {
    condition     = var.load_balancer_type == "network" || var.load_balancer_type == "application" || var.load_balancer_type == null
    error_message = "Supported load_balancer_type value is either 'network' or 'application'."
  }
}

variable "product_name" {
  description = "Product Information Tag"
  type        = string
}

variable "sdlc_branch" {
  description = "Branch name for sdlc_deploy"
  type        = string
  default     = null
}

variable "service_capacity" {
  description = "Target number of hosts for ASG to start with"
  type        = number
  default     = 2
}

variable "service_health_check_wait" {
  description = "Seconds to wait before health checks are applied to a new instance"
  type        = number
  default     = 600
}

variable "service_max_size" {
  description = "Maximum number of hosts for ASG"
  type        = number
  default     = 8
}

variable "service_min_size" {
  description = "Minimum number of hosts for ASG"
  type        = number
  default     = 1
}

variable "service_port" {
  description = "The port the load balancer will send traffic"
  type        = string
  default     = null
}

variable "service_protocol" {
  description = "The port the load balancer will send traffic"
  type        = string
  default     = "HTTP"
}

variable "stack_name" {
  description = "Stack Tag, Ex Val: Commercial(Commercial+Corporate+Hospitality)/Operations(Airline Ops)"
  type        = string
}

variable "stack_role" {
  description = "Feature Role Tag, Ex Val(s): web, middleware, db"
  type        = string
  default     = null
}

variable "ssl_service_port" {
  description = "SSL service port"
  type        = string
  default     = null
}

variable "use_load_balancer" {
  description = "Indicates if the deployment should be fronted by a load balancer"
  type        = bool
  default     = false
}

variable "use_external_load_balancer_listner" {
  description = "Indicates if the deployment should be using external load balancer listners"
  type        = bool
  default     = false
}

variable "use_autoscaling_group" {
  description = "Indicates if the deployment should be fronted by a autoscaling group"
  type        = bool
  default     = false
}

variable "use_ec2_instaces" {
  description = "Indicates if there should be deployed instances (outside of asg)"
  type        = bool
  default     = false
}

variable "vertical_name" {
  description = "Vertical Information Tag, Ex Val: Commercial/Airline Ops/Corporate"
  type        = string
  default     = null
}

variable "wildcard_signed_certs" {
  description = "wildcard_signed_certs for ansible"
  type        = string
  default     = null
}

variable "instance_extra_disks" {
  description = "An object composed of maps that describe extra ebs disks"
  type        = map(any)
  default     = {}
}

variable "apps" {
  type        = list(any)
  description = "List of applications that make up the application group or application bundle"
  default     = []
}

variable "backend_service_port" {
  description = "backend service port"
  type        = string
  default     = null
}

variable "backend_service_protocol" {
  description = "backend service protocol"
  type        = string
  default     = null
}

variable "ec2_image_builder" {
  description = "True, if the AMIs are built using EC2 Image Builder"
  type        = bool
  default     = true
}

variable "need_ec2_tags" {
  description = "Do you need EC2 tags? True or False"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = null
}
variable "elb_subnet_ids" {
  description = "A list of security groups to associate with the elb"
  type        = list(string)
  default     = []
}
variable "target_type" {
  type        = string
  description = "target_type for Target Group"
  default     = "instance"
}
variable "internal_alb" {
  type        = bool
  description = "Internal ALB True/False"
  default     = true
}

variable "drop_invalid_header" {
  type        = bool
  description = "Drop invalid header - True/False"
  default     = false
}

variable "consul_server" {
  type        = string
  description = "consul_server other than default consul_server"
  default     = null
}

variable "consul_datacenter" {
  type        = string
  description = "consul_datacenter e.g. awsdev01|awsdev01_pci"
  default     = null
}

variable "idle_timeout" {
  default     = 60
  type        = string
  description = "The time in seconds that the connection is allowed to be idle."
}

variable "app_log_check" {
  default     = true
  type        = bool
  description = "To check app log is clean or not"
}
variable "additional_lb_certificate" {
  type    = bool
  default = false
}

variable "validate_tg_health" {
  type        = bool
  default     = true
  description = "Validate TG health in TF"
}

variable "use_snapshot_identifier" {
  description = "Run Environment specific setup"
  type        = bool
  default     = false
}

variable "use_redirect_listener" {
  description = "Indicates if it requires for create redirect_listener e.g. g4pwa , g4pwa3"
  type        = bool
  default     = false
}

variable "use_path_based_listener" {
  description = "Indicates if it requies path based listener or not e.g g4pwa , g4pwa3"
  type        = bool
  default     = false
}

variable "path_priority_map" {
  description = "Map of path list and priority for path-based routing"
  type = object({
    app_path_list = list(string)
    priority      = number
  })
  default = {
    app_path_list = ["/"]
    priority      = 1
  }
}

variable "disable_nw_sg" {
  description = "Disable Network Security Group"
  type        = bool
  default     = true

}
variable "lb_stickiness_type" {
  description = "Type of lb stickiness e.g NLB -> source_ip , ALB -> lb_cookie or app_cookie"
  type        = string
  default     = null
}

variable "external_lb_path_based_routing" {
  type    = map(any)
  default = {}
}

variable "enable_termination_protection" {
  description = "Set to true to enable termination protection, false to disable."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Enable or disable HTTP/2 for the ALB"
  type        = bool
  default     = true
}

variable "longlived_with_ext_loadbalancer" {
  description = "Is your application long lived with external load balancer? True or False "
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "vpc id passed in deployer (if any)"
  type        = string
  default     = null
}
