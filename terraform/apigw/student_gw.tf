/// Entry point for the mobile application to the backend services
/// This abstracts the implementation of the different API's
/// If in some moment it's decided to implement an API-Gateway pattern
/// With a backend service, this should be the API that handles that
/// new implementation

resource "aws_api_gateway_rest_api" "student_gw" {
  name = "${local.stage}-student-gw"
  description = "Gateway for the Student Mobile Application"

  endpoint_configuration {
    types = [
      "EDGE",
    ]
  }
}
/// Institution related resources

/// The student mobile application will only be able to perform
/// GET operations over this resources.
resource "aws_api_gateway_resource" "student_instapi_resource" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  parent_id = aws_api_gateway_rest_api.student_gw.root_resource_id
  path_part = "instapi"
}

resource "aws_api_gateway_resource" "student_instapi_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  parent_id = aws_api_gateway_resource.student_instapi_resource.id
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "student_instapi_proxy_get" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  resource_id = aws_api_gateway_resource.student_instapi_proxy_resource.id
  http_method = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "student_instapi_integration" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  resource_id = aws_api_gateway_resource.student_instapi_proxy_resource.id
  http_method = aws_api_gateway_method.student_instapi_proxy_get.http_method
  integration_http_method = aws_api_gateway_method.student_instapi_proxy_get.http_method
  type = "HTTP_PROXY"
  uri = "https://institutions-api-${local.stage}.compute.universy.app/v1/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

/// Institution related resources

/// The student mobile application will only be able to perform
/// GET operations over this resources.

resource "aws_api_gateway_resource" "student_stdnapi_resource" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  parent_id = aws_api_gateway_rest_api.student_gw.root_resource_id
  path_part = "stdnapi"
}

resource "aws_api_gateway_resource" "student_stdnapi_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  parent_id = aws_api_gateway_resource.student_stdnapi_resource.id
  path_part = "{proxy+}"
}

resource "aws_api_gateway_method" "student_stdnapi_proxy_get" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  resource_id = aws_api_gateway_resource.student_stdnapi_proxy_resource.id
  http_method = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "student_stdnapi_integration" {
  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  resource_id = aws_api_gateway_resource.student_stdnapi_proxy_resource.id
  http_method = aws_api_gateway_method.student_stdnapi_proxy_get.http_method
  integration_http_method = aws_api_gateway_method.student_stdnapi_proxy_get.http_method
  type = "HTTP_PROXY"
  uri = "https://students-api-${local.stage}.compute.universy.app/v1/{proxy}"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "student_gw_deploy" {
  depends_on = [
    aws_api_gateway_integration.student_instapi_integration,
    aws_api_gateway_integration.student_stdnapi_integration
  ]


  rest_api_id = aws_api_gateway_rest_api.student_gw.id
  stage_name = local.stage

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}


/// DNS Integration
data "aws_acm_certificate" "root_certificate" {
  domain   = "*.universy.app"
  statuses = ["ISSUED"]
  provider = aws.us
}

resource "aws_api_gateway_domain_name" "student_gw_domain_name" {
  domain_name = "student-gw-${local.stage}.universy.app"
  certificate_arn = data.aws_acm_certificate.root_certificate.arn
}

resource "aws_api_gateway_base_path_mapping" "student_gw_path_mapping" {
  api_id      = aws_api_gateway_rest_api.student_gw.id
  stage_name  = aws_api_gateway_deployment.student_gw_deploy.stage_name
  domain_name = aws_api_gateway_domain_name.student_gw_domain_name.domain_name
}

data "aws_route53_zone" "root_zone" {
  name = "universy.app"
}


resource "aws_route53_record" "student_gw_dns_record" {
  name = aws_api_gateway_domain_name.student_gw_domain_name.domain_name
  type = "A"
  zone_id = data.aws_route53_zone.root_zone.id

  alias {
    evaluate_target_health = false
    name = aws_api_gateway_domain_name.student_gw_domain_name.cloudfront_domain_name
    zone_id = aws_api_gateway_domain_name.student_gw_domain_name.cloudfront_zone_id
  }
}


