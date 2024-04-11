locals {
  network-id = [for account in data.aws_organizations_organization.org.accounts : account if account.name == "aws-Prd-Infrastructure-Networking"][0].id
}
