output "role_arn" {
  description = "ARN of the role for GitHub Actions to assume. Use it in aws-actions/configure-aws-credentials."
  value       = module.role.role_arn
}

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider used by the role."
  value       = local.provider_arn
}
