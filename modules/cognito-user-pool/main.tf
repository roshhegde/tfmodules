resource "aws_cognito_user_pool" "this" {
  name                     = var.name
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  deletion_protection      = var.deletion_protection ? "ACTIVE" : "INACTIVE"

  password_policy {
    minimum_length    = var.password_min_length
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = var.password_require_symbols
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "Terraform"
  })
}
