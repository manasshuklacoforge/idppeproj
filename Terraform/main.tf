terraform {
 required_providers {
   azurerm = {
     source = "hashicorp/azurerm"
     version = "3.78.0"
   }
 }
}
provider "azurerm" {
  features {}
  subscription_id = "a327a41f-a5e9-458f-b5bb-0dc87483eb85"
}
# Create a resource group
resource "idppeproj_resource_group" "example" {
  name     = "idppeproj-resource-group"
  location = "eastus" # Choose your desired location
}
# Create an Azure Storage Account
resource "azurerm_storage_account" "example" {
  name                     = "idppeprojstorageaccount" # Storage account name (must be globally unique)
  resource_group_name      = idppeproj_resource_group.example.name
  location                 = idppeproj_resource_group.example.location
  account_kind             = "StorageV2" # Or "BlobStorage", "FileStorage", etc.
  account_replication_type = "LRS"  # Or "GRS", "ZRS", etc.
  }
  

