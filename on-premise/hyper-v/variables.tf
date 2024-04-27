variable "HOST" {
  description = "The IP address of the Hyper-V host"
  type        = string
}

variable "USER" {
  description = "The username to connect to the Hyper-V host"
  type        = string
}

variable "PASSWORD" {
  description = "The password to connect to the Hyper-V host"
  type        = string
}

variable "VM_NAME" {
  description = "The name of the VM to manage"
  type        = string
}

variable "VM_PATH" {
  description = "The path to the VM on the Hyper-V host"
  type        = string
}

variable "IMAGE_PATH" {
  description = "The path to the image to use for the VM"
  type        = string
}

variable "IMAGE_NAME" {
  description = "The name of the image to use for the VM"
  type        = string
}

variable "VCPUS" {
  description = "The number of vCPUs to assign to the VM"
  type        = number
  default     = 4
}

variable "MEMORY_STARTUP_BYTES" {
  description = "The startup memory for the VM in bytes"
  type        = string
  default     = "4294967296"
}

variable "MEMORY_MINIMUM_BYTES" {
  description = "The minimum memory for the VM in bytes"
  type        = string
  default     = "4294967296"
}

variable "MEMORY_MAXIMUM_BYTES" {
  description = "The maximum memory for the VM in bytes"
  type        = string
  default     = "8589934592"
}

variable "ENABLE_SECURE_BOOT" {
  description = "Enable or disable secure boot for the VM"
  type        = string
  default     = "Off"
}

variable "NESTED_VIRTUALIZATION" {
  description = "Enable or disable nested virtualization for the VM"
  type        = bool
  default     = true
}
