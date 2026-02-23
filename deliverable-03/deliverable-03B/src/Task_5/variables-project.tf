# Project-level variables: change per deployment

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

  validation {
    condition = (
      length(var.resource_group_name) >= 1 &&
      length(var.resource_group_name) <= 90 &&
      can(regex("^[a-zA-Z0-9._()\\-]+$", var.resource_group_name)) &&
      !can(regex("\\.$", var.resource_group_name))
    )
    error_message = "Resource group name must be 1-90 characters, contain only alphanumerics, periods, underscores, hyphens, and parentheses, and cannot end with a period."
  }
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string

  validation {
    condition = (
      length(var.vm_name) >= 1 &&
      length(var.vm_name) <= 64 &&
      can(regex("^[a-zA-Z0-9\\-]+$", var.vm_name)) &&
      !can(regex("^-", var.vm_name)) &&
      !can(regex("-$", var.vm_name))
    )
    error_message = "VM name must be 1-64 characters, contain only alphanumerics and hyphens, and cannot start or end with a hyphen."
  }
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2pts_v2"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "lab"
}

variable "ansible_group" {
  description = "Ansible inventory group tag"
  type        = string
  default     = "webservers"
}

variable "image_publisher" {
  description = "OS image publisher"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "OS image offer"
  type        = string
  default     = "ubuntu-24_04-lts"
}

variable "image_sku" {
  description = "OS image SKU"
  type        = string
  default     = "server-arm64"
}

variable "image_version" {
  description = "OS image version"
  type        = string
  default     = "latest"
}
