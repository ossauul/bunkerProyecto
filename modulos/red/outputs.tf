output "vpc_id" {
  description = "El ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "El ID de la subred creada"
  value       = aws_subnet.main.id
}
