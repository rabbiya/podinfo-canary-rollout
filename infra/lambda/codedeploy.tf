resource "aws_codedeploy_app" "podinfo" {
  name             = "podinfo-lambda"
  compute_platform = "Lambda"
}

resource "aws_codedeploy_deployment_group" "podinfo" {
  app_name              = aws_codedeploy_app.podinfo.name
  deployment_group_name = "podinfo-lambda-dg"
  service_role_arn      = aws_iam_role.codedeploy.arn

  # Canary: 10% traffic, 5 minute wait, then 100%
  deployment_config_name = "CodeDeployDefault.LambdaCanary10Percent5Minutes"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  # automatic rollback on alarm
  alarm_configuration {
    enabled = true
    alarms  = [aws_cloudwatch_metric_alarm.lambda_errors.alarm_name]
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }
}
