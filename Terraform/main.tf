# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "eastus" # Choose your desired location
}
# Create an Azure Storage Account
resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount" # Storage account name (must be globally unique)
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_kind             = "StorageV2" # Or "BlobStorage", "FileStorage", etc.
  account_replication_type = "LRS"  # Or "GRS", "ZRS", etc.
  # Optional: Enable static website hosting
  static_website {
    index_document = "index.html"
    error_404_document = "404.html"
  }
  enable_http_logging = true
  # Optional: Enable large file support
  enable_large_file_support = true
}
