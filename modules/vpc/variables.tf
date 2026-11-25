variable "name" {
  description = "Name prefix applied to the VPC and everything in it."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR range for the VPC."
  type        = string
}

variable "azs" {
  description = "Availability Zones to place subnets in, in order. The Nth public and private CIDR go in the Nth AZ."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "One CIDR per AZ for public subnets (load balancers, NAT gateways). Empty creates no public subnets and no internet gateway."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.public_subnet_cidrs : can(cidrnetmask(c))])
    error_message = "Every public subnet CIDR must be a valid IPv4 CIDR."
  }
}

variable "private_subnet_cidrs" {
  description = "One CIDR per AZ for private subnets (nodes, pods, databases). Empty creates no private subnets."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.private_subnet_cidrs : can(cidrnetmask(c))])
    error_message = "Every private subnet CIDR must be a valid IPv4 CIDR."
  }
}

variable "nat_gateway_mode" {
  description = "Outbound internet for private subnets: none, single (one NAT in the first AZ) or per_az (one NAT per AZ)."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["none", "single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be none, single or per_az."
  }
}

variable "public_subnet_tags" {
  description = "Extra tags for public subnets, such as kubernetes.io/role/elb = 1 so the AWS Load Balancer Controller finds them."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Extra tags for private subnets, such as kubernetes.io/role/internal-elb = 1."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags to apply to every resource."
  type        = map(string)
  default     = {}
}
