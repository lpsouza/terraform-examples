provider "azurerm" {
  features {}
  subscription_id = var.SUBSCRIPTION_ID
}

resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_resource_group" "my_resource_group" {
  name     = "${var.STORAGE_ACCOUNT_NAME}-RG"
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

data "azurerm_storage_account_sas" "my_storage_container_sas" {
  connection_string = azurerm_storage_account.my_storage_account.primary_connection_string
  https_only        = true

  resource_types {
    object    = true
    container = true
    service   = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2021-01-01T00:00:00Z"
  expiry = "2025-01-01T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}

output "sas_url_query_string" {
  value     = data.azurerm_storage_account_sas.my_storage_container_sas.sas
  sensitive = true
}
