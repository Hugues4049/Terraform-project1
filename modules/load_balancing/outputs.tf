output "lb_arn" {
  description = "The ARN of the created load balancer"
  value       = aws_lb.lb_roland.arn
}

output "listener_arn" {
  description = "The ARN of the created listener"
  value       = aws_lb_listener.front_end.arn
}

output "target_group_arn" {
  description = "The ARN of the created target group"
  value       = aws_lb_target_group.roland_vms.arn
}

output "target_group_arn_B" {
  description = "The ARN of the second created target group"
  value       = aws_lb_target_group.roland_vms_B.arn
}

