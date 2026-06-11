variable "aws_region" {
  default = "us-east-1"
}

variable "github_org" {
  description = "rabbiya"
  type        = string
}

variable "github_repo" {
  description = "podinfo-canary-rollout"
  type        = string
  default     = "podinfo-canary-rollout"
}
