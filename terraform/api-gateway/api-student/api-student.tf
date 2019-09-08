variable "account_id" {}

variable "stage" {}

variable "region" {}

variable "apigw_role_arn" {}


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

resource "aws_api_gateway_resource" "student" {
  rest_api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.universy.id}"
  path_part = "student"
}


# API Endpoints
module "career" {
  source = "./career"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.apigw_role_arn}"
}

module "profile" {
  source = "./profile"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.apigw_role_arn}"
}

module "rate" {
  source = "./rate"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.apigw_role_arn}"
}

module "session" {
  source = "./session"
  account_id = "${var.account_id}"
  region = "${var.region}"
  stage = "${var.stage}"
  api_id = "${aws_api_gateway_rest_api.api-student.id}"
  parent_id = "${aws_api_gateway_resource.student.id}"
  role_arn = "${var.apigw_role_arn}"
}

# API Deployment
resource "aws_api_gateway_deployment" "api-student-deploy" {
  depends_on = [
    "module.career",
    "module.profile",
    "module.rate"
  ]

  rest_api_id = "${aws_api_gateway_rest_api.api-student.id}"
  stage_name  = "${var.stage}"
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
}

resource "aws_ssm_parameter" "api-student-key" {
  name = "/${var.stage}/apigw/api-student/key"
  type = "String"
  value = "${aws_api_gateway_api_key.api-student-key.value}"
}