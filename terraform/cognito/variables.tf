locals {
  stage = var.stage != "" ? var.stage : terraform.workspace
  accountId = data.aws_caller_identity.current.account_id
}

variable "stage" {
  default = ""
}

variable "region" {
  default = "sa-east-1"
}