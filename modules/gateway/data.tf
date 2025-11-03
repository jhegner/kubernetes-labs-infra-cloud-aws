# Data source para buscar gateways existentes por tag
# Isso permitirá verificar se já existe um gateway com o ID específico
data "aws_resourcegroupstaggingapi_resources" "existing_gateways" {
  resource_type_filters = ["apigateway:restapis"]

  tag_filter {
    key    = "GatewayId"
    values = [var.gateway_id]
  }
}
