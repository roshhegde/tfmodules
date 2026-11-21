resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  namespace           = var.namespace
  metric_name         = var.metric_name
  dimensions          = var.dimensions
  statistic           = var.statistic
  period              = var.period
  evaluation_periods  = var.evaluation_periods
  threshold           = var.threshold
  comparison_operator = var.comparison_operator
  treat_missing_data  = var.treat_missing_data
  alarm_actions       = var.alarm_actions

  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}
