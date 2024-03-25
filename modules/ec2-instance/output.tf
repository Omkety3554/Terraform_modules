
output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "bastion Server is firstinstance"
}

output "web_private_instance_id" {
  value = aws_instance.private.id
}