# EC2 instance
resource "aws_instance" "ec2" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name          = var.key_name

  tags = {
    Name = var.instance_name
  }

  user_data = var.user_data
}

# Elastic IP cho Public EC2 instance
resource "aws_eip" "public_eip" {
  count    = var.associate_public_ip ? 1 : 0
  instance = aws_instance.ec2.id
}
