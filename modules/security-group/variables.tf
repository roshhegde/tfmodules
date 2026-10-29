variable "name" {
  description = "Name prefix applied to the security group."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created."
  type        = string
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair name. Required when SSH CIDRs are configured."
  type        = string
  default     = null
  nullable    = true
}

variable "ssh_allowed_cidrs" {
  description = "IPv4 CIDR ranges allowed to connect over SSH."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.ssh_allowed_cidrs : can(cidrnetmask(cidr))
    ])
    error_message = "Every SSH allowed CIDR must be a valid IPv4 CIDR range."
  }
}

variable "tags" {
  description = "Additional tags to apply to the security group."
  type        = map(string)
  default     = {}
}
