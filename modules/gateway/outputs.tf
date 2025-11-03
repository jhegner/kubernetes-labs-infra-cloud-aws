output "gateway_id" {
  description = "ID do API Gateway criado"
  value       = local.should_create_gateway ? aws_api_gateway_rest_api.kubernetes_labs_gateway[0].id : null
}

output "gateway_arn" {
  description = "ARN do API Gateway criado"
  value       = local.should_create_gateway ? aws_api_gateway_rest_api.kubernetes_labs_gateway[0].arn : null
}

output "gateway_url" {
  description = "URL do API Gateway"
  value       = local.should_create_gateway ? aws_api_gateway_stage.gateway_stage[0].invoke_url : null
}

output "gateway_exists" {
  description = "Indica se o gateway já existia"
  value       = local.gateway_exists
}

output "gateway_created" {
  description = "Indica se o gateway foi criado por este módulo"
  value       = local.should_create_gateway
}

output "target_gateway_id" {
  description = "ID do gateway que estava sendo verificado"
  value       = var.gateway_id
}
