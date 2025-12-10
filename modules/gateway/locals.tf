locals {
  region = "us-east-1"

  api_name = "apilab"

  # Verifica se já existe um gateway com o GatewayId específico
  gateway_exists = length(data.aws_resourcegroupstaggingapi_resources.existing_gateways.resource_tag_mapping_list) > 0

  # Determina se deve criar o gateway
  should_create_gateway = var.create_gateway && !local.gateway_exists

  # Extrai o ARN do gateway existente se houver
  existing_gateway_arn = local.gateway_exists ? data.aws_resourcegroupstaggingapi_resources.existing_gateways.resource_tag_mapping_list[0].resource_arn : null

  # Extrai o ID do gateway existente do ARN (formato: arn:aws:apigateway:region::/restapis/{id})
  existing_gateway_id = local.existing_gateway_arn != null ? element(split("/", local.existing_gateway_arn), length(split("/", local.existing_gateway_arn)) - 1) : null

  # Constrói a URL do gateway existente
  existing_gateway_url = local.existing_gateway_id != null ? "https://${local.existing_gateway_id}.execute-api.${local.region}.amazonaws.com/lab" : null
}

locals {
  tag_key_name = "lab"
  tag_filter   = "kubernetes"
}
