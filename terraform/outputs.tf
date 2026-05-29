output "backend_api_url" {
  description = "Connect your React app to this URL (Add to GitHub Secret: ALB_DNS)"
  value       = "http://${module.compute.alb_dns_name}"
}

output "frontend_url" {
  description = "Access your website via this CloudFront URL"
  value       = "https://${module.storage.cloudfront_domain_name}"
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution (Add to GitHub Secret: CLOUDFRONT_DIST_ID)"
  value       = module.storage.cloudfront_distribution_id
}

output "s3_bucket_name" {
  description = "Target S3 bucket for frontend assets (Add to GitHub Secret: S3_BUCKET_NAME)"
  value       = module.storage.s3_bucket_name
}

output "redis_endpoint" {
  description = "Redis endpoint for the application config (Add to GitHub Secret: REDIS_URL)"
  value       = module.redis.redis_endpoint
}

output "ecr_repository_url" {
  description = "ECR Repository URL for Docker pushes"
  # Replace 'backend' with whatever your ECR resource name is if you created it via Terraform
  value = module.compute.ecr_url
}
