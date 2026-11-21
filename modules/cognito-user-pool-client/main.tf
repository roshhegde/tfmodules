resource "aws_cognito_user_pool_client" "this" {
  name         = var.name
  user_pool_id = var.user_pool_id

  generate_secret = var.generate_secret
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
