variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_tags" {
  type    = map(any)
  default = {}
}

variable "igw_tags" {
  type    = map(any)
  default = {}
}

# Enforcing user to provide 2 subnet values
variable "public_subnet_cidr" {
  type        = list(any)
  description = "Please provide 2 public subnet CIDR"
  validation {
    condition     = length(var.public_subnet_cidr) == 2
    error_message = "CIDR list length must be 2"
  }
}

variable "public_subnet_tags" {
  type    = map(any)
  default = {}
}

variable "private_subnet_tags" {
  type    = map(any)
  default = {}
}

# Enforcing user to provide 2 subnet values
variable "private_subnet_cidr" {
  type        = list(any)
  description = "Please provide 2 private subnet CIDR"
  validation {
    condition     = length(var.private_subnet_cidr) == 2
    error_message = "CIDR list length must be 2"
  }
}

variable "public_route_table_tags" {
  type    = map(any)
  default = {}
}

variable "private_route_table_tags" {
  type    = map(any)
  default = {}
}

variable "eip_tags" {
  type    = map(any)
  default = {}
}

variable "nat_gateway_tags" {
  type    = map(any)
  default = {}
}


variable "database_subnet_cidr" {
  type        = list(any)
  description = "Please provide 2 database subnet CIDR"
  validation {
    condition     = length(var.database_subnet_cidr) == 2
    error_message = "CIDR list length must be 2"
  }
}

variable "database_subnet_tags" {
  type    = map(any)
  default = {}
}

variable "database_route_table_tags" {
  type    = map(any)
  default = {}
}
