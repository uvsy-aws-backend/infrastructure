variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "cognito-region" {}

variable "apigw_role_arn" {}

variable "cognito_user_pool_id" {}


# API Creation
resource "aws_api_gateway_rest_api" "api-institution" {
  name = "${var.stage}-api-institution"

  endpoint_configuration {
    types = [
      "REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "universy" {
  rest_api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_rest_api.api-institution.root_resource_id}"
  path_part = "universy"
}

resource "aws_api_gateway_resource" "institution" {
  rest_api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.universy.id}"
  path_part = "institution"
}

# Authorizer
resource "aws_api_gateway_authorizer" "api-institution-authorizer" {
  name = "${aws_api_gateway_rest_api.api-institution.name}-authorizer"
  type = "COGNITO_USER_POOLS"
  rest_api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  provider_arns = ["arn:aws:cognito-idp:${var.cognito-region}:${var.account_id}:userpool/${var.cognito_user_pool_id}"]
  identity_source = "method.request.header.id-token"
}

# API Endpoints

module "root" {
  source = "./root"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-institution-authorizer.id}"
}

module "career" {
  source = "./careers"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-institution-authorizer.id}"
}

module "programs" {
  source = "./programs"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-institution-authorizer.id}"
}

module "subjects" {
  source = "./subjects"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-institution-authorizer.id}"
}

module "courses" {
  source = "./courses"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  parent_id = "${aws_api_gateway_resource.institution.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-institution-authorizer.id}"
}

# API Deployment
resource "aws_api_gateway_deployment" "api-institution-deploy" {
  depends_on = [
    "module.root",
    "module.career",
    "module.programs",
    "module.subjects",
    "module.courses",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api-institution.id}"
  stage_name = "${var.stage}"

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

# API Key and Usage Plan
resource "aws_api_gateway_api_key" "api-institution-key" {
  name = "${var.stage}-institution-key"
}

resource "aws_api_gateway_usage_plan" "api-institution-usage-plan" {
  name = "${var.stage}-institution-key-usage-plan"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.api-institution.id}"
    stage  = "${aws_api_gateway_deployment.api-institution-deploy.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "api-institutions-usage-plan-key" {
  key_id = "${aws_api_gateway_api_key.api-institution-key.id}"
  key_type = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api-institution-usage-plan.id}"
}


# SSM Parameters
resource "aws_ssm_parameter" "api-institution-endpoint" {
  name = "/${var.stage}/apigw/api-institution/endpoint"
  type = "String"
  value = "${aws_api_gateway_deployment.api-institution-deploy.invoke_url}"
  overwrite = true
}

resource "aws_ssm_parameter" "api-institution-key" {
  name = "/${var.stage}/apigw/api-institution/key"
  type = "String"
  value = "${aws_api_gateway_api_key.api-institution-key.value}"
  overwrite = true
}