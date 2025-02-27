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
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    ip_restriction {
      service_tag               = "AzureFrontDoor.Backend"
      ip_address                = null
      virtual_network_subnet_id = null
      action                    = "Allow"
      priority                  = 100
      headers {
        x_azure_fdid      = [azurerm_cdn_frontdoor_profile.front_door.resource_guid]
        x_fd_health_probe = []
        x_forwarded_for   = []
        x_forwarded_host  = []
      }
      name = "Allow traffic from Front Door"
    }
  }
  app_settings = {
    "AZURE_MYSQL_DBNAME"   = azurerm_mysql_flexible_database.db_prod.name
    "AZURE_MYSQL_FLAG"     = "MYSQLI_CLIENT_SSL"
    "AZURE_MYSQL_HOST"     = azurerm_mysql_flexible_server.mysql.fqdn
    "AZURE_MYSQL_PASSWORD" = azurerm_mysql_flexible_server.mysql.administrator_password
    "AZURE_MYSQL_PORT"     = "3306"
    "AZURE_MYSQL_USERNAME" = azurerm_mysql_flexible_server.mysql.administrator_login
  }
  connection_string {
    name  = "Database"
    type  = "MySql"
    value = ""
  }
  storage_account {
    name         = "prod-files"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.drupal_files.name
    share_name   = azurerm_storage_share.drupal_files_prod.name
    access_key   = azurerm_storage_account.drupal_files.primary_access_key
    mount_path   = "/var/www/share"
  }
  sticky_settings {
    app_setting_names = [
      "AZURE_MYSQL_HOST",
      "AZURE_MYSQL_PORT",
      "AZURE_MYSQL_DATABASE",
      "AZURE_MYSQL_SSL",
      "AZURE_MYSQL_USERNAME",
      "AZURE_MYSQL_PASSWORD",
      "AZURE_MYSQL_DBNAME",
      "AZURE_MYSQL_HOST",
      "AZURE_MYSQL_PORT",
      "AZURE_MYSQL_FLAG",
      "AZURE_MYSQL_USERNAME",
      "AZURE_MYSQL_PASSWORD",
    ]
    connection_string_names = [
      "Database"
    ]
  }
}

# Pre-prod slot.
resource "azurerm_linux_web_app_slot" "preprod" {
  name           = "app-slot-preprod"
  app_service_id = azurerm_linux_web_app.app.id
  https_only = true
  app_settings = {
    "AZURE_MYSQL_DBNAME"   = azurerm_mysql_flexible_database.db_prod.name
    "AZURE_MYSQL_FLAG"     = "MYSQLI_CLIENT_SSL"
    "AZURE_MYSQL_HOST"     = azurerm_mysql_flexible_server.mysql.fqdn
    "AZURE_MYSQL_PASSWORD" = azurerm_mysql_flexible_server.mysql.administrator_password
    "AZURE_MYSQL_PORT"     = "3306"
    "AZURE_MYSQL_USERNAME" = azurerm_mysql_flexible_server.mysql.administrator_login
    "AZURE_MYSQL_SSL"      = "true"
    "DOCKER_ENABLE_CI"     = "true"
  }
  connection_string {
    name  = "Database"
    type  = "MySql"
    value = ""
  }
  site_config {
    application_stack {
      docker_image_name        = "${var.container_registry_repo_name}:main"
      docker_registry_url      = "https://${azurerm_container_registry.registry.login_server}"
      docker_registry_username = azurerm_container_registry.registry.admin_username
      docker_registry_password = azurerm_container_registry.registry.admin_password
    }
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
  }
  storage_account {
    name         = "prod-files"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.drupal_files.name
    share_name   = azurerm_storage_share.drupal_files_prod.name
    access_key   = azurerm_storage_account.drupal_files.primary_access_key
    mount_path   = "/var/www/share"
  }
}

# Dev slot.
resource "azurerm_linux_web_app_slot" "dev" {
  name           = "app-slot-dev"
  app_service_id = azurerm_linux_web_app.app.id
  https_only = true
  app_settings = {
    "AZURE_MYSQL_DBNAME"   = azurerm_mysql_flexible_database.db_dev.name
    "AZURE_MYSQL_FLAG"     = "MYSQLI_CLIENT_SSL"
    "AZURE_MYSQL_HOST"     = azurerm_mysql_flexible_server.mysql.fqdn
    "AZURE_MYSQL_PASSWORD" = azurerm_mysql_flexible_server.mysql.administrator_password
    "AZURE_MYSQL_PORT"     = "3306"
    "AZURE_MYSQL_USERNAME" = azurerm_mysql_flexible_server.mysql.administrator_login
    "AZURE_MYSQL_SSL"      = "true"
    "DOCKER_ENABLE_CI"     = "true"
  }
  site_config {
    application_stack {
      docker_image_name        = "${var.container_registry_repo_name}:dev"
      docker_registry_url      = "https://${azurerm_container_registry.registry.login_server}"
      docker_registry_username = azurerm_container_registry.registry.admin_username
      docker_registry_password = azurerm_container_registry.registry.admin_password
    }
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
  }
  storage_account {
    name         = "dev-files"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.drupal_files.name
    share_name   = azurerm_storage_share.drupal_files_dev.name
    access_key   = azurerm_storage_account.drupal_files.primary_access_key
    mount_path   = "/var/www/share"
  }
}

# UAT slot.
resource "azurerm_linux_web_app_slot" "uat" {
  name           = "app-slot-uat"
  app_service_id = azurerm_linux_web_app.app.id
  https_only = true
  app_settings = {
    "AZURE_MYSQL_DBNAME"   = azurerm_mysql_flexible_database.db_uat.name
    "AZURE_MYSQL_FLAG"     = "MYSQLI_CLIENT_SSL"
    "AZURE_MYSQL_HOST"     = azurerm_mysql_flexible_server.mysql.fqdn
    "AZURE_MYSQL_PASSWORD" = azurerm_mysql_flexible_server.mysql.administrator_password
    "AZURE_MYSQL_PORT"     = "3306"
    "AZURE_MYSQL_USERNAME" = azurerm_mysql_flexible_server.mysql.administrator_login
    "AZURE_MYSQL_SSL"      = "true"
    "DOCKER_ENABLE_CI"     = "true"
  }
  site_config {
    application_stack {
      docker_image_name        = "${var.container_registry_repo_name}:uat"
      docker_registry_url      = "https://${azurerm_container_registry.registry.login_server}"
      docker_registry_username = azurerm_container_registry.registry.admin_username
      docker_registry_password = azurerm_container_registry.registry.admin_password
    }
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
  }
  storage_account {
    name         = "uat-files"
    type         = "AzureFiles"
    account_name = azurerm_storage_account.drupal_files.name
    share_name   = azurerm_storage_share.drupal_files_uat.name
    access_key   = azurerm_storage_account.drupal_files.primary_access_key
    mount_path   = "/var/www/share"
  }
}
