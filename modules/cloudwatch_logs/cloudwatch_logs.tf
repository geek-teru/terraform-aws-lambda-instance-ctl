resource "aws_cloudwatch_log_group" "log_group" {
  name = var.lambda_log_group_name
}

resource "aws_cloudwatch_log_metric_filter" "metric_filter" {
  name           = var.cloudwatch_logs_vars.name
  pattern        = var.cloudwatch_logs_vars.pattern 
  log_group_name = aws_cloudwatch_log_group.log_group.name

  metric_transformation {
    name      = var.cloudwatch_logs_vars.name
    namespace = var.cloudwatch_logs_vars.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm" {
  alarm_name          = var.cloudwatch_logs_vars.name
  metric_name         = var.cloudwatch_logs_vars.name
  namespace           = var.cloudwatch_logs_vars.namespace

  statistic           = var.cloudwatch_alarm_vars.statistic
  evaluation_periods  = var.cloudwatch_alarm_vars.evaluation_periods

  period              = var.cloudwatch_alarm_vars.period
  comparison_operator = var.cloudwatch_alarm_vars.comparison_operator
  threshold           = var.cloudwatch_alarm_vars.threshold
  datapoints_to_alarm = var.cloudwatch_alarm_vars.datapoints_to_alarm

  alarm_description   = var.cloudwatch_alarm_vars.alarm_description
  actions_enabled     = var.cloudwatch_alarm_vars.actions_enabled
  treat_missing_data  = var.cloudwatch_alarm_vars.treat_missing_data

  alarm_actions       = [var.sns_arn]
  ok_actions          = [var.sns_arn]
}