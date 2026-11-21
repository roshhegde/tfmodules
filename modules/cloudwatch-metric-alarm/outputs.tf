output "alarm_arn" {
  description = "ARN of the alarm."
  value       = aws_cloudwatch_metric_alarm.this.arn
}
