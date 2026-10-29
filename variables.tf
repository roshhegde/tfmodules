variable "name" {
  description = "Name prefix applied to the AWS resources."
  type        = string
  default     = "terraform-web"

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+$", var.name))
    error_message = "The name must contain only letters, numbers, and hyphens."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "IPv4 CIDR range for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair name. SSH ingress remains disabled when null."
  type        = string
  default     = null
  nullable    = true
}

variable "ssh_allowed_cidrs" {
  description = "IPv4 CIDR ranges allowed to connect over SSH. Keep this restricted to trusted IPs."
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
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
