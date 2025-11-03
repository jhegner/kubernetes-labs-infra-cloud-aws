locals {
  region = "us-east-1"

  # Verifica se já existe um gateway com o GatewayId específico
  gateway_exists = length(data.aws_resourcegroupstaggingapi_resources.existing_gateways.resource_tag_mapping_list) > 0

  # Determina se deve criar o gateway
  should_create_gateway = var.create_gateway && !local.gateway_exists
}
