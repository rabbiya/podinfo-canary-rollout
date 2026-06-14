resource "aws_lambda_function" "podinfo" {
  function_name = "podinfo"
  role          = aws_iam_role.lambda_exec.arn
  package_type  = "Image"
  image_uri     = "${data.aws_ecr_repository.podinfo.repository_url}@${var.image_digest}"
  timeout       = 30
  memory_size   = 512
  publish       = true   

  environment {
    variables = {
      
      SECRET_ARN = aws_secretsmanager_secret.super_secret.arn
    }
  }

  lifecycle {
    
    ignore_changes = [image_uri]
  }
}

# Alias: traffic shifting (10% -> 100%)
resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = aws_lambda_function.podinfo.function_name
  function_version = aws_lambda_function.podinfo.version

  lifecycle {
    ignore_changes = [function_version, routing_config]   
  }
}
