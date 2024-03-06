locals {
  external_load_balancer = var.jboss_scheduler == false ? "jboss-standalone-${var.vip_name}-lb" : null
  instance_ips = []
  elb_health_check = {}
  load_balancer_listeners = var.jboss_scheduler == false ?  {
    https-tcp = {

    }

    http-tcp = {

    }
  } : {}
  asg_policy_out = { scaling_adjustment = "1", cooldown = "300" }
  asg_policy_in  = { scaling_adjustment = "-1", cooldown = "300" }
  account_id = data.aws_caller_identity.current.account_id
  sub_env = data.aws_ssm_parameter.sub_env.value
  fqdn  = "${local.sub_env}.aws.allegiant.com"
  working_environment = "aws${local.sub_env}"
  environment              = trim(local.sub_env,substr(local.sub_env, -2,-1 ))
  initial_ami              = nonsensitive(data.aws_ssm_parameter.initial_ami.value)
  hostname  = var.hostname_override == null?"${var.deployment_name}.${local.fqdn}": "${var.hostname_override}.${local.fqdn}"
  aws_resource_name_prefix = replace(var.deployment_name,"_", "-")
  #service_name = join("-", slice(split("-", var.deployment_name), 2, length(split("-", var.deployment_name))))
  service_name = var.jboss_scheduler ? join("-", slice(split("-", var.deployment_name), 2, length(split("-", var.deployment_name)) -1)) : join("-", slice(split("-", var.deployment_name), 2, length(split("-", var.deployment_name))))
  ansible_playbook  = join("_", ["eap6sa", replace(local.service_name, "-", "_")])
  region  = data.aws_region.current.name
  vipname_to_ssm_cidr_data = {
    "jbshc1" = "std_app_cidrs"
    "jbshc2" = "pci_ext_web_cidrs"
    "jbshc3" = "pci_int_app_cidrs"
  }
  ou_name = data.aws_ssm_parameter.ou_name.value
  efs_id = data.aws_ssm_parameter.jboss_efs_id.value
  efs_filestore_acp = var.vip_name == "jbshc1" ? data.aws_ssm_parameter.jboss_filestore_efs_id[0].value : null
  efs_cassPhotos_acp = var.vip_name == "jbshc1" ? data.aws_ssm_parameter.jboss_cassphotos_efs_id[0].value : null
  efs_publication-manager_acp = var.vip_name == "jbshc1" ? data.aws_ssm_parameter.jboss_pubmanager_efs_id[0].value : null
  efs_jboss_nfs_acp = var.vip_name == "jbshc1" ? data.aws_ssm_parameter.jboss_nfs_efs_id[0].value : null
  jboss_binfiles_efs = var.vip_name == "jbshc3" ? data.aws_ssm_parameter.jboss_binfiles_efs_id[0].value : null
  jboss_adyen_rep_efs = var.vip_name == "jbshc3" ? data.aws_ssm_parameter.jboss_adyen_rep_efs_id[0].value : null
  app_in_ports = {
    all_from_nexpose = {
      desc     = "Allow all from nexpose"
      from     = 0
      to       = 0
      protocol = "all"
      cidrs    = split(",", data.aws_ssm_parameter.nexpose_cidrs.value)
    },
    jboss_https = {
      desc     = "${var.product_name} server https tcp"
      from     = var.ssl_service_port
      to       = var.ssl_service_port
      protocol = "tcp"
      cidrs    = split(",", data.aws_ssm_parameter.mw_cidrs[var.vip_name].value)
    },
    jboss_http = {
      desc     = "${var.product_name} server http tcp"
      from     = var.http_service_port
      to       = var.http_service_port
      protocol = "tcp"
      cidrs    = split(",", data.aws_ssm_parameter.mw_cidrs[var.vip_name].value)
    },
    ssh_tcp = {
      desc     = "SSH Server tcp"
      from     = "22"
      to       = "22"
      protocol = "tcp"
      cidrs    = split(",", data.aws_ssm_parameter.jump_host_cidrs.value)
    },
    icmp_all = {
      desc     = "ICMP (Ping, PMTUD, etc) icmp"
      from     = "-1"
      to       = "-1"
      protocol = "icmp"
      cidrs    = split(",", data.aws_ssm_parameter.jump_host_cidrs.value)
    },
    infosec_rule = {
      # This rule is everything else from Infosec that talks to AWS.
      # It will allow anything in from these networks and onus is on fw for blocking ports
      desc     = "Infosec fw rule"
      protocol = "all"
      to       = 0
      from     = 0
      cidrs    = split(",", data.aws_ssm_parameter.infosec_fw_cidrs.value)
    }
  }
  bootstrap_script = <<EOF
#cloud-config
hostname: "${local.hostname}"
runcmd:
%{ if local.ou_name == "Standard" ~}
  - echo "${local.efs_id} /opt/jboss_nfs efs _netdev,noresvport,tls,accesspoint=${local.efs_jboss_nfs_acp} 0 0" >>/etc/fstab
  - echo "${local.efs_id} /mnt/filestore efs _netdev,noresvport,tls,accesspoint=${local.efs_filestore_acp} 0 0" >> /etc/fstab
  - echo "${local.efs_id} /opt/g4-operations/cassPhotos efs _netdev,noresvport,tls,accesspoint=${local.efs_cassPhotos_acp} 0 0" >> /etc/fstab
  - echo "${local.efs_id} /data/content/publication-manager efs _netdev,noresvport,tls,accesspoint=${local.efs_publication-manager_acp} 0 0" >> /etc/fstab
  - mkdir -p /opt/jboss_nfs
  - mkdir -p /mnt/filestore
  - mkdir -p /opt/g4-operations/cassPhotos
  - mkdir -p /data/content/publication-manager
  - mount -a
%{endif ~}
  - echo "127.0.0.1 localhost $(hostname) $(hostname -s)" > /etc/hosts
  - echo -e '[${var.jboss_application_name}]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}'  > /etc/ansible/hosts
  - echo -e '[${var.ansible_group}]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}' >> /etc/ansible/hosts
%{ if var.deployment_name == "jboss-standalone-allegianttravel" ~}
  - echo -e '\n[jbs031_otaflight]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}' >> /etc/ansible/hosts
  - echo -e '\n[jbs027_g4flight]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}' >> /etc/ansible/hosts
  - echo -e '\n[jbs028_otavehicle]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}\n' >> /etc/ansible/hosts
%{endif ~}
  - echo -e '' >> /etc/ansible/hosts
  - echo -e '#! /bin/bash\n/usr/bin/echo $G4_VAULT_PASS' > /root/env-vault.sh
  - chmod 700 /root/env-vault.sh
  - export G4_VAULT_PASS=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/${var.ansible_vault} --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - export ANSIBLE_VAULT_PASSWORD_FILE=/root/env-vault.sh
  - export is_live=$(/usr/local/bin/aws ssm get-parameter --name /env_info/is_env_live --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - mkdir -p /root/repo/sdlc_deploy_s3
  - cd /root/repo/sdlc_deploy_s3
  - /usr/local/bin/aws s3 cp s3://${local.account_id}-${local.region}-deployment-archive/${var.deployment_name}/sdlc_deploy.tar . --endpoint-url https://bucket.vpce-052dffaae324ab23c-1agcyw3v.s3.us-west-2.vpce.amazonaws.com
  - /usr/local/bin/aws s3api head-object --bucket ${local.account_id}-${local.region}-deployment-archive --key ${var.deployment_name}/sdlc_deploy.tar --endpoint-url https://bucket.vpce-052dffaae324ab23c-1agcyw3v.s3.us-west-2.vpce.amazonaws.com
  - tar xvzf sdlc_deploy.tar --strip-components=1
  - ansible-playbook "${local.ansible_playbook}.yml" --skip-tags sumo,consul,datadog --extra-vars 'jboss_start=False' -e is_live=$${is_live} > /var/log/ansible.log
  - if [ -s /var/log/ansible.log ]; then echo "/var/log/ansible.log file is not empty" ;ansible_out=$(cat /var/log/ansible.log |grep failed=|grep -v failed=0);if [ -n "$ansible_out" ]; then echo "Ansible run encountered failures, check ansible logs in /var/log/ansible.log"; systemctl stop jboss-${local.service_name}; exit 1; else echo "Ansible run completed successfully (no failures detected)"; fi; else "/var/log/ansible.log file is empty" ; systemctl stop jboss-${local.service_name}; exit 1;fi
  - ifconfig |grep "inet " |grep broadcast|awk '{print $2"  "}' |tr -d '\n' >> /etc/hosts
  - echo "$(hostname) $(hostname -s)" >> /etc/hosts
  - /opt/CrowdStrike/falconctl -s --cid=`/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name crowdstrikeCID --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value`
  - systemctl start falcon-sensor
  - export dynatrace_tenant=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/dynatrace/tenantID --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
  - export dynatrace_tenant_token=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/dynatrace/tenantToken --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)

  - if [ `/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name /env_info/monitoring_mode  --with-decryption --region us-west-2 --output text --query Parameter.Value` == "ON" ]; then /bin/sh /root/Dynatrace-OneAgent-Linux-1.249.198.sh --set-infra-only=false --set-app-log-content-access=true --set-host-group=env_${local.sub_env} --set-host-tag=${local.service_name} --set-host-property=env=${local.sub_env} --set-host-tag=env=${local.sub_env} --set-tenant=$${dynatrace_tenant} --set-tenant-token=$${dynatrace_tenant_token} --set-server=https://$${dynatrace_tenant}.live.dynatrace.com/; fi
  - log_file1=/var/log/jbossas/${local.service_name}/console.log
  - log_file2=/var/log/jbossas/${local.service_name}/server.log
  - cat /dev/null| tee $log_file1 $log_file2
  - chown jboss:jboss $log_file1 $log_file2
  - /etc/init.d/jboss-${local.service_name} start
  - sleep 10
  - service_stat=$(systemctl status jboss-${local.service_name}|grep "active (running)")
  - if [ -n "$service_stat" ]; then echo "Service status is OK" ;else echo "Service status is Not OK";exit 1; fi
  - if [ ${var.app_log_check} == true ]; then tail -n 100 $log_file1 $log_file2 |grep -iE 'error|fail'; if [ $? -eq 0 ]; then echo "Errors or failure detected in the logs"; systemctl stop jboss-${local.service_name};exit 1; else  echo " No Errors or failure detected in the logs";fi; else echo "application log check is false";fi
EOF
}

data "aws_ssm_parameter" "initial_ami" {
  name = "/ami-builder/standard-jboss-standalone-ami-${local.environment}/latest"
}

data "aws_ssm_parameter" "mw_cidrs" {
  for_each = local.vipname_to_ssm_cidr_data

  name = "/env_info/${each.value}"
}

data "aws_ssm_parameter" "ou_name" {
  name = "/aft/account-request/custom-fields/account/ou_name"
}

data "aws_ssm_parameter" "jboss_efs_id" {
  name = "/efs/jboss_efs/efs_fs_id"
}

data "aws_ssm_parameter" "jboss_filestore_efs_id" {
  count = var.vip_name == "jbshc1" ? 1 : 0
  name = "/efs/jboss_efs/jboss_filestore"
}

data "aws_ssm_parameter" "jboss_pubmanager_efs_id" {
  count = var.vip_name == "jbshc1" ? 1 : 0
  name = "/efs/jboss_efs/jboss_pubmanager"
}

data "aws_ssm_parameter" "jboss_cassphotos_efs_id" {
  count = var.vip_name == "jbshc1" ? 1 : 0
  name = "/efs/jboss_efs/jboss_cassphotos"
}

data "aws_ssm_parameter" "jboss_nfs_efs_id" {
  count = var.vip_name == "jbshc1" ? 1 : 0
  name = "/efs/jboss_efs/jboss_nfs"
}

data "aws_ssm_parameter" "jboss_adyen_rep_efs_id" {
  count = var.vip_name == "jbshc3" ? 1 : 0
  name = "/efs/jboss_efs/jboss_adyen_rep"
}

data "aws_ssm_parameter" "jboss_binfiles_efs_id" {
  count = var.vip_name == "jbshc3" ? 1 : 0
  name = "/efs/jboss_efs/jboss_binfiles"
}
