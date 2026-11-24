output "distribution_id" {
  description = "ID of the distribution, used for cache invalidations."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "ARN of the distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "The distribution's *.cloudfront.net domain name."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "bucket_policy_json" {
  description = "Bucket policy granting this distribution read access. Pass it to the s3-bucket module's policy_json."
  value       = data.aws_iam_policy_document.bucket.json
}
