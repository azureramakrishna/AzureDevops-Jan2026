# Use this data source to access information about an existing Resource Group.
data "azurerm_resource_group" "example" {
  name = "saanvikit-rg"
}

# Use this data source to access information about an existing Virtual Network.
data "azurerm_virtual_network" "example" {
  name                = "saanvikit-vnet"
  resource_group_name = data.azurerm_resource_group.example.name
}

# Use this data source to access information about an existing Subnet within a Virtual Network.
data "azurerm_subnet" "example" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_resource_group.example.name
}

# Use this data source to access information about an existing Key Vault.
data "azurerm_key_vault" "example" {
  name                = "saanvikitkv01"
  resource_group_name = data.azurerm_resource_group.example.name
}

# Use this data source to access information about an existing Key Vault Secret.
data "azurerm_key_vault_secret" "example" {
  name         = "windows-vm-password"
  key_vault_id = data.azurerm_key_vault.example.id
}