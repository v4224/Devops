# AMI ID tạo EC2 instance
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

# Loại EC2 instance
variable "instance_type" {
  description = "The instance type (e.g., t2.micro)"
  type        = string
  default     = "t2.micro"
}

# ID của Subnet nơi EC2 instance sẽ được tạo
variable "subnet_id" {
  description = "The ID of the subnet in which to create the EC2 instance"
  type        = string
}

# Danh sách các Security Groups ID gán cho EC2 instance
variable "security_group_ids" {
  description = "The IDs of the security groups to attach to the EC2 instance"
  type        = list(string)
}

# EC2 instance (dùng để gắn tag)
variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
}

# SSH key để truy cập EC2 instance
variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}

# Script cấu hình EC2 instance khi khởi động (user data)
variable "user_data" {
  description = "User data script to configure the instance"
  type        = string
  default     = ""
}

# Có gắn Elastic IP cho instance hay không (chỉ dùng cho Public EC2)
variable "associate_public_ip" {
  description = "Whether to associate a public IP address (for instances in public subnets)"
  type        = bool
  default     = false
}
