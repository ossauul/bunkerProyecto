# ---- COMPUTO ----
# Este módulo crea la instancia EC2 donde correrá la aplicación.

# Crea una instancia EC2 (un servidor virtual).
# Necesita:
# - ami: La imagen de sistema operativo a usar.
# - instance_type: El tamaño de la instancia (CPU, RAM).
# - subnet_id: La subred donde se lanzará.
# - vpc_security_group_ids: El grupo de seguridad para aplicar.
# - iam_instance_profile: El perfil IAM con los permisos necesarios.
# - user_data: Un script que se ejecuta al iniciar la instancia por primera vez.
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile = var.iam_instance_profile_arn

  # Este script instala OpenJDK 11, Maven, descarga una aplicación Java desde GitHub,
  # la compila y la ejecuta.
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y openjdk-11-jre
              sudo apt-get install -y maven
              wget https://github.com/SaulSS1/java-tomcat-app/archive/refs/heads/main.zip
              unzip main.zip
              cd java-tomcat-app-main
              mvn clean install
              java -jar target/java-tomcat-app-1.0.war
              EOF

  tags = {
    Name = "${var.project_name}-ec2"
  }
}