variable "vpc_cidr_range" {
  description = "El rango CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_range" {
  description = "El rango CIDR para la subred"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vpc_name" {
  description = "El nombre de la VPC"
  type        = string
  default     = "bunker_vpc"
}

variable "subnet_name" {
  description = "El nombre de la subred"
  type        = string
  default     = "bunker_subnet"
}