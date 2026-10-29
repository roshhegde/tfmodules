output "association_id" {
  description = "ID of the created route-table association."
  value       = aws_route_table_association.this.id
}
