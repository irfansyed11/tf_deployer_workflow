provider "aws" {
  region = "us-west-2"

  ignore_tags {
    key_prefixes = ["AutoTag_"]
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
