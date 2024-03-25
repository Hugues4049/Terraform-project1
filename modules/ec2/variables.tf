variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  # Add any other variable declarations you need
}

variable "target_group_arn" {
  description = "ARN of the target group for main database instance"
  type        = string
}

variable "target_group_arn_B" {
  description = "ARN of the target group for secondary database instance"
  type        = string
}

variable "instance_subnet_ids" {
  description = "List of subnet IDs for EC2 instances"
  type        = list(string)
}
/*
variable "database_subnet_group_name" {
  description = "Name of the database subnet group"
  type        = string
}
*/

variable "instance_ami_filter_name" {
  type        = string
  description = "Filter name for EC2 instance AMI."
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance."
}

variable "database_engine" {
  type        = string
  description = "Database engine type."
}

variable "database_engine_version" {
  type        = string
  description = "Database engine version."
}

variable "database_instance_class" {
  type        = string
  description = "Database instance class."
}

variable "database_multi_az" {
  type        = bool
  description = "Enable Multi-AZ for the database."
}

variable "web_asg_desired_capacity" {
  type        = number
  description = "Desired capacity for the Auto Scaling Group of web instances."
}

variable "web_asg_max_size" {
  type        = number
  description = "Maximum size for the Auto Scaling Group of web instances."
}

variable "web_asg_min_size" {
  type        = number
  description = "Minimum size for the Auto Scaling Group of web instances."
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "app_subnet_ids" {
  description = "List of application subnet IDs"
  type        = list(string)
}
variable "sg_roland_id" {
  description = "The ID of the security group"
}
/*
variable "myec2key_key_name" {
  description = "The key name of the key pair"
}*/
variable "key_id" {
  description = "ID of the keyfor the bastion instance"
  type        = number
}
