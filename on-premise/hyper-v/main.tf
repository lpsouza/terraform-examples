terraform {
  required_providers {
    hyperv = {
      source  = "taliesins/hyperv"
      version = "1.2.1"
    }
  }
}

provider "hyperv" {
  host     = var.HOST
  user     = var.USER
  password = var.PASSWORD
  insecure = true
}

# Create a cloud-init ISO for the VM
resource "null_resource" "cidata" {
  provisioner "local-exec" {
    command = "sudo apt-get update > /dev/null 2>&1 && sudo apt-get install -y cloud-utils > /dev/null 2>&1"
    quiet   = true
    when    = create
  }

  provisioner "local-exec" {
    working_dir = "cloud-init"
    command     = "echo 'instance-id: iid-1234567890' > meta-data && echo 'local-hostname: ${var.VM_NAME}' >> meta-data"
    quiet       = true
    when        = create
  }

  provisioner "local-exec" {
    working_dir = "cloud-init"
    command     = "cloud-localds cloud-init.iso user-data meta-data"
    quiet       = true
    when        = create
  }

  provisioner "file" {
    source      = "cloud-init/cloud-init.iso"
    destination = "${var.VM_PATH}\\${var.VM_NAME}\\cloud-init.iso"
    when        = create

    connection {
      type     = "winrm"
      user     = var.USER
      password = var.PASSWORD
      host     = var.HOST
      https    = true
      insecure = true
    }
  }

  provisioner "local-exec" {
    working_dir = "cloud-init"
    command     = "rm -f cloud-init.iso meta-data"
    quiet       = true
    when        = create
  }
}

# Get the switch to use for the VM
data "hyperv_network_switch" "default_switch" {
  name = "Default Switch"
}

# Create a differencing disk for OS disk
resource "hyperv_vhd" "os_disk" {
  path        = "${var.VM_PATH}\\${var.VM_NAME}\\${var.VM_NAME}.vhdx"
  vhd_type    = "Differencing"
  parent_path = "${var.IMAGE_PATH}\\${var.IMAGE_NAME}"
}

# Create the VM
resource "hyperv_machine_instance" "vm" {
  name = var.VM_NAME

  # Processor settings
  processor_count = var.VCPUS

  # Memory settings
  dynamic_memory       = true
  memory_startup_bytes = var.MEMORY_STARTUP_BYTES
  memory_minimum_bytes = var.MEMORY_MINIMUM_BYTES
  memory_maximum_bytes = var.MEMORY_MAXIMUM_BYTES

  path                   = var.VM_PATH
  smart_paging_file_path = "${var.VM_PATH}\\${var.VM_NAME}"
  snapshot_file_location = "${var.VM_PATH}\\${var.VM_NAME}"

  network_adaptors {
    name        = "${var.VM_NAME}-Adapter-1"
    switch_name = data.hyperv_network_switch.default_switch.name
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    controller_number   = 0
    controller_location = 0
    path                = hyperv_vhd.os_disk.path
  }

  dvd_drives {
    controller_number   = 0
    controller_location = 1
    path                = "${var.VM_PATH}\\${var.VM_NAME}\\cloud-init.iso"
    resource_pool_name  = "Primordial"
  }

  vm_firmware {
    enable_secure_boot = var.ENABLE_SECURE_BOOT
    boot_order {
      boot_type           = "HardDiskDrive"
      controller_number   = 0
      controller_location = 0
    }
  }

  vm_processor {
    expose_virtualization_extensions = var.NESTED_VIRTUALIZATION
  }

  depends_on = [null_resource.cidata]
}
