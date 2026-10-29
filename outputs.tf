output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = module.internet_gateway.internet_gateway_id
}

output "public_subnet_id" {
  description = "ID of the public subnet hosting the web server."
  value       = module.public_subnet.subnet_id
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = module.public_route_table.route_table_id
}

output "web_security_group_id" {
  description = "ID of the web server security group."
  value       = module.web_security_group.security_group_id
}

output "web_instance_id" {
  description = "ID of the web server EC2 instance."
  value       = module.ec2.web_instance_id
}

output "web_public_ip" {
  description = "Public IPv4 address of the web server."
  value       = module.ec2.web_public_ip
}

output "web_public_dns" {
  description = "Public DNS name of the web server."
  value       = module.ec2.web_public_dns
}

output "web_url" {
  description = "HTTP URL for the web server."
  value       = module.ec2.web_url
}
