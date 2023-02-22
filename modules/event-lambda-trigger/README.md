# EventBridge Lambda Trigger

Used to set up scheduled EventBridge rules to trigger Lambda functions. Give a list of lambda functions you would like triggered, and EventBridge rules will be created to trigger each one.

## Inputs

`lambda_config` - A list of objects with the following values:
* `lambda_name` - (required) Name of the lambda function
* `lambda_arn` - (required) Arn of the lambda function
* `lambda_role_arn` - (required) Arn of the IAM role the lambda function uses
* `schedule_expression` - (required) A string in the format of an AWS schedule expression. Either a cron or a rate expression

`timezone` - The timezone to use for cron schedule expressions

## Outputs

`eventbridge_rules` - A list of objects for each EventBridge rule created with the following values:
* `name` - The name of the EventBridge rule
* `arn` - The arn of the EventBridge rule
