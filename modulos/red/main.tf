# ---- RED ----
# Este módulo crea la infraestructura de red base.

# Crea una Virtual Private Cloud (VPC) para aislar los recursos.
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_range
  tags = {
    Name = var.vpc_name
  }
}

# Crea una subred pública dentro de la VPC.
# Necesita: El ID de la VPC donde crearse.
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_range
  tags = {
    Name = var.subnet_name
  }
}

# Crea un Internet Gateway para dar acceso a internet a la VPC.
# Necesita: El ID de la VPC a la que se adjuntará.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Crea una tabla de rutas para dirigir el tráfico de la subred.
# Necesita: El ID de la VPC.
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  # Define una ruta para que todo el tráfico (0.0.0.0/0) salga a través del Internet Gateway.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt"
  }
}

# Asocia la tabla de rutas con la subred.
# Necesita: El ID de la subred y el ID de la tabla de rutas.
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}