locals {
  oidc_host    = "token.actions.githubusercontent.com"
  provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : var.oidc_provider_arn
  # subjects (list) wins, then subject (one string), then github_repository + github_ref.
  trusted_subjects = length(var.subjects) > 0 ? var.subjects : [coalesce(var.subject, "repo:${var.github_repository}:ref:${var.github_ref}")]
}

resource "aws_iam_openid_connect_provider" "github" {
  count           = var.create_oidc_provider ? 1 : 0
  url             = "https://${local.oidc_host}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.thumbprint_list

  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${local.oidc_host}:sub"
      values   = local.trusted_subjects
    }
  }
}

module "role" {
  source = "../iam-role"

  name                = var.role_name
  assume_role_policy  = data.aws_iam_policy_document.trust.json
  managed_policy_arns = var.policy_arns
  inline_policy_json  = var.inline_policy_json
  tags                = var.tags
}
