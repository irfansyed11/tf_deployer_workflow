# Hyderate SSM

Create tfvars & run terraform from the account directory where we are creating SSM parameters.  
For example: if we need to create SSM parameters in standard app account for stg02 then follow below steps:<br>
&nbsp;&nbsp;a) Go to the [path](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/manual/hydrate-ssm-param/app-standard)<br>
&nbsp;&nbsp;b) Create tfvars stg02-terraform.tfvars [refer existing tfvars](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/manual/hydrate-ssm-param/app-standard/tfvars/terraform-stg01.tfvars) and add relevant parameters in the tfvars file.<br>

&nbsp;&nbsp;c) Update the route53_zone_id variable in tfvars file. Go to account aws-Prd-Infrastructure-Networking (330705608308), under route 53 -> hosted zone, get the zone ID value of stg02.aws.allegiant.com.<br>
&nbsp;&nbsp;d) Update the tfvars file with correct CIDR values for variables std_app_cidrs, std_web_cidrs, std_db_cidrs, pci_ext_web_cidrs, pci_int_app_cidrs, pci_int_db_cidrs, db_standard_allowed_cidr_blocks. CIDR values can be found out from "VPC" section of AWS console all 6 respective accounts.<br>
&nbsp;&nbsp;(Ignore making changes to subnet ID and IP reservation of other long lived system present like consul,ais,etc in the code as its no longer required because now IP reservation is done through respective application terraform code.)<br>

&nbsp;&nbsp;e) Run terraform commands to apply:<br>
```
terraform init -backend-config backends/{account-id}.conf<br>
terraform apply --var-file=tfvars/terraform-stg02.tfvars<br>
```
<b>Repeat above steps for rest of the AWS accounts.</b>

# Deploy consolidated LBs

A) Create ALB for JBOSS services(jbshc1/2/3)<br>
&nbsp;&nbsp;&nbsp;&nbsp;a) To create in mw-app account use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/jboss-standalone-jbshc1/apply.sh) script(modification is required in script to change environment specific parameters)<br>
&nbsp;&nbsp;&nbsp;&nbsp;b) To create in pci-int account use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/pci-int/jboss-alb-jbshc3/apply.sh) script(modification is required in scrip to change environment specific parameters)<br>
&nbsp;&nbsp;&nbsp;&nbsp;c) To create in pci-ext account use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/pci-ext/jboss-alb-jbshc2/apply.sh) script(modification is required in script to change environment specific parameters)

B) Create ALB for springboot services<br>
&nbsp;&nbsp;&nbsp;&nbsp;a) To create springboot ALB in mw-app use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/springboot-hc-alb/apply.sh) script(modifications might be required to change environment specific parameters)<br>
&nbsp;&nbsp;&nbsp;&nbsp;b) To create springboot ALB in pci-int use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/pci-int/springboot-hc-alb/apply.sh) script(modifications might be required to change environment specific parameters)

<b>Note: Springboot ALB Deployment in pci-internal is only required if we are deploying navitaire applications.</b>

# Deploy EFS

Create EFS for services mentioned below: 

[airweb](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/airweb-efs)<br>
[amqap](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/amqap-efs)<br>
[jboss-efs-mw-app](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/jboss-efs)<br>
[jboss-efs-pci-int](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/pci-int/jboss-efs)<br>
[nodap](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/nodap-efs)<br>
[springboot-efs-mw-app](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/springboot-efs-prd)<br>
[springboot-efs-pci-int](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/pci-int/springboot-efs-prd)<br>
[ais](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/ais-efs)<br>
[mxweb](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/php53-mxweb-efs)<br>
[DB2](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/db-standard/db2-efs)<br> 

<b>Note: Springboot EFS in pci-int is only required for navitaire applications</b>

Steps to deploy EFS:<br>
```
terraform init -backend-config backends/<sub_env>.conf
terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
<b>Note: sub_env is value of environment for example : dev01, prd01</b>

# Create required certificates in AWS Certificate Manager
Need information on steps

# Deploy Databases(EC2)

Deploy below databases in standard-db account:<br>
[DB2](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/db-standard/db-db2)<br>
[opsrd](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/db-standard/opsrd)<br>
[comrd](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/db-standard/comrd)<br>
[mongo3](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/db-standard/mongo3)<br>
[mongo2](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/db-standard/mongo2)<br>
[mongo4](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/db-standard/monor)

Steps to deploy databases:<br>
```
terraform init -backend-config backends/{account-id}.conf
terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
<b>Note: sub_env is value of environment for example : dev01, prd01</b>

# Deploy Voltage(long-lived)
Need information on steps

# Deploy JBOSS Domain Controller(long-lived)
Please refer to [readme](https://github.com/AllegiantTravelCo/aws-docs/wiki/jboss-domain-mode-%E2%80%90-terraform-automation) for the same.

# Deploy required services(AMQ,RMQAP etc)

A) <b>AMQAP:</b> amqap is having two deployments [amqap11](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/amqap11) and [amqap12](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/amqap12). We can deploy both amqap11/12 at the same time but once the deployment is done and we want amqap11 as master node then stop amq service on both the nodes and then first start amqap11 followed by amqap12.

&nbsp;&nbsp;&nbsp;&nbsp;Steps to deploy amqap:<br>
```
terraform init -backend-config backends/{account-id}.conf<br>
terraform apply -var-file tfvars/terraform-global.tfvars -var-file tfvars/terraform-<sub_env>.tfvars
```
 &nbsp;&nbsp;&nbsp;<b>Note: sub_env is value of environment for example : dev01, prd01.</b>

B) <b>RMQAP(long-lived):</b> [rmqap](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/rmqap-ha) is HA clustered and having only one deployment.

&nbsp;&nbsp;&nbsp;&nbsp;Steps to deploy rmqap:<br>
```
terraform init -backend-config backends/{account-id}.conf
terraform apply -var-file tfvars/terraform-global.tfvars -var-file tfvars/terraform-<sub_env>.tfvars
```
&nbsp;&nbsp;&nbsp;<b>Note: sub_env is value of environment for example : dev01, prd01</b>

C) <b>Elastic Memcached:</b> Memcache service need to deploy in standard app account. Use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/elasticache-memcached/terraform-apply.sh) script to deploy [memcache](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/elasticache-memcached)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Note: while using script to deploy kindly change environment specific parameters like account id, path of tfvar in terraform apply. We are &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;deploying 6 memcache services and each service is using seperate state file so while deploying other service we need to change backend &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;key in [backend.tf](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/src/elasticache-memcached/backend.tf)

D) <b>Kakfa:</b> For lower(dev/qa) environments kakfa is deployed in NP-infrastructure(#248452401457) and for upper(stg/prd) environments kafka &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;is deployed in respective accounts i.e. if you are creating a lower environment then we don't need to deploy kafka only we just need to &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;create kafka topics for that particular environment but if you are creating an upper environment then we need to deploy kafka in particular &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;account.

&nbsp;&nbsp;&nbsp;&nbsp;(i) Steps to create kafka topics in NP-infrastructure:<br>
* Create a tfvar on [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/infra-np/kafka-topics/tfvars) path take a reference of [exisiting](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/infra-np/kafka-topics/tfvars/dev01-terraform.tfvars) tfvar. In this we only need to change working environment parameter.
* Run below commands from NP jump host:<br>
  ```
  cd /home/ec2-user/tf-ami-deployer/terraform/infra-np/kafka-topics/deployer
  terraform init
  terrform apply /home/ec2-user/tf-ami-deployer/terraform/infra-np/kafka-topics/tfvars/<sub_env>-terraform.tfvars
  ```
&nbsp;&nbsp;&nbsp;&nbsp;Note: sub_env is value of environment for example : dev01, prd01

&nbsp;&nbsp;&nbsp;&nbsp;(ii) Steps to deploy kafka in upper environments:<br>
* Create Kafka-cluster by using [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/infra-np/kafka-cluster/terraform-apply.sh) script(environment specific changes will be required in the script and path of tfvar)
* Create kakfa-topic by using [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/infra-np/kafka-topics/terraform-apply.sh) script(environment specific changes will be required in the script and path of tfvar)

# Deploy Traefik(balap)

Steps to deploy [traefik](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/balap):
```
terraform init -backend-config backends/{account-id}.conf
terraform apply -var-file tfvars/terraform-global.tfvars -var-file tfvars/terraform-<sub_env>.tfvars
```
Note: 
  * sub_env is value of environment for example : dev01, prd01 
  * Please refer [readme](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/balap/README) for more information.
  * Please note Traefik might need to deploy in PCI-INT in case we are deploying navitaire applications in environment.

# Deploy Consul(long-lived)

Steps to deploy [consul](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/consul)
```
terraform init -backend-config backends/backend-<sub_env>.conf
terraform apply -var-file terraform-global.tfvars -var-file terraform-dev01.tfvars
```
Note:
  * sub_env is value of environment for example : dev01, prd01
  * You need to replace terraform-dev01.tfvars with terraform-prd01.tfvars in case you are deploying on prd01 environment.
  * Please note Traefik might need to deploy in PCI-INT in case we are deploying navitaire applications in environment.

Troubleshooting steps in case of consul split brain issue:

refer below sop for steps with screenshots.
https://allegiantair0.sharepoint.com/:w:/s/AWS/EbSDqyN7PXNDqKt8Et_vXbIBdHmmKLQwYEYqReb5q-R1Pg?e=Sw6Rku

1)Environment & account wise workflow-
Please check the requested envionrment to deploy the consul- dev/stage/prod.
There are two accounts that consul servers need to be deployed in each dev/stage/prod.

Stage:
aws-NPStg-Standard-Stg01App
aws-NPPCIStg-Internal-Stg01App

Dev:
aws-NPDev-Standard-Dev01App
aws-NPPCIDev-Internal-Dev01App

Prod:
aws-Prd-Standard-Prd01App
aws-PCIPrd-Internal-Prd01App


run the workflow for stage standard

login to github 
 

Got to repo named tf-ami-deployer 
Go to actions and choose deploy matrix


Select worflow and modify the details as per environment & account.
Stage standard in below case.

Branch: main
type of content to deployed: common-subenv
target tier: null
Sub-environment to taret: stg01
other values default.
 

Once github workflow job is successful.


Login to aws account:
aws-npstg-standard-stg01App


Validate if all 5 servers are up and running after workflow succeeds.
Go to EC2 and search with consul
 

Use session manager to connect to EC2 instance. Open all 5 servers in different tabs.

Check consul service status on all servers and make sure its active.
```
systemctl status consul 
```
When you run consul members, it may show just one server that means it is not communicating with other consule servers or nodes. Hence cluster is not functioning. 

To get this fixed, please verify encryption key on each serverver and it has to be common across all of them.

Check encryption on any of the server at location
```
cat /etc/consul.d/server/00_config.json
```

If key is not similar then generate the new encryption key using below cmd and copy it to all the server by following below step.

1)	Generate key on one server & copy it to notepad.
```
consul keygen
```
2)	Stop consul service on all 5 servers.
```
systemctl stop consul
```
3)	Clear cache on all 5 servers using below cmd.
```
rm -rf /var/consul/serf/*
rm -rf /etc/consul.d/client/
```
4)	Edit the file 00_config.json using vi editor ( /etc/consul.d/server/00_config.json ) and make the following chnages. 

i)   Paste new encrytption key ("encrypt": "<your-token>", ) copied in above step 1 on all servers. So that i would be identical across all of them.
ii)  Change bootstrap value to 3 if its 1 by default ( bootstrap_expect": 3, )
iii) Make sure to add the ipaddress of all the consul servers if it shows the fqdn in "retry_join". ( IF IT SHOWS FQDN, THEN CHANGE IT TO IPADDRESS)


```
{
    "addresses": {
        "dns": "0.0.0.0",
        "http": "0.0.0.0",
        "https": "0.0.0.0"
    },
    "bootstrap_expect": 3,
    "datacenter": "<env>>",
    "enable_syslog": true,
    "encrypt": "<your-token>",
    "log_level": "INFO",
    "retry_join": [
        "X.X.X.X",
        "X.X.X.X",
        "X.X.X.X",
        "X.X.X.X",
        "X.X.X.X"
    ],
    "server": true,
    "ui": true
}
```

6)	Start the consul service on each server one at a time
```
systemctl start consul
```
7)	Check the status of consul service and it shall be active(running)
```
systemctl status consul
```
8)	To verify all cluster nodes are communicating with each other and cluster is functioning properly run below cmd.

Run below cmd on all the servers and it shall show common output like below ( IP addresses will vary as per environment and account)

```
consul members
```

Run one more cmd to check which is leader/master for the cluster.
```
consul info | grep -i leader
consul operator raft list-peers
```
Verify the logs if needed
```
consul monitor
```
Lastly check the allocated static IP addresses to servers are same from parameter store

the steps mentioned above have been followed for consul running in stage- standard app account.
Follow  same for stage-pci account.

You have to repeat this for each environment based on deployment request received. 



# Deploy G4 Spring Cloud Config

Once consul and traefik is deployed next step is to deploy [springboot-g4-spring-cloud-config](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/springboot-g4-spring-cloud-config)

Steps to deploy springboot-g4-spring-cloud-config:
```
terraform init -backend-config backends/backend-<sub_env>.conf
terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
Note: sub_env is value of environment for example : dev01, prd01

# Deploy FMM Config

Once springboot-g4-spring-cloud-config is deployed next step is to deploy [springboot-fmm-config](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/springboot-fmm-config)

Steps to deploy springboot-fmm-config:
```
terraform init -backend-config backends/backend-<sub_env>.conf
terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
Note: sub_env is value of environment for example : dev01, prd01

# Deploy ECMPX

Steps to deploy [ecmpx](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/ecmpx):
```
  terraform init -backend-config backends/backend-<sub_env>.conf
  terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
Note: sub_env is value of environment for example : dev01, prd01

# Deploy Sorry Server(maintainence page)

Steps to deploy [sorry](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/sorry-server):
```
terraform init -backend-config backends/{account-id}.conf
terraform apply -var-file tfvars/terraform-global.tfvars -var-file tfvars/terraform-<sub_env>.tfvars
```
Note: 
  * sub_env is value of environment for example : dev01, prd01 
  * Please refer [readme](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/balap/README) for more information.

# Deploy node applications

There are two node applications:
  * [nodap-sox](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/nodap-sox)
  * [nodap-nonsox](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/nodap-nonsox)

Steps to deploy node applications:
```
terraform init -backend-config backends/backend-<sub_env>.conf
terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
Note: sub_env is value of environment for example : dev01, prd01

# Deploy Drupal(long-lived)

Drupal is a free, open-source content management system written in PHP. It allows users to easily manage and organize a wide variety of content, from basic text to multimedia and complex data. Drupal is known for its flexibility, scalability, and robust feature set, making it an excellent choice for building websites, blogs, intranets, and web applications.

Key features of Drupal include:-
Content Management: Drupal provides a powerful content management system that enables users to create, edit, and organize content easily.

Modularity: The system is built around a modular architecture, allowing for the addition of various functionalities and features through modules.

Customization: Drupal is highly customizable, thanks to a theming system that allows you to create unique designs and layouts.

Community and Support: The Drupal community is extensive, providing resources, documentation, and support for users, developers, and site administrators.

Drupal is categorized in two silo's:
  * silo1 - [drpau11](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/rhel6-drpau11)
  * silo2 - [drpau21](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/rhel6-drpau21)

Steps to deploy drpau:
**Note:** To Know more about the workflow please refer to -
https://github.com/AllegiantTravelCo/tf-ami-deployer#deployment

Go to tf-ami-deployer repo, click on Actions select the workflow with the name "Deploy Matrix".
 * Run the workflow with below params to deploy to drpau
 
```
**Parameters:**

Branch should be: main
JSON list of list of tiers: \[\[\"rhel6-drpau11\"\],\[\"rhel6-drpau21\"\]\]
Type of content to deployed: applications
Target Tier: null
Sub-Environment to Target: Respective env, ex - stg01, dev01, prd01
Current processing index of the array:\[ Greyed out \] - 1
Whether to auto-approve the apply or not: true/false (if \"false\" tf
will run only plan )
Whether to update sdlc: true/false (if \"false\" sdlc tar ball will not
upload to s3 )

```
 * Once drpau code is deployed we need to make sure TG is healthy for (rhel6-drpau11-7 & 
rhel6-drpau21-7 )

Note:
  *  We can configure both drpau11 and drpau21 parallely

# Deploy Drupal Eco-system

Once drpau is configured then we need to configure other systems which are connecting to drpau(other systems are also categorized in two silo's).

A) <b>drpau1X, 2X:</b>
   * silo1 - [drpau1X](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/app/rhel6-drpau1X)
   * silo2 - [drpau2X](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/app/rhel6-drpau2X)

   Steps to deploy drpau1X,2X:

Go to tf-ami-deployer repo, click on Actions select the workflow with the name "Deploy Matrix".
 * Run the workflow with below params to deploy drpau
 
```
**Parameters:**

Branch should be: main
JSON list of list of tiers: \[\[\"rhel6-drpau1X\"\],\[\"rhel6-drpau2X\"\]\]
Type of content to deployed: applications
Target Tier: null
Sub-Environment to Target: Respective env, ex - stg01, dev01, prd01
Current processing index of the array:\[ Greyed out \] - 1
Whether to auto-approve the apply or not: true/false (if \"false\" tf
will run only plan )
Whether to update sdlc: true/false (if \"false\" sdlc tar ball will not
upload to s3 )

```
 * Once drpau code is deployed we need to make sure TG is healthy for (rhel6-drpau1X-8,rhel6-drpau1X-9 & rhel6-drpau2X-8 
rhel6-drpau2X-9 ) 

B) <b>smfws:</b>
   * silo1 - [rhel6-smfws1](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/app/rhel6-smfws1)
   * silo2 - [rhel6-smfws2](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/app/rhel6-smfws2)

   Steps to deploy smfws:

Go to tf-ami-deployer repo, click on Actions select the workflow with the name "Deploy Matrix".
 * Run the workflow with below params to deploy smfws
 
```
**Parameters:**

Branch should be: main
JSON list of list of tiers: \[\[\"rhel6-smfws1\"\],\[\"rhel6-smfws2\"\]\]
Type of content to deployed: applications
Target Tier: null
Sub-Environment to Target: Respective env, ex - stg01, dev01, prd01
Current processing index of the array:\[ Greyed out \] - 1
Whether to auto-approve the apply or not: true/false (if \"false\" tf
will run only plan )
Whether to update sdlc: true/false (if \"false\" sdlc tar ball will not
upload to s3 )

```
 * Once smfws code is deployed we need to make sure TG is healthy for (rhel6-smfws1-8,rhel6-smfws1-9 & rhel6-smfws2-8 
rhel6-smfws2-9 ) 

   Note:<br>
    * We can configure both smfws1 and smfws2 parallely

C) <b>drpmc11/21:</b>
   * silo1 - [rhel6-drpmc11](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/app/rhel6-drpmc11)
   * silo2 - [rhel6-drpmc21](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/app/rhel6-drpmc21)

   Steps to deploy drpmc11,21:

Go to tf-ami-deployer repo, click on Actions select the workflow with the name "Deploy Matrix".
 * Run the workflow with below params to deploy drpmc11/21
 
```
**Parameters:**

Branch should be: main
JSON list of list of tiers: \[\[\"rhel6-drpmc11\"\],\[\"rhel6-drpmc11-nlb\"\],\[\"rhel6-drpmc21\"\],\[\"rhel6-drpmc21-nlb\"\]\]
Type of content to deployed: applications
Target Tier: null
Sub-Environment to Target: Respective env, ex - stg01, dev01, prd01
Current processing index of the array:\[ Greyed out \] - 1
Whether to auto-approve the apply or not: true/false (if \"false\" tf
will run only plan )
Whether to update sdlc: true/false (if \"false\" sdlc tar ball will not
upload to s3 )

```
 * Once drpmc11/21 code is deployed we need to make sure TG is healthy for apps & nlb's (
rhel6-drpmc11-10,rhel6-drpmc11-11 & rhel6-drpmc21-10 rhel6-drpmc21-11 etc for nlb's ) 


   Note:<br>
    * We can configure both vrnap1 and vrnap2 parallely

D) <b>vrnap(varnish):</b>
   * silo1 - [vrnap1](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/web/rhel6-vrnap1)
   * silo2 - [vrnap2](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/web/rhel6-vrnap2)

   Steps to deploy varnish: This is dependent on pervious ones to be healthy

Go to tf-ami-deployer repo, click on Actions select the workflow with the name "Deploy Matrix".
 * Run the workflow with below params to deploy varnish
 
```
**Parameters:**

Branch should be: main
JSON list of list of tiers: [["rhel6-vrnap1","rhel6-vrnap2"]]
Type of content to deployed: applications
Target Tier: null
Sub-Environment to Target: Respective env, ex - stg01, dev01, prd01
Current processing index of the array:\[ Greyed out \] - 1
Whether to auto-approve the apply or not: true/false (if \"false\" tf
will run only plan )
Whether to update sdlc: true/false (if \"false\" sdlc tar ball will not
upload to s3 )

```
 * Once vrnap1 & 2 code is deployed we need to make sure TG is healthy for apps(
rhel6-vrnap1-8,rhel6-vrnap1-9 & rhel6-vrnap2-8 rhel6-vrnap2-9) 

   Note:<br>
    We can configure both vrnap1 and vrnap2 parallely


E) <b>vplap nodes(immutable):</b>
   * silo1 - [rhel7-vplap](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/web/rhel7-vplap)
   * silo2 - [rhel7-vplap-nlb](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/web/rhel7-vplap/rhel7-vplap-nlb)

   Steps to deploy vplap: This has dependency on pervious ones and on other apps like Jboss , AOT to be healthy

Go to tf-ami-deployer repo, click on Actions select the workflow with the name "Deploy Matrix".
 * Run the workflow with below params to deploy vplap
 
```
**Parameters:**

Branch should be: main
JSON list of list of tiers: [["rhel7-vplap","rhel7-vplap-nlb"]]
Type of content to deployed: applications
Target Tier: null
Sub-Environment to Target: Respective env, ex - stg01, dev01, prd01
Current processing index of the array:\[ Greyed out \] - 1
Whether to auto-approve the apply or not: true/false (if \"false\" tf
will run only plan )
Whether to update sdlc: true/false (if \"false\" sdlc tar ball will not
upload to s3 )

```
 * Once vplap is deployed we need to make sure TG is healthy for (
rhel7-vplap-9, rhel7-vplap-nlb-9) 


   Note:<br>
    * sub_env is value of environment for example : dev01, prd01<br>
    * We can configure both drpauX1 and drpauX2 parallely<br>
    * This task is dependent on drpau and can only be deployed once drpau deployement is done.

# Drupal Deployment Process:
Drupal eco system consists of varnish(vrnap & vplap), drupal (drpau), drupal mem cache (drpmc) & symfony (smfws) services.

Release in the drupal systems happens through ansible playbook, just like other services.
Drupal Release deployments are done through isengard, But not too many releases for drupal systems, in the recent times. While we can also use the Github Workflows to deploy/perform release on the services.

silo-drupal.yml & all-drupal-upgrade.yml for the major playbooks being used. In AWS,silo-drupal is the ansible playbook being executed for drupal systems.

The list of apps that are released / deployed in drupal eco system, are  mentioned in the playbook (one reference below, taken from silo-drupal.yml) :

hosts: drupalall 
tags:
post-content
g4www
drupal
g4styles
g4analytics

Applicaiton list : https://isengard.allegiantair.com/#/applications/list

# Deploy GQLAP, AOTAP

Steps to deploy [GQLAP](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/gqlap) and [AOTAP](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/rhel7-httpd-aotap):<br>
```
  terraform init -backend-config backends/backend-<sub_env>.conf<br>
  terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
Note: sub_env is value of environment for example : dev01, prd01

# Deploy JBOSS Standalone

A) To deploy JBOSS standalone services in MW-APP use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/install_jb.sh) script(modification might be required to change environment specific parameters). Use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/jboss-deployment.txt) text file for the application list. 

B) To deploy JBOSS standalone services in PCI-INT use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/pci-int/install_jb.sh) script(modification might be required to change environment specific parameters). Use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/pci-int/jboss-deployment.txt) text file for the application list. 

C) To deploy JBOSS standalone services in PCI-EXT use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/pci-ext/jboss-standalone-myidtravel) TF code(only one application in pci-ext). 

# Deploy Domain Nodes

This has to be done once domain controller setup is completed.<br>
To deploy JBOSS Domain Nodes use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/install_jb.sh) script(modification might be required to change environment specific parameters). Use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/terraform/mw-app/jbossdc-deployment1.txt) text file for the application list.

# Deploy Springboot

To deploy springboot use [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/src/generic-deployer/bootstrap/springboot-shell.sh) script and refer [this](https://github.com/AllegiantTravelCo/tf-ami-deployer/blob/main/src/generic-deployer/bootstrap/springboot-shell.sh) path for files containing springboot application list["sb1.txt", "sb2.txt", "sb3.txt", "sb4.txt", "sb5.txt", "sb6.txt"]

# Deploy Tomcat

We have three tomcat services in AWS:

  * a2gws
  * resweb
  * awbws

To deploy these services follow below steps:
```
  terraform init -backend-config backends/backend-<sub_env>.conf
  terraform apply -var-file terraform-global.tfvars -var-file terraform-<sub_env>.tfvars
```
Note:

  * sub_env is value of environment for example : dev01, prd01

# Deploy AIS

Steps to deploy aisap:
  * Run terraform
  ```
  terraform init -backend-config backends/backend-<sub_env>.conf
  terraform apply -var-file=terraform-global.tfvars -var-file=terraform-<sub_env>.tfvars
  ```
  * once TF code deployment is done we need to run ansible manually and additional commands to configure systems. Please refer to [readme](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/web/php53-aisap/README.md) for the same.

Note:
  * sub_env is value of environment for example : dev01, prd01
  * Readme file for AIS contains information of exisiting environment. We need to follow the same approach when we are configuring AIS on new environment.

# Deploy MXWEB

Steps to deploy mxweb:
  * Run terraform
```
   terraform init -backend-config backends/backend-<sub_env>.conf
   terraform apply -var-file=terraform-global.tfvars -var-file=terraform-<sub_env>.tfvars
```
  * once TF code deployment is done we need to run ansible manually and additional commands to configure systems. Please refer to [readme](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/applications/standard/web/php53-mxweb/README.md) for the same.

Note: sub_env is value of environment for example : dev01, prd01

# Deploy AJP, PHP, varnish+

A) AJP-PROXY : We have two applications in AJP-PROXY

   * [awbwa](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/ajp-proxy-awbwa)
   * [a2gwa](http://-https:/github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/ajp-proxy-a2gwa)

   Steps to deploy AJP services:
```
     terraform init -backend-config backends/backend-<sub_env>.conf
     terraform apply -var-file=terraform-global.tfvars -var-file=terraform-<sub_env>.tfvars
```
   Note: sub_env is value of environment for example : dev01, prd01

B) PHP: We have seven services in PHP apart from AIS and mxweb

   * [g4pop](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/php54-g4pop)
   * [g4pwa](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/php53-g4pwa)
   * [g4plusmx](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/php54-g4plusmx)
   * [g4php](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/php53-g4php)
   * [loyad](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/mw-app/php54-loyad)
   * [loyct](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/pci-ext/php54-loyct)
   * [kayws](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/pci-ext/php54-loyct)

   i) Steps to deploy g4pop, g4plusmx:
```
terraform init -backend-config backends/{account-id}.conf
terraform apply -var-file tfvars/terraform-global.tfvars -var-file tfvars/terraform-<sub_env>.tfvars
```
   Note: sub_env is value of environment for example : dev01, prd01

   ii) Steps to deploy loyct, g4php, loyad, kayws, g4pwa
```
terraform init -backend-config backends/backend-<sub_env>.conf
terraform apply -var-file=terraform-global.tfvars -var-file=terraform-<sub_env>.tfvars
```
   Note: sub_env is value of environment for example : dev01, prd01

C) vplap(varnish+)
   
   Steps to deploy [varnish+](https://github.com/AllegiantTravelCo/tf-ami-deployer/tree/main/terraform/web-app/vplap):
```
terraform init -backend-config backend-<sub_env>.conf
terraform apply -var-file=terraform-global.tfvars -var-file=terraform-<sub_env>.tfvars
```
   Note: sub_env is value of environment for example : dev01, prd01
