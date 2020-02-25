variable "stage" {}

module "lambda_invoke_policy" {
  source = "./policies"
  stage = "${var.stage}"
}

module "api-gw-role" {
  source = "./roles"
  stage = "${var.stage}"
  lambda_invocation_policy_arn = "${module.lambda_invoke_policy.lambda_invocation_policy_arn}"
}

output "api-gw-role-arn" {
  value = "${module.api-gw-role.api-gw-role-arn}"
}