# Elastic IP

resource "aws_eip" "nat_eip" {
   
  depends_on = [var.igw]

  tags = {
    Name = "${var.Task_name}-eip"
  }
}


# Nat GateWay

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public1
  depends_on    = [var.igw]
  tags = {
    Name = "${var.Task_name}-nat"
  }
}

# Route Table Private

resource "aws_route_table" "route-private" {
  vpc_id = var.main
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw
  }
  tags = {
    Name = "${var.Task_name}-private-route"
  }
}

# Route Table Association Private

resource "aws_route_table_association" "private1" {
  subnet_id      = var.private1
  route_table_id = aws_route_table.route-private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = var.private2
  route_table_id = aws_route_table.route-private.id
}
