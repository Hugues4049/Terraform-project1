variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_subnet_cidr_blocks" {
  description = "CIDR blocks for app subnets"
  type        = list(string)
  default     = ["10.1.0.0/24"]
}


variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  # Add any other variable declarations you need
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "List of application subnet IDs"
  type        = list(string)
}
variable "aws_network_acl_a_id" {
  type = string
}
variable "aws_network_acl_b_id" {
  type = string
}
