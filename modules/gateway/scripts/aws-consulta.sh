#!/bin/bash

export AWS_API_LAB_KEY="ku9lj1zme7"

# Script para consultar a API Gateway criada pelo Terraform
aws apigateway get-rest-api --rest-api-id=$AWS_API_LAB_KEY --region us-east-1