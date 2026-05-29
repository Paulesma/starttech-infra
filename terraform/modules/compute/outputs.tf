output "alb_dns_name" {
  description = "The DNS name of the backend load balancer"
  value       = aws_lb.backend_alb.dns_name
}

output "backend_sg_id" {
  description = "The ID of the security group assigned to the EC2 instances"
  value       = aws_security_group.ec2_sg.id
}

output "asg_name" {
  description = "The name of the Auto Scaling Group for monitoring and scaling policies"
  value       = aws_autoscaling_group.backend_asg.name
}

output "alb_arn_suffix" {
  description = "The ARN suffix of the ALB for CloudWatch metrics"
  value       = aws_lb.backend_alb.arn_suffix
}

output "target_group_arn_suffix" {
  description = "The ARN suffix of the Target Group for CloudWatch metrics"
  value       = aws_lb_target_group.backend_tg.arn_suffix
}

output "target_group_arn" {
  description = "The full ARN of the target group"
  value       = aws_lb_target_group.backend_tg.arn
}
output "ecr_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.backend.repository_url
}
