variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "cognito-region" {}

variable "apigw_role_arn" {}

variable "cognito_user_pool_id" {}



# API Creation
resource "aws_api_gateway_rest_api" "api-student" {
  name = "${var.stage}-api-student"

  endpoint_configuration {
    types = [
    "REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "universy" {
  rest_api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_rest_api.api-student.root_resource_id}"
  path_part = "universy"
}

# Authorizer
resource "aws_api_gateway_authorizer" "api-student-authorizer" {
  name          = "${aws_api_gateway_rest_api.api-student.name}-authorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = "${aws_api_gateway_rest_api.api-student.id}"
  provider_arns = ["arn:aws:cognito-idp:${var.cognito-region}:${var.account_id}:userpool/${var.cognito_user_pool_id}"]
  identity_source = "method.request.header.id-token"
}

# API Endpoints
module "student" {
  source = "./student"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.universy.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-student-authorizer.id}"
}

module "institution" {
  source = "./institution"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.universy.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-student-authorizer.id}"
}

module "account" {
  source = "./account"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.universy.id}"
  role_arn = "${var.apigw_role_arn}"
  authorizer_id = "${aws_api_gateway_authorizer.api-student-authorizer.id}"
}


# API Deployment
resource "aws_api_gateway_deployment" "api-student-deploy" {
  depends_on = [
    "module.student",
    "module.institution",
    "module.account",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api-student.id}"
  stage_name  = "${var.stage}"

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}


# API Key and Usage Plan
resource "aws_api_gateway_api_key" "api-student-key" {
  name = "${var.stage}-student-key"
}

resource "aws_api_gateway_usage_plan" "api-student-usage-plan" {
  name = "${var.stage}-student-key-usage-plan"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.api-student.id}"
    stage  = "${aws_api_gateway_deployment.api-student-deploy.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "api-students-usage-plan-key" {
  key_id        = "${aws_api_gateway_api_key.api-student-key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api-student-usage-plan.id}"
}


# SSM Parameters
resource "aws_ssm_parameter" "api-student-endpoint" {
  name = "/${var.stage}/apigw/api-student/endpoint"
  type = "String"
  value = "${aws_api_gateway_deployment.api-student-deploy.invoke_url}"
  overwrite = true
}

resource "aws_ssm_parameter" "api-student-key" {
  name = "/${var.stage}/apigw/api-student/key"
  type = "String"
  value = "${aws_api_gateway_api_key.api-student-key.value}"
  overwrite = true
}