module "instance_ctl_cloudwatch_event" {
  source = "../modules/cloudwatch_event"

  cloudwatch_event_vars = var.instance_ctl_cloudwatch_event_vars
  lambda_function_arn = module.instance_ctl_lambda.lambda_function_arn
}

module "instance_ctl_lambda" {
  source = "../modules/lambda"

  lambda_vars = var.instance_ctl_lambda_vars
  event_rule_arn = module.instance_ctl_cloudwatch_event.event_rule_arn
}

