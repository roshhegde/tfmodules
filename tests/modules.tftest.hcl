# Offline tests: a mocked AWS provider "applies" the fixtures, so these catch
# wiring mistakes (cycles, unknown for_each keys, bad outputs) without an AWS
# account. Run with: terraform init && terraform test
mock_provider "aws" {
  mock_data "aws_iam_policy_document" { defaults = { json = "{}" } }
  mock_resource "aws_eks_cluster" { defaults = { arn = "arn:aws:eks:us-east-1:123456789012:cluster/t", certificate_authority = [{ data = "Zm9v" }] } }
  mock_resource "aws_db_instance" { defaults = { master_user_secret = [{ secret_arn = "arn:aws:secretsmanager:us-east-1:123456789012:secret:rds", kms_key_id = "k", secret_status = "active" }] } }
  mock_resource "aws_iam_role" { defaults = { arn = "arn:aws:iam::123456789012:role/t" } }
  mock_resource "aws_cloudfront_distribution" { defaults = { arn = "arn:aws:cloudfront::123456789012:distribution/E1" } }
  mock_resource "aws_s3_bucket" { defaults = { arn = "arn:aws:s3:::t-site" } }
}
run "eks_stack" {
  command = apply
  module { source = "./tests/fixtures/eks-stack" }
  assert {
    condition     = length(module.vpc.public_subnet_ids) == 2 && length(module.vpc.nat_gateway_ids) == 1
    error_message = "vpc wrong"
  }
}

run "vpc_modes" {
  command = apply
  module { source = "./tests/fixtures/vpc-modes" }
  assert {
    condition     = length(module.vpc.nat_gateway_ids) == 2 && length(module.plain.private_subnet_ids) == 0 && module.plain.internet_gateway_id == null
    error_message = "per_az or plain vpc wrong"
  }
}
