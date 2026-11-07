variable "name" {
  description = "Name prefix for the node group and its IAM role."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster the nodes join."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the worker nodes. Private subnets are recommended."
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types for the nodes."
  type        = list(string)
  default     = ["t3.small"]
}

variable "disk_size" {
  description = "Root volume size in GiB for each node."
  type        = number
  default     = 20
}

variable "desired_size" {
  description = "Desired number of nodes."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of nodes."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes."
  type        = number
  default     = 3
}

variable "tags" {
  description = "Additional tags to apply to the node group and its IAM role."
  type        = map(string)
  default     = {}
}
