# The bucket plus its security settings. The versioning, encryption and
# public-access-block resources only configure this one bucket, so they
# live in the same module.

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name      = var.bucket_name
    ManagedBy = "Terraform"
  })
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional bucket policy, for example the read grant from the cloudfront module.
resource "aws_s3_bucket_policy" "this" {
  count  = var.attach_policy ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.policy_json

  # The public access block must exist first, or S3 may evaluate the policy without it.
  depends_on = [aws_s3_bucket_public_access_block.this]
}
