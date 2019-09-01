variable "stage" {}

variable "lambda_invocation_policy_arn" {}

resource "aws_iam_role" "api-gw-role" {
  name = "${var.stage}-apigw-asume-role"
  description = "Role that Amazon API Gateway can asume on stage ${var.stage}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

resource "aws_iam_policy_attachment" "apigw-lambda-role-attachment" {
  name = "${var.stage}-apigw-lambda-invoke-attachment"
  roles = [
    "${aws_iam_role.api-gw-role.name}"
  ]
  policy_arn = "${var.lambda_invocation_policy_arn}"
}

output "api-gw-role-arn" {
  value = "${aws_iam_role.api-gw-role.arn}"
}