output "security_group_id" {
  description = "El ID del grupo de seguridad"
  value       = aws_security_group.allow_ssh_http.id
}

output "iam_instance_profile_arn" {
  description = "El ARN del perfil de instancia IAM"
  value       = aws_iam_instance_profile.ec2_profile.arn
}

output "secret_arn" {
  description = "El ARN del secreto"
  value       = aws_secretsmanager_secret.db_credentials.arn
}
