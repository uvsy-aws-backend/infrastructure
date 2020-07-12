resource "aws_ses_email_identity" "main_email" {
  email = "info.universy@gmail.com"
  provider = aws.cognito-aws
}

data "aws_iam_policy_document" "main_email_policy_document" {
  statement {
    actions   = ["SES:SendEmail", "SES:SendRawEmail"]
    resources = [aws_ses_email_identity.main_email.arn]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
  }
  provider = aws.cognito-aws
}

resource "aws_ses_identity_policy" "main_email_policy" {
  identity = aws_ses_email_identity.main_email.arn
  name     = "main_email_policy"
  policy   = data.aws_iam_policy_document.main_email_policy_document.json
  provider = aws.cognito-aws
}
