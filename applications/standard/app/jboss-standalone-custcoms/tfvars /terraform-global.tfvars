ansible_group         = "jbs002_custcoms"
ansible_groups        = "['jboss','jboss_standalone']"
build_info            = "git@github.com:AllegiantTravelCo/tf-ami-deployer-all-jboss-standalone.git"
business_unit         = "TODO: Find business_unit for custcoms"
compliance_status     = "compliant"
cost_center           = "TODO: Find cost_center for custcoms"
deployment_name       = "jboss-standalone-custcoms"
domain_name           = "TODO: Find domain_name for custcoms"
feature_version       = "TODO: Find feature_version for custcoms"
health_check_path     = "/custcoms-logging/info.json"
health_check_type     = "ELB"
http_service_port     = "8280"
initiative_id         = "TODO: Find initiative_id for custcoms"
os                    = "linux"
patch_group           = "TODO: Find patch_group for custcoms"
persistent_team_name  = "TODO: Find persistent_team_name for custcoms"
product_name          = "custcoms"
service_port          = "8280"
ssl_service_port      = "8643"
stack_name            = "TODO: Find stack_name for custcoms"
vertical_name         = "TODO: Find vertical_name for custcoms"
vip_name              = "jbshc1"
use_autoscaling_group = true
apps                  = ["custcoms-logging-web", "custcoms-web"]


external_lb_path_based_routing = {
  "custcoms-logging-web" = {
    load_balancer_name = "jboss-standalone-jbshc1-hc2-lb"
    routing            = { path = "/" }
    health_check       = { path = "/custcoms/" }
  }
  "custcoms-web" = {
    load_balancer_name = "jboss-standalone-jbshc1-hc2-lb"
    routing            = { path = "/" }
    health_check       = { path = "/custcoms/" }
  }
}
additional_lb_certificate = true
dns_check                 = "allegiantair.com"
