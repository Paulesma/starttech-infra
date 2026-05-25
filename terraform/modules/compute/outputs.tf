output "alb_dns_name" {
  description = "The DNS name of the backend load balancer"
  value       = aws_lb.backend_alb.dns_name
}
output "backend_sg_id" {
  value = aws_security_group.alb_sg.id # Or the specific SG you created for the EC2 instances
}
