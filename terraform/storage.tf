##
# LGD in Azure - Storage.


resource "azurerm_storage_account" "drupal_files" {
  name                     = "st-${var.resource_group_name}-001"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

resource "azurerm_storage_share" "drupal_files_prod" {
  name               = "sh-${var.resource_group_name}-prod"
  storage_account_id = azurerm_storage_account.drupal_file.id
  quota              = var.storage_share_file_quota
  enabled_protocol   = "NFS"
}

resource "azurerm_storage_share" "drupal_files_dev_private" {
  name               = "sh-${var.resource_group_name}-dev"
  storage_account_id = azurerm_storage_account.drupal_file.id
  quota              = var.storage_share_file_quota
  enabled_protocol   = "NFS"
}

resource "azurerm_storage_share" "drupal_files_uat_private" {
  name               = "sh-${var.resource_group_name}-uat-"
  storage_account_id = azurerm_storage_account.drupal_file.id
  quota              = var.storage_share_file_quota
  enabled_protocol   = "NFS"
}
