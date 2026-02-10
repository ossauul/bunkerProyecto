output "server_public_ip" {
  description = "La IP pública del servidor web"
  value       = module.computo.public_ip
}
