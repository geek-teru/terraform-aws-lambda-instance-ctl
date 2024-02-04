# lambda
variable "instance_ctl_lambda_vars" {
  type = map
}

# event bridge
variable "instance_ctl_cloudwatch_event_vars" {
  type = map
}

# cloudwatch logs
variable "instance_ctl_cloudwatch_logs_vars" {
  type = map
}

# cloudwatch alarm
variable "instance_ctl_cloudwatch_alarm_vars" {
  type = map
}

# sns
variable "instance_ctl_sns_vars" {
  type = map
}
