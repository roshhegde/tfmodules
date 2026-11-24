# The VPC and, optionally, everything that makes it usable: public and private
# subnets spread over Availability Zones, an internet gateway, NAT gateways and
# route tables. Leave the subnet lists empty to create only the VPC, as before.

locals {
  base_tags = merge(var.tags, { ManagedBy = "Terraform" })

  # try() keeps a bad input from failing here, so the precondition below can explain it.
  public_subnets  = { for i, cidr in var.public_subnet_cidrs : try(var.azs[i], "missing-az-${i}") => cidr }
  private_subnets = { for i, cidr in var.private_subnet_cidrs : try(var.azs[i], "missing-az-${i}") => cidr }

  create_igw = length(var.public_subnet_cidrs) > 0

  # "single": one NAT gateway in the first AZ that every private subnet uses (cheap, one AZ of risk).
  # "per_az": one NAT gateway per AZ, so losing an AZ never cuts the others off (about $33 a month each).
  nat_azs = (
    var.nat_gateway_mode == "none" || length(var.private_subnet_cidrs) == 0 ? [] :
    var.nat_gateway_mode == "single" ? [var.azs[0]] :
    keys(local.public_subnets)
  )

  # Which NAT gateway each private subnet's default route goes through.
  private_nat_az = {
    for az in keys(local.private_subnets) : az => (
      var.nat_gateway_mode == "per_az" ? az : var.azs[0]
    ) if length(local.nat_azs) > 0
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.base_tags, {
    Name = "${var.name}-vpc"
  })

  lifecycle {
    precondition {
      condition     = length(var.public_subnet_cidrs) <= length(var.azs) && length(var.private_subnet_cidrs) <= length(var.azs)
      error_message = "List at least as many azs as public or private subnet CIDRs."
    }
    precondition {
      condition     = var.nat_gateway_mode == "none" || length(var.private_subnet_cidrs) == 0 || length(var.public_subnet_cidrs) == length(var.azs)
      error_message = "NAT gateways live in public subnets, so give one public subnet CIDR per AZ, or set nat_gateway_mode = \"none\"."
    }
  }
}

resource "aws_internet_gateway" "this" {
  count  = local.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(local.base_tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_subnet" "public" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true

  tags = merge(local.base_tags, var.public_subnet_tags, {
    Name = "${var.name}-public-${each.key}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = each.value

  tags = merge(local.base_tags, var.private_subnet_tags, {
    Name = "${var.name}-private-${each.key}"
    Tier = "private"
  })
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_azs)
  domain   = "vpc"

  tags = merge(local.base_tags, {
    Name = "${var.name}-nat-${each.key}"
  })
}

resource "aws_nat_gateway" "this" {
  for_each      = toset(local.nat_azs)
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(local.base_tags, {
    Name = "${var.name}-nat-${each.key}"
  })

  depends_on = [aws_internet_gateway.this]
}

# Public subnets share one route table whose default route is the internet gateway.
resource "aws_route_table" "public" {
  count  = local.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(local.base_tags, {
    Name = "${var.name}-public"
  })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

# Each private subnet gets its own route table, so switching from one NAT
# gateway to one per AZ only changes routes, never subnets.
resource "aws_route_table" "private" {
  for_each = local.private_subnets
  vpc_id   = aws_vpc.this.id

  dynamic "route" {
    for_each = contains(keys(local.private_nat_az), each.key) ? [local.private_nat_az[each.key]] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[route.value].id
    }
  }

  tags = merge(local.base_tags, {
    Name = "${var.name}-private-${each.key}"
  })
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
