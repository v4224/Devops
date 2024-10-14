variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a"]
}


variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default = "ami-0fff1b9a61dec8a5f"
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  default = "my-key-pair"
}

variable "my_ip_address" {
  description = "Your public IP for SSH access to the public EC2"
  default = "113.161.91.9/32"
}
