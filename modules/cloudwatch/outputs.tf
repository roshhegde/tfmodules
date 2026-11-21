output "log_group_arns" {
  description = "Log group ARNs keyed by name."
  value       = { for k, v in aws_cloudwatch_log_group.this : k => v.arn }
}

output "alarm_arns" {
  description = "Alarm ARNs keyed by name."
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.arn }
}
