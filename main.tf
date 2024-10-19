resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}"
  location = "West Europe"
}

resource "azurerm_storage_account" "stg" {
  name                = "stg${var.name}"
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  dynamic "network_rules" {
    for_each = var.ips_allowed == null ? {} : { k = "1" }
    content {
      default_action = "Deny"
      ip_rules       = var.ips_allowed
    }
  }
}