variable "aws_region" {
  description = "AWS region containing the public subnet and EC2 key pair."
  type        = string
  default     = "ap-south-1"
}

variable "public_subnet_id" {
  description = "Existing public subnet with a default route to an internet gateway."
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]+$", var.public_subnet_id))
    error_message = "Enter an existing subnet ID beginning with subnet-."
  }
}

variable "key_name" {
  description = "Existing EC2 key pair name in the selected AWS region."
  type        = string

  validation {
    condition     = length(trimspace(var.key_name)) > 0
    error_message = "Enter the name of an existing EC2 key pair."
  }
}

variable "ssh_cidr" {
  description = "Operator's current public IPv4 address in /32 CIDR notation."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_cidr)) && endswith(var.ssh_cidr, "/32")
    error_message = "Use a single IPv4 address followed by /32."
  }
}
