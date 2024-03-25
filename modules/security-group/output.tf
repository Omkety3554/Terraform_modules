
output "alb_security_grp_id" {
  value = aws_security_group.lb_sg.id
}

output "web_app_security_grp_id" {
  value = aws_security_group.sg.id
}

output "bastion_security_grp_id" {
  value = aws_security_group.bastion.id
}