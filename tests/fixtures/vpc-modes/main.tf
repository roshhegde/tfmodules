provider "aws" { region = "us-east-1" }
module "vpc" {
  source               = "../../../modules/vpc"
  name                 = "t"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  nat_gateway_mode     = "per_az"
}
module "plain" {
  source   = "../../../modules/vpc"
  name     = "p"
  vpc_cidr = "10.1.0.0/16"
}
