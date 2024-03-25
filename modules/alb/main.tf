

# Target Group 

resource "aws_lb_target_group" "tg1" {
  name        = "The-tg1"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.main
  target_type = "instance"
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             = 200
    port                = 8080
    protocol            = "HTTP"
    path                = "/"
    timeout             = 2
  }

lifecycle {
  create_before_destroy = true
}


  tags = {
    Env = "${var.Task_name}-tg1"
  }

}

# Application LoadBalancer

resource "aws_lb" "alb" {
  name               = "The-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_grp_id]
  subnets            = [var.public1, var.public2]

  enable_deletion_protection = false

  tags = {
    Name = "${var.Task_name}-alb"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.tg1]


 default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
 }

}

# ALB Host Routing Rule -1

resource "aws_lb_listener_rule" "host_based_weighted_routing-1" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 40

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }

}


resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = var.web_private_instance_id
}