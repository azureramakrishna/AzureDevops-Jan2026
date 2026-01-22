# Create a resource group 01
resource "azurerm_resource_group" "rg" {
  name     = var.ressource_group_name
  location = var.location
  tags     = var.tags
}

# Create a storage account 
resource "azurerm_storage_account" "sa" {
  name                     = "${var.storage_account_name}${count.index + 1}"
  count                    = var.count_value
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}