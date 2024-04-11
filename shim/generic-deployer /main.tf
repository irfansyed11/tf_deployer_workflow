module "generic_deployer" {
  source = "git::git@github.com:AllegiantTravelCo/tfmod-ami-deployer.git?ref=main"

  # (Module parameters are in alphabetical order, let's keep them at that way)
  allow_stickiness                   = var.allow_stickiness
  ansible_groups                     = var.ansible_groups
  ansible_group                      = var.ansible_group
  app_in_ports                       = local.app_in_ports
  apps                               = var.apps
  asg_policy_in                      = local.asg_policy_in
  asg_policy_out                     = local.asg_policy_out
  backend_service_port               = var.backend_service_port
  backend_service_protocol           = var.backend_service_protocol
  backup_schedule                    = var.backup_schedule
  bootstrap_script_inline            = local.bootstrap_script
  build_info                         = var.build_info
  business_unit                      = var.business_unit
  change_ticket                      = var.change_ticket
  compliance_status                  = var.compliance_status
  cost_center                        = var.cost_center
  default_vpc                        = var.vpc_name == null ? nonsensitive(data.aws_ssm_parameter.vpc_name.value) : var.vpc_name
  deployment_instance_type           = var.deployment_instance_type
  deployment_name                    = var.deployment_name
  dns_check                          = var.dns_check
  dns_cnames                         = var.dns_cnames
  domain_name                        = var.domain_name
  drop_invalid_header                = var.drop_invalid_header
  ec2_image_builder                  = var.ec2_image_builder
  ec2_schedule                       = var.ec2_schedule
  elb_health_check                   = local.elb_health_check
  elb_subnet_ids                     = var.elb_subnet_ids
  external_listener_arn              = var.use_external_load_balancer_listner == true ? data.aws_ssm_parameter.sb_lb_listener_arn[0].value : null
  ext_listener_arn_path_based        = var.use_path_based_listener == true ? jsondecode(data.aws_ssm_parameter.g4pwa_lb_listener_arn[0].value) : null
  external_listener_host             = local.hostname
  external_load_balancer             = local.external_load_balancer != null ? local.external_load_balancer : null
  longlived_with_ext_loadbalancer    = var.longlived_with_ext_loadbalancer
  feature_version                    = var.feature_version
  health_check_down_thresh           = var.health_check_down_thresh
  health_check_enabled               = var.health_check_enabled
  health_check_interval              = var.health_check_interval
  health_check_path                  = var.health_check_path
  health_check_ret_vals              = var.health_check_ret_vals
  health_check_timeout               = var.health_check_timeout
  health_check_type                  = var.health_check_type
  health_check_up_tresh              = var.health_check_up_tresh
  http_service_port                  = var.http_service_port
  idle_timeout                       = var.idle_timeout
  initial_deployment_ami_id          = local.initial_ami
  initiative_id                      = var.initiative_id
  instance_extra_disks               = var.instance_extra_disks
  instance_iam_profile               = aws_iam_instance_profile.ec2_iam_profile.name
  instance_ips                       = local.instance_ips
  internal_alb                       = var.internal_alb
  load_balancer_listeners            = local.load_balancer_listeners
  load_balancer_type                 = var.load_balancer_type
  need_ec2_tags                      = var.need_ec2_tags
  os                                 = var.os
  patch_group                        = var.patch_group
  persistent_team_name               = var.persistent_team_name
  product_name                       = var.product_name
  service_capacity                   = var.service_capacity
  service_health_check_wait          = var.service_health_check_wait
  service_max_size                   = var.service_max_size
  service_min_size                   = var.service_min_size
  service_port                       = var.service_port
  service_protocol                   = var.service_protocol
  ssl_service_port                   = var.ssl_service_port
  stack_name                         = var.stack_name
  stack_role                         = var.stack_role
  target_type                        = var.target_type
  use_autoscaling_group              = var.use_autoscaling_group
  use_ec2_instaces                   = var.use_ec2_instaces
  use_external_load_balancer_listner = var.use_external_load_balancer_listner
  use_path_based_listener            = var.use_path_based_listener
  use_load_balancer                  = var.use_load_balancer
  vertical_name                      = var.vertical_name
  additional_lb_certificate          = var.additional_lb_certificate
  path_priority_map                  = var.path_priority_map
  disable_nw_sg                      = var.disable_nw_sg
  preserve_client_ip                 = var.preserve_client_ip
  lb_stickiness_type                 = var.lb_stickiness_type
  external_lb_path_based_routing     = var.external_lb_path_based_routing
  enable_termination_protection      = var.enable_termination_protection
  enable_http2                       = var.enable_http2

}
