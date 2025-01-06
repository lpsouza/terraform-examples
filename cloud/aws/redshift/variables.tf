variable "AWS_REGION" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "AWS_ACCESS_KEY" {
  description = "AWS access key"
  type        = string
  default     = "ASDFASDFASDFASDFASDF"
}

variable "AWS_SECRET_KEY" {
  description = "AWS secret key"
  type        = string
  default     = "ASDFASDFASDFASDFASDFASDFASDFASDFASDFASDF"
}

variable "CLUSTER_NAME" {
  description = "Name of the Redshift cluster"
  type        = string
  default     = "my-redshift-cluster"
}

variable "NODE_TYPE" {
  description = "Type of node to use in the Redshift cluster"
  type        = string
  default     = "dc2.large"
}

variable "NODE_COUNT" {
  description = "Number of nodes in the Redshift cluster"
  type        = number
  default     = 1
}

variable "DBNAME" {
  description = "Name of the Redshift database"
  type        = string
  default     = "mydb"
}

variable "MASTER_USERNAME" {
  description = "Master username for the Redshift cluster"
  type        = string
  default     = "admin"
}

variable "MASTER_PASSWORD" {
  description = "Master password for the Redshift cluster"
  type        = string
  default     = "S&nhAS&cr3tA1Dois3"
}
