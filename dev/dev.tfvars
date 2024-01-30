# lambda
instance_ctl_lambda_vars = {
  package_type        = "zip"
  package_source_dir  = "./package"
  package_output_path = "./package.zip"
  function_name    = "instance_ctl_function"
  handler          = "main.lambda_handler"
  runtime          = "python3.11"
  timeout_sec      = 60
  role_arn = "arn:aws:iam::775538353788:role/lambda-invoke-ec2-start-stop"
}

# event bridge
instance_ctl_cloudwatch_event_vars = {
  name    = "instance-ctl-schedule"
  description = "Invoke lambda function that start and stop instances every hour", 
  schedule_expression = "cron(0 * * * ? *)"
}
