package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestGateway(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// Path para o módulo gateway
		TerraformDir: "../modules/gateway",

		// Variáveis para passar ao módulo
		Vars: map[string]interface{}{
			"gateway_name":   "test-kubernetes-labs-gateway",
			"create_gateway": true,
		},

		// Desabilitar cores para melhor legibilidade nos logs
		NoColor: true,
	}

	// Cleanup: destruir recursos no final do teste
	defer terraform.Destroy(t, terraformOptions)

	// Executar terraform init e apply
	terraform.InitAndApply(t, terraformOptions)

	// Validar outputs
	gatewayID := terraform.Output(t, terraformOptions, "gateway_id")
	gatewayARN := terraform.Output(t, terraformOptions, "gateway_arn")
	gatewayURL := terraform.Output(t, terraformOptions, "gateway_url")
	gatewayExists := terraform.Output(t, terraformOptions, "gateway_exists")
	gatewayCreated := terraform.Output(t, terraformOptions, "gateway_created")

	// Assertions
	assert.NotEmpty(t, gatewayID, "Gateway ID não deve estar vazio")
	assert.NotEmpty(t, gatewayARN, "Gateway ARN não deve estar vazio")
	assert.NotEmpty(t, gatewayURL, "Gateway URL não deve estar vazio")
	assert.Contains(t, gatewayARN, "arn:aws:apigateway", "ARN deve conter o prefixo correto")
	assert.Contains(t, gatewayURL, "execute-api", "URL deve conter execute-api")

	t.Logf("Gateway ID: %s", gatewayID)
	t.Logf("Gateway ARN: %s", gatewayARN)
	t.Logf("Gateway URL: %s", gatewayURL)
	t.Logf("Gateway Exists: %s", gatewayExists)
	t.Logf("Gateway Created: %s", gatewayCreated)
}

// Teste para verificar se o módulo detecta gateway existente
func TestGatewayExisting(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../modules/gateway",
		Vars: map[string]interface{}{
			"gateway_name":   "kubernetes-labs-gateway",
			"create_gateway": true,
		},
		NoColor: true,
	}

	// Executar apenas plan para não modificar recursos existentes
	terraform.Init(t, terraformOptions)
	terraform.Plan(t, terraformOptions)

	// Nota: Este teste apenas valida que o módulo funciona,
	// não cria recursos reais se já existir um gateway com a tag lab=kubernetes
}
