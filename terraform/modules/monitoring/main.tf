# 1. Centralized Log Group (Requirement: Centralized logging for all services)
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/starttech/backend-logs"
  retention_in_days = 7
}

# 2. Metric Alarm (Requirement: Monitoring setup)
# This alerts you if your EC2 instances fail the ALB health check
resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "unhealthy-backend-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "Alarm if any backend instances are unhealthy"

  dimensions = {
    TargetGroup  = var.target_group_arn_suffix
    LoadBalancer = var.alb_arn_suffix
  }
}

# 3. CloudWatch Dashboard (Requirement: Phase 3 Monitoring)
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "StartTech-Dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Backend CPU Utilization"
        }
      }
    ]
  })
}
