terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.19.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  ignore_tags {
    key_prefixes = ["AutoTag_"]
  }
}

provider "aws" {
  alias = "route53-network"
  assume_role {
    role_arn = "arn:aws:iam::${local.network-id}:role/R53_Update_Records_${data.aws_ssm_parameter.sub_env.value}.aws.allegiant.com"
  }
  region = data.aws_region.current.name
  ignore_tags {
    key_prefixes = ["AutoTag_"]
  }
}
