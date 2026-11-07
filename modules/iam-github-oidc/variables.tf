variable "role_name" {
  description = "Name of the IAM role that GitHub Actions assumes."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository allowed to assume the role, in owner/repo form."
  type        = string

  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "github_repository must be in owner/repo form."
  }
}

variable "github_ref" {
  description = "Git ref allowed to assume the role, for example refs/heads/main. Use * to allow any ref."
  type        = string
  default     = "refs/heads/main"
}

variable "create_oidc_provider" {
  description = "Create the GitHub OIDC provider in this account. Set to false if it already exists and pass oidc_provider_arn."
  type        = bool
  default     = true
}

variable "oidc_provider_arn" {
  description = "ARN of an existing GitHub OIDC provider. Required when create_oidc_provider is false."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.create_oidc_provider || var.oidc_provider_arn != null
    error_message = "oidc_provider_arn is required when create_oidc_provider is false."
  }
}

variable "thumbprint_list" {
  description = "Certificate thumbprints for the GitHub OIDC endpoint."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

variable "policy_arns" {
  description = "Managed policy ARNs to attach to the role. Keep this to the least privilege the pipeline needs."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the OIDC provider and role."
  type        = map(string)
  default     = {}
}
