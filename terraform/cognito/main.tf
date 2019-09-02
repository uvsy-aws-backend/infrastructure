variable "stage" {}

variable "account_id" {}

module "universy-user-pool" {
  source = "./userpool"
  stage = "${var.stage}"
  account_id = "${var.account_id}"
}

module "universy-clients" {
  source = "./clients"
  stage = "${var.stage}"
  user_pool_id = "${module.universy-user-pool.user_pool_id}"
}

output "universy-mobile-client-id" {
  value = "${module.universy-clients.universy-mobile-client-id}"
}
