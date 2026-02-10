variable "subnet_id" {
  description = "El ID de la subred para la instancia EC2"
  type        = string
}

variable "iam_instance_profile_arn" {
  description = "El ARN del perfil de instancia IAM"
  type        = string
}

variable "secret_arn" {
  description = "El ARN del secreto de Secrets Manager"
  type        = string
}

variable "ami_id" {
  description = "El ID de la AMI para la instancia"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 LTS en us-east-1
}

variable "instance_type" {
  description = "El tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "project_name" {
  description = "Nombre del proyecto para nombrar recursos"
  type        = string
  default     = "bunker"
}
variable "sg_id" {
  description = "ID del sg"
  type        = string
}
