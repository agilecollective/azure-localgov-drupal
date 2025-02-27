##
# LGD in Azure - Container Registry.

resource "azurerm_container_registry" "registry" {
  name                = "cr${var.resource_group_name}"
  #name                = "${var.resource_group_name}${var.resource_group_id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.container_registry_sku
  admin_enabled       = true
}
