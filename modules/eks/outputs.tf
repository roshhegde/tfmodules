output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster."
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Endpoint URL of the Kubernetes API."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 certificate authority data for the cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group EKS creates for the cluster. Managed nodes without a launch template, and their pods, use it."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "cluster_role_arn" {
  description = "ARN of the IAM role used by the control plane."
  value       = module.cluster_role.role_arn
}

output "node_role_arn" {
  description = "ARN of the IAM role used by the nodes."
  value       = module.node_role.role_arn
}

output "node_group_names" {
  description = "Node group names keyed by the node_groups map key."
  value       = { for k, ng in aws_eks_node_group.this : k => ng.node_group_name }
}

output "pod_identity_role_arns" {
  description = "IAM role ARNs keyed by the pod_identities map key."
  value       = { for k, r in module.pod_identity_role : k => r.role_arn }
}
