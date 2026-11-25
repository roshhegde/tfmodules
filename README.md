# AWS Terraform modules

This repository contains one Terraform module folder per AWS resource type:
`modules/vpc`, `modules/subnet`, `modules/internet-gateway`,
`modules/route-table`, `modules/route`, `modules/route-table-association`,
`modules/security-group`, and `modules/ec2`. Each module creates only its
corresponding AWS resource. The root module composes them into a web server
stack.

## Serverless modules

These follow the same one-resource-type-per-module rule:

| Module | Creates |
|---|---|
| `modules/dynamodb-table` | DynamoDB table (on-demand, encrypted, PITR on by default) |
| `modules/lambda-function` | Lambda function from a zip you build (pass `filename` and `source_code_hash`) |
| `modules/lambda-permission` | Permission for a service such as API Gateway to invoke a function |
| `modules/cognito-user-pool` | Cognito user pool with email sign-in; outputs `issuer_url` for JWT authorizers |
| `modules/cognito-user-pool-client` | App client for a user pool |
| `modules/apigatewayv2-api` | HTTP API with optional CORS |
| `modules/apigatewayv2-authorizer` | JWT authorizer |
| `modules/apigatewayv2-integration` | Lambda proxy integration |
| `modules/apigatewayv2-route` | One route; pass `authorizer_id` to protect it, or leave it null for a public route |
| `modules/apigatewayv2-stage` | Auto-deploying stage with throttling and optional access logs |
| `modules/cloudwatch-log-group` | Log group with retention |
| `modules/cloudwatch-metric-alarm` | Metric alarm |
| `modules/s3-bucket` | Private, encrypted, versioned bucket (its versioning, encryption and public access block settings are part of the module) |
| `modules/budget` | Monthly cost budget with email alerts |

`modules/iam-github-oidc` also accepts `subjects`, a list of token subjects, so one deploy role can trust the main branch, pull requests and a deployment environment together.

Reference modules from another repository with a pinned tag:

```hcl
module "table" {
  source = "git::https://github.com/roshhegde/tfmodules.git//modules/dynamodb-table?ref=v1.0.0"

  name      = "my-table"
  hash_key  = "pk"
  range_key = "sk"
}
```

## Modules for Shoplane phase 2 (EKS, RDS, CloudFront)

These follow the one-module-per-AWS-service rule: each one owns the pieces that
only exist for that service.

| Module | Creates |
|---|---|
| `modules/vpc` | The VPC, and when you pass `azs` plus subnet CIDRs: public and private subnets per AZ, internet gateway, NAT gateways (`nat_gateway_mode` = `none`, `single` or `per_az`) and route tables. With only `name` and `vpc_cidr` it still creates just the VPC, so existing callers are unchanged. |
| `modules/eks` | EKS cluster and its IAM role, managed node groups (Spot and Graviton supported), EKS add-ons, Pod Identity roles and associations, and access entries. Supersedes `eks-cluster` and `eks-node-group`, which stay for existing callers. |
| `modules/rds` | RDS instance with a generated master password kept in Secrets Manager, its subnet group, parameter group and security group. |
| `modules/cloudfront` | CloudFront distribution with Origin Access Control for a private S3 bucket, optional uncached custom origins (such as an ALB for `/api/*`), and the bucket policy JSON to hand to `s3-bucket`. |
| `modules/s3-bucket` | Now also takes `attach_policy` and `policy_json`, and outputs `bucket_regional_domain_name`. |

```hcl
module "network" {
  source = "git::https://github.com/roshhegde/tfmodules.git//modules/vpc?ref=v1.1.0"

  name                 = "shoplane"
  vpc_cidr             = "10.40.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.40.0.0/24", "10.40.1.0/24"]
  private_subnet_cidrs = ["10.40.10.0/24", "10.40.11.0/24"]
  nat_gateway_mode     = "single"
}
```

### Tests

`tests/modules.tftest.hcl` plans and "applies" small fixtures against a mocked
AWS provider, so it needs no credentials and costs nothing:

```sh
terraform init && terraform test
```

GitHub Actions runs format, validate and these tests on every pull request.

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
