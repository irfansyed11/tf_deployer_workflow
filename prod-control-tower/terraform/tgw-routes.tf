################################################################################
# Routes
################################################################################

# us-west-2

# associate route table prod

# Route to force all traffic through west-2 Firewall VPC for "prod"
resource "aws_ec2_transit_gateway_route" "route_associate_west-2_all_prod_to_west-2_prod_firewall" {
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_to_fw-us-west-2.id
}

# associate route table corp

# Route to force all traffic through west-2 Firewall VPC for "corp"
resource "aws_ec2_transit_gateway_route" "route_associate_west-2_all_corp_to_west-2_corp_firewall" {
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_to_fw-us-west-2.id
}

# propagate route table prod

# Route for west-2 prod internet
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_west_2_prod_internet" {
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2["internet"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}
# Route for west-2 prod to legacy prod
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_west_2_prod_legacy" {
  destination_cidr_block         = var.legacy_aws_prod_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_g4aws_master_prod_tgw_west-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route for west-2 prod to onprem RFC-1918 Class A 10.0.0.0/8
resource "aws_ec2_transit_gateway_route" "route_propagate_west_2_prod_to_west-2_on_prem" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_1
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route for west-2 prod to onprem RFC-1918 Class B 172.16.0.0/12
resource "aws_ec2_transit_gateway_route" "route_propagate_west_2_prod_to_west-2_on_prem_1" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_2
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route for west-2 prod to onprem RFC-1918 Class C 192.168.0.0/16
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_west-2_on_prem_2" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_3
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

#Propagated routes via Direct Connect from VSW to prod-spoke-propagate-route
resource "aws_ec2_transit_gateway_route_table_propagation" "route_propagate_west_2_prod_to_west_2_onprem_bgp" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route for west-2 prod to east-2 prod and nonprod
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_east-2_prod_and_nonprod" {
  destination_cidr_block         = aws_vpc_ipam_pool_cidr.us-east-2.cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route for west-2 common to legacy prod
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_prod_legacy" {
  destination_cidr_block         = var.legacy_aws_prod_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_g4aws_master_prod_tgw_west-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 prod to east-2 pci
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_east-2_pci" {
  destination_cidr_block         = var.pci_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route from west-2 prod to east-2 corp
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_east-2_corp" {
  destination_cidr_block         = var.corporate_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route from west-2 prod to west-2 corp
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_west-2_corp" {
  destination_cidr_block         = var.corporate_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route from west-2 prod to west-2 nonprod
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_west-2_nonprod" {
  destination_cidr_block         = var.nonprod_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# Route from west-2 prod to west-2 corp firewall explicit
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_prod_to_west-2_corp_firewall_explicit" {
  destination_cidr_block         = var.corp_firewall_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-west-2.id
}

# propagate route table corp

# Route for west-2 corp internet
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_corp_to_west-2_corp_internet" {
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2["internet-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route for west-2 corp to onprem RFC-1918 Class A 10.0.0.0/8
resource "aws_ec2_transit_gateway_route" "route_propagate_west_2_corp_to_west-2_on_prem" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_1
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route for west-2 corp to onprem RFC-1918 Class A 172.16.0.0/12
resource "aws_ec2_transit_gateway_route" "route_propagate_west_2_corp_to_west-2_on_prem_1" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_2
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route for west-2 corp to onprem RFC-1918 Class A 192.168.0.0/16
resource "aws_ec2_transit_gateway_route" "route_propagate_west_2_corp_to_west-2_on_prem_2" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_3
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}


# Propagated routes via Direct Connect from VSW to corp-spoke-propagate-route
resource "aws_ec2_transit_gateway_route_table_propagation" "route_propagate_west_2_prod_onprem_bgp" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route for west-2 corp to east-2 prod and nonprod
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_corp_to_east_2_prod_and_nonprod" {
  destination_cidr_block         = var.ipam_pool_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route for west-2 corp to east-2 pci
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_corp_to_east_2_pci" {
  destination_cidr_block         = var.pci_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route from west-2 corp to east-2 corp
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_corp_to_east_2_corp" {
  destination_cidr_block         = var.corporate_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route from west-2 corp to west-2 pci
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_corp_to_west-2_pci" {
  destination_cidr_block         = var.pci_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# Route from west-2 corp to west-2 prod
resource "aws_ec2_transit_gateway_route" "route_propagate_west-2_corp_to_west_2_prod" {
  destination_cidr_block         = var.production_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-west-2.id
}

# common route table

# Route from west-2 common to west-2 nonprod
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_west-2_nonprod" {
  destination_cidr_block         = var.ipam_pool_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route from west-2 common to west-2 prod
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_west-2_prod" {
  destination_cidr_block         = var.production_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to onprem RFC-1918 Class A 10.0.0.0/8
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_on_prem" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_1
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to onprem RFC-1918 Class B 172.16.0.0/12
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_on_prem_1" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_2
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to onprem RFC-1918 Class C 192.168.0.0/16
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_on_prem_2" {
  destination_cidr_block         = var.rfc1918_generic_private_cidr_3
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}


# Propagated routes via Direct Connect from VSW to common-route
resource "aws_ec2_transit_gateway_route_table_propagation" "route_propagate_common_west-2_common_to_west-2_on_prem" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_dx_gateway_attachment.dxgw_corp_tgw-us-west-2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to east-2 prod and nonprod
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_east-2_prod_and_nonprod" {
  destination_cidr_block         = var.ipam_pool_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to east-2 corp
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_east-2_corp" {
  destination_cidr_block         = var.corporate_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to west-2 corp
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_corp" {
  destination_cidr_block         = var.corporate_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to west-2 pci
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_pci" {
  destination_cidr_block         = var.pci_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to east-2 pci
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_east-2_pci" {
  destination_cidr_block         = var.pci_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tgw_prod_west-2_to_east-2_peer.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to west-2 corp firewall explicit
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_corp_firewall_explicit" {
  destination_cidr_block         = var.corp_firewall_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to west-2 corp domain-services explicit
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_corp_domain-services_explicit" {
  destination_cidr_block         = var.domain_services_corp_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# Route for west-2 common to west-2 corp internet explicit
resource "aws_ec2_transit_gateway_route" "route_common_west-2_common_to_west-2_corp_internet_explicit" {
  destination_cidr_block         = var.internet_corp_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-west-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-west-2.id
}

# us-east-2

# associate route table prod

# Route to force all traffic through east-2 Firewall VPC for "prod"
resource "aws_ec2_transit_gateway_route" "route_associate_east-2_all_prod_to_east-2_prod_firewall" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_to_fw-us-east-2.id
}

# associate route table corp

# Route to force all traffic through east-2 Firewall VPC for "corp"
resource "aws_ec2_transit_gateway_route" "route_associate_east-2_all_corp_to_east-2_prod_firewall" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_to_fw-us-east-2.id
}

# propagate route table prod

# Route for east-2 prod internet
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_east_2_prod_internet" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2["internet"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to onprem RFC-1918 Class A 10.0.0.0/8
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_west-2_on_prem" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.rfc1918_generic_private_cidr_1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to onprem RFC-1918 Class B 172.16.0.0/12
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_west-2_on_prem_1" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.rfc1918_generic_private_cidr_2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to onprem RFC-1918 Class C 192.168.0.0/16
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_west-2_on_prem_2" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.rfc1918_generic_private_cidr_3
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to west-2 prod and nonprod
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_west-2_prod_and_nonprod" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.ipam_pool_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to west-2 pci
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_west-2_pci" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.pci_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to east-2 corp
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_east-2_corp" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.corporate_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to east-2 nonprod
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_east-2_nonprod" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.nonprod_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to west-2 corp
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_west-2_corp" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.corporate_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# Route for east-2 prod to east-2 corp firewall explicit
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_prod_to_east-2_corp_firewall_explicit" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.corp_firewall_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_prod_fw_to_spokes-us-east-2.id
}

# propagate route table corp

# Route for east-2 corp internet
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_east_2_corp_internet" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.generic_public_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2["internet-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to west-2 prod and nonprod
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_west-2_prod_and_nonprod" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.ipam_pool_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to west-2 pci
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_west-2_pci" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.pci_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to onprem RFC-1918 Class A 10.0.0.0/8
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_west-2_on_prem" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.rfc1918_generic_private_cidr_1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to onprem RFC-1918 Class B 172.16.0.0/12
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_west-2_on_prem_1" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.rfc1918_generic_private_cidr_2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to onprem RFC-1918 Class C 192.168.0.0/16
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_west-2_on_prem_2" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.rfc1918_generic_private_cidr_3
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to west-2 corp
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_west-2_corp" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.corporate_cidr_usw2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.tgw_prod_west-2_to_east-2_peer_accept.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to east-2 pci
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_east-2_pci" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.pci_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# Route for east-2 corp to east-2 prod
resource "aws_ec2_transit_gateway_route" "route_propagate_east-2_corp_to_east-2_prod" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.production_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_corp_fw_to_spokes-us-east-2.id
}

# common route table

# Route for east-2 common to east-2 prod
resource "aws_ec2_transit_gateway_route" "route_common_east-2_common_to_east-2_prod" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.production_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

# Route for east-2 common to east-2 nonprod
resource "aws_ec2_transit_gateway_route" "route_common_east-2_common_to_east-2_nonprod" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.ipam_pool_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

# Route for east-2 common to east-2 corp
resource "aws_ec2_transit_gateway_route" "route_common_east-2_common_to_east-2_corp" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.corporate_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

# Route for east-2 common to east-2 pci
resource "aws_ec2_transit_gateway_route" "route_common_east-2_common_to_east-2_pci" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.pci_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

# Route for east-2 common to east-2 corp firewall explicit
resource "aws_ec2_transit_gateway_route" "route_common_east-2_common_to_east-2_corp_firewall_explicit" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.corp_firewall_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

# Route for east-2 common to east-2 corp domain-services explicit
resource "aws_ec2_transit_gateway_route" "route_common_east-2_common_to_east-2_corp_domain-services_explicit" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.domain_services_corp_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}

# Route for east-2 common to east-2 corp internet explicit
resource "aws_ec2_transit_gateway_route" "route_common_east-2_common_to_east-2_corp_internet_explicit" {
  provider                       = aws.us-east-2
  destination_cidr_block         = var.internet_corp_cidr_use2
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.us-east-2-fw-tgw-attachment["firewall-corp"].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_to_tgw-us-east-2.id
}
