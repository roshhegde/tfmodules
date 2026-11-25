variable "name" {
  description = "Cluster name. Also the prefix for its IAM roles and node groups."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the control plane, such as 1.34."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the control plane network interfaces and, by default, the nodes. Use private subnets in at least two AZs."
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
  description = "Enable the public Kubernetes API endpoint. IAM still controls who can use it."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint. Restrict this to trusted ranges where possible."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_cluster_log_types" {
  description = "Control plane logs to send to CloudWatch, such as api, audit, authenticator. Empty keeps costs at zero."
  type        = list(string)
  default     = []
}

variable "bootstrap_creator_admin" {
  description = "Give the IAM principal that creates the cluster admin access. Set false when you list every admin in access_entries."
  type        = bool
  default     = true
}

variable "access_entries" {
  description = "IAM principals allowed into the cluster, each with one EKS access policy (for example AmazonEKSClusterAdminPolicy)."
  type = map(object({
    principal_arn = string
    policy_arn    = string
  }))
  default = {}
}

variable "node_groups" {
  description = "Managed node groups keyed by short name. Use ami_type AL2023_ARM_64_STANDARD for Graviton (t4g, m7g) instances and capacity_type SPOT for spare capacity at a discount."
  type = map(object({
    instance_types = list(string)
    capacity_type  = optional(string, "ON_DEMAND")
    ami_type       = optional(string, "AL2023_x86_64_STANDARD")
    disk_size      = optional(number, 20)
    desired_size   = number
    min_size       = number
    max_size       = number
    subnet_ids     = optional(list(string))
    labels         = optional(map(string), {})
  }))
  default = {}
}

variable "addons" {
  description = "EKS add-ons keyed by add-on name (vpc-cni, coredns, kube-proxy, eks-pod-identity-agent). A null version uses the default for the cluster version."
  type = map(object({
    version              = optional(string)
    configuration_values = optional(string)
  }))
  default = {}
}

variable "pod_identities" {
  description = "IAM roles for Kubernetes service accounts through EKS Pod Identity, keyed by role suffix. The pod_identity_role_arns output returns each role's ARN."
  type = map(object({
    namespace          = string
    service_account    = string
    policy_arns        = optional(list(string), [])
    inline_policy_json = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags to apply to every resource."
  type        = map(string)
  default     = {}
}
