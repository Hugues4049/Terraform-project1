

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "List of application subnet IDs"
  type        = list(string)
}

variable "security_groups_application_lb" {
  type = string
}
