# Exemplo de Uso do Módulo Gateway

Este diretório contém um exemplo completo de como usar o módulo Gateway para provisionar um API Gateway AWS.

## Pré-requisitos

- Terraform >= 1.0
- AWS CLI configurado com credenciais apropriadas
- Permissões para criar recursos API Gateway na AWS

## Como usar

1. **Clone ou navegue até este diretório:**
   ```bash
   cd examples/gateway
   ```

2. **Inicialize o Terraform:**
   ```bash
   terraform init
   ```

3. **Revise o plano:**
   ```bash
   terraform plan
   ```

4. **Aplique as mudanças:**
   ```bash
   terraform apply
   ```

## O que será criado

Este exemplo irá:

1. Verificar se já existe um gateway com o ID `ku9lj1zme7`
2. Se não existir, criar:
   - Um API Gateway REST API
   - Um deployment para o gateway
   - Um stage "prod" para o gateway
3. Aplicar tags apropriadas incluindo o `GatewayId`

## Personalização

Você pode personalizar o exemplo modificando as variáveis no arquivo `main.tf`:

- `gateway_id`: ID específico para verificação
- `gateway_name`: Nome do gateway a ser criado
- `create_gateway`: Flag para controlar a criação

## Limpeza

Para remover os recursos criados:

```bash
terraform destroy
```

## Outputs

Após a aplicação, você verá informações sobre:
- ID do gateway criado
- ARN do gateway
- URL do endpoint
- Status da operação (se existia, se foi criado)