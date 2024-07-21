variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "fileup"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "test"
}
