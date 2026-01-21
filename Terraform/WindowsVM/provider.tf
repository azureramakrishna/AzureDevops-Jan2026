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
  client_id       = "95dbbdc9-d160-460b-b8cc-86cdb55d351c"
  client_secret   = "jSK8Q~yg_9Ct1NHYAuSuOrlj5e258oq93BCTEaN2"
  tenant_id       = "459865f1-a8aa-450a-baec-8b47a9e5c904"
}