output "web_instance_id" {
  description = "ID of the web server EC2 instance."
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IPv4 address of the web server."
  value       = aws_instance.web.public_ip
}

output "web_public_dns" {
  description = "Public DNS name of the web server."
  value       = aws_instance.web.public_dns
}

output "web_url" {
  description = "HTTP URL for the web server."
  value       = "http://${aws_instance.web.public_dns}"
}
