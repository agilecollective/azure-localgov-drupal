##
# LGD in Azure - Databases.

resource "random_password" "mysql_password" {
  length  = 16
  special = false
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "db-${var.resource_group_name}-001"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  sku_name               = var.mysql_flexible_server_sku
  zone                   = "1"
  delegated_subnet_id    = azurerm_subnet.subnet_db.id
  administrator_login    = var.mysql_admin_user
  administrator_password = random_password.mysql_password.result
}

resource "azurerm_mysql_flexible_database" "db_prod" {
  name                = "db_prod"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_database" "db_dev" {
  name                = "db_dev"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_flexible_database" "db_uat" {
  name                = "db_uat"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
