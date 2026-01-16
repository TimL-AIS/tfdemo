terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "demo" {
  name     = "rg-tl-demo-1"
  location = "East US"
}

# Storage Account
# Note: Azure storage account names must be 3-24 characters, lowercase letters and numbers only
# "sa-tl-demo-1" is invalid, using "satldemo1" instead
resource "azurerm_storage_account" "demo" {
  name                     = "satldemo1"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Blob Container
resource "azurerm_storage_container" "demo" {
  name                  = "container1"
  storage_account_name  = azurerm_storage_account.demo.name
  container_access_type = "private"
}
