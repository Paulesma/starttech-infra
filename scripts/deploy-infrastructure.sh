#!/bin/bash
set -e

echo "🚀 Initializing Terraform..."
cd terraform
terraform init

echo "🔍 Planning Infrastructure..."
terraform plan -out=tfplan

echo "🏗️ Applying Infrastructure..."
terraform apply "tfplan"
