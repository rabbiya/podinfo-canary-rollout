resource "aws_secretsmanager_secret" "super_secret" {
  name = "/dockyard/SUPER_SECRET_TOKEN"
}

# Initial value 
resource "aws_secretsmanager_secret_version" "initial" {
  secret_id     = aws_secretsmanager_secret.super_secret.id
  secret_string = "initial-value-rotate-me"

  lifecycle {
    ignore_changes = [secret_string]   
  }
}
