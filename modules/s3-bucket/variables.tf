variable "bucket_name" {
  description = "Globally unique bucket name."
  type        = string
}

variable "versioning" {
  description = "Keep previous versions of objects. Recommended for Terraform state."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow destroy to delete a non-empty bucket, including all versions."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the resource."
  type        = map(string)
  default     = {}
}

variable "attach_policy" {
  description = "Attach policy_json as the bucket policy. A separate flag because the policy is often unknown until apply (for example it names a CloudFront distribution)."
  type        = bool
  default     = false
}

variable "policy_json" {
  description = "Bucket policy document as JSON, used when attach_policy is true. Public policies stay blocked by the public access block."
  type        = string
  default     = null
}
