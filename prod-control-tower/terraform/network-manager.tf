resource "aws_networkmanager_global_network" "core" {
  description = "Allegiant Core Network"
  tags = {
    "Name" = "Core"
  }
}

resource "aws_networkmanager_transit_gateway_registration" "us-west-2" {
  global_network_id   = aws_networkmanager_global_network.core.id
  transit_gateway_arn = aws_ec2_transit_gateway.tgw_prod-us-west-2.arn
}

resource "aws_networkmanager_transit_gateway_registration" "us-east-2" {
  global_network_id   = aws_networkmanager_global_network.core.id
  transit_gateway_arn = aws_ec2_transit_gateway.tgw_prod-us-east-2.arn
}
