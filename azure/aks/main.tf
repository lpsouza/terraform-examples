provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  cluster_name   = "TestAKS"
  vm_size        = "Standard_D2_v2"
  admin_username = "lpsouza"
  public_key     = tls_private_key.ssh.public_key_openssh
  location       = "westus"
  agent_count    = 3
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.cluster_name}RG"
  location = local.location
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = local.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  dns_prefix          = lower(local.cluster_name)

  linux_profile {
    admin_username = local.admin_username

    ssh_key {
      key_data = local.public_key
    }
  }

  default_node_pool {
    name       = "${lower(local.cluster_name)}pool"
    node_count = local.agent_count
    vm_size    = local.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }
}

output "tls_private_key" {
  value = "${tls_private_key.ssh.private_key_pem}"
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}
