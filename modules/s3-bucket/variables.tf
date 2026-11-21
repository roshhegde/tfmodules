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
