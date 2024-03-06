
data "aws_ssm_parameter" "initial_ami" {
  name = "/ami-builder/standard-springboot-ami-${local.environment}/latest"
}

data "aws_ssm_parameter" "sb_efs_id" {
  name = "/efs/springboot_efs/efs_fs_id"
}

data "aws_ssm_parameter" "sb_cloud_efs_id" {
  name = "/efs/springboot_efs/g4_spring_cloud_config"
}

data "aws_ssm_parameter" "sb_zb_efs_id" {
  name = "/efs/springboot_efs/zb_config"
}

data "aws_ssm_parameter" "sb_bulk_efs_id" {
  name = "/efs/springboot_efs/bulk_cancel"
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  sb_allow_cidrs = format("%s,%s,%s,%s,%s",
    nonsensitive(data.aws_ssm_parameter.std_app_cidrs.value),
    nonsensitive(data.aws_ssm_parameter.std_web_cidrs.value),
    nonsensitive(data.aws_ssm_parameter.pci_ext_web_cidrs.value),
    nonsensitive(data.aws_ssm_parameter.pci_int_app_cidrs.value),
    nonsensitive(data.aws_ssm_parameter.jump_host_cidrs.value)
  )
  sub_env = data.aws_ssm_parameter.sub_env.value
  fqdn  = "${local.sub_env}.aws.allegiant.com"
  working_environment = "aws${local.sub_env}"
  environment = trim(local.sub_env,substr(local.sub_env, -2,-1 ))
  initial_ami = nonsensitive(data.aws_ssm_parameter.initial_ami.value)
  aws_resource_name_prefix = replace(var.deployment_name,"_", "-")
  service_name = join("-", slice(split("-", var.deployment_name), 1, length(split("-", var.deployment_name))))
  hostname  = var.hostname_override == null?"${var.deployment_name}.${local.fqdn}": "${var.hostname_override}.${local.fqdn}"
  consul_server = var.consul_server == null? "consul_server": var.consul_server
  consul_datacenter = var.consul_datacenter == null? "${local.working_environment}": var.consul_datacenter
  asg_policy_out = { scaling_adjustment = "1", cooldown = "300" }
  asg_policy_in  = { scaling_adjustment = "-1", cooldown = "300" }
  instance_ips = []
  load_balancer_listeners = {}
  elb_health_check = {}
  external_load_balancer = null
  region  = data.aws_region.current.name
  efs_id = data.aws_ssm_parameter.sb_efs_id.value
  efs_cloud_config = data.aws_ssm_parameter.sb_cloud_efs_id.value
  efs_zb_config = data.aws_ssm_parameter.sb_zb_efs_id.value
  efs_bulk_cancel = data.aws_ssm_parameter.sb_bulk_efs_id.value
  bootstrap_script = <<EOF
#cloud-config

runcmd:
  - hostname $(curl -X GET http://169.254.169.254/latest/meta-data/local-hostname | cut -d . -f1).${data.aws_region.current.name}.compute.internal
  - echo "127.0.0.1 localhost" > /etc/hosts
  - ifconfig |grep "inet " |grep cast|tr -d 'addr:' |awk '{print $2" "}' |tr -d '\n' >> /etc/hosts
  - echo "$(hostname) $(hostname -s)" >> /etc/hosts
  - echo -e '[${var.ansible_group}]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}'  > /etc/ansible/hosts
  - echo -e '[${var.ansible_group}_odd]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}' >> /etc/ansible/hosts
  - echo -e '[conap]\n${local.consul_server}.${local.fqdn} working_environment=${local.working_environment}' >> /etc/ansible/hosts
  - echo -e '[spnws0]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}' >> /etc/ansible/hosts
  - echo -e '#! /bin/bash\n/usr/bin/echo $G4_VAULT_PASS' > /root/env-vault.sh
  - chmod 700 /root/env-vault.sh
  - systemctl stop consul
  - rm -rf /var/consul/*
  - systemctl enable consul
  - echo "${local.efs_id} /opt/g4/support/g4-spring-cloud-config/application-config efs _netdev,noresvport,tls,accesspoint=${local.efs_cloud_config} 0 0" >>/etc/fstab
  - mkdir -p /opt/g4/support/g4-spring-cloud-config/application-config
  - mount /opt/g4/support/g4-spring-cloud-config/application-config
  - case "${var.product_name}" in "zone-boarding"|"ota-legacy-modify"|"order-payment-event-processor"|"g4-loyalty-web"|"g4-ops-seats"|"g4-tally-ace-config") echo "${local.efs_id} /var/zone-boarding/configurationUploads efs _netdev,noresvport,tls,accesspoint=${local.efs_zb_config} 0 0" >>/etc/fstab;mkdir -p /var/zone-boarding/configurationUploads;mount /var/zone-boarding/configurationUploads; ;; *) echo "${var.product_name} does not require this mount"; ;; esac
  - case "${var.product_name}" in "flight-disposition-orch"|"flight-info"|"flight-jms"|"flight-record"|"g4-merlot-proxy") echo "${local.efs_id} /opt/bulk_cancel efs _netdev,noresvport,tls,accesspoint=${local.efs_bulk_cancel} 0 0" >>/etc/fstab;mkdir -p /opt/bulk_cancel;mount /opt/bulk_cancel; ;; *) echo "${var.product_name} does not require this mount"; ;; esac
  - export G4_VAULT_PASS=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/${var.ansible_vault} --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - export ANSIBLE_VAULT_PASSWORD_FILE=/root/env-vault.sh
  - mkdir -p /root/repo/sdlc_deploy_s3
  - cd /root/repo/sdlc_deploy_s3
  - /usr/local/bin/aws s3 cp s3://${local.account_id}-${local.region}-deployment-archive/${var.deployment_name}/sdlc_deploy.tar . --endpoint-url https://bucket.vpce-052dffaae324ab23c-1agcyw3v.s3.us-west-2.vpce.amazonaws.com
  - /usr/local/bin/aws s3api head-object --bucket ${local.account_id}-${local.region}-deployment-archive --key ${var.deployment_name}/sdlc_deploy.tar --endpoint-url https://bucket.vpce-052dffaae324ab23c-1agcyw3v.s3.us-west-2.vpce.amazonaws.com
  - tar xvzf sdlc_deploy.tar --strip-components=1
  - echo -e 'springboot_apps:\n - ${local.service_name}\nspringboot_spn_limit_apps:\n - ${local.service_name}\n' > LIMIT_APPS
  - if [ ${var.product_name} == "fmm-flight-ops-data-orchestrator" ]; then ansible-playbook fmmws_pre.yml -e "skip_aws_repo_set=0" -e "@LIMIT_APPS" -e ansible_domain=${local.fqdn} --tags config,filebeat --skip-tags datadog,prereq,configrepofile; fi
  - if [ ${var.ansible_group} == "dmxws" ]; then ansible-playbook spnws.yml -e "skip_aws_repo_set=0" -e "@LIMIT_APPS" -e ansible_domain=${local.fqdn} --tags config,filebeat --skip-tags datadog,prereq,configrepofile; fi
  - ansible-playbook ${var.ansible_group}.yml -e skip_aws_repo_set=0 -e consul_datacenter=${local.consul_datacenter} -e "@LIMIT_APPS" -e ansible_domain=${local.fqdn} --tags deploy,filebeat --skip-tags config,datadog,configrepofile > /var/log/ansible.log
  - export is_live=$(/usr/local/bin/aws ssm get-parameter --name /env_info/is_env_live --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - export is_nav_load_test=$(/usr/local/bin/aws ssm get-parameter --name /env_info/LOAD_TEST --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - ansible-playbook ${var.ansible_group}.yml -e skip_aws_repo_set=false -e consul_datacenter=${local.consul_datacenter} -e aws_consul_call_for_key=true -e "consul_server_list=['${local.consul_server}.${local.fqdn}']" -e "@LIMIT_APPS" -e ansible_domain=${local.fqdn} --tags config,filebeat -e override_run_prereqs=true -e aws_sb_port=${var.service_port} -e is_live=$${is_live} -e load_test=$${is_nav_load_test} --skip-tags deploy,datadog,configrepofile >> /var/log/ansible.log
  - if [ -s /var/log/ansible.log ]; then echo "/var/log/ansible.log file is not empty" ;ansible_out=$(cat /var/log/ansible.log |grep failed=|grep -v failed=0);if [ -n "$ansible_out" ]; then echo "Ansible run encountered failures, check ansible logs in /var/log/ansible.log"; systemctl stop ${var.init_service_name}; exit 1; else echo "Ansible run completed successfully (no failures detected)"; fi; else "/var/log/ansible.log file is empty" ; systemctl stop ${var.init_service_name}; exit 1;fi
  - systemctl stop ${var.init_service_name}
  - sleep 30
  - pkill -9 -s java
  - echo -e '\nPORT=${var.service_port}' >> /etc/sysconfig/${var.init_service_name}
  - systemctl enable ${var.init_service_name}
  - case "${var.product_name}" in "g4mx-line"|"g4-spring-boot-admin"|"dmx-admin"|"g4mx-accounting"|"g4mx-portal"|"g4mx-admin"|"g4mx-aos"|"g4mx-materials"|"g4mx-pi"|"g4mx-lmto"|"g4mx-mco") /usr/local/bin/aws s3 cp s3://${local.account_id}-${local.region}-deployment-archive/keystore/springboot.keystore /tmp/ --endpoint-url https://bucket.vpce-052dffaae324ab23c-1agcyw3v.s3.us-west-2.vpce.amazonaws.com;mv /etc/pki/java/springboot.keystore /etc/pki/java/springboot.keystore-allegiant;cp /tmp/springboot.keystore /etc/pki/java/;chown root:tomcat /etc/pki/java/springboot.keystore;chmod 644 /etc/pki/java/springboot.keystore;sudo service sb-${var.product_name} restart; ;; *) echo "${var.product_name} Skipped due to Condition"; ;; esac
  - export G4_CID=$(/usr/local/bin/aws ssm get-parameter --name aws/reference/secretsmanager/devops/crowdstrikeCID --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - /opt/CrowdStrike/falconctl -s --cid=$G4_CID
  - systemctl start falcon-sensor
  - export dynatrace_tenant=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/dynatrace/tenantID --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - export dynatrace_tenant_token=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/dynatrace/tenantToken --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)

  - if [ `/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name /env_info/monitoring_mode  --with-decryption --region us-west-2 --output text --query Parameter.Value` == "ON" ]; then /bin/sh /root/Dynatrace-OneAgent-Linux-1.249.198.sh --set-infra-only=false --set-app-log-content-access=true --set-host-group=env_${local.sub_env} --set-host-tag=${local.service_name} --set-host-property=env=${local.sub_env} --set-host-tag=env=${local.sub_env} --set-tenant=$${dynatrace_tenant} --set-tenant-token=$${dynatrace_tenant_token} --set-server=https://$${dynatrace_tenant}.live.dynatrace.com/; fi
  - sb_app=$(echo "${var.init_service_name}"|cut -d- -f2-)
  - if [ ${var.ansible_group} == "fmmws" ]; then log_file=/var/log/fmm/${var.init_service_name}.log;> $log_file; elif [[ ${var.ansible_group} = "spnws" || ${var.ansible_group} = "dmxws" ]]; then log_file=/var/log/springboot/$sb_app/${var.init_service_name}.log; > $log_file; else echo "Ansible group is not matching";fi
  - systemctl restart ${var.init_service_name}
  - sleep 10
  - service_stat=$(systemctl status ${var.init_service_name}|grep "active (running)")
  - if [ -n "$service_stat" ]; then echo "Service status is OK" ;else echo "Service status is Not OK";exit 1; fi
  - if [ ${var.app_log_check} == true ]; then tail -n 100 $log_file |grep -iE 'error|fail'; if [ $? -eq 0 ]; then echo "Errors or failure detected in the logs"; systemctl stop ${var.init_service_name};exit 1; else  echo " No Errors or failure detected in the logs";fi; else echo "application log check is false";fi
  - sed -i "s/syslog.infra.aws.allegiant.com/syslog/g" /etc/rsyslog.d/10-central_syslog.conf
  - systemctl restart rsyslog.service
EOF

  app_in_ports = {
    https_tcp = {
      desc     = "Spingboot Server tcp"
      from     = var.service_port
      to       = var.service_port
      protocol = "tcp"
      cidrs    = split(",", local.sb_allow_cidrs)
    },
    http_tcp = {
      desc     = "Spingboot Server tcp"
      from     = var.service_port
      to       = var.service_port
      protocol = "tcp"
      cidrs    = split(",", local.sb_allow_cidrs)
    },
    consul_tcp = {
      desc     = "Consul replication, local gossip, remote gossip tcp"
      from     = "8300"
      to       = "8302"
      protocol = "tcp"
      cidrs    = split(",", local.sb_allow_cidrs)
    },
    consul_udp = {
      desc     = "Consul replication, local gossip, remote gossip udp"
      from     = "8300"
      to       = "8302"
      protocol = "udp"
      cidrs    = split(",", local.sb_allow_cidrs)
    },
    jmp_all = {
      desc     = "All port to jump host"
      from     = 0
      to       = 0
      protocol = "all"
      cidrs    = split(",", nonsensitive(data.aws_ssm_parameter.jump_host_cidrs.value))
    },
    all_from_nexpose = {
      desc     = "Allow all from nexpose"
      from     = 0
      to       = 0
      protocol = "all"
      cidrs    = split(",", nonsensitive(data.aws_ssm_parameter.nexpose_cidrs.value))
    },
    infosec_rule = {
      # This rule is everything else from Infosec that talks to AWS.
      # It will allow anything in from these networks and onus is on fw for blocking ports
      desc     = "Infosec fw rule"
      protocol = "all"
      to       = 0
      from     = 0
      cidrs    = split(",", nonsensitive(data.aws_ssm_parameter.infosec_fw_cidrs.value))
    }

  }
}
