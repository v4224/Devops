provider "aws" {
  region = "us-east-1"
}

# VPC
module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  availability_zones  = var.availability_zones
  vpc_name            = "my-vpc"
}

# NAT Gateway
module "nat_gateway" {
  source           = "./modules/NAT Gateway"
  public_subnet_id = module.vpc.public_subnet_ids[0]
}

# Route Tables cho Public và Private Subnets
module "route_tables" {
  source            = "./modules/Route tables"
  vpc_id            = module.vpc.vpc_id
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id    = module.nat_gateway.nat_gateway_id
}

# Security Groups
module "security_groups" {
  source        = "./modules/Security Groups"
  vpc_id        = module.vpc.vpc_id
  my_ip_address = var.my_ip_address 
  vpc_name      = "my-vpc"
}

# Public EC2 instance
module "public_ec2" {
  source              = "./modules/EC2"
  ami_id              = var.ami_id
  instance_type       = "t2.micro"
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_ids  = [module.security_groups.public_ec2_sg_id]
  key_name            = var.key_name
  instance_name       = "Public-EC2"
  associate_public_ip = true
}

# Tạo Private EC2 instance
module "private_ec2" {
  source              = "./modules/EC2"
  ami_id              = var.ami_id
  instance_type       = "t2.micro"
  subnet_id           = module.vpc.private_subnet_ids[0]
  security_group_ids  = [module.security_groups.private_ec2_sg_id]
  key_name            = var.key_name
  instance_name       = "Private-EC2"
  associate_public_ip = false
}
