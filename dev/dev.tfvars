# lambda
instance_ctl_lambda_vars = {
  package_type        = "zip"
  package_source_dir  = "./package"
  package_output_path = "./package.zip"
  function_name    = "instance-ctl-function"
  handler          = "main.lambda_handler"
  runtime          = "python3.11"
  timeout_sec      = 60
  role_arn         = "arn:aws:iam::775538353788:role/lambda-instance-ctl"
}

# event bridge
instance_ctl_cloudwatch_event_vars = {
  name        = "instance-ctl-schedule"
  description = "Invoke lambda function every hour", 
  schedule_expression = "cron(0 * * * ? *)"
}

# cloudwatch logs
instance_ctl_cloudwatch_logs_vars = {
  namespace = "CustomMetrics"
  name      = "LambdaInstanceCtlFunctionErrorCount"
  pattern   = "ERROR"
}

instance_ctl_cloudwatch_alarm_vars = {
  statistic           = "Maximum"

  # 100分間(20datapoints)で、1回でも閾値を超えた場合、異常とみなす
  evaluation_periods  = 20
  datapoints_to_alarm = 1  

  period              = 300
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 1

  alarm_description   = "instance_ctl_function failed."
  actions_enabled     = "true"

  # データがない場合、正常とみなす。（20datapointsデータがない場合、正常に戻る）
  treat_missing_data  = "notBreaching" 
}

# sns
instance_ctl_sns_vars = {
  name = "instance-ctl-sns"
}