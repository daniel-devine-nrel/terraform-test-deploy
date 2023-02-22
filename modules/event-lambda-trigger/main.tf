resource "aws_scheduler_schedule" "triggers" {
  count = length(var.lambda_config)

  name = "${var.lambda_config[count.index]["lambda_name"]}-scheduler"
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = var.lambda_config[count.index]["schedule_expression"]
  schedule_expression_timezone = var.timezone

  target {
    arn      = var.lambda_config[count.index]["lambda_arn"]
    role_arn = var.lambda_config[count.index]["lambda_role_arn"]
  }
}