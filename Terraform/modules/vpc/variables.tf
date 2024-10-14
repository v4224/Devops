# CIDR block cho VPC
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Tên VPC
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

# List CIDR blocks cho public subnets
variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

# List CIDR blocks cho private subnets
variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

# List Availability Zones
variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
}
