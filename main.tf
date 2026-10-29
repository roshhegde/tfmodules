module "vpc" {
  source = "./modules/vpc"

  name     = var.name
  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}

module "internet_gateway" {
  source = "./modules/internet-gateway"

  name   = var.name
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "public_subnet" {
  source = "./modules/subnet"

  name                    = var.name
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags                    = var.tags
}

module "public_route_table" {
  source = "./modules/route-table"

  name   = var.name
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "public_route" {
  source = "./modules/route"

  route_table_id         = module.public_route_table.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.internet_gateway.internet_gateway_id
}

module "public_route_table_association" {
  source = "./modules/route-table-association"

  subnet_id      = module.public_subnet.subnet_id
  route_table_id = module.public_route_table.route_table_id
}

module "web_security_group" {
  source = "./modules/security-group"

  name              = var.name
  vpc_id            = module.vpc.vpc_id
  ssh_key_name      = var.ssh_key_name
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
  tags              = var.tags
}

module "ec2" {
  source = "./modules/ec2"

  name              = var.name
  instance_type     = var.instance_type
  subnet_id         = module.public_subnet.subnet_id
  security_group_id = module.web_security_group.security_group_id
  ssh_key_name      = var.ssh_key_name
  tags              = var.tags
}
