# Specify the required provider and version
# NOTE: State Management - This configuration uses local state storage (default)
# For team environments or AWX integration, consider using a remote backend such as:
#   - Azure Storage Account (azurerm backend)
#   - Terraform Cloud
#   - AWS S3 with DynamoDB locking
# Remote state is critical for shared infrastructure and CI/CD pipelines
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Common tags applied to all resources for organization and cost tracking
locals {
  common_tags = {
    ansible_group = var.ansible_group
    environment   = var.environment
    managed_by    = "opentofu"
    project       = "deliverable-3-task-5"
  }
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Virtual network (required by Azure)
resource "azurerm_virtual_network" "main" {
  name                = "vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# Subnet (required by Azure)
resource "azurerm_subnet" "main" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnet_address_prefix
}

# Public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.vm_name}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = lower(var.vm_name)
  tags                = local.common_tags
}

# Network Security Group with SSH and HTTP open

resource "azurerm_network_security_group" "main" {
  name                = "nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = ["132.235.0.0/16", "64.247.64.0/18"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network interface (required by Azure)
resource "azurerm_network_interface" "main" {
  name                = "nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Connect NSG to NIC
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Option B: Tags for Azure dynamic inventory (used by AWX later)
  tags = local.common_tags
}

# Generate Ansible inventory in YAML format
# This creates a static inventory file that can be used with ansible-playbook
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.yml"
  content  = yamlencode({
    all = {
      children = {
        "${var.ansible_group}" = {
          hosts = {
            "${azurerm_public_ip.main.ip_address}" = {
              ansible_user                = var.admin_username
              ansible_python_interpreter  = "/usr/bin/python3"
            }
          }
        }
      }
    }
  })

  depends_on = [azurerm_linux_virtual_machine.main]
}

# Wait for SSH to be ready before allowing Ansible to run
# This prevents Ansible connection failures when run immediately after 'tofu apply'
resource "null_resource" "wait_for_ssh" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for SSH to be ready on ${azurerm_public_ip.main.ip_address}..."
      timeout=300
      elapsed=0
      while [ $elapsed -lt $timeout ]; do
        if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 ${var.admin_username}@${azurerm_public_ip.main.ip_address} "echo SSH Ready" 2>/dev/null; then
          echo "SSH is ready!"
          exit 0
        fi
        echo "SSH not ready yet, waiting... ($elapsed seconds elapsed)"
        sleep 10
        elapsed=$((elapsed + 10))
      done
      echo "Timeout waiting for SSH after $timeout seconds"
      exit 1
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    azurerm_linux_virtual_machine.main,
    azurerm_network_interface_security_group_association.main
  ]
}

# Outputs
output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "ssh_connection" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.main.ip_address}"
}

output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the resource group (useful for cleanup and resource management)"
}

output "ansible_group" {
  value       = var.ansible_group
  description = "Ansible inventory group assigned to this VM"
}

output "ansible_inventory_file" {
  value       = local_file.ansible_inventory.filename
  description = "Path to generated Ansible inventory file (YAML format)"
}

output "ansible_inventory_note" {
  value       = "Use 'ansible-playbook -i ${local_file.ansible_inventory.filename} configuration.yml' to run playbooks"
  description = "Information about Ansible inventory usage"
}

output "web_url" {
  value       = "http://${azurerm_public_ip.main.fqdn}"
  description = "URL to reach the web server"
}
