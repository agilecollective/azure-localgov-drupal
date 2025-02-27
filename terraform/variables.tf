##
# LGD in Azure - variables.

# Name used when creating resource group.
variable "resource_group_name" {
  type        = string
  default     = "lgd"
  description = "Name used when creating resources."
}

# ID used for resource group.
variable "resource_group_id" {
  type        = string
  default     = "001"
  description = "ID used when creating resource group."
}

# Location for all resources.
variable "resource_group_location" {
  type        = string
  default     = "uksouth"
  description = "Location of the resource group."
}

# App service plan SKU.
# See https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans
variable "app_service_plan_sku" {
  type        = string
  default     = "P0v3"
  description = "App service plan SKU."
}

# Container registry service tier.
# See https://learn.microsoft.com/en-us/azure/container-registry/container-registry-skus
variable "container_registry_sku" {
  type        = string
  default     = "Standard"
  description = "Container registry service tier SKU."
}

# Container image name.
variable "container_registry_repo_name" {
  type        = string
  default     = "lgd/drupal"
  description = "Name of repository in container registry to deploy web app to."
}

# Front Door account tier.
# See https://learn.microsoft.com/en-us/azure/frontdoor/understanding-pricing
variable "front_door_sku" {
  type        = string
  default     = "Standard_AzureFrontDoor"
  description = "Front Door tier SKU."
}

# MySQL server tier.
# See https://learn.microsoft.com/en-us/azure/mysql/flexible-server/concepts-service-tiers-storage
variable "mysql_flexible_server_sku" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "MySQL flexible server tier SKU."
}

# MySQL admin user.
variable "mysql_admin_user" {
  type        = string
  default     = "lgd_admin"
  description = "MySQL admin user."
}

# Storage account tier.
# See https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview
variable "storage_account_tier" {
  type        = string
  default     = "Standard"
  description = "Storage account tier."
}

# Storage account replication type.
variable "storage_account_replication_type" {
  type        = string
  default     = "LRS"
  description = "Storage account replication type."
}

# Drupal files quota size.
variable "storage_share_file_quota" {
  type = number
  default = 5
  description = "Quota for Drupal files (public and private)."
}
