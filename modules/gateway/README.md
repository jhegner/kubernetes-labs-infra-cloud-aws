# Gateway Module

Este módulo Terraform provisiona um API Gateway AWS apenas se não existir um gateway com a tag `lab = kubernetes`.

## Funcionalidades

- Verifica se já existe um gateway com a tag `lab = kubernetes`
- Cria um novo API Gateway apenas se não encontrar um gateway com essa tag
- Configura deployment e stage "lab" para o gateway
- Fornece outputs com informações do gateway criado e status da operação

## Requisitos

| Nome      | Versão  |
| --------- | ------- |
| Terraform | >= 1.0  |
| AWS       | ~> 6.0  |

### Permissões AWS Necessárias

O usuário/role executando este módulo precisa das seguintes permissões:

- `apigateway:GET` (para consultar gateways existentes)
- `apigateway:POST` (para criar gateway)
- `apigateway:PUT` (para atualizar configurações)
- `tag:GetResources` (para buscar recursos por tags)
- `apigateway:CreateDeployment` (para criar deployment)
- `apigateway:CreateStage` (para criar stage)

## Uso

### Exemplo básico

```hcl
module "gateway" {
  source = "./modules/gateway"
  
  gateway_name   = "kubernetes-labs-gateway"
  create_gateway = true
}
```

### Exemplo com configuração personalizada

```hcl
module "gateway" {
  source = "./modules/gateway"
  
  gateway_id     = "meu-gateway-id"
  gateway_name   = "meu-gateway-kubernetes"
  create_gateway = true
}
```

## Variáveis

| Nome             | Descrição                                          | Tipo     | Padrão                      | Obrigatório |
| ---------------- | -------------------------------------------------- | -------- | --------------------------- | ----------- |
| `gateway_id`     | ID de referência do gateway (usado apenas em tags) | `string` | `"ku9lj1zme7"`              | Não         |
| `gateway_name`   | Nome do gateway a ser criado                       | `string` | `"kubernetes-labs-gateway"` | Não         |
| `create_gateway` | Flag para controlar a criação do gateway           | `bool`   | `true`                      | Não         |

## Outputs

| Nome                | Descrição                                                  |
| ------------------- | ---------------------------------------------------------- |
| `gateway_id`        | ID do API Gateway criado ou existente                      |
| `gateway_arn`       | ARN do API Gateway criado ou existente                     |
| `gateway_url`       | URL do API Gateway criado ou existente                     |
| `gateway_exists`    | Indica se já existe um gateway com a tag `lab=kubernetes`  |
| `gateway_created`   | Indica se o gateway foi criado por este módulo             |
| `target_gateway_id` | ID de referência do gateway (valor da variável gateway_id) |

## Lógica de Funcionamento

1. O módulo consulta todos os API Gateways existentes na região usando o AWS Resource Groups Tagging API
2. Verifica se algum gateway possui a tag `lab = kubernetes`
3. Se nenhum gateway com essa tag existir e `create_gateway` for `true`, cria um novo gateway
4. Configura um deployment e stage "lab" para o gateway criado
5. Retorna informações sobre o status da operação através dos outputs

**Importante:** O módulo verifica a existência do gateway por **tags**, não por ID. A variável `gateway_id` é usada apenas como referência em tags e outputs.

## Recursos Criados (quando necessário)

Quando `create_gateway = true` e não existe um gateway com a tag `lab = kubernetes`:

- `aws_api_gateway_rest_api`: O API Gateway principal (endpoint REGIONAL)
- `aws_api_gateway_deployment`: Deployment do gateway
- `aws_api_gateway_stage`: Stage "lab" do gateway

## Tags Aplicadas

Todos os recursos criados recebem as seguintes tags:

- `Name`: Nome do gateway (valor de `gateway_name`)
- `Environment`: "labs"
- `ManagedBy`: "terraform"
- `GatewayId`: ID de referência (valor de `gateway_id`)
- `lab`: "kubernetes" *(tag usada para verificar existência do gateway)*

## Data Sources Utilizados

- `aws_resourcegroupstaggingapi_resources`: Busca gateways existentes com a tag `lab = kubernetes` (usado na verificação de existência)
- `aws_api_gateway_rest_api`: Consulta API Gateway pelo nome "apilab" na região us-east-1 (data source de referência, não utilizado na lógica principal)

## Comportamento por Cenário

| Cenário                                        | create_gateway | gateway_exists | Ação                     |
| ---------------------------------------------- | -------------- | -------------- | ------------------------ |
| Nenhum gateway com tag `lab=kubernetes` existe | `true`         | `false`        | Cria novo gateway        |
| Nenhum gateway com tag `lab=kubernetes` existe | `false`        | `false`        | Não cria nada            |
| Já existe gateway com tag `lab=kubernetes`     | `true`         | `true`         | Não cria nada            |
| Já existe gateway com tag `lab=kubernetes`     | `false`        | `true`         | Não cria nada            |

## Notas

- O módulo agora retorna informações do gateway tanto quando criado quanto quando já existe
- Os outputs (`gateway_id`, `gateway_arn`, `gateway_url`) retornam dados do gateway existente quando detectado
- O módulo não reutiliza ou modifica gateways existentes, apenas evita criar duplicatas e retorna suas informações
- A região padrão configurada no módulo é `us-east-1` (definida em `locals.tf`)

## Limitações Conhecidas

- O módulo possui um provider configurado internamente, o que não é uma prática recomendada para módulos reutilizáveis
- O data source `aws_api_gateway_rest_api` (apilab) é consultado mas não utilizado na lógica principal
- Não há suporte para reutilizar gateways existentes, apenas detecção de existência

## Exemplo de Output

Quando um gateway é criado com sucesso:

```hcl
gateway_id        = "abc123xyz"
gateway_arn       = "arn:aws:apigateway:us-east-1::/restapis/abc123xyz"
gateway_url       = "https://abc123xyz.execute-api.us-east-1.amazonaws.com/lab"
gateway_exists    = false
gateway_created   = true
target_gateway_id = "ku9lj1zme7"
```

Quando um gateway já existe:

```hcl
gateway_id        = "ku9lj1zme7"
gateway_arn       = "arn:aws:apigateway:us-east-1::/restapis/ku9lj1zme7"
gateway_url       = "https://ku9lj1zme7.execute-api.us-east-1.amazonaws.com/lab"
gateway_exists    = true
gateway_created   = false
target_gateway_id = "ku9lj1zme7"
```

## Testes

Este módulo possui testes automatizados usando [Terratest](https://terratest.gruntwork.io/). Os testes estão localizados em `../../test/gateway_test.go`.

### Requisitos para Testes

- Go >= 1.16
- Credenciais AWS configuradas
- Permissões AWS necessárias (listadas acima)

### Executar Testes

```bash
# Navegar até o diretório de testes
cd test

# Instalar dependências
go mod download
go mod tidy

# Executar teste de gateway existente (sem criar recursos)
go test -v -timeout 30m -run TestGatewayExisting

# Executar teste de criação de gateway (cria e destroi recursos reais)
# ⚠️ ATENÇÃO: Este teste cria recursos reais na AWS
go test -v -timeout 30m -run TestGateway

# Executar todos os testes do módulo gateway
go test -v -timeout 30m -run TestGateway
```

### Testes Disponíveis

#### `TestGateway`

- **Objetivo**: Valida a criação de um novo gateway
- **Comportamento**:
  - Cria um novo gateway com nome de teste
  - Valida todos os outputs
  - Destrói o gateway automaticamente ao final
- **⚠️ Atenção**: Cria recursos reais na AWS

#### `TestGatewayExisting`

- **Objetivo**: Valida a detecção de gateway existente
- **Comportamento**:
  - Executa apenas `terraform plan`
  - Verifica se o módulo detecta corretamente gateways com a tag `lab=kubernetes`
  - Não cria nem modifica recursos
- **Seguro**: Não cria recursos reais

### Exemplo de Resultado de Teste

```text
=== RUN   TestGatewayExisting
TestGatewayExisting 2025-12-09T22:30:52-03:00 logger.go:66: 
TestGatewayExisting 2025-12-09T22:30:52-03:00 logger.go:66: Changes to Outputs:
TestGatewayExisting 2025-12-09T22:30:52-03:00 logger.go:66:   + gateway_arn     = "arn:aws:apigateway:us-east-1::/restapis/ku9lj1zme7"
TestGatewayExisting 2025-12-09T22:30:52-03:00 logger.go:66:   + gateway_created = false
TestGatewayExisting 2025-12-09T22:30:52-03:00 logger.go:66:   + gateway_exists  = true
TestGatewayExisting 2025-12-09T22:30:52-03:00 logger.go:66:   + gateway_id      = "ku9lj1zme7"
TestGatewayExisting 2025-12-09T22:30:52-03:00 logger.go:66:   + gateway_url     = "https://ku9lj1zme7.execute-api.us-east-1.amazonaws.com/lab"
--- PASS: TestGatewayExisting (14.08s)
PASS
```
