locals {
  external_load_balancer = "jboss-standalone-${var.vip_name}-lb"
  instance_ips = []
  elb_health_check = {}
  load_balancer_listeners = {
    https-tcp = {
      
    }
  
    http-tcp = {
      
    }
  }
  asg_policy_out = { scaling_adjustment = "1", cooldown = "300" }
  asg_policy_in  = { scaling_adjustment = "-1", cooldown = "300" }
  account_id = data.aws_caller_identity.current.account_id
  sub_env = data.aws_ssm_parameter.sub_env.value
  fqdn  = "${local.sub_env}.aws.allegiant.com"
  working_environment = "aws${local.sub_env}"
  # serveralias_host is added to keep the variable without '-' or '.' as it is required
  serveralias_host = "${local.sub_env}" == "prd01" ? "prod" : "${local.sub_env}.aws.allegiantair.com"
  region  = data.aws_region.current.name
  serveralias = "${local.sub_env}" == "prd01" ? "${local.sub_env}.allegiantair.com" : "${local.sub_env}.aws.allegiantair.com"
  #serveralias_conf = "${local.sub_env}" == "prd01" ? "-${local.serveralias}" : ".${local.serveralias}"
  environment              = trim(local.sub_env,substr(local.sub_env, -2,-1 ))
  initial_ami              = nonsensitive(data.aws_ssm_parameter.initial_ami.value)
  hostname  = var.hostname_override == null?"${var.deployment_name}.${local.fqdn}": "${var.hostname_override}.${local.fqdn}"
  aws_resource_name_prefix = replace(var.deployment_name,"_", "-")
  service_name = join("-", slice(split("-", var.deployment_name), 2, length(split("-", var.deployment_name))))
  ansible_playbook  = join("_", ["eap6sa", replace(local.service_name, "-", "_")])
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

  bootstrap_script  = <<EOF
#!/bin/bash
hostname "${local.hostname}"
echo "${local.efs_id} /opt/jboss_nfs efs _netdev,noresvport,tls,accesspoint=${local.efs_jboss_nfs_acp} 0 0" >>/etc/fstab
echo "${local.efs_id} /mnt/filestore efs _netdev,noresvport,tls,accesspoint=${local.efs_filestore_acp} 0 0" >> /etc/fstab
echo "${local.efs_id} /opt/g4-operations/cassPhotos efs _netdev,noresvport,tls,accesspoint=${local.efs_cassPhotos_acp} 0 0" >> /etc/fstab
echo "${local.efs_id} /data/content/publication-manager efs _netdev,noresvport,tls,accesspoint=${local.efs_publication-manager_acp} 0 0" >> /etc/fstab
mkdir -p /opt/jboss_nfs
mkdir -p /mnt/filestore
mkdir -p /opt/g4-operations/cassPhotos
mkdir -p /data/content/publication-manager
mount -a
#/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name vault_lowers --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value > vaultpass
#/usr/bin/ansible-playbook ${local.ansible_playbook} --skip-tags consul --extra-vars 'jboss_start=False g4_allow_nexus=False' --vault-password-file vaultpass --tags configuration
#rm -f vaultpass
echo "127.0.0.1 localhost $(hostname) $(hostname -s)" > /etc/hosts
echo -e '[${var.jboss_application_name}]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}'  > /etc/ansible/hosts
echo -e '[${var.ansible_group}]\n127.0.0.1 ansible_connection=local working_environment=${local.working_environment}' >> /etc/ansible/hosts
echo -e '' >> /etc/ansible/hosts
echo -e '#! /bin/bash\n/usr/bin/echo $G4_VAULT_PASS' > /root/env-vault.sh
chmod 700 /root/env-vault.sh
export G4_VAULT_PASS=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/${var.ansible_vault} --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
export ANSIBLE_VAULT_PASSWORD_FILE=/root/env-vault.sh
export is_live=$(/usr/local/bin/aws ssm get-parameter --name /env_info/is_env_live --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
mkdir -p /root/repo/sdlc_deploy_s3
cd /root/repo/sdlc_deploy_s3
/usr/local/bin/aws s3 cp s3://${local.account_id}-${local.region}-deployment-archive/${var.deployment_name}/sdlc_deploy.tar . --endpoint-url https://bucket.vpce-052dffaae324ab23c-1agcyw3v.s3.us-west-2.vpce.amazonaws.com
/usr/local/bin/aws s3api head-object --bucket ${local.account_id}-${local.region}-deployment-archive --key ${var.deployment_name}/sdlc_deploy.tar --endpoint-url https://bucket.vpce-052dffaae324ab23c-1agcyw3v.s3.us-west-2.vpce.amazonaws.com
tar xvzf sdlc_deploy.tar --strip-components=1
ansible-playbook "${local.ansible_playbook}.yml" --skip-tags sumo,consul,datadog --extra-vars 'jboss_start=False' -e is_live=$${is_live} > /var/log/ansible.log
if [ -s /var/log/ansible.log ]; then echo "/var/log/ansible.log file is not empty" ;ansible_out=$(cat /var/log/ansible.log |grep failed=|grep -v failed=0);if [ -n "$ansible_out" ]; then echo "Ansible run encountered failures, check ansible logs in /var/log/ansible.log"; systemctl stop jboss-${local.service_name}; exit 1; else echo "Ansible run completed successfully (no failures detected)"; fi; else "/var/log/ansible.log file is empty" ; systemctl stop jboss-${local.service_name}; exit 1;fi

ifconfig |grep "inet " |grep broadcast|awk '{print $2"  "}' |tr -d '\n' >> /etc/hosts
echo "$(hostname) $(hostname -s)" >> /etc/hosts
systemctl enable collector
systemctl start collector
sleep 30
rm -rf /etc/sumo.conf
/opt/CrowdStrike/falconctl -s --cid=`/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name crowdstrikeCID --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value`
systemctl start falcon-sensor

export SUB_ENV=$(/usr/local/bin/aws ssm get-parameter --name /aft/account-request/custom-fields/account/sub_env --with-decryption --region us-west-2 --output text --query Parameter.Value)
export is_live=$(/usr/local/bin/aws ssm get-parameter --name /env_info/is_env_live --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
if [ ${local.sub_env} == "prd01" ]; then serveralias="-${local.sub_env}.allegiantair.com"; else serveralias=".${local.sub_env}.aws.allegiantair.com"; fi
if [[ ${local.sub_env} == "prd01" && $${is_live} == "true" ]]; then serveralias_conf=".allegiantair.com"; else serveralias_conf=$${serveralias}; fi
sed -i "s/www.infra.aws.allegiant.com/www$${serveralias_conf}/g" /etc/jbossas/standalone/sa-custcoms.xml
sed -i "s+.*<property name=\"environment.name.*+        <property name=\"environment.name\" value=\"${local.serveralias_host}\"/>+" /etc/jbossas/standalone/sa-custcoms.xml
sed -i "s/infra.aws.allegiant.com/$SUB_ENV.aws.allegiant.com/g" /etc/jbossas/standalone/sa-custcoms.xml
if [ `/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name /env_info/is_env_live --with-decryption --region us-east-2 --output text --query Parameter.Value` != "false" ]; then
  sed -i "s+.*cheetah.password.*+        <property name=\"cheetah.password\" value=\"`/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name /jbossSA/stg/cheetah.password --with-decryption --region us-east-2 --output text --query Parameter.Value`\"/>+" /etc/jbossas/standalone/sa-custcoms.xml
  sed -i "s+.*cheetah.username.*+        <property name=\"cheetah.username\" value=\"`/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name /jbossSA/stg/cheetah.username --with-decryption --region us-east-2 --output text --query Parameter.Value`\"/>+" /etc/jbossas/standalone/sa-custcoms.xml
  sed -i 's+.*emailValidator.filter.inclusive.*+        <property name="emailValidator.filter.inclusive" value="true"/>+' /etc/jbossas/standalone/sa-custcoms.xml
  sed -i 's/.*emailValidator.filter.regex.*/        <property name="emailValidator.filter.regex" value="^(?i)([^@]+@?(tridentsqa.com|allegiantair.com|kayasoftware.com|mailinator.com))|(ccmod.validation@gmail.com)$|(adinnerod@gmail.com)$"\/>/' /etc/jbossas/standalone/sa-custcoms.xml
  sed -i 's/.*environment.name.*/        <property name="environment.name" value="stg"\/>/' /etc/jbossas/standalone/sa-custcoms.xml
  sed -i s/resweb_/resweb_stage_/ /etc/jbossas/standalone/sa-custcoms.xml
  sed -i s/otares_/otares_stage_/ /etc/jbossas/standalone/sa-custcoms.xml
  sed -i s/reaccom_/reaccom_stage_/ /etc/jbossas/standalone/sa-custcoms.xml
  sed -i s/myaccount_/myaccount_stage_/ /etc/jbossas/standalone/sa-custcoms.xml
  sed -i s/fclub_verification/fclub_stage_verification/ /etc/jbossas/standalone/sa-custcoms.xml
  sed -i s/rewards_accountlinked/rewards_stage_accountlinked/ /etc/jbossas/standalone/sa-custcoms.xml
fi
export dynatrace_tenant=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/dynatrace/tenantID --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
export dynatrace_tenant_token=$(/usr/local/bin/aws ssm get-parameter --name /aws/reference/secretsmanager/dynatrace/tenantToken --with-decryption --region ${data.aws_region.current.name} --output text --query Parameter.Value)
if [ `/usr/local/aws-cli/v2/2.2.20/bin/aws ssm get-parameter --name /env_info/monitoring_mode  --with-decryption --region us-west-2 --output text --query Parameter.Value` == "ON" ]; then /bin/sh /root/Dynatrace-OneAgent-Linux-1.249.198.sh --set-infra-only=false --set-app-log-content-access=true --set-host-group=env_${local.sub_env} --set-host-tag=${local.service_name} --set-host-property=env=${local.sub_env} --set-host-tag=env=${local.sub_env} --set-tenant=$${dynatrace_tenant} --set-tenant-token=$${dynatrace_tenant_token} --set-server=https://$${dynatrace_tenant}.live.dynatrace.com/; fi
/etc/init.d/jboss-${local.service_name} start
sleep 10
service_stat=$(systemctl status jboss-${local.service_name}|grep "active (running)")
if [ -n "$service_stat" ]; then echo "Service status is OK" ;else echo "Service status is Not OK";exit 1; fi
if [ ${var.app_log_check} == true ]; then tail -n 100 $log_file |grep -iE 'error|fail'; if [ $? -eq 0 ]; then echo "Errors or failure detected in the logs"; systemctl stop jboss-${local.service_name};exit 1; else  echo " No Errors or failure detected in the logs";fi; else echo "application log check is false";fi
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
