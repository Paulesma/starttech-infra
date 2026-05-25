output "backend_api_url" {
  description = "Connect your React app to this URL"
  value       = "http://${module.compute.alb_dns_name}"
}

output "frontend_url" {
  description = "Access your website via this CloudFront URL"
  value       = "https://${module.storage.cloudfront_domain_name}"
}

output "s3_bucket_name" {
  value = module.storage.s3_bucket_name
}
output "redis_endpoint" {
  value = module.redis.redis_endpoint
}
