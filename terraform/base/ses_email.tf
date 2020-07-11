resource "aws_ses_email_identity" "main_email" {
  email = "info.universy@gmail.com"
  provider = aws.cognito-aws
}
