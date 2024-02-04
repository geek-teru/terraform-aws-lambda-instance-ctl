data "archive_file" "lambda_package" {
  type        = var.lambda_vars.package_type
  source_dir  = var.lambda_vars.package_source_dir
  output_path = var.lambda_vars.package_output_path
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_vars.function_name
  handler       = var.lambda_vars.handler
  runtime       = var.lambda_vars.runtime
  timeout       = var.lambda_vars.timeout_sec
  role          = var.lambda_vars.role_arn

  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  logging_config {
    log_format = "Text"
    log_group = "/aws/lambda/${var.lambda_vars.function_name}"
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = var.event_rule_arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.lambda_function.arn
}

output "lambda_log_group_name" {
  value = aws_lambda_function.lambda_function.logging_config[0].log_group
}