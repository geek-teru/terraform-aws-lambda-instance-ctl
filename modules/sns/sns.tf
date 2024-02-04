resource "aws_sns_topic" "sns_topic" {
  name = var.sns_vars.name
}

output "sns_arn" {
  value = aws_sns_topic.sns_topic.arn
}