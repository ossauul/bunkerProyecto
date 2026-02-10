output "public_ip" {
  description = "La IP pública de la instancia EC2"
  value       = aws_instance.web_server.public_ip
}
