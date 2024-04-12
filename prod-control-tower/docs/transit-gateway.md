# Transit Gateway (TGW)

We use transit gateway as a centralized router that connects all of our VPCs. In this  scenario, all attachments are associated with the transit gateway default route table and propagate to the transit gateway default route table. Therefore, all attachments can route packets to each other, with the transit gateway serving as a simple layer 3 IP router.

![Transit Gateway Centralized](transit-gateway-centralized.png)

Pattern via https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-centralized-router.html

## Resources

- aws_ec2_transit_gateway - The Transit Gateway
- aws_ec2_tag - A name tag for the propigation route table
- aws_ram_resource_share - Resource Access Management share
- aws_ram_resource_association - Association of the TGW to the RAM share
- aws_ram_principal_association - OU principals to share the TGW with (prod / non-prod)

## Environments
`/terraform/tgw-nonprod.tf` - Transit Gateway servicing non-prod accounts
`/terraform/tgw-prod.tf` - Transit Gateway servicing prod acocunts

## Attachment from `spoke` VPCs
In order for spoke VPCs to make us of the shared Transit Gateway, those accounts need to create an attachment between their `default-vpc` and the TGW, as well as create a route in their route tables to TGW. These actions are performed as part of `aft_account_customizations` via `terraform/vpc.tf`, making use of the Terraform module in the repo `tfmod-aws-vpc`.
