##
# LGD in Azure - Storage.

# Drupal files storage account.
resource "azurerm_storage_account" "drupal_files" {
  name                     = "st${var.resource_group_name}001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

# Production file share.
resource "azurerm_storage_share" "drupal_files_prod" {
  name                 = "sh-${var.resource_group_name}-prod"
  storage_account_name = azurerm_storage_account.drupal_files.name
  quota                = var.storage_share_file_quota
  enabled_protocol     = "SMB"
}

# Dev file share.
resource "azurerm_storage_share" "drupal_files_dev" {
  name                 = "sh-${var.resource_group_name}-dev"
  storage_account_name = azurerm_storage_account.drupal_files.name
  quota                = var.storage_share_file_quota
  enabled_protocol     = "SMB"
}

# UAT file share.
resource "azurerm_storage_share" "drupal_files_uat" {
  name                 = "sh-${var.resource_group_name}-uat"
  storage_account_name = azurerm_storage_account.drupal_files.name
  quota                = var.storage_share_file_quota
  enabled_protocol     = "SMB"
}
