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
