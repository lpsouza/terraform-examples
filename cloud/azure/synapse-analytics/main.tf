provider "azurerm" {
  features {}
  subscription_id = var.SUBSCRIPTION_ID
}

resource "random_id" "randomId" {
  byte_length = 4
}

resource "azurerm_resource_group" "example" {
  name     = "${var.WORKSPACE_NAME}-rg"
  location = var.LOCATION
}

resource "azurerm_storage_account" "example" {
  name                     = "${substr(replace(lower(var.WORKSPACE_NAME), "-", ""), 0, 15)}${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "${azurerm_storage_account.example.name}-dl"
  storage_account_id = azurerm_storage_account.example.id
}

resource "azurerm_synapse_workspace" "example" {
  name                                 = "${var.WORKSPACE_NAME}-${random_id.randomId.hex}"
  resource_group_name                  = azurerm_resource_group.example.name
  location                             = azurerm_resource_group.example.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.example.id
  sql_administrator_login              = var.ADMIN_USERNAME
  sql_administrator_login_password     = var.ADMIN_PASSWORD

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_firewall_rule" "example-allow-azure-ips" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.example.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}

resource "azurerm_synapse_firewall_rule" "example-allow-all" {
  name                 = "AllowAll"
  synapse_workspace_id = azurerm_synapse_workspace.example.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}

resource "azurerm_synapse_sql_pool" "example" {
  name                      = var.SQL_POOL_NAME
  synapse_workspace_id      = azurerm_synapse_workspace.example.id
  sku_name                  = "DW100c"
  create_mode               = "Default"
  storage_account_type      = "LRS"
  geo_backup_policy_enabled = false
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.example.identity[0].principal_id
}
