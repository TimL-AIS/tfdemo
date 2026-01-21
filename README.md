# tfdemo
Learning how to use Terraform

## Azure Resources Demo

This Terraform configuration creates the following resources in Azure:

- **Resource Group**: `rg-tl-demo-1` (in East US)
- **Storage Account**: `satldemo1` (Note: Azure storage account names must be 3-24 characters, lowercase letters and numbers only, so hyphens are not allowed)
- **Blob Container**: `container1` (within the storage account)
- **Virtual Network**: `vnet-demo` with subnet
- **Network Security Group**: Allows SSH (port 22) and HTTP (port 80)
- **Ubuntu VM**: With NGINX web server installed

## Usage

1. Install Terraform: https://www.terraform.io/downloads
2. Authenticate with Azure:
   ```bash
   az login
   ```
3. Initialize Terraform (creates state file):
   ```bash
   terraform init
   ```
4. Validate Terraform configuration:
   ```bash
   terraform validate
   ```
5. Plan the deployment:
   ```bash
   terraform plan
   ```
6. Apply the configuration:
   ```bash
   terraform apply
   ```
7. To destroy the resources:
   ```bash
   terraform destroy
   ```

## Requirements

- Terraform >= 1.0
- Azure CLI
- Azure subscription

## GitHub Actions

This project includes a GitHub Actions workflow for automated Terraform deployments. To use it, configure the following secrets in your GitHub repository:

- `AZURE_CLIENT_ID`: Azure service principal client ID
- `AZURE_TENANT_ID`: Azure tenant ID
- `AZURE_SUBSCRIPTION_ID`: Azure subscription ID

The workflow uses OIDC authentication for secure, passwordless Azure authentication.
