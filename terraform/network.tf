##
# LGD in Azure - networking.


# Virtual Network
resource "azurerm_virtual_network" "private" {
  name                = "vnet-${var.resource_group_name}-private-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# DB subnet.
resource "azurerm_subnet" "subnet_db" {
  name                 = "snet-private-db"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Files subnet.
resource "azurerm_subnet" "subnet_file" {
  name                 = "snet-private-file"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# CDN subnet.
resource "azurerm_subnet" "subnet_cdn" {
  name                 = "snet-private-cdn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.2.0/24"]
}
