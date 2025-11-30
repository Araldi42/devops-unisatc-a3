variable "aws_region" {
  description = "AWS region para deploy"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "strapi-devops-v2"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "docker_image" {
  description = "Docker image com tag completa"
  type        = string
}

variable "app_keys" {
  description = "APP_KEYS do Strapi"
  type        = string
  sensitive   = true
}

variable "container_port" {
  description = "Porta do container"
  type        = number
  default     = 1337
}

variable "container_cpu" {
  description = "CPU units para o container (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memória em MB para o container"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Número de tasks desejadas"
  type        = number
  default     = 1
}

