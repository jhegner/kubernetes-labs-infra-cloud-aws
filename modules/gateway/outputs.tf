output "gateway_id" {
  description = "ID do API Gateway criado ou existente"
  value       = local.should_create_gateway ? aws_api_gateway_rest_api.kubernetes_labs_gateway[0].id : local.existing_gateway_id
}

output "gateway_arn" {
  description = "ARN do API Gateway criado ou existente"
  value       = local.should_create_gateway ? aws_api_gateway_rest_api.kubernetes_labs_gateway[0].arn : local.existing_gateway_arn
}

output "gateway_url" {
  description = "URL do API Gateway"
  value       = local.should_create_gateway ? aws_api_gateway_stage.gateway_stage[0].invoke_url : local.existing_gateway_url
}

output "gateway_exists" {
  description = "Indica se o gateway já existia"
  value       = local.gateway_exists
}

output "gateway_created" {
  description = "Indica se o gateway foi criado por este módulo"
  value       = local.should_create_gateway
}
