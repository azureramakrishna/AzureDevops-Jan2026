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

  subscription_id = ""
}

# terraform backend configuration
terraform {
  backend "azurerm" {
    resource_group_name  = "saanvikit-rg"
    storage_account_name = "saanvikittf"       # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"           # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
}


# Create a resource group 01
resource "azurerm_resource_group" "rg-1" {
  name     = var.ressource_group_name_01
  location = var.location
  tags     = var.tags
}


# Create an App Service Plan and App Service
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name
  tags                = var.tags

  sku {
    tier = "Premium V3"
    size = "P0v3"
  }
}

resource "azurerm_app_service" "app_service" {
  name                = var.app_service_name
  location            = azurerm_resource_group.rg-1.location
  resource_group_name = azurerm_resource_group.rg-1.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  tags                = var.tags

   site_config {
    always_on = true
  }
}