# lambda source code
data "archive_file" "function_package" {
  type        = "zip"
  source_dir  = "./package"
  output_path = "./package.zip"
}

resource "aws_lambda_function" "instance_ctl_lambda" {
  function_name = var.instance_ctl_lambda_config.function_name
  handler       = var.instance_ctl_lambda_config.handler
  runtime       = var.instance_ctl_lambda_config.runtime
  timeout       = var.instance_ctl_lambda_config.timeout_sec
  role          = var.instance_ctl_lambda_config.role_arn

  filename         = data.archive_file.function_package.output_path
  source_code_hash = data.archive_file.function_package.output_base64sha256
}

resource "aws_lambda_permission" "instance_ctl_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.instance_ctl_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.instance_ctl_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "instance_ctl_event_rule" {
  name        = var.instance_ctl_event_config.name
  description = var.instance_ctl_event_config.description

  schedule_expression = var.instance_ctl_event_config.schedule_expression
}

resource "aws_cloudwatch_event_target" "instance_ctl_event_target" {
  arn  = aws_lambda_function.instance_ctl_lambda.arn
  rule = aws_cloudwatch_event_rule.instance_ctl_event_rule.name 
}