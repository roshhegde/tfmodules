variable "name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten. IMMUTABLE prevents overwriting, including of latest."
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["IMMUTABLE", "MUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be IMMUTABLE or MUTABLE."
  }
}

variable "scan_on_push" {
  description = "Scan images for known vulnerabilities when they are pushed."
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Number of most recent images to keep. Older images expire."
  type        = number
  default     = 20

  validation {
    condition     = var.max_image_count >= 1
    error_message = "max_image_count must be at least 1."
  }
}

variable "tags" {
  description = "Additional tags to apply to the repository."
  type        = map(string)
  default     = {}
}
