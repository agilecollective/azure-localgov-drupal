##
# LGD in Azure - outputs

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "container_registry_url" {
  value = azurerm_container_registry.registry.login_server
}

output "mysql_admin_login" {
  value = azurerm_mysql_flexible_server.mysql.administrator_login
}

output "mysql_admin_password" {
  sensitive = true
  value     = random_password.mysql_password.result
}

output "mysql_server_host" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}
