variable "cidr_vpc" {
  description = "CIDR du VPC"
  default     = "10.1.0.0/16"

}


variable "cidr_public_subnet_a" {
  description = "CIDR du Sous-réseau  public a"
  default     = "10.0.128.0/20"

}

variable "cidr_public_subnet_b" {
  description = "CIDR du Sous-réseau  public b"
  default     = "10.0.144.0/20"

}

variable "cidr_app_subnet_a" {
  description = "CIDR du Sous-réseau privé a"
  default     = "10.0.0.0/19"

}

variable "cidr_app_subnet_b" {
  description = "CIDR du Sous-réseau privé b"
  default     = "10.0.32.0/19"

}


variable "az_a" {
  description = "zone de disponibilité a"
  default     = "eu-west-3a"
}


variable "az_b" {
  description = "zone de disponibilité b"
  default     = "eu-west-3b"

}
variable "environement" {
  type    = string
  default = "dev"
}