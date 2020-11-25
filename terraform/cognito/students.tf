resource "aws_cognito_user_pool" "students" {
  name = "${local.stage}-students"
  provider = aws.us

  username_attributes = ["email"]

  username_configuration {
    case_sensitive = false
  }

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_symbols = false
    require_uppercase = false
    temporary_password_validity_days = 7
  }

  auto_verified_attributes = [
    "email",
  ]

  verification_message_template {
    email_subject = "Bienvenido a Universy!"
    email_message = "Tu código de verificación es {####}"
  }

  email_configuration {
    # TODO: Migrate to SES proper configuration before any mass launch
    source_arn = "arn:aws:ses:us-east-1:${local.accountId}:identity/info.universy@gmail.com"
  }
}

resource "aws_cognito_user_pool_client" "universy_mobile_client" {
  provider = aws.us
  user_pool_id = aws_cognito_user_pool.students.id
  name = "${local.stage}-mobile-client"

  explicit_auth_flows = [
    "USER_PASSWORD_AUTH"
  ]

  refresh_token_validity = 30

  generate_secret = false
}

resource "aws_ssm_parameter" "cognito_user_pool_id_ssm" {

  name = "/${local.stage}/cognito/students/poolId"
  type = "String"
  value = aws_cognito_user_pool.students.id
  provider = aws
}

resource "aws_ssm_parameter" "cognito_client_id_ssm" {

  name = "/${local.stage}/cognito/students/clientId"
  type = "String"
  value = aws_cognito_user_pool_client.universy_mobile_client.id
  provider = aws
}
