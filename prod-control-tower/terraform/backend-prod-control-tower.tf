provider "aws" {
  region = "us-west-2"

  ignore_tags {
    key_prefixes = ["AutoTag_"]
  }
}
provider "aws" {
  alias  = "us-east-2"
  region = "us-east-2"

  ignore_tags {
    key_prefixes = ["AutoTag_"]
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version = "~> 4.29"
    }
  }
}
terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "330705608308-tf-remote-state"
    dynamodb_table = "tf-state-lock"
    key            = "AllegiantTravelCo/aws-network.tfstate"
    region         = "us-west-2"
    profile        = "330705608308"
  }
}
