locals {
  domains = var.r53_domains
  orgid   = data.aws_organizations_organization.org.id
}

################################################################################
# Route 53
################################################################################

resource "aws_route53_zone" "private" {
  for_each = toset(local.domains)

  name = each.key
  vpc {
    vpc_id = module.vpc-west-2["domain-services"].vpc_id
  }
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone_association" "corp" {
  for_each = toset(local.domains)

  zone_id = aws_route53_zone.private[each.key].zone_id
  vpc_id  = module.vpc-west-2["domain-services-corp"].vpc_id
}

resource "aws_route53_zone_association" "us-east-2" {
  provider = aws.us-east-2
  for_each = toset(local.domains)

  zone_id = aws_route53_zone.private[each.key].zone_id
  vpc_id  = module.vpc-east-2["domain-services"].vpc_id
}

resource "aws_route53_zone_association" "us-east-2-corp" {
  provider = aws.us-east-2
  for_each = toset(local.domains)

  zone_id = aws_route53_zone.private[each.key].zone_id
  vpc_id  = module.vpc-east-2["domain-services-corp"].vpc_id
}

################################################################################
# IAM
################################################################################

data "aws_iam_policy_document" "policy_document" {
  for_each = aws_route53_zone.private

  statement {
    sid = "UpdateRecords1"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/${aws_route53_zone.private[each.key].zone_id}",
    ]
  }
  statement {
    sid = "UpdateRecords2"
    actions = [
      "route53:GetChange",
      "route53:ListHostedZones",
      "route53:GetHostedZone",
      "route53:ListTagsForResource"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "policy" {
  for_each = data.aws_iam_policy_document.policy_document

  name   = "R53_Update_Record_Policy_${each.key}"
  path   = "/"
  policy = data.aws_iam_policy_document.policy_document[each.key].json
}

resource "aws_iam_role" "role" {
  for_each = aws_iam_policy.policy

  name                = "R53_Update_Records_${each.key}"
  managed_policy_arns = [aws_iam_policy.policy[each.key].arn]
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Action" : "sts:AssumeRole",
      "Principal" : {
        "AWS" : "*"
      },
      "Condition" : {
        "StringEquals" : {
          "aws:PrincipalOrgID" : "${local.orgid}",
          "iam:ResourceTag/sub_env" : "$${aws:PrincipalTag/sub_env}"
        },
        "StringLike" : {
          "aws:PrincipalArn" : "arn:aws:iam::*:role/github-workflow-role-*"
        }
      }
    }
  })
  tags = {
    "sub_env" = element(split(".", each.key), 0)
  }
}
