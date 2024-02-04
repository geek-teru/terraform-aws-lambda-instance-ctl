variable "cloudwatch_logs_vars" {
  type = map
}

variable "cloudwatch_alarm_vars" {
  type = map
}

variable "lambda_log_group_name" {
  type = string
}

variable "sns_arn" {
  type = string
}
