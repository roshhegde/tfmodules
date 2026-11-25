# One module for Amazon EKS: the control plane, managed node groups, EKS add-ons,
# Pod Identity associations and access entries. These are all parts of the same
# AWS service, so they live together (one module per service).

locals {
  base_tags = merge(var.tags, { ManagedBy = "Terraform" })
}

# ------------------------------------------------------------ Control plane --

data "aws_iam_policy_document" "cluster_assume" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

module "cluster_role" {
  source = "../iam-role"

  name                = "${var.name}-eks-cluster"
  assume_role_policy  = data.aws_iam_policy_document.cluster_assume.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
  tags                = var.tags
}

resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = module.cluster_role.role_arn
  version  = var.kubernetes_version

  enabled_cluster_log_types = var.enabled_cluster_log_types

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_creator_admin
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  tags = local.base_tags

  depends_on = [module.cluster_role]
}

# ---------------------------------------------------------- Access entries --
# Who may use the Kubernetes API, mapped from IAM principals. No aws-auth ConfigMap.

resource "aws_eks_access_entry" "this" {
  for_each      = var.access_entries
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal_arn
  type          = "STANDARD"
  tags          = local.base_tags
}

resource "aws_eks_access_policy_association" "this" {
  for_each      = var.access_entries
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = each.value.principal_arn
  policy_arn    = each.value.policy_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.this]
}

# ------------------------------------------------------ Managed node groups --

data "aws_iam_policy_document" "node_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

module "node_role" {
  source = "../iam-role"

  name               = "${var.name}-eks-node"
  assume_role_policy = data.aws_iam_policy_document.node_assume.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]

  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-${each.key}"
  node_role_arn   = module.node_role.role_arn
  subnet_ids      = coalesce(each.value.subnet_ids, var.subnet_ids)
  instance_types  = each.value.instance_types
  capacity_type   = each.value.capacity_type
  ami_type        = each.value.ami_type
  disk_size       = each.value.disk_size
  labels          = each.value.labels

  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = local.base_tags

  lifecycle {
    precondition {
      condition     = each.value.min_size <= each.value.desired_size && each.value.desired_size <= each.value.max_size
      error_message = "Each node group needs min_size <= desired_size <= max_size."
    }

    # Let an autoscaler change the node count without Terraform fighting it.
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [module.node_role]
}

# ------------------------------------------------------------------ Add-ons --
# AWS-managed cluster components (VPC CNI, CoreDNS, kube-proxy, Pod Identity Agent).
# Created after the nodes, because CoreDNS needs somewhere to run.

resource "aws_eks_addon" "this" {
  for_each = var.addons

  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = each.key
  addon_version               = each.value.version
  configuration_values        = each.value.configuration_values
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = local.base_tags

  depends_on = [aws_eks_node_group.this]
}

# ---------------------------------------------------- Pod Identity (IRSA v2) --
# Each entry gives one Kubernetes service account an IAM role. The role is
# created here with a trust policy for pods.eks.amazonaws.com, so pods using that
# service account get its AWS credentials from the Pod Identity Agent.

data "aws_iam_policy_document" "pod_identity_assume" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    # Only pods in this cluster can use the role.
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_eks_cluster.this.arn]
    }
  }
}

module "pod_identity_role" {
  source   = "../iam-role"
  for_each = var.pod_identities

  name                = "${var.name}-${each.key}"
  assume_role_policy  = data.aws_iam_policy_document.pod_identity_assume.json
  managed_policy_arns = each.value.policy_arns
  inline_policy_json  = each.value.inline_policy_json
  tags                = var.tags
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = var.pod_identities

  cluster_name    = aws_eks_cluster.this.name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = module.pod_identity_role[each.key].role_arn

  tags = local.base_tags
}
