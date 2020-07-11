data "aws_caller_identity" "current" {
}

provider "aws" {
  version = "~> 2.25"
  profile = "uvsy-dev"
  region = var.region
}

provider "aws" {
  alias = "cognito-aws"
  version = "~> 2.25"
  profile = "uvsy-dev"
  region = var.cognito_region
}

