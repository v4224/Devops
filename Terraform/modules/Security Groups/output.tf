# Public EC2 Security Group ID
output "public_ec2_sg_id" {
  value       = aws_security_group.public_ec2_sg.id
  description = "The ID of the public EC2 security group"
}

# Private EC2 Security Group ID
output "private_ec2_sg_id" {
  value       = aws_security_group.private_ec2_sg.id
  description = "The ID of the private EC2 security group"
}
