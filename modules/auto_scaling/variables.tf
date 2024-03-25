variable "region" {
  type        = string
  description = "Région AWS où l'infrastructure sera déployée"
  default     = "eu-west-3"
}
variable "vpc_zone_identifier" {
  description = "List of VPC zone identifiers for the Auto Scaling Group"
  type        = list(string)
}
