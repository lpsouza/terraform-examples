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

variable "CLUSTER_NAME" {
  description = "HDInsight cluster name"
  type        = string
  default     = "my-hdinsight-cluster"
}

variable "USERNAME" {
  description = "Username for the cluster login"
  type        = string
  default     = "admin"
}

variable "PASSWORD" {
  description = "Password for the cluster login"
  type        = string
  default     = "Hd1n5ight!SecureP@ssw0rd"
}

variable "VM_SIZE" {
  description = "The size of the VMs in the cluster"
  type        = string
  default     = "Large"
}
