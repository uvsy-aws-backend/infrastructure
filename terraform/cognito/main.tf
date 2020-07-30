data "aws_caller_identity" "current" {
}

provider "aws" {
  version = "~> 2.25"
  profile = "uvsy-dev"
  region  = var.region
}

provider "aws" {
  alias = "us"
  version = "~> 2.25"
  profile = "uvsy-dev"
  region = var.us_region
}
