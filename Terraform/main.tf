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
  resource "azurerm_virtual_network" "Example" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.Example.name
}

resource "azurerm_subnet" "Example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.Example.name
  virtual_network_name = azurerm_virtual_network.Example.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_network_interface" "Example" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.Example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "Example" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.Example.name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.Example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_app_service_plan" "Example" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.Example.name
  kind                = "Windows"
  reserved            = false

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "Example" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = azurerm_resource_group.Example.name
  app_service_plan_id = azurerm_app_service_plan.Example.id

  site_config {
    dotnet_framework_version = "v4.0"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }
}
resource "azurerm_postgresql_flexible_server" "Example" {
  name                   = var.postgres_server_name
  resource_group_name    = azurerm_resource_group.Example.name
  location               = var.location
  version                = "13"
  administrator_login    = var.postgres_admin_user
  administrator_password = var.postgres_admin_password
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "B1ms"
  backup_retention_days  = 7
  geo_redundant_backup_enabled = false
  

  authentication {
    password_auth_enabled = true
  }

  depends_on = [azurerm_resource_group.Example]
}

resource "azurerm_postgresql_flexible_server_database" "Example" {
  name      = var.postgres_db_name
  server_id = azurerm_postgresql_flexible_server.Example.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

