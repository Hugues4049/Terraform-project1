

variable "subnet_id" {
  description = "ID of the subnet for the bastion instance"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group for the bastion instance"
  type        = string
}


variable "key_id" {
  description = "ID of the keyfor the bastion instance"
  type        = number
}
