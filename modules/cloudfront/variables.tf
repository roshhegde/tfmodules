variable "name" {
  description = "Name for the distribution and its origin access control."
  type        = string
}

variable "comment" {
  description = "Comment shown on the distribution in the console."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "Name of the private S3 bucket that holds the static site."
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "Regional domain name of the bucket, such as my-bucket.s3.us-east-1.amazonaws.com."
  type        = string
}

variable "default_root_object" {
  description = "Object returned for requests to /."
  type        = string
  default     = "index.html"
}

variable "spa_fallback" {
  description = "Return the root object with status 200 when S3 answers 403 or 404, for single-page apps."
  type        = bool
  default     = false
}

variable "custom_origins" {
  description = "Extra origins, such as an ALB, and the path patterns (for example /api/*) routed to each one without caching. Use origin_protocol_policy https-only once the origin has a certificate."
  type = list(object({
    origin_id              = string
    domain_name            = string
    path_patterns          = list(string)
    origin_protocol_policy = optional(string, "http-only")
  }))
  default = []
}

variable "price_class" {
  description = "Edge locations to use. PriceClass_100 is North America and Europe only, and the cheapest."
  type        = string
  default     = "PriceClass_100"
}

variable "aliases" {
  description = "Custom domain names. Requires acm_certificate_arn from us-east-1."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate in us-east-1 for the aliases. Null uses the default *.cloudfront.net certificate."
  type        = string
  default     = null
}

variable "web_acl_id" {
  description = "ARN of a WAFv2 web ACL (CLOUDFRONT scope) to attach."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to the distribution."
  type        = map(string)
  default     = {}
}
