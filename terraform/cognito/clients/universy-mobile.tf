resource "aws_cognito_user_pool_client" "universy-mobile-client" {
  user_pool_id = "${var.user_pool_id}"
  name = "${var.stage}-universy-mobile"

  explicit_auth_flows = [
    "USER_PASSWORD_AUTH"
  ]

  refresh_token_validity = 30

  generate_secret = false
}

output "universy-mobile-client-id" {
  value = "${aws_cognito_user_pool_client.universy-mobile-client.id}"
}