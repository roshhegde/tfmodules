variable "name" {
  description = "Name prefix for the cluster and its IAM role."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the control plane network. Use at least two subnets in different Availability Zones."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "subnet_ids must contain at least two subnets."
  }
}

variable "endpoint_private_access" {
  description = "Enable the private Kubernetes API endpoint inside the VPC."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable the public Kubernetes API endpoint."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint. Restrict this to trusted ranges where possible."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "access_entries" {
  description = "Map of IAM principals to grant cluster access, with an EKS access policy for each. Use this for the CI deploy role and for humans."
  type = map(object({
    principal_arn = string
    policy_arn    = string
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags to apply to the cluster and its IAM role."
  type        = map(string)
  default     = {}
}
