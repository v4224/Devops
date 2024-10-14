# VPC ID
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

# Public Subnet IDs
output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "List of public subnet IDs"
}

# Private Subnet IDs
output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "List of private subnet IDs"
}

# Internet Gateway ID
output "internet_gateway_id" {
  value       = aws_internet_gateway.gw.id
  description = "The ID of the Internet Gateway"
}

# Default Security Group ID
output "default_security_group_id" {
  value       = aws_security_group.default.id
  description = "The ID of the default security group for the VPC"
}