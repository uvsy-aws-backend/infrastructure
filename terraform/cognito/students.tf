resource "aws_cognito_user_pool" "students" {
  name = "${var.stage}-students"

  schema {
    developer_only_attribute = false
    attribute_data_type = "String"
    name = "email"
    required = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    developer_only_attribute = false
    attribute_data_type = "String"
    name = "family_name"
    required = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  schema {
    developer_only_attribute = false
    attribute_data_type = "String"
    name = "given_name"
    required = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
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
    # TODO: Migrate to SES
    source_arn = "arn:aws:ses:us-east-1:${local.accountId}:identity/info.universy@gmail.com"
  }
}
