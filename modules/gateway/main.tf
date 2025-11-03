terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = local.region
}

# Recurso do API Gateway - criado apenas se não existir
resource "aws_api_gateway_rest_api" "kubernetes_labs_gateway" {
  count = local.should_create_gateway ? 1 : 0

  name        = var.gateway_name
  description = "API Gateway para Kubernetes Labs - ID: ${var.gateway_id}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name        = var.gateway_name
    Environment = "labs"
    GatewayId   = var.gateway_id
    ManagedBy   = "terraform"
  }
}

# Recurso para deployment do gateway
resource "aws_api_gateway_deployment" "gateway_deployment" {
  count = local.should_create_gateway ? 1 : 0

  depends_on = [aws_api_gateway_rest_api.kubernetes_labs_gateway]

  rest_api_id = aws_api_gateway_rest_api.kubernetes_labs_gateway[0].id

  lifecycle {
    create_before_destroy = true
  }
}

# Stage para o deployment
resource "aws_api_gateway_stage" "gateway_stage" {
  count = local.should_create_gateway ? 1 : 0

  deployment_id = aws_api_gateway_deployment.gateway_deployment[0].id
  rest_api_id   = aws_api_gateway_rest_api.kubernetes_labs_gateway[0].id
  stage_name    = "lab"

  tags = {
    Name        = "${var.gateway_name}-lab"
    Environment = "labs"
    GatewayId   = var.gateway_id
    ManagedBy   = "terraform"
  }
}

