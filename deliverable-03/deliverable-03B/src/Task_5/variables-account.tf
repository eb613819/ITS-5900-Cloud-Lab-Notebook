# Account-level variables: set once per user, reused across projects

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.subscription_id))
    error_message = "The subscription_id must be a valid GUID format (e.g., 12345678-1234-1234-1234-123456789012)."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "westus2"
}

variable "admin_username" {
  description = "VM administrator username"
  type        = string

  validation {
    condition = (
      length(var.admin_username) >= 1 &&
      length(var.admin_username) <= 64 &&
      !contains(["administrator", "admin", "root", "guest"], lower(var.admin_username))
    )
    error_message = "The admin_username must be 1-64 characters and cannot be 'administrator', 'admin', 'root', or 'guest'."
  }
}

variable "admin_ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.admin_ssh_public_key) > 0 && can(regex("^(ssh-rsa|ssh-ed25519|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521) ", var.admin_ssh_public_key))
    error_message = "The admin_ssh_public_key must be a valid SSH public key starting with ssh-rsa, ssh-ed25519, or ecdsa-sha2."
  }
}
