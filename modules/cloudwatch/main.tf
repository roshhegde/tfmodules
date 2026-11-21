# CloudWatch log groups and metric alarms. Pass as many of each as you
# need; either map can be empty.

resource "aws_cloudwatch_log_group" "this" {
  for_each          = var.log_groups
  name              = each.key
  retention_in_days = each.value.retention_in_days

  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}

resource "aws_cloudwatch_metric_alarm" "this" {
  for_each            = var.metric_alarms
  alarm_name          = each.key
  alarm_description   = each.value.description
  namespace           = each.value.namespace
  metric_name         = each.value.metric_name
  dimensions          = each.value.dimensions
  statistic           = each.value.statistic
  period              = each.value.period
  evaluation_periods  = each.value.evaluation_periods
  threshold           = each.value.threshold
  comparison_operator = each.value.comparison_operator
  treat_missing_data  = each.value.treat_missing_data
  alarm_actions       = each.value.alarm_actions

  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}
