output "nat_gateway_id" {
  description = "ID of the NAT gateway. Use it as the target of private route table default routes."
  value       = aws_nat_gateway.this.id
}

output "public_ip" {
  description = "Public IP address of the NAT gateway."
  value       = aws_eip.this.public_ip
}
