##
# LocalGov Drupal hosting in Azure.

# Configure the Azure provider.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Azure resource group.
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "rg-${var.resource_group_name}-${var.resource_group_location}-${var.resource_group_id}"
}
