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
  features {}
  subscription_id = "a327a41f-a5e9-458f-b5bb-0dc87483eb85"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "idppeproj"
  location = "EastUS"
}

# Create a storage account
resource "azurerm_storage_account" "example" {
  name                = "saidppeproj"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  account_kind        = "StorageV2" # Or "BlobStorage", "FileStorage", etc.
  account_replication_type = "LRS"  # Or "GRS", "ZRS", etc.
  account_tier             = "Standard"
  }
  

