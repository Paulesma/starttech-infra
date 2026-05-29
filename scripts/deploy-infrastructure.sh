#!/bin/bash
set -e

# Move to the terraform directory relative to the script location
cd "$(dirname "$0")/../terraform"

echo "🚀 Initializing Terraform..."
# -input=false is better for automation/CI
terraform init -input=false

echo "🔍 Planning Infrastructure..."
# We use -out to ensure the plan we see is exactly what gets applied
terraform plan -out=tfplan -input=false

echo "🏗️ Applying Infrastructure..."
# Senior Tip: Only apply the plan file generated in the previous step
terraform apply -input=false "tfplan"

echo "✅ Infrastructure Deployment Complete!"

# Senior Requirement: Output the results for the next stage
echo "📊 Current Infrastructure Outputs:"
terraform output
