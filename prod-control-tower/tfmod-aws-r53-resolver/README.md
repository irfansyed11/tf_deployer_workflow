# tfmod-aws-r53-resolver
Terraform Module Route53 Resolver

## Usage

```terraform
module "r53-resolver" {
    source = "ssh::git@github.com:Erebor-Slope/tfmod-aws-r53-resolver.git"

    inbound_endpoint_name    = "inbound"
    inbound_destinations     = [
    { subnet_id = "subnet-xxxxxxxxxxxxxxxxx" },
    { subnet_id = "subnet-xxxxxxxxxxxxxxxxx" },
    { subnet_id = "subnet-xxxxxxxxxxxxxxxxx" }
    ]
    outbound_endpoint_name   = "outbound"
    outbound_destinations    = [
    { subnet_id = "subnet-xxxxxxxxxxxxxxxxx" },
    { subnet_id = "subnet-xxxxxxxxxxxxxxxxx" },
    { subnet_id = "subnet-xxxxxxxxxxxxxxxxx" }
    ]
    forward_domains          = ["domain.com", "sub.domain.com"]
    forward_excluded_domains = ["sub.sub.domain.com", "sub.sub.sub.domain.com"]
    forward_targets          = [
    { ip_address = "1.1.1.1" },
    { ip_address = "2.2.2.2" },
    { ip_address = "3.3.3.3" }
    ]
    rule_bound_vpc_ids       = [
    "vpc-xxxxxxxxxxxxxxxxx"
    ]

    ram_share_name      = "org-R53-resolver-rules"
    ram_share_principal = ["arn:aws:organizations::xxxxxxxxxxxx:organization/o-xxxxxxxxx"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ram_principal_association.ram_principal_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.ram_resource_association-r53forward](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_association.ram_resource_association-r53system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.ram_share](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route53_resolver_endpoint.inbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_endpoint.outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_endpoint) | resource |
| [aws_route53_resolver_rule.forward](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule.system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule) | resource |
| [aws_route53_resolver_rule_association.forward](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_resolver_rule_association.system](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_security_group.r53-resolver-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_forward_domains"></a> [forward\_domains](#input\_forward\_domains) | Specify which domains should be forwarded | `list(string)` | `[]` | no |
| <a name="input_forward_excluded_domains"></a> [forward\_excluded\_domains](#input\_forward\_excluded\_domains) | Specify which domains should not be forwarded | `list(string)` | `[]` | no |
| <a name="input_forward_targets"></a> [forward\_targets](#input\_forward\_targets) | "The target IPs when queries are forwarded. Required key: ip\_address. Optional key: port.<br>Initial implementation applies the same target to all forwarded domains." | `list(map(string))` | <pre>[<br>  {<br>    "ip_address": "10.172.137.237"<br>  },<br>  {<br>    "ip_address": "10.172.137.23"<br>  }<br>]</pre> | no |
| <a name="input_inbound_destinations"></a> [inbound\_destinations](#input\_inbound\_destinations) | "Define the subnets and/or IP address that DNS queries originating from<br>on-prem will be forwarded. Required key: 'subnet\_id'. Optional key: 'ip\_address'." | `list(map(string))` | `[]` | no |
| <a name="input_inbound_endpoint_name"></a> [inbound\_endpoint\_name](#input\_inbound\_endpoint\_name) | A name to assign the inbound endpoint | `string` | `null` | no |
| <a name="input_outbound_destinations"></a> [outbound\_destinations](#input\_outbound\_destinations) | "Define the subnets and/or IP address that DNS queries originating from<br>the VPC will be forwarded. Required key: 'subnet\_id'. Optional key: 'ip\_address'." | `list(map(string))` | `[]` | no |
| <a name="input_outbound_endpoint_name"></a> [outbound\_endpoint\_name](#input\_outbound\_endpoint\_name) | A name to assign the outbound endpoint | `string` | `null` | no |
| <a name="input_ram_share_name"></a> [ram\_share\_name](#input\_ram\_share\_name) | RAM resource share name | `string` | `null` | no |
| <a name="input_ram_share_principal"></a> [ram\_share\_principal](#input\_ram\_share\_principal) | Principals such AWS Account Id or Org ARN to share RAM resource with | `list(string)` | `[]` | no |
| <a name="input_rule_bound_vpc_ids"></a> [rule\_bound\_vpc\_ids](#input\_rule\_bound\_vpc\_ids) | The IDs of the VPCs that will be governed by the resolver rules | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to created AWS resources | `map(string)` | `{}` | no |
| <a name="input_tags_template"></a> [tags\_template](#input\_tags\_template) | Expected tags for resources | `map(string)` | <pre>{<br>  "description": "",<br>  "exp_date": "",<br>  "jira": "",<br>  "owner": "",<br>  "prod": "",<br>  "product": "",<br>  "sub_env": "",<br>  "terraform": "True",<br>  "terraform_repo": "",<br>  "working_environment": ""<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
