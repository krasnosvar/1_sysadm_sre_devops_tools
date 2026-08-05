variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to provision"
}

variable "profile" {
  default = ""
}


variable "repositories" {
  type = set(string)
  description = "(Required) Name of the repository. {project_family}/{environment}/{name}."
}


variable "image_tag_mutability" {
  type = string
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  default = "MUTABLE"
}

variable "scan_on_push" {
  type = bool
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default = true
}

variable "additional_tags" {
  type = map(string)
  description = "(Optional) A map of tags to assign to the resource."
  default = {}
}
