##
# LGD in Azure - outputs

output "mysql_admin_login" {
  value = azurerm_mysql_flexible_server.mysql.administrator_login
}

output "mysql_server_host" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
