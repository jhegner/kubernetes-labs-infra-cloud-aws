variable "gateway_id" {
  description = "ID específico do gateway a ser verificado"
  type        = string
}

variable "gateway_name" {
  description = "Nome do gateway a ser criado"
  type        = string
  default     = "kubernetes-labs-gateway"
}

variable "region" {
  description = "Região AWS para criar os recursos"
  type        = string
  default     = "us-east-1"
}

variable "create_gateway" {
  description = "Flag para controlar a criação do gateway"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais para aplicar aos recursos"
  type        = map(string)
  default = {
    Project     = "kubernetes-labs"
    Environment = "example"
  }
}