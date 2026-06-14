terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket         = "podinfo-tfstate"  
    key            = "lambda/terraform.tfstate"          
    region         = "us-east-1"
    dynamodb_table = "podinfo-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
data "aws_ecr_repository" "podinfo" {
  name = "podinfo"
}
data "aws_sns_topic" "alerts" {
  name = "podinfo-alerts"
}
