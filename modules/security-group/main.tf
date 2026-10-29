resource "aws_security_group" "this" {
  name_prefix = "${var.name}-web-"
  description = "Allow public HTTP traffic and optional restricted SSH access"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.ssh_allowed_cidrs

    content {
      description = "SSH from an explicitly allowed CIDR"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    precondition {
      condition     = length(var.ssh_allowed_cidrs) == 0 || var.ssh_key_name != null
      error_message = "Set ssh_key_name when configuring ssh_allowed_cidrs."
    }
  }

  tags = merge(var.tags, {
    Name      = "${var.name}-web"
    ManagedBy = "Terraform"
  })
}
