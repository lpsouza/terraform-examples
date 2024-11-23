variable "SUBSCRIPTION_ID" {
  description = "Azure subscription ID"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "LOCATION" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

variable "STORAGE_ACCOUNT_NAME" {
  description = "Azure storage account name"
  type        = string
  default     = "mystorageaccount"
}
