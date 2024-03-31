provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ncpl_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.azurerm_app_service_plan
  location            = azurerm_resource_group.ncpl_group.location
  resource_group_name = azurerm_resource_group.ncpl_group.name

  sku {
    tier = var.sku
    size = var.size
  }
}

resource "azurerm_app_service" "ncpl_app_service" {
  name                = var.ncpl_app_service
  location            = azurerm_resource_group.ncpl_group.location
  resource_group_name = azurerm_resource_group.ncpl_group.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
}
