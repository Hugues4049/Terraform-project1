output "bastion_instance_id" {
  description = "ID of the created bastion instance"
  value       = aws_instance.roland_bastion.id
}

output "bastion_instance_public_ip" {
  description = "Public IP of the created bastion instance"
  value       = aws_instance.roland_bastion.public_ip
}

output "bastion_instance_private_ip" {
  description = "Private IP of the created bastion instance"
  value       = aws_instance.roland_bastion.private_ip
}
output "key_id" {
  description = "Key id for bastion instance"
  value       = aws_key_pair.myec2key.id
}
