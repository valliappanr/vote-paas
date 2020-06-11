resource "aws_api_gateway_rest_api" "nominees_api" {
  name = "nominees_api"
  description = "Nominees Api"
}

resource "aws_api_gateway_resource" "nominees_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.nominees_api.id
  parent_id = aws_api_gateway_rest_api.nominees_api.root_resource_id
  path_part = "nominees"
}

resource "aws_api_gateway_method" "nominees_api_method" {
  rest_api_id = aws_api_gateway_rest_api.nominees_api.id
  resource_id = aws_api_gateway_resource.nominees_api_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "nominees_api_method-integration" {
  rest_api_id = aws_api_gateway_rest_api.nominees_api.id
  resource_id = aws_api_gateway_resource.nominees_api_resource.id
  http_method = aws_api_gateway_method.nominees_api_method.http_method
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account_id}:function:${aws_lambda_function.voting_nominees_fn.function_name}/invocations"
  integration_http_method = "GET"
}

resource "aws_api_gateway_deployment" "nominees_deployment_dev" {
  depends_on = [
    "aws_api_gateway_method.nominees_api_method",
    "aws_api_gateway_integration.nominees_api_method-integration"
  ]
  rest_api_id = aws_api_gateway_rest_api.nominees_api.id
  stage_name = "dev"
}