# tfdemo
Learning how to use Terraform

## Azure Resources Demo

This Terraform configuration creates the following resources in Azure:

- **Resource Group**: `rg-tl-demo-1` (in East US)
- **Storage Account**: `satldemo1` (Note: Azure storage account names must be 3-24 characters, lowercase letters and numbers only, so hyphens are not allowed)
- **Blob Container**: `container1` (within the storage account)

## Usage

1. Install Terraform: https://www.terraform.io/downloads
2. Authenticate with Azure:
   ```bash
   az login
   ```
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Plan the deployment:
   ```bash
   terraform plan
   ```
5. Apply the configuration:
   ```bash
   terraform apply
   ```
6. To destroy the resources:
   ```bash
   terraform destroy
   ```

## Requirements

- Terraform >= 1.0
- Azure CLI
- Azure subscription
