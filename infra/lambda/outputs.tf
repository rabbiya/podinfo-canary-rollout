output "api_url" {
  value = aws_apigatewayv2_api.podinfo.api_endpoint
}

output "secret_arn" {
  value = aws_secretsmanager_secret.super_secret.arn
}
