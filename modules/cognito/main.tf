# A Cognito user pool with email sign-in and its app client.

resource "aws_cognito_user_pool" "this" {
  name                     = "${var.name}-users"
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
    Name      = "${var.name}-users"
    ManagedBy = "Terraform"
  })
}

resource "aws_cognito_user_pool_client" "this" {
  name         = "${var.name}-client"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = var.generate_client_secret
  explicit_auth_flows = concat(
    ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"],
    var.allow_password_auth ? ["ALLOW_USER_PASSWORD_AUTH"] : [],
  )
  prevent_user_existence_errors = "ENABLED"
  access_token_validity         = var.token_validity_hours
  id_token_validity             = var.token_validity_hours
  refresh_token_validity        = var.refresh_token_validity_days

  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }
}
