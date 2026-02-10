# ---- DIRECTOR DE ORQUESTA ----
# Este archivo principal llama a los módulos y conecta sus salidas y entradas.

# Configura el proveedor de AWS, indicando la región donde se crearán los recursos.
# Necesita: La región de AWS (ej: "us-east-1").
provider "aws" {
  region = var.aws_region
}

# Llama al módulo de red para crear la VPC y la subred.
module "red" {
  source = "./modulos/red"
}

# Llama al módulo de seguridad.
# Pasa el ID de la VPC creada por el módulo 'red' para que el grupo de seguridad
# se cree en la VPC correcta.
module "seguridad" {
  source = "./modulos/seguridad"
  vpc_id = module.red.vpc_id
}

# Llama al módulo de cómputo para crear la instancia EC2.
# Conecta las salidas de los otros módulos a las entradas de este:
# - subnet_id: De la red.
# - iam_instance_profile_arn: Del módulo de seguridad.
# - secret_arn: Del módulo de seguridad.
# - sg_id: Del módulo de seguridad.
module "computo" {
  source                   = "./modulos/computo"
  subnet_id                = module.red.subnet_id
  iam_instance_profile_arn = module.seguridad.iam_instance_profile_arn
  secret_arn               = module.seguridad.secret_arn
  sg_id                    = module.seguridad.security_group_id
}