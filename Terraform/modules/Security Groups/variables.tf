# VPC ID
variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

# Địa chỉ IP để truy cập SSH
variable "my_ip_address" {
  description = "The IP address from which SSH access to the public EC2 instance is allowed"
  type        = string
}

# Tên VPC
variable "vpc_name" {
  description = "The name of the VPC (used for tagging resources)"
  type        = string
}
