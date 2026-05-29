# 1. Main VPC Definition
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true # Required for proper AWS service resolution
  tags = {
    Name = "starttech-vpc"
  }
}

# 2. Public Subnet Generation
resource "aws_subnet" "public" {
  # Dynamically creates subnets based on your input variable list
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  # CRITICAL: Ensures instances get the public IP for ECR/Docker/Mongo connectivity
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
    Tier = "public"
  }
}

# 3. Internet Gateway for Public Traffic
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "starttech-igw"
  }
}

# 4. Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Directs all non-local traffic (0.0.0.0/0) to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# 5. Route Table Association (Dynamic Version)
resource "aws_route_table_association" "public" {
  # Senior Fix: Dynamic count ensures all created subnets get associated
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# 6. Data Source for Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}
