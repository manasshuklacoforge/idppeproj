terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  feature {
    storage_account_enable_public_access_by_default = false
  }
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "EastUS"
}

# Create a storage account
resource "azurerm_storage_account" "example" {
  name                = "mystorageaccount123"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  account_kind        = "StandardLRS"
  # ... other settings
}
  

