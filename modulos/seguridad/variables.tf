variable "vpc_id" {
  description = "El ID de la VPC para asociar el grupo de seguridad"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto para nombrar recursos"
  type        = string
  default     = "bunker"
}
