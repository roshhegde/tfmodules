# One module for an Amazon RDS database: the DB instance plus the pieces that
# only exist for it (subnet group, parameter group and its security group).
# The master password is generated and rotated by RDS in Secrets Manager, so it
# never appears in Terraform code, variables or state.

locals {
  base_tags = merge(var.tags, { ManagedBy = "Terraform" })
  family    = coalesce(var.parameter_group_family, "${var.engine}${split(".", var.engine_version)[0]}")
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db"
  subnet_ids = var.subnet_ids

  tags = merge(local.base_tags, {
    Name = "${var.name}-db"
  })
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.name}-db"
  family = local.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }

  tags = local.base_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.name}-db-"
  description = "Database access for ${var.name}"
  vpc_id      = var.vpc_id

  tags = merge(local.base_tags, {
    Name = "${var.name}-db"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Only the listed security groups (for example the EKS cluster group) may connect.
resource "aws_vpc_security_group_ingress_rule" "from_sg" {
  for_each = var.allowed_security_groups

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = each.value
  ip_protocol                  = "tcp"
  from_port                    = var.port
  to_port                      = var.port
  description                  = "Database from ${each.key}"
}

resource "aws_vpc_security_group_ingress_rule" "from_cidr" {
  for_each = toset(var.allowed_cidr_blocks)

  security_group_id = aws_security_group.this.id
  cidr_ipv4         = each.value
  ip_protocol       = "tcp"
  from_port         = var.port
  to_port           = var.port
  description       = "Database from ${each.value}"
}

resource "aws_db_instance" "this" {
  identifier     = var.name
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name                     = var.db_name
  username                    = var.username
  port                        = var.port
  manage_master_user_password = true

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = var.kms_key_id

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false

  backup_retention_period    = var.backup_retention_days
  auto_minor_version_upgrade = true
  apply_immediately          = var.apply_immediately

  performance_insights_enabled = var.performance_insights_enabled

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final"

  tags = local.base_tags
}
