output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR range of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs, in the order of var.azs."
  value       = [for az in var.azs : aws_subnet.public[az].id if contains(keys(aws_subnet.public), az)]
}

output "private_subnet_ids" {
  description = "Private subnet IDs, in the order of var.azs."
  value       = [for az in var.azs : aws_subnet.private[az].id if contains(keys(aws_subnet.private), az)]
}

output "internet_gateway_id" {
  description = "ID of the internet gateway, or null when no public subnets were requested."
  value       = one(aws_internet_gateway.this[*].id)
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs keyed by AZ."
  value       = { for az, nat in aws_nat_gateway.this : az => nat.id }
}

output "nat_public_ips" {
  description = "Public IPs of the NAT gateways, keyed by AZ. Outbound traffic from private subnets comes from these."
  value       = { for az, eip in aws_eip.nat : az => eip.public_ip }
}
