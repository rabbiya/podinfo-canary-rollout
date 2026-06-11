output "ecr_repository_url" {
  value = aws_ecr_repository.podinfo.repository_url
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}
