resource "aws_apigatewayv2_api" "podinfo" {
  name          = "podinfo-api"
  protocol_type = "HTTP"
}

# Integration point on ALIAS  
resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.podinfo.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_alias.live.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "all" {
  api_id    = aws_apigatewayv2_api.podinfo.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.podinfo.id
  name        = "$default"
  auto_deploy = true

  # Access logs with correlation ID 
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw.arn
    format = jsonencode({
      requestId     = "$context.requestId"
      correlationId = "$context.requestId"
      path          = "$context.path"
      status        = "$context.status"
      latency       = "$context.responseLatency"
    })
  }
}

resource "aws_cloudwatch_log_group" "apigw" {
  name              = "/apigw/podinfo"
  retention_in_days = 7
}

# API Gateway permission to invoke alias
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.podinfo.function_name
  qualifier     = aws_lambda_alias.live.name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.podinfo.execution_arn}/*/*"
}
