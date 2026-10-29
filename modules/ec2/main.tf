data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = var.ssh_key_name
  user_data                   = <<-EOF
    #!/bin/bash
    set -euxo pipefail
    dnf install -y httpd
    systemctl enable --now httpd
    cat > /var/www/html/index.html <<'HTML'
    <!doctype html>
    <html lang="en">
      <head><meta charset="utf-8"><title>${var.name}</title></head>
      <body><h1>${var.name}</h1><p>Deployed with Terraform on AWS.</p></body>
    </html>
    HTML
  EOF

  tags = merge(var.tags, {
    Name      = "${var.name}-web"
    ManagedBy = "Terraform"
  })
}
