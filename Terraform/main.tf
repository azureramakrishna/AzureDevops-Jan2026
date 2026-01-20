terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.47.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}

  subscription_id = "2e28c82c-17d7-4303-b27a-4141b3d4088f"
}

# Create a resource group 01
resource "azurerm_resource_group" "rg-1" {
  name     = var.ressource_group_name_01
  location = var.location
  tags     = var.tags
}

# Create a resource group 02
resource "azurerm_resource_group" "rg-2" {
  name     = var.ressource_group_name_02
  location = var.location
  tags     = var.tags
}

# Create a storage account
resource "azurerm_storage_account" "sa" {
  name                     = lower(var.storage_account_name)
  resource_group_name      = azurerm_resource_group.rg-1.name
  location                 = azurerm_resource_group.rg-1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}


resource "azurerm_public_ip" "example" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.rg-2.name
  location            = azurerm_resource_group.rg-2.location
  allocation_method   = "Static"

  tags = var.tags
}