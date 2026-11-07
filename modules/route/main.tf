resource "aws_route" "this" {
  route_table_id         = var.route_table_id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = var.gateway_id
  nat_gateway_id         = var.nat_gateway_id

  lifecycle {
    precondition {
      condition     = (var.gateway_id != null) != (var.nat_gateway_id != null)
      error_message = "Set exactly one of gateway_id or nat_gateway_id."
    }
  }
}
