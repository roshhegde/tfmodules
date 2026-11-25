provider "aws" { region = "us-east-1" }
module "vpc" {
  source               = "../../../modules/vpc"
  name                 = "t"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  nat_gateway_mode     = "single"
}
module "eks" {
  source             = "../../../modules/eks"
  name               = "t"
  kubernetes_version = "1.34"
  subnet_ids         = module.vpc.private_subnet_ids
  node_groups        = { spot = { instance_types = ["t4g.medium"], capacity_type = "SPOT", ami_type = "AL2023_ARM_64_STANDARD", desired_size = 2, min_size = 2, max_size = 3 } }
  addons             = { "vpc-cni" = {}, "coredns" = {}, "eks-pod-identity-agent" = {} }
  pod_identities     = { lbc = { namespace = "kube-system", service_account = "x", inline_policy_json = "{}" } }
  access_entries     = { ci = { principal_arn = "arn:aws:iam::123456789012:role/ci", policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" } }
}
module "rds" {
  source                  = "../../../modules/rds"
  name                    = "t"
  db_name                 = "shop"
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  allowed_security_groups = { eks = module.eks.cluster_security_group_id }
}
module "site" {
  source        = "../../../modules/s3-bucket"
  bucket_name   = "t-site"
  attach_policy = true
  policy_json   = module.cdn.bucket_policy_json
}
module "cdn" {
  source                         = "../../../modules/cloudfront"
  name                           = "t"
  s3_bucket_name                 = module.site.bucket_name
  s3_bucket_regional_domain_name = module.site.bucket_regional_domain_name
  custom_origins                 = [{ origin_id = "alb", domain_name = "x.elb.amazonaws.com", path_patterns = ["/api/*"] }]
}
output "pub" { value = module.vpc.public_subnet_ids }
