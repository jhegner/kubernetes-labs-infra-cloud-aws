# Gateway Module

Este módulo Terraform provisiona um API Gateway AWS apenas se um gateway com o ID específico não existir.

## Funcionalidades

- Verifica se um gateway com ID específico (`ku9lj1zme7`) já existe
- Cria um novo API Gateway apenas se não encontrar o ID especificado
- Configura deployment e stage para o gateway
- Fornece outputs com informações do gateway criado

## Uso

```hcl
module "gateway" {
  source = "./modules/gateway"
  
  gateway_id     = "ku9lj1zme7"
  gateway_name   = "meu-gateway-kubernetes"
  create_gateway = true
}
```

## Variáveis

| Nome             | Descrição                                 | Tipo     | Padrão                      |
| ---------------- | ----------------------------------------- | -------- | --------------------------- |
| `gateway_id`     | ID específico do gateway a ser verificado | `string` | `"ku9lj1zme7"`              |
| `gateway_name`   | Nome do gateway a ser criado              | `string` | `"kubernetes-labs-gateway"` |
| `create_gateway` | Flag para controlar a criação do gateway  | `bool`   | `true`                      |

## Outputs

| Nome                | Descrição                                      |
| ------------------- | ---------------------------------------------- |
| `gateway_id`        | ID do API Gateway criado                       |
| `gateway_arn`       | ARN do API Gateway criado                      |
| `gateway_url`       | URL do API Gateway                             |
| `gateway_exists`    | Indica se o gateway já existia                 |
| `gateway_created`   | Indica se o gateway foi criado por este módulo |
| `target_gateway_id` | ID do gateway que estava sendo verificado      |

## Lógica de Funcionamento

1. O módulo consulta todos os API Gateways existentes na região
2. Verifica se algum gateway possui o ID especificado (`ku9lj1zme7`)
3. Se o gateway não existir e `create_gateway` for `true`, cria um novo gateway
4. Configura um deployment e stage "prod" para o gateway criado
5. Retorna informações sobre o status da operação através dos outputs

## Recursos Criados (quando necessário)

- `aws_api_gateway_rest_api`: O API Gateway principal
- `aws_api_gateway_deployment`: Deployment do gateway
- `aws_api_gateway_stage`: Stage de produção do gateway

## Tags Aplicadas

Todos os recursos criados recebem as seguintes tags:
- `Name`: Nome do gateway
- `Environment`: "labs"
- `GatewayId`: ID específico do gateway
- `ManagedBy`: "terraform"