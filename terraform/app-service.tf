##
# LGD in Azure - App Service.

# Linux App Service Plan.
resource "azurerm_service_plan" "appserviceplan" {
  name                = "asp-${var.resource_group_name}-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

# Linux Web App.
resource "azurerm_linux_web_app" "app" {
  name                  = "app-${var.resource_group_name}-001"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config {
    application_stack {
      docker_image_name        = "lgd"
      docker_registry_url      = "https://${azurerm_container_registry.registry.login_server}"
      docker_registry_username = azurerm_container_registry.registry.admin_username
      docker_registry_password = azurerm_container_registry.registry.admin_password
    }
  }
}

# Dev slot.
resource "azurerm_linux_web_app_slot" "dev" {
  name           = "app-slot-${var.resource_group_name}-dev"
  app_service_id = azurerm_linux_web_app.app.id
  site_config {}
}

# Prod slot.
resource "azurerm_linux_web_app_slot" "preprod" {
  name           = "app-slot-${var.resource_group_name}-prod"
  app_service_id = azurerm_linux_web_app.app.id
  site_config {}
}

# UAT slot.
resource "azurerm_linux_web_app_slot" "uat" {
  name           = "app-slot-${var.resource_group_name}-uat"
  app_service_id = azurerm_linux_web_app.app.id
  site_config {}
}
