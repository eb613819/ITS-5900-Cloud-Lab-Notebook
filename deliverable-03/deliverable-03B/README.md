# Deliverable 3B - Ansible Automation

## Objective
The purpose of this deliverable is to 

---

## Reference Documentation
- [Ansible VyOS Module](https://docs.ansible.com/ansible/latest/collections/vyos/vyos)
- [YAML Lint](https://www.yamllint.com) – YAML syntax checker
- [JinjaFx](https://jinjafx.io) – Jinja syntax checker
- [Ansible Overview](https://medium.com/@denot/ansible-101-d6dc9f86df0a)
- [JSON Structure Overview](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON)

---

## Table of Contents
- [Objective](#objective)
- [Reference Documentation](#reference-documentation)
- [Task 1 – Clone Class GitHub Repo](#task-1)
   - [Authenticate Git](#authenticate-git)
   - [Create Directory](#create-directory)
   - [Clone Repository](#clone-repository)
- [Task 2 - Build an SSH key](#task-2)
   - [Generate the SSH Key](#generate-the-ssh-key)
   - [Start the SSH Agent](#start-the-ssh-agent)
   - [Add the SSH Key to the Agent](#add-the-ssh-key-to-the-agent)
   - [Verify the Key is Loaded](#verify-the-key-is-loaded)
   - [Start SSH Agent Automatically on Login](#start-ssh-agent-automatically-on-login)
- [Task 3 - New Tofu Configurations](#task-3)
   - [Providers](#providers)
      - [Terraform Block](#terraform-block)
      - [Azure Provider Block](#azure-provider-block)
   - [Resource Group](#resource-group)
   - [Virtual Network](#virtual-network)
   - [Subnet](#subnet)
   - [Public IP](#public-ip)
   - [Network Security Group](#network-security-group)
   - [Network Interface](#network-interface)
      - [NIC Creation](#nic-creation)
      - [Connection to Network Security Group](#connection-to-network-security-group)
   - [Virtual Machine](#virtual-machine)
   - [Outputs](#outputs)

---

<a id="task-1"></a>
## Task 1 - Clone Class GitHub Repo
The first step of this deliverable is to clone the class repo.

### **Authenticate Git**
First, we must check if the gHost's GitHub CLI (`gh`) is authenticated to GitHub:
```bash
gh auth status
```

If it is not, follow the steps from the [Pre-deliverable Setup](../../pre-deliverable-setup/README.md#authentication)

### **Create Directory**
We want a standard directory structure for the homework assignments. The homework will assume a structure like `~/Cloud/<GITHUB_REPO_NAME>`. We will match that to keep things simple:
```bash
mkdir ~/Cloud
cd ~/Cloud
```

### **Clone Repository**
From inside the newly created directory we can clone the deliverable repository:
```bash
gh repo clone OHIO-ECT/ITS-4900-Cloud-Release
```
   
**Note**: for an error like:
```bash
GraphQL: Resource protected by organization SAML enforcement. You must grant your OAuth token access to this organization. (repository)
Authorize in your web browser:  https://github.com/enterprises/ohiouniversity/sso?authorization_request=AQX5XL3U5VNYBPQIFEN66KLJTEWS3A5PN5ZGOYLONF5GC5DJN5XF62LEZYCUOQUJVVRXEZLEMVXHI2LBNRPWSZGOY2LJAKNPMNZGKZDFNZ2GSYLML52HS4DFVNHWC5LUNBAWGY3FONZQ
```
1. Open the exact URL shown
2. Click `Continue`
3. Sign in
4. Refresh the token:
   ```bash
   gh auth refresh -h github.com -s repo
   ```
   - `-h` specifies the GitHub host
   - `-s` adds specific OAuth scopes
     
Then try cloning the repo again.

---

<a id="task-2"></a>
## Task 2 - Build an SSH Key
We will generate an SSH key to securely access the virtual machines provisioned by Tofu, eliminating the need for password-based authentication.

### Generate the SSH Key
We can generate an SSH key with the following command:
```bash
ssh-keygen -t ed25519 -C "itsclass"
```
- `t` specifies the key type
- `-C` adds a comment to the key
  
**Note**: Use the default file location when prompted and give it a passphrase that you can remember.

A success will show the key's randomart image.

### Start the SSH Agent
Start the SSH agent and set the necessary environment variables:
```bash
eval $(ssh-agent -s)
```
- `eval` executes the output of the command in the current shell
- `ssh-agent -s` starts the SSH agent and outputs the environment variables

If successful, the agent PID will show:
```bash
Agent pid 2880398
```

### Add the SSH Key to the Agent
Add the generated private key to the running SSH agent:
```bash
ssh-add ~/.ssh/id_ed25519
```
- `ssh-add` loads a private key into the SSH agent
- `~/.ssh/id_ed25519` is the default private key generated earlier

This will prompt for the key's passphrase, then add it to the agent:
```bash
Identity added: /home/itsvm/.ssh/id_ed25519 (itsclass)
```

### Verify the Key is Loaded
To confirm the key was successfully added:
```bash
ssh-add -l
```
- `-l` lists the fingerprints of all loaded keys

If successful, you should see the key's fingerprint displayed.

### Start SSH Agent Automatically on Login
So that we do not have to manually start the SSH agent on every login, we can append the commands to `.bashrc`:
```bash
cat >> ~/.bashrc << 'EOF'

# Auto-start ssh-agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_ed25519
fi
EOF
```
- `cat >> ~/.bashrc` appends content to your shell configuration file
- The conditional checks whether the SSH agent is already running
- If not, it starts the agent and loads your key

---

<a id="task-3"></a>
## Task 3 - New Tofu Configurations
A `~/Cloud/ITS-4900-Cloud-Release/Deliverable_3/Task3/main.tf` file is provided for the deliverable. `main.tf` defines all the Azure resources that will be provisioned. Each component in the provided `main.tf` is outlined below.
**Note**: User-specific changes will need to be made before this `main.tf` is usable.

### Providers
#### Terraform Block
The Terraform block defines which provider should be used and the required version.
```hcl
# Specify the required provider and version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```
- `source` tells Tofu to use the official Azure provider from HashiCorp
- `version = "~> 4.0"` ensures compatibility with version 4.x

This ensures Tofu downloads and uses the correct Azure provider plugin.

#### Azure Provider Block
This block configures how Tofu connects to Azure.
```hcl
# Configure the Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "REDACTED"
}
```
- `features {}` is required by the Azure provider
- `subscription_id` specifies which Azure subscription resources will be created in. The instructor's subscription ID was provided in the file, but it will have to be changed before running.

This allows Tofu to authenticate and provision resources in the correct Azure subscription.

### Resource Group
The resource group acts as a logical container for all Azure resources created by this configuration.
```hcl
# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "its-cloud-del2b"
  location = "westus2"
}
```
This creates a resource group named `its-cloud-del2b` in `westus2`. The name should be changed to match this deliverable, and the location should be changed to one that the user has access to.

### Virtual Network
The virtual network provides isolated networking for Azure resources and is required by Azure.
```hcl
# Virtual network (required by Azure)
resource "azurerm_virtual_network" "main" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
```
**Note**: `location` and `resource_group_name` need to be consistent with the created resource group.

### Subnet
The subnet defines a smaller address range inside the virtual network and is also required by Azure.
```hcl
# Subnet (required by Azure)
resource "azurerm_subnet" "main" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
```
**Note**: `resource_group_name` and `virtual_network_name` need to match the previously created components.

### Public IP
The publice IP is very important because it allows external access to the virtual machine.
```hcl
# Public IP
resource "azurerm_public_ip" "main" {
  name                = "del01-testvm-wus2-0101"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
```
- `allocation_method = "Static"` ensures the IP does not change
- `sku = "Standard"` and `allocation_method = "Static"` are required for student Azure subscriptions
**Note**: `resource_group_name` and `location` need to match the previously created components.
  
### Network Security Group
The network security group controls inbound and outbound traffic rules. We need to open port 22 to allow us to SSH into the machine.
```hcl
# Network Security Group with SSH open
resource "azurerm_network_security_group" "main" {
  name                = "nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```
**Note**: `resource_group_name` and `location` need to match the previously created components.

### Network Interface
#### NIC Creation
The network interface connects the virtual machine to the subnet and public IP.
```hcl
# Network interface (required by Azure)
resource "azurerm_network_interface" "main" {
  name                = "nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}
```
**Note**: `location`, `resource_group_name`, `subnet_id`, and `public_ip_address_id` need to match the previously created components. 

#### Connection to Network Security Group
This connects the network security group to the network interface.
```hcl
# Connect NSG to NIC
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}
```
This ensures the SSH rule is actually applied to the VM’s network interface.
**Note**: `network_interface_id` and `network_security_group_id` need to match the previously created components. 

### Virtual Machine
This block provisions the actual virtual machine.
```hcl
# Virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                            = "del01-testvm-wus2-01"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2pts_v2"
  admin_username                  = "REDACTED"
  admin_password                  = "REDACTED"
  disable_password_authentication = false
  
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server-arm64"
    version   = "latest"
  }
}
```
**Note**: `location`, `resource_group_name`, and `network_interface_ids` need to match the previously created components.
**IMPORTANT**: the admin username and password were provided directly in the file. This is not a safe practice. This could be fixed using variables.

### Outputs
Outputs display useful information,
```hcl
output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}
```
Displays the public IP address of the VM.
```hcl
output "ssh_connection" {
  value = "ssh azureuser@${azurerm_public_ip.main.ip_address}"
}
```
Prints a ready-to-use SSH command. However, the username does not match the value of `admin_username` provided in the VM block, so this command will not work.
