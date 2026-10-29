variable "name" {
  description = "Name prefix applied to the EC2 resources."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the web server."
  type        = string
}

variable "subnet_id" {
  description = "ID of the public subnet where the EC2 instance will be launched."
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group attached to the EC2 instance."
  type        = string
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair name."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Additional tags to apply to the EC2 resources."
  type        = map(string)
  default     = {}
}
