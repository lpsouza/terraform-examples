variable "SUBSCRIPTION_ID" {
  description = "Azure subscription ID"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "LOCATION" {
  description = "Azure location"
  type        = string
  default     = "eastus"
}

variable "VM_NAME" {
  description = "Virtual machine name"
  type        = string
  default     = "my-vm"
}

variable "VM_SIZE" {
  description = "Virtual machine size"
  type        = string
  default     = "Standard_B1s"
}

variable "USERNAME" {
  description = "Username"
  type        = string
  default     = "ubuntu"
}

variable "PUBLIC_KEY" {
  description = "Public key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAA... user@host"
}

variable "IMAGE_PUBLISHER" {
  description = "Image publisher"
  type        = string
  default     = "Canonical"
}

variable "IMAGE_OFFER" {
  description = "Image offer"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "IMAGE_SKU" {
  description = "Image SKU"
  type        = string
  default     = "22_04-lts-gen2"

}

variable "IMAGE_VERSION" {
  description = "Image version"
  type        = string
  default     = "latest"
}
