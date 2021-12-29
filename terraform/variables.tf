# variables.tf
variable "aws_region" {
  description = "aws region to create the resources"
  type        = string
  default     = "us-east-1"
}

variable "iam_user" {
  description = "The iam user."
  type        = string
}

variable "iam_groups" {
  description = "List of iam groups that we need assign to the iam user created"
  type        = list(string)
}

variable "pgp_key_path" {
  description = "The pgp public key path"
  type        = string
  default     = "./keys/public-key-binary.gpg"
}
