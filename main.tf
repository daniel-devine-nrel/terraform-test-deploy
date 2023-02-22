provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      billingId = "210001"
      org       = "ops"
    }
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "test_lambda_role" {
  name = "terraform_test_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "0"
        Effect = "Allow"
        Action = "logs:CreateLogGroup"
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
        ]
      },
      {
        Sid      = "1"
        Effect   = "Allow"
        Action   = "logs:PutLogEvents"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*:log-stream:*"
      },
      {
        Sid      = "2"
        Effect   = "Allow"
        Action   = "logs:CreateLogStream"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
      }
    ]
  })
}

resource "aws_lambda_function" "test_func_1" {
  function_name = "terraform_test_func_1"
  role          = aws_iam_role.test_lambda_role.arn
  description   = "Testing Terraform deploy on multiple lambda functions"
  filename      = var.lambda_file
  handler       = "test_func_1"
  runtime       = "python3.9"
}

resource "aws_lambda_function" "test_func_2" {
  function_name = "terraform_test_func_2"
  role          = aws_iam_role.test_lambda_role.arn
  description   = "Testing Terraform deploy on multiple lambda functions"
  filename      = var.lambda_file
  handler       = "test_func_2"
  runtime       = "python3.9"
}
