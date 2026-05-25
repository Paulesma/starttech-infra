output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.public[*].id # Note: Using public for now so EC2 can pull Docker images without a NAT Gateway (saves money)
}
