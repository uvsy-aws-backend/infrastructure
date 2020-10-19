locals {
  stage = var.stage != "" ? var.stage : terraform.workspace
}

variable "stage" {
  default = ""
}

variable "region" {
  default = "sa-east-1"
}