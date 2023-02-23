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

resource "aws_iam_policy" "test_lambda_policy" {
  name        = "terraform_test_lambda_policy"
  description = "Allows creating log groups and streams and writing to log streams for lambda functions"

  policy = jsonencode({
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

resource "aws_iam_role" "test_lambda_role" {
  name = "terraform_test_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "",
        Effect = "Allow",
        Principal = {
          Service = [
            "lambda.amazonaws.com"
          ]
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_lambda_role_attatch" {
  role       = aws_iam_role.test_lambda_role.name
  policy_arn = aws_iam_policy.test_lambda_policy.arn
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

locals {
  funcs = [
    aws_lambda_function.test_func_1,
    aws_lambda_function.test_func_2
  ]
}

module "eventbridge-lambda-trigger" {
  source  = "daniel-devine-nrel/eventbridge-lambda-trigger/aws"
  version = ">=0.0.0"
  lambda_config = [for func in local.funcs : {
    lambda_name         = func.function_name
    lambda_arn          = func.arn
    lambda_role_arn     = func.role
    schedule_expression = "rate(2 hours)"
  }]
}
