variable "project" {
  description = "Reference to a \"project\" module. See: https://registry.terraform.io/modules/PGBI/project/aws/"
}

variable "description" {
  description = "The description of the key as viewed in AWS console."
  default     = "Managed by terraform."
}

variable "name" {
  description = "Alias name for the key."
  type        = "string"
}

variable "iam_consumers_arns" {
  description = "List of IAM users/groups/roles arns that will be allowed to use the key."
  type        = list(string)
  default     = []
}

variable "consuming_aws_services" {
  description = "List of identifiers of AWS Services that should be allowed to use the key. See: https://gist.github.com/shortjared/4c1e3fe52bdfa47522cfe5b41e5d6f22 for a list of AWS Services identifiers."
  type        = list(string)
  default     = []
}
