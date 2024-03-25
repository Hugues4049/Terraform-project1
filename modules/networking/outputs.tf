output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.roland_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

output "app_subnet_id" {
  description = "IDs of the created app subnets"
  value       = [aws_subnet.app_subnet_a.id, aws_subnet.app_subnet_b.id]
}

output "igw_id" {
  description = "ID of the created Internet Gateway"
  value       = aws_internet_gateway.roland_igateway.id
}

output "rtb_public_id" {
  description = "ID of the created public route table"
  value       = aws_route_table.rtb_public.id
}

output "rtb_appa_id" {
  description = "ID of the created app subnet A route table"
  value       = aws_route_table.rtb_appa.id
}

output "rtb_appb_id" {
  description = "ID of the created app subnet B route table"
  value       = aws_route_table.rtb_appb.id
}


output "eip_public_a" {
  description = "Public IP address of the created EIP for nat gateway A"
  value       = aws_eip.eip_public_a.public_ip
}

output "eip_public_b" {
  description = "Public IP address of the created EIP for nat gateway B"
  value       = aws_eip.eip_public_b.public_ip
}

output "nat_gw_id_a" {
  description = "ID of the created nat gateway A"
  value       = aws_nat_gateway.gw_public_a.id
}

output "nat_gw_id_b" {
  description = "ID of the created nat gateway B"
  value       = aws_nat_gateway.gw_public_b.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}

output "app_subnet_a_id" {
  value = aws_subnet.app_subnet_a.id
}

output "app_subnet_b_id" {
  value = aws_subnet.app_subnet_b.id
}
output "vpc_zone_identifier" {
  value = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}
