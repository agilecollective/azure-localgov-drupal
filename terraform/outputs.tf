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

output "front_door_prod_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.prod.host_name}/"
}

output "front_door_preprod_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.preprod.host_name}/"
}

output "front_door_uat_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.uat.host_name}/"
}

output "front_door_dev_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.dev.host_name}/"
}

