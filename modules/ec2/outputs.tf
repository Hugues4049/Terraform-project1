

output "database_primary_endpoint" {
  description = "Endpoint of the primary database instance"
  value       = aws_db_instance.database_instance
}

output "database_secondary_endpoint" {
  description = "Endpoint of the secondary database instance"
  value       = aws_db_instance.database_instance_secondary
}

output "db_instance_id" {
  value = aws_db_instance.database_instance.id
}

output "db_instance_secondary_id" {
  value = aws_db_instance.database_instance_secondary.id
}
output "key_id" {
  description = "Key id for  instance"
  value       = aws_key_pair.myec2key.id
}
