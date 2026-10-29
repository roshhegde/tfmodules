# AWS Terraform modules

This repository contains one Terraform module folder per AWS resource type:
`modules/vpc`, `modules/subnet`, `modules/internet-gateway`,
`modules/route-table`, `modules/route`, `modules/route-table-association`,
`modules/security-group`, and `modules/ec2`. Each module creates only its
corresponding AWS resource. The root module composes them into a web server
stack.

## Requirements

- Terraform 1.5 or later.
- AWS provider 5.0 or later.
- AWS credentials configured outside this module with permission to manage the
  resources above and read the public Amazon Linux AMI SSM parameter.

## Usage

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "web_app" {
  source = "./path/to/tfmodules"

  name               = "my-web-app"
  vpc_cidr           = "10.20.0.0/16"
  public_subnet_cidr = "10.20.1.0/24"
  instance_type      = "t3.micro"

  tags = {
    Environment = "dev"
    Project     = "my-web-app"
  }
}

output "web_url" {
  value = module.web_app.web_url
}
```

Each resource module can be used independently. For example, use the VPC module
without creating the rest of the web stack:

```hcl
module "vpc" {
  source = "./path/to/tfmodules/modules/vpc"

  name     = "my-network"
  vpc_cidr = "10.20.0.0/16"
}
```

Other modules similarly accept IDs of prerequisite resources as inputs. For
example, `modules/subnet` accepts a `vpc_id`; `modules/route` accepts a
`route_table_id` and `gateway_id`; and `modules/ec2` accepts a `subnet_id` and
`security_group_id`.

To enable SSH on the root web-app stack, provide an existing EC2 key pair and
only trusted public CIDRs:

```hcl
module "web_app" {
  source = "./path/to/tfmodules"

  ssh_key_name      = "my-existing-key"
  ssh_allowed_cidrs = ["203.0.113.10/32"]
}
```

Do not use `0.0.0.0/0` for SSH access. The security-group module requires an
SSH key name when SSH CIDRs are configured.

## Apply and destroy

From a root configuration that calls this module:

```sh
terraform init
terraform plan
terraform apply
terraform destroy
```

The EC2 instance is internet-facing and incurs AWS charges while running. Store
Terraform state remotely with encryption and access controls for shared or
production use. Review the plan before applying or destroying resources.
