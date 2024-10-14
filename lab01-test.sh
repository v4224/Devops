#!/bin/bash

# Configuration
VPC_CIDR="10.0.0.0/16"
PUBLIC_SUBNET_CIDR="10.0.1.0/24"
PRIVATE_SUBNET_CIDR="10.0.2.0/24"

# Replace these with your actual subnet IDs after deployment
PUBLIC_SUBNET_ID="<public-subnet-id>"  # Update with the actual Public Subnet ID
PRIVATE_SUBNET_ID="<private-subnet-id>"  # Update with the actual Private Subnet ID
PUBLIC_EC2_ID="<public-ec2-id>"  # Update with the actual Public EC2 instance ID
PRIVATE_EC2_ID="<private-ec2-id>"  # Update with the actual Private EC2 instance ID

# Test Case 1: Check if VPC exists
echo "Checking if VPC with CIDR $VPC_CIDR exists..."
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=cidr,Values=$VPC_CIDR" --query "Vpcs[*].VpcId" --output text)
if [ -z "$VPC_ID" ]; then
    echo "ERROR: VPC with CIDR $VPC_CIDR does not exist!"
    exit 1
else
    echo "VPC with CIDR $VPC_CIDR exists: VPC ID is $VPC_ID"
fi

# Test Case 2: Check Public Subnet
echo "Checking if Public Subnet with CIDR $PUBLIC_SUBNET_CIDR exists..."
PUBLIC_SUBNET_CHECK=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=cidr-block,Values=$PUBLIC_SUBNET_CIDR" --query "Subnets[*].SubnetId" --output text)
if [ -z "$PUBLIC_SUBNET_CHECK" ]; then
    echo "ERROR: Public Subnet with CIDR $PUBLIC_SUBNET_CIDR does not exist!"
    exit 1
else
    echo "Public Subnet with CIDR $PUBLIC_SUBNET_CIDR exists: Subnet ID is $PUBLIC_SUBNET_CHECK"
fi

# Test Case 3: Check Private Subnet
echo "Checking if Private Subnet with CIDR $PRIVATE_SUBNET_CIDR exists..."
PRIVATE_SUBNET_CHECK=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" "Name=cidr-block,Values=$PRIVATE_SUBNET_CIDR" --query "Subnets[*].SubnetId" --output text)
if [ -z "$PRIVATE_SUBNET_CHECK" ]; then
    echo "ERROR: Private Subnet with CIDR $PRIVATE_SUBNET_CIDR does not exist!"
    exit 1
else
    echo "Private Subnet with CIDR $PRIVATE_SUBNET_CIDR exists: Subnet ID is $PRIVATE_SUBNET_CHECK"
fi

# Test Case 4: Check Internet Gateway
echo "Checking if Internet Gateway is attached to VPC..."
IGW_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[*].InternetGatewayId" --output text)
if [ -z "$IGW_ID" ]; then
    echo "ERROR: Internet Gateway is not attached to VPC!"
    exit 1
else
    echo "Internet Gateway is attached to VPC: IGW ID is $IGW_ID"
fi

# Test Case 5: Check NAT Gateway
echo "Checking if NAT Gateway exists in Public Subnet..."
NAT_GW_ID=$(aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" "Name=subnet-id,Values=$PUBLIC_SUBNET_CHECK" --query "NatGateways[*].NatGatewayId" --output text)
NAT_GW_STATE=$(aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" "Name=subnet-id,Values=$PUBLIC_SUBNET_CHECK" --query "NatGateways[*].State" --output text)
if [ -z "$NAT_GW_ID" ] || [ "$NAT_GW_STATE" != "available" ]; then
    echo "ERROR: NAT Gateway does not exist or is not available!"
    exit 1
else
    echo "NAT Gateway exists in Public Subnet: NAT Gateway ID is $NAT_GW_ID, State is $NAT_GW_STATE"
fi

# Test Case 6: Check Public Route Table for Internet Gateway route
echo "Checking if Public Route Table has a route to Internet Gateway..."
ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=$PUBLIC_SUBNET_CHECK" --query "RouteTables[*].RouteTableId" --output text)
IGW_ROUTE=$(aws ec2 describe-route-tables --route-table-ids $ROUTE_TABLE_ID --query "RouteTables[*].Routes[?GatewayId=='$IGW_ID']" --output text)
if [ -z "$IGW_ROUTE" ]; then
    echo "ERROR: Public Route Table does not have a route to the Internet Gateway!"
    exit 1
else
    echo "Public Route Table has a route to the Internet Gateway: Route Table ID is $ROUTE_TABLE_ID"
fi

# Test Case 7: Check Private Route Table for NAT Gateway route
echo "Checking if Private Route Table has a route to NAT Gateway..."
PRIVATE_ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=$PRIVATE_SUBNET_CHECK" --query "RouteTables[*].RouteTableId" --output text)
NAT_ROUTE=$(aws ec2 describe-route-tables --route-table-ids $PRIVATE_ROUTE_TABLE_ID --query "RouteTables[*].Routes[?NatGatewayId=='$NAT_GW_ID']" --output text)
if [ -z "$NAT_ROUTE" ]; then
    echo "ERROR: Private Route Table does not have a route to the NAT Gateway!"
    exit 1
else
    echo "Private Route Table has a route to the NAT Gateway: Route Table ID is $PRIVATE_ROUTE_TABLE_ID"
fi

# Test Case 8: Check Public EC2 instance status
echo "Checking if Public EC2 instance is running..."
PUBLIC_EC2_STATUS=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$PUBLIC_SUBNET_CHECK" --query "Reservations[*].Instances[*].State.Name" --output text)
PUBLIC_EC2_ID=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$PUBLIC_SUBNET_CHECK" --query "Reservations[*].Instances[*].InstanceId" --output text)
if [ "$PUBLIC_EC2_STATUS" != "running" ]; then
    echo "ERROR: Public EC2 instance is not running!"
    exit 1
else
    echo "Public EC2 instance is running: Instance ID is $PUBLIC_EC2_ID"
fi

# Test Case 9: Check Private EC2 instance status
echo "Checking if Private EC2 instance is running..."
PRIVATE_EC2_STATUS=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$PRIVATE_SUBNET_CHECK" --query "Reservations[*].Instances[*].State.Name" --output text)
PRIVATE_EC2_ID=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$PRIVATE_SUBNET_CHECK" --query "Reservations[*].Instances[*].InstanceId" --output text)
if [ "$PRIVATE_EC2_STATUS" != "running" ]; then
    echo "ERROR: Private EC2 instance is not running!"
    exit 1
else
    echo "Private EC2 instance is running: Instance ID is $PRIVATE_EC2_ID"
fi

# Test Case 10: Check if Elastic IP is associated with Public EC2 instance
echo "Checking if Elastic IP is associated with Public EC2 instance..."
PUBLIC_EC2_PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $PUBLIC_EC2_ID --query "Reservations[*].Instances[*].PublicIpAddress" --output text)
if [ -z "$PUBLIC_EC2_PUBLIC_IP" ]; then
    echo "ERROR: Elastic IP is not associated with the Public EC2 instance!"
    exit 1
else
    echo "Elastic IP is associated with Public EC2 instance: $PUBLIC_EC2_PUBLIC_IP"
fi

echo "All checks completed successfully!"
