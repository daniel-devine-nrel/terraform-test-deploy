output "eventbridge_rules" {
  description = "List of names and arns of EventBridge rules created"
  value = [for rule in aws_scheduler_schedule.triggers : {
    name = rule.id
    arn  = rule.arn
  }]
}