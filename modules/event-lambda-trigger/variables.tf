variable "lambda_config" {
  type = list(object({
    lambda_name         = string
    lambda_arn          = string
    lambda_role_arn     = string
    schedule_expression = string
  }))
}

variable "timezone" {
  type    = string
  default = "UTC"
}