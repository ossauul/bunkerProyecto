# ---- SEGURIDAD ----
# Este módulo gestiona los recursos de seguridad: Grupos de Seguridad, Roles IAM y Secretos.

# Crea un Grupo de Seguridad para la instancia EC2.
# Permite tráfico entrante en los puertos 22 (SSH) y 80/8080 (HTTP) desde cualquier IP.
# Necesita: El ID de la VPC para saber dónde crearse.
resource "aws_security_group" "allow_ssh_http" {
  name        = "${var.project_name}-sg"
  description = "Permitir trafico SSH y HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# Crea un Rol IAM que la instancia EC2 asumirá.
# Esto le da permisos a la instancia para interactuar con otros servicios de AWS.
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Crea un secreto en AWS Secrets Manager para guardar credenciales.
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "${var.project_name}/db_credentials"
}

# Define el valor del secreto.
# Necesita: El ID del secreto.
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = "{\"username\":\"admin\",\"password\":\"password_super_secreto\"}"
}

# Crea una política IAM que permite leer el valor del secreto.
# Necesita: El ARN del secreto para especificar a qué recurso se aplica el permiso.
resource "aws_iam_policy" "secret_read_policy" {
  name   = "${var.project_name}_secret_read_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })
}

# Adjunta la política de lectura de secretos al rol de la EC2.
# Necesita: El nombre del rol y el ARN de la política.
resource "aws_iam_role_policy_attachment" "attach_secret_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secret_read_policy.arn
}

# Crea un perfil de instancia IAM.
# Este perfil se asocia a la instancia EC2 para que pueda usar el rol.
# Necesita: El nombre del rol.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}_ec2_profile"
  role = aws_iam_role.ec2_role.name
}