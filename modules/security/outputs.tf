output "sg_22_id" {
  description = "ID of the created security group sg_22"
  value       = aws_security_group.sg_22.id
}

output "sg_roland_id" {
  description = "ID of the created security group sg_roland"
  value       = aws_security_group.sg_roland.id
}

output "rolan_public_a_acl_id" {
  description = "ID of the created NACL rolan_public_a"
  value       = aws_network_acl.rolan_public_a.id
}

output "rolan_public_b_acl_id" {
  description = "ID of the created NACL rolan_public_b"
  value       = aws_network_acl.rolan_public_b.id
}

output "security_group_ids" {
  value = aws_security_group.sg_application_lb.id
}

output "aws_network_acl_a_id" {
  value = aws_network_acl.rolan_public_a.id
}
output "aws_network_acl_b_id" {
  value = aws_network_acl.rolan_public_b.id
}
