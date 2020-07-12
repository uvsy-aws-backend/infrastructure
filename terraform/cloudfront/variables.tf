locals {
  stage = var.stage != "" ? var.stage : terraform.workspace
}

variable "stage" {
  default = ""
}

variable "region" {
  default = "sa-east-1"
}

variable "us_region" {
  default = "us-east-1"
}