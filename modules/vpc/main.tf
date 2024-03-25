


# VPC Creation 

resource "aws_vpc" "main" {
  cidr_block           =  var.main_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.Task_name}-${var.Environment}-vpc"
  }
}

# Collecting Avialabilty Zones 

data "aws_availability_zones" "az" {
  state = "available"
}

# Internet GateWay Creation

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.Task_name}-${var.Environment}-igw"
  }
}

# Public Subnet - 1 

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public1_cidr
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.Task_name}-${var.Environment}-public1"
  }
}

# Public Subnet - 2 

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public2_cidr
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.Task_name}-${var.Environment}-public2"
  }
}

# Private Subnet - 1

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private1_cidr
  availability_zone = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.Task_name}-${var.Environment}-private1"
  }
}

#private subnet - 2

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private2_cidr
  availability_zone = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.Task_name}-${var.Environment}-private2"
  }
}

# Route Table Public

resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.Task_name}-${var.Environment}-public-route"
  }
}


# Route Table Association Public


resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.route-public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.route-public.id
}