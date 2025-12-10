# Data source para buscar gateways existentes por tag
# Isso permitirá verificar se já existe um gateway com o ID específico
data "aws_resourcegroupstaggingapi_resources" "existing_gateways" {
  resource_type_filters = ["apigateway:restapis"]

  tag_filter {
    key    = local.tag_key_name
    values = [local.tag_filter]
  }
}

# Consulta um API Gateway específico pelo nome (exemplo adicional)
data "aws_api_gateway_rest_api" "kubernetes_labs_api" {
  name   = local.api_name
  region = local.region
}
