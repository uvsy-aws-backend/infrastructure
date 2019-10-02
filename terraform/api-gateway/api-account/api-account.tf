variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "apigw_role_arn" {}


# API Creation
resource "aws_api_gateway_rest_api" "api-account" {
  name = "${var.stage}-api-account"

  endpoint_configuration {
    types = [
      "REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "universy" {
  rest_api_id = "${aws_api_gateway_rest_api.api-account.id}"
  parent_id = "${aws_api_gateway_rest_api.api-account.root_resource_id}"
  path_part = "universy"
}

resource "aws_api_gateway_resource" "account" {
  rest_api_id = "${aws_api_gateway_rest_api.api-account.id}"
  parent_id = "${aws_api_gateway_resource.universy.id}"
  path_part = "account"
}


# API Endpoints
module "login" {
  source = "./login"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-account.id}"
  parent_id = "${aws_api_gateway_resource.account.id}"
  role_arn = "${var.apigw_role_arn}"
}

module "logon" {
  source = "./logon"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-account.id}"
  parent_id = "${aws_api_gateway_resource.account.id}"
  role_arn = "${var.apigw_role_arn}"
}

module "verify" {
  source = "./verify"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-account.id}"
  parent_id = "${aws_api_gateway_resource.account.id}"
  role_arn = "${var.apigw_role_arn}"
}


# API Deployment
resource "aws_api_gateway_deployment" "api-account-deploy" {
  depends_on = [
    "module.login",
    "module.logon",
    "module.verify"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api-account.id}"
  stage_name  = "${var.stage}"


  variables {
    deployed_at = "${timestamp()}"
  }
}


# API Key and Usage Plan
resource "aws_api_gateway_api_key" "api-account-key" {
  name = "${var.stage}-account-key"
}

resource "aws_api_gateway_usage_plan" "api-account-usage-plan" {
  name = "${var.stage}-account-key-usage-plan"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.api-account.id}"
    stage  = "${aws_api_gateway_deployment.api-account-deploy.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "api-account-usage-plan-key" {
  key_id        = "${aws_api_gateway_api_key.api-account-key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.api-account-usage-plan.id}"
}


# SSM Parameters
resource "aws_ssm_parameter" "api-account-endpoint" {
  name = "/${var.stage}/apigw/api-account/endpoint"
  type = "String"
  value = "${aws_api_gateway_deployment.api-account-deploy.invoke_url}"
}

resource "aws_ssm_parameter" "api-account-key" {
  name = "/${var.stage}/apigw/api-account/key"
  type = "String"
  value = "${aws_api_gateway_api_key.api-account-key.value}"
}
