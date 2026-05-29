output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

# Senior Tip: Keep the name 'private_subnets' so your other modules 
# don't break, but document WHY they point to the public IDs.
output "private_subnets" {
  description = "List of subnet IDs for private resources (Redis)"
  value       = aws_subnet.public[*].id
}
