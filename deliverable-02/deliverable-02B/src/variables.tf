variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
  default     = "del03A-ncenus"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
  default     = "northcentralus"
}

variable "admin_username" {
  description = "The admin username for the VM being created."
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "The password for the VM being created."
  type        = string
  sensitive   = true
}
