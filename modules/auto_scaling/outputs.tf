output "web_server_asg_id" {
  value       = aws_autoscaling_group.web_server_asg.id
  description = "Identifiant du groupe Auto Scaling des serveurs web"
}
/*
output "web_server_instance_ids" {
  value = aws_autoscaling_group.web_server_asg.instances
  description = "Liste des identifiants des instances du groupe Auto Scaling"
}*/
output "web_asg_name" {
  description = "Name of the Auto Scaling Group for the web instances"
  value       = aws_autoscaling_group.web_server_asg.name
}
