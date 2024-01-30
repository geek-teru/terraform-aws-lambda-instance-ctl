resource "aws_cloudwatch_event_rule" "event_rule" {
  name        = var.cloudwatch_event_vars.name
  description = var.cloudwatch_event_vars.description

  schedule_expression = var.cloudwatch_event_vars.schedule_expression
}

resource "aws_cloudwatch_event_target" "event_target" {
  arn  = var.lambda_function_arn
  rule = aws_cloudwatch_event_rule.event_rule.name 
}

output "event_rule_arn" {
  value = aws_cloudwatch_event_rule.event_rule.arn
}
