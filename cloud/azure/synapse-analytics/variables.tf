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

variable "WORKSPACE_NAME" {
  description = "Synapse workspace name"
  type        = string
  default     = "my-synapse-workspace"
}

variable "ADMIN_USERNAME" {
  description = "SQL administrator login"
  type        = string
  default     = "sqladmin"
}

variable "ADMIN_PASSWORD" {
  description = "SQL administrator password"
  type        = string
  default     = "S&nhAS&cr3tA1Dois3"
}

variable "SQL_POOL_NAME" {
  description = "Synapse SQL pool name"
  type        = string
  default     = "mysqlpool"
}
