
# Bastion Security Group

resource "aws_security_group" "bastion" {

  name_prefix = "${var.Task_name}-bsg--"
  description = "allows 22"
  vpc_id      = var.main

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.Task_name}-bastion"
  }
}

# Web-Application Security Group


resource "aws_security_group" "sg" {

  name_prefix = "${var.Task_name}-sg--"
  description = "allows 80 443 22"
  vpc_id      = var.main

  ingress {
    description = "HTTP/HTTPS Access"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
    description     = "HTTPS Access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

 ingress {
    description     = "HTTP Access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }


  ingress {
    description = "SSH Access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.Task_name}-sg"
  }
}

# Load- balancer Security Group


resource "aws_security_group" "lb_sg" {

  name_prefix = "${var.Task_name}-lb_sg--"
  description = "allows 80 443 "
  vpc_id      = var.main

  ingress {
    description = "HTTP/HTTPS Access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.Task_name}-lb_sg"
  }


}