variable "asg_name" {
  description = "The name of the Auto Scaling Group to monitor"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "The ARN suffix of the Target Group for health metrics"
  type        = string
}

variable "alb_arn_suffix" {
  description = "The ARN suffix of the ALB for request metrics"
  type        = string
}

variable "aws_region" {
  description = "The AWS region for the dashboard"
  type        = string
}
