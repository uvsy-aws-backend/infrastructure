locals {
  stage = terraform.workspace
}

data "aws_caller_identity" "current" {
}

variable "default-region" {
  default = "sa-east-1"
}

variable "cognito-region" {
  default = "us-east-1"
}

provider "aws" {
  version = "~> 2.25"
  profile = "uvsy-terraform-dev"
  region  = var.default-region
}

provider "aws" {
  alias   = "cognito-aws"
  version = "~> 2.25"
  profile = "uvsy-terraform-dev"
  region  = var.cognito-region
}

module "iam" {
  source = "./iam/"
  stage  = local.stage
  providers = {
    aws = aws
  }
}

module "cognito" {
  source     = "./cognito"
  stage      = local.stage
  account_id = data.aws_caller_identity.current.account_id
  providers = {
    aws = aws.cognito-aws
  }
}

module "api-gw" {
  source               = "./api-gateway"
  region               = var.default-region
  cognito-region       = var.cognito-region
  stage                = local.stage
  account_id           = data.aws_caller_identity.current.account_id
  apigw_role_arn       = module.iam.api-gw-role-arn
  cognito_user_pool_id = module.cognito.universy-user-pool-id
  providers = {
    aws = aws
  }
}

module "s3" {
  source = "./s3"
  stage  = local.stage
  region = var.default-region
}

# Parameters to be consumed by serverless
resource "aws_ssm_parameter" "cognito-region" {
  name     = "/${local.stage}/cognito/region"
  type     = "String"
  value    = var.cognito-region
  provider = aws
  overwrite = true
}

resource "aws_ssm_parameter" "universy-mobile-client-id" {
  name     = "/${local.stage}/cognito/clients/universy_mobile_client_id"
  type     = "String"
  value    = module.cognito.universy-mobile-client-id
  provider = aws
  overwrite = true
}

