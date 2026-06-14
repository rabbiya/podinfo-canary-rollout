variable "aws_region" {
  default = "us-east-1"
}

variable "image_digest" {
  description = "ECR image digest"
  type        = string
}
