locals {
  prefix = "saanvikit"
}

resource "azurerm_resource_group" "example" {
  name     = "${locals.prefix}-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "${locals.prefix}-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "${locals.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}