variable "api_id" {
  description = "ID of the HTTP API."
  type        = string
}

variable "route_key" {
  description = "Route key, for example \"GET /items/{id}\"."
  type        = string
}

variable "integration_id" {
  description = "ID of the integration that handles the route."
  type        = string
}

variable "authorizer_id" {
  description = "ID of a JWT authorizer. Null makes the route public."
  type        = string
  default     = null
  nullable    = true
}
