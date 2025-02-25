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
  virtual_network_name = azurerm_virtual_network.private.name
  address_prefixes     = ["10.0.0.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# Web app subnet.
resource "azurerm_subnet" "subnet_app" {
  name                 = "snet-private-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.private.name
  address_prefixes     = ["10.0.1.0/24"]
}

# CDN subnet.
resource "azurerm_subnet" "subnet_cdn" {
  name                 = "snet-private-cdn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.private.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Private DB DNS zone.
resource "azurerm_private_dns_zone" "dns_db" {
  name                = "${var.resource_group_name}.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

# Private DB endpoint.
resource "azurerm_private_endpoint" "endpoint_db" {
  name                = "endpoint-${azurerm_mysql_flexible_server.mysql.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet_app.id

  private_service_connection {
    name                           = "psc-${azurerm_mysql_flexible_server.mysql.name}"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name = "private-dns-${azurerm_mysql_flexible_server.mysql.name}"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.dns_db.id
    ]
  }
}

# DB private endpoint connecton.
data "azurerm_private_endpoint_connection" "db" {
  name                = azurerm_private_endpoint.endpoint_db.name
  resource_group_name = azurerm_resource_group.rg.name
}

# Private DNS to VNET link.
resource "azurerm_private_dns_zone_virtual_network_link" "db" {
  name                  = "vnet-link-db"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_db.name
  virtual_network_id    = azurerm_virtual_network.private.id
}
