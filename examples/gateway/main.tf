# Exemplo de uso do módulo Gateway

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Uso básico do módulo
module "gateway" {
  source = "../../modules/gateway"

  gateway_name   = "kubernetes-labs-gateway"
  create_gateway = true
}

# Outputs para exibir informações do gateway
output "gateway_info" {
  description = "Informações do gateway criado"
  value = {
    id        = module.gateway.gateway_id
    arn       = module.gateway.gateway_arn
    url       = module.gateway.gateway_url
    exists    = module.gateway.gateway_exists
    created   = module.gateway.gateway_created
    target_id = module.gateway.target_gateway_id
  }
}
