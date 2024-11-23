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

resource "azurerm_resource_group" "rg" {
  name     = "${var.VM_NAME}-rg"
  location = var.LOCATION
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.VM_NAME}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.VM_NAME}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.VM_NAME}-pip"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.VM_NAME}-nsg"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "default-allow-ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.VM_NAME}-nic"
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.VM_NAME}-nic-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-bound" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_storage_account" "storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.LOCATION
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.VM_NAME
  location              = var.LOCATION
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.VM_SIZE

  os_disk {
    name                 = "${var.VM_NAME}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.IMAGE_PUBLISHER
    offer     = var.IMAGE_OFFER
    sku       = var.IMAGE_SKU
    version   = var.IMAGE_VERSION
  }

  computer_name                   = lower(var.VM_NAME)
  admin_username                  = var.USERNAME
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.USERNAME
    public_key = var.PUBLIC_KEY
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }
}

output "public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}
