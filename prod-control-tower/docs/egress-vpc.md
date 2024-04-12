# Egress VPC
This is a VPC in the centralized networking account providing `egress` to the internet (and centralized VPC Endpoints in the future) to organization VPCs served over the Transit Gateways.

## Pattern
Via https://docs.aws.amazon.com/vpc/latest/tgw/transit-gateway-nat-igw.html

![image](https://github.com/irfansyed11/tf_deployer_workflow/assets/48002646/db623e41-84cc-421b-a1af-d506e5d5253f)



## Resources
- aws_vpc - The Egress VPC
- aws_subnet - A subnet resource is created for each AZ the organization expects to use in the region
- aws_route_table
  - A public route table is created and associated with all public subnets, with a route to the internet gateway, and a route for organiztion traffic back through the Transit Gateway.
  - Private route tables are unique per subnet to create a route to the designated NAT Gateway in each availability zone.
- aws_route_table_association - Associates subnets with route tables
- aws_nat_gateway - Provides NAT in order for non-public resources to have egress traffic flow to an internet gateway
- aws_eip - Elastic IP address (public) assigned to the NAT Gateway
- aws_internet_gateway - Resource providing internet access in AWS
- aws_ec2_transit_gateway_route - A static route is created on the TGW route table to advertise the egress VPC for internet CIDRs
- aws_ec2_transit_gateway_vpc_attachment - Attaching the egress VPC to the Transit Gateway

## Environments
- `terraform/egress-vpc-nonprod.tf` - An egress VPC associated with the non-prod transit gateway, providing egress for non-prod environments
- A `prod` egress VPC has not been established yet, but can be done so by copying the nonprod. We should consider if these should be seperate egress VPCs or perhaps shared.


## Future Considerations
- Routing will traverse a security appliance in the networking account
- An ingress path may be needed to serve public-facing internet traffic
- Additional routes through Direct Connect to on-premise environments will be added
- Will Egress be shared between prod/non-prod?
