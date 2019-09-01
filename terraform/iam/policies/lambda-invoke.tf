variable "stage" {}

resource "aws_iam_policy" "lambda_invocation_policy" {
  name = "${var.stage}_lambda_policy"
  description = "Grant execution for all aws lambda in stage ${var.stage}"

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"",
         "Effect":"Allow",
         "Action":"lambda:InvokeFunction",
         "Resource":"*"
      }
   ]
}
EOF
}

output "lambda_invocation_policy_arn" {
  value = "${aws_iam_policy.lambda_invocation_policy.arn}"
}