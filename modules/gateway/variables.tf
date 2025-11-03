variable "gateway_id" {
  description = "ID específico do gateway a ser verificado"
  type        = string
  default     = "ku9lj1zme7"
}

variable "gateway_name" {
  description = "Nome do gateway a ser criado"
  type        = string
  default     = "kubernetes-labs-gateway"
}

variable "create_gateway" {
  description = "Flag para controlar a criação do gateway"
  type        = bool
  default     = true
}
