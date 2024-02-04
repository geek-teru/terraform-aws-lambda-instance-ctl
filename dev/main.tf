module "instance_ctl_lambda" {
  source = "../modules/lambda"

  lambda_vars = var.instance_ctl_lambda_vars
  event_rule_arn = module.instance_ctl_cloudwatch_event.event_rule_arn
}

module "instance_ctl_cloudwatch_event" {
  source = "../modules/cloudwatch_event"

  cloudwatch_event_vars = var.instance_ctl_cloudwatch_event_vars
  lambda_function_arn = module.instance_ctl_lambda.lambda_function_arn
}

module "instance_ctl_cloudwatch_logs" {
  source = "../modules/cloudwatch_logs"

  cloudwatch_logs_vars = var.instance_ctl_cloudwatch_logs_vars
  cloudwatch_alarm_vars = var.instance_ctl_cloudwatch_alarm_vars
  lambda_log_group_name = module.instance_ctl_lambda.lambda_log_group_name
  sns_arn = module.instance_ctl_sns.sns_arn
}

module "instance_ctl_sns" {
  source = "../modules/sns"

  sns_vars = var.instance_ctl_sns_vars
}
