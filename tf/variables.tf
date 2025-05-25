variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Entorno de despliegue (dev, prod, etc)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nombre del proyecto para etiquetar recursos"
  type        = string
  default     = "lti-project"
}

variable "ami_id" {
  description = "ID de la AMI para las instancias EC2"
  type        = string
  default     = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "backend_instance_type" {
  description = "Tipo de instancia para el backend"
  type        = string
  default     = "t2.micro"
}

variable "frontend_instance_type" {
  description = "Tipo de instancia para el frontend"
  type        = string
  default     = "t2.medium"
}

variable "backend_port" {
  description = "Puerto para el backend"
  type        = number
  default     = 8080
}

variable "frontend_port" {
  description = "Puerto para el frontend"
  type        = number
  default     = 3000
}

variable "allowed_cidr_blocks" {
  description = "Bloques CIDR permitidos para acceso a la aplicación"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidr_blocks" {
  description = "Bloques CIDR permitidos para acceso SSH (debería ser restringido a IPs específicas)"
  type        = list(string)
  default     = []  # Debe ser configurado explícitamente, no permitimos un default abierto
}

variable "s3_bucket_name" {
  description = "Nombre del bucket S3 para el código"
  type        = string
  default     = "ai4devs-project-code-bucket"
}

variable "tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "lti-project"
    ManagedBy   = "terraform"
  }
}

variable "datadog_api_key" {
  description = "API Key de Datadog"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Application Key de Datadog"
  type        = string
  sensitive   = true
}

variable "datadog_site" {
  description = "Site de Datadog (datadoghq.eu o datadoghq.com)"
  type        = string
  default     = "datadoghq.eu"
}
