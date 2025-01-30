provider "azurerm" {
  features {}
  subscription_id = var.SUBSCRIPTION_ID
}

resource "random_id" "randomId" {
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.CLUSTER_NAME}-rg"
  location = var.LOCATION
}

resource "azurerm_storage_account" "hadoop" {
  name                     = "hadoop${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "hadoop" {
  name                  = "hadoop-container"
  storage_account_id    = azurerm_storage_account.hadoop.id
  container_access_type = "private"
}

resource "azurerm_hdinsight_hadoop_cluster" "hadoop" {
  name                = "${var.CLUSTER_NAME}-hadoop"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cluster_version     = "5.1"
  tier                = "Standard"
  tls_min_version     = "1.2"

  component_version {
    hadoop = "3.3"
  }

  gateway {
    username = var.USERNAME
    password = "${var.PASSWORD}!GW"
  }

  storage_account {
    storage_container_id = "${azurerm_storage_account.hadoop.primary_blob_endpoint}${azurerm_storage_container.hadoop.name}"
    storage_account_key  = azurerm_storage_account.hadoop.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = var.VM_SIZE
      username = "ssh${var.USERNAME}"
      password = "${var.PASSWORD}!HN"
    }

    worker_node {
      vm_size               = var.VM_SIZE
      username              = "ssh${var.USERNAME}"
      password              = "${var.PASSWORD}!WN"
      target_instance_count = 1
    }

    zookeeper_node {
      vm_size  = var.VM_SIZE
      username = "ssh${var.USERNAME}"
      password = "${var.PASSWORD}!ZN"
    }
  }
}

resource "azurerm_storage_account" "spark" {
  name                     = "spark${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "spark" {
  name                  = "hadoop-container"
  storage_account_id    = azurerm_storage_account.spark.id
  container_access_type = "private"
}

resource "azurerm_hdinsight_spark_cluster" "spark" {
  name                = "${var.CLUSTER_NAME}-spark"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  cluster_version     = "5.1"
  tier                = "Standard"

  component_version {
    spark = "3.3"
  }

  gateway {
    username = var.USERNAME
    password = "${var.PASSWORD}!GW"
  }

  storage_account {
    storage_container_id = "${azurerm_storage_account.spark.primary_blob_endpoint}${azurerm_storage_container.spark.name}"
    storage_account_key  = azurerm_storage_account.spark.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = var.VM_SIZE
      username = "ssh${var.USERNAME}"
      password = "${var.PASSWORD}!HN"
    }

    worker_node {
      vm_size               = var.VM_SIZE
      username              = "ssh${var.USERNAME}"
      password              = "${var.PASSWORD}!WN"
      target_instance_count = 1
    }

    zookeeper_node {
      vm_size  = var.VM_SIZE
      username = "ssh${var.USERNAME}"
      password = "${var.PASSWORD}!ZN"
    }
  }
}
