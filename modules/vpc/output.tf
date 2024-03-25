
# export region
output "region" {
  value = var.region
}

# export Task_name
output "Task_name" {
  value = var.Task_name
}

# export Environment
output "Environment" {
  value = var.Environment
}

# export vpc_id
output "main" {
  value = aws_vpc.main.id
}

# export internet gateway
output "igw" {
  value = aws_internet_gateway.igw.id
}

# export public1 id
output "public1" {
  value = aws_subnet.public1.id
}

# export public2 id
output "public2" {
  value = aws_subnet.public2.id
}

# export private1 id
output "private1" {
  value = aws_subnet.private1.id
}

# export private2 id
output "private2" {
  value = aws_subnet.private2.id
}

#export the first availabiity zone
output "az1" {
  value = data.aws_availability_zones.az.names[0]
}

# export the second availability zone
output "az2" {
  value = data.aws_availability_zones.az.names[1]
}