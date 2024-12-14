provider "azurerm" {
  features {}
  subscription_id = var.SUBSCRIPTION_ID
}

resource "random_id" "randomId" {
  byte_length = 4
}

resource "azurerm_resource_group" "my_resource_group" {
  name     = "${var.STORAGE_ACCOUNT_NAME}-rg"
  location = var.LOCATION
}

resource "azurerm_storage_account" "my_storage_account" {
  name                     = "${var.STORAGE_ACCOUNT_NAME}${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.my_resource_group.name
  location                 = var.LOCATION
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "my_storage_container" {
  name                  = "${var.STORAGE_ACCOUNT_NAME}-container"
  storage_account_id    = azurerm_storage_account.my_storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_management_policy" "example" {
  storage_account_id = azurerm_storage_account.my_storage_account.id

  rule {
    name    = "move-to-cool-tier"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_creation_greater_than    = 30
        tier_to_archive_after_days_since_creation_greater_than = 60
      }
    }
  }
}
