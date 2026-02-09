# Deliverable 2B - Infrastructure as Code

## Objective
The purpose of this deliverable is to get OpenTofu setup on the gHost and use it to provision a VM in Azure.

---

## Resources
These resources were used to complete this deliverable:
- [Linux Foundation OpenTofu Course](https://trainingportal.linuxfoundation.org/learn/course/getting-started-with-opentofu-lfel1009/)
- [OpenTofu Docs](https://opentofu.org/docs/)
- [`hashicorp/azurerm` docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [`hashicorp/azurerm` `azurerm_linux_virtual_machine` docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
- [`hashicorp/azurerm` `azurerm_linux_virtual_machine` examples](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/virtual-machines/linux)

---

## Table of Contents
- [Objective](#objective)
- [Resources](#resources)
- [OpenTofu Setup](#opentofu-setup)
  - [Installation](#installation)
  - [Autocomplete](#autocomplete)
- [OpenTofu Workflow](#opentofu-workflow)
  - [Write](#write)  
  - [Plan](#plan)  
  - [Apply](#apply)  
- [OpenTofu Building Blocks](#opentofu-building-blocks)
  - [Common CLI Commands](#common-cli-commands)  
  - [The Language](#the-language)
- [Local Sandbox / Hello World](#local-sandbox-/-hello-world)
  - [Create a Working Directory](#create-a-working-directory)
  - [Create a `main.tf` File](#create-main-hello)
  - [Format the File](#format-the-file)
  - [Initialize the Working Directory](#initialize-the-working-directory)
  - [Validate the Syntax](#validate-the-syntax)
  - [Generate a Plan](#generate-a-plan)
  - [Execute the Plan](#execute-the-plan)
  - [Change the File](#change-the-file)
  - [Clean up the Resources](#clean-up-the-resources)
- [Provision a VM in Azure](#provision-a-vm-in-azure)
  - [Create a Directory](#create-a-directory)
  - [Create a `providers.tf` File](#create-providers-vm)
  - [Create a `main.tf` File](#create-main-vm)

---

## OpenTofu Setup
### Installation
These steps can be used to install OpenTofu on the gHost running Ubuntu 24.04.3 LTS.
1.) Download the installer script:
  ```bash
  curl -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
  ```
2.) Grant execute permissions and review the script:
  ```bash
  chmod +x install-opentofu.sh && less install-opentofu.sh
  ```
3.) Install using the script:
  ```bash
  ./install-opentofu.sh --install-method standalone
  ```
4.) Check that OpenTofu is installed:
  ```bash
  tofu version
  ```
  ```console
  OpenTofu v1.11.4
  on linux_amd64
  ```
5.) Remove the installer:
  ```bash
  rm -f install-opentofu.sh
  ```

### Autocomplete
OpenTofu provides tab-completion support for all command names and some command arguments.
To set up auto-completion, run the following:
```bash
tofu -install-autocomplete
```

---

## OpenTofu Workflow
### Write
Define the desired infrastructure using OpenTofu configuration files (`.tf`).  
This includes providers, resources, variables, and outputs that describe **what** infrastructure should exist, not how to create it manually.

Common tasks:
- Write or edit `.tf` configuration files
- Define variables and outputs
- Organize files into reusable modules

### Plan
Preview the changes OpenTofu will make to reach the desired state.  
This step compares the current state with the configuration and shows what will be created, modified, or destroyed **without making changes**.

Common tasks:
- Initialize the project (first run only)
- Review proposed infrastructure changes
- Catch mistakes before applying

Typical command:
```bash
tofu plan
```

### Apply
Execute the planned changes to create, update, or remove infrastructure.
OpenTofu updates the state file to reflect the real-world resources after the operation completes.

Common tasks:
- Apply reviewed changes
- Confirm or automate deployment
- Update state to match deployed infrastructure

Typical command:
```bash
tofu apply
```

---

## OpenTofu Building Blocks
OpenTofu is built around two core components: the **tofu CLI** and the **OpenTofu language**.

### Common CLI Commands
| Command | Description |
|--------|-------------|
| `tofu -h` | Display the OpenTofu help |
| `tofu init` | Initialize the working directory with configuration files |
| `tofu plan` | Generate and display an execution plan for changes |
| `tofu apply` | Apply the changes required to reach the desired state |
| `tofu destroy` | Destroy all resources managed by the configuration |
| `tofu fmt` | Format configuration files for consistency |
| `tofu validate` | Validate the syntax and integrity of configuration files |
| `tofu state list` | List all resources in the current state |
| `tofu state show <resource>` | Show detailed information about a specific resource |
| `tofu workspace new <name>` | Create a new workspace for managing separate environments |
| `tofu workspace select <name>` | Switch to a different workspace |
| `tofu import <resource> <id>` | Import an existing resource into Tofu's state management |


### The Language
The syntax of the OpenTofu language consists of a few basic elements:

```hcl
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```
- Blocks are used to group related settings and usually represent an object, like a resource. Each block has a specific type, can include labels for identification, and contains a body with arguments and other nested blocks. Most of the key features in OpenTofu are controlled through these top-level blocks in configuration files.
- Arguments are used inside blocks to assign specific values to names, defining settings for a resource or feature.
- Expressions represent values, either directly or by referencing or combining other values. These expressions are used as values for arguments or within other expressions.

---

## Local Sandbox / Hello World
### Create a Working Directory
Create a directory to house the OpenTofu code:
```bash
mkdir hello_world_tofu && cd hello_world_tofu
```

<a id="create-main-hello"></a>
### Create a `main.tf` File
In the OpenTofu language, we declare resources representing infrastructure as objects. Create a file `main.tf` with the contents below. This code will create a resource (a file named `demo.txt`) with the contents mentioned.
```hcl
resource "local_file" "hello_world" {
  filename = "${path.module}/demo.txt"

  content = <<-EOF
    Hello World!
    Welcome to OpenTofu!
  EOF
}
```

### Format the File
The OpenTofu CLI provides commands to make code easier to work with. We can format the code by running:
```bash
tofu fmt
```

### Initialize the Working Directory
After writing the code, the first step is to initialize an OpenTofu working directory. This creates initial files, loads remote state, downloads modules, etc. This is the first command that should be run:
```bash
tofu init
```
and it will output something like:
```console

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Installing hashicorp/local v2.6.2...
- Installed hashicorp/local v2.6.2 (signed, key ID 0C0AF313E5FD9F80)

Providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://opentofu.org/docs/cli/plugins/signing/

OpenTofu has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that OpenTofu can guarantee to make the same selections by default when
you run "tofu init" in the future.

OpenTofu has been successfully initialized!

You may now begin working with OpenTofu. Try running "tofu plan" to see
any changes that are required for your infrastructure. All OpenTofu commands
should now work.

If you ever set or change modules or backend configuration for OpenTofu,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Validate the Syntax
Optionally, we can validate the syntax and arguments of the configuration files present in the directory:
```bash
tofu validate
```
If everything is ok it will output something like:
```console
Success! The configuration is valid.
```

### Generate a Plan
Next, generate a speculative execution plan. This will show the actions OpenTofu would take to apply the current configuration. It will not actually perform the actions.
```bash
tofu plan
```
```console
OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

OpenTofu will perform the following actions:

  # local_file.hello_world will be created
  + resource "local_file" "hello_world" {
      + content              = <<-EOT
            Hello World!
            Welcome to OpenTofu!
        EOT
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./demo.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so OpenTofu can't guarantee to take exactly these actions if you run "tofu
apply" now.
```

### Execute the Plan
We can execute the plan, which will create or update existing infrastructure, with the following command:
```bash
tofu apply
```
```console
OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

OpenTofu will perform the following actions:

  # local_file.hello_world will be created
  + resource "local_file" "hello_world" {
      + content              = <<-EOT
            Hello World!
            Welcome to OpenTofu!
        EOT
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./demo.txt"
      + id                   = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  OpenTofu will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

local_file.hello_world: Creating...
local_file.hello_world: Creation complete after 0s [id=7b53eb297df671746dc3a9f64317b8f047d4da64]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
We can check that the file was created:
```bash
ls demo.txt && cat demo.txt
```
```console
demo.txt
Hello World!
Welcome to OpenTofu!
```

### Change the File
We can change the contents of `demo.txt` to something like:
```hcl
resource "local_file" "hello_world" {
  filename = "${path.module}/demo.txt"

  content = <<-EOF
    Hello World!
    I changed the contents of this file!
  EOF
}
```
Then run these commands to plan and apply the changes:
```bash
tofu plan
tofu apply
```

### Clean up the Resources
We can clean up and destroy the resource created:
```bash
tofu destroy
```
```console
local_file.hello_world: Refreshing state... [id=7b53eb297df671746dc3a9f64317b8f047d4da64]

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  - destroy

OpenTofu will perform the following actions:

  # local_file.hello_world will be destroyed
  - resource "local_file" "hello_world" {
      - content              = <<-EOT
            Hello World!
            Welcome to OpenTofu!
        EOT -> null
      - content_base64sha256 = "WyXqhEWD5Vgv4QpSIV9AyAE1xKMuY5zeKZ25TSDAsus=" -> null
      - content_base64sha512 = "tEe6G0kHw1M03wfKXwY+6tIzX0TexFAHyNtoVGwUoP7woMjEs/yvWfV5zGM0hU9RTzMEu7lE749amL7zv/J5sw==" -> null
      - content_md5          = "2feecba9d8d2c08da8921b6320e4700d" -> null
      - content_sha1         = "7b53eb297df671746dc3a9f64317b8f047d4da64" -> null
      - content_sha256       = "5b25ea844583e5582fe10a52215f40c80135c4a32e639cde299db94d20c0b2eb" -> null
      - content_sha512       = "b447ba1b4907c35334df07ca5f063eead2335f44dec45007c8db68546c14a0fef0a0c8c4b3fcaf59f579cc6334854f514f3304bbb944ef8f5a98bef3bff279b3" -> null
      - directory_permission = "0777" -> null
      - file_permission      = "0777" -> null
      - filename             = "./demo.txt" -> null
      - id                   = "7b53eb297df671746dc3a9f64317b8f047d4da64" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  OpenTofu will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

local_file.hello_world: Destroying... [id=7b53eb297df671746dc3a9f64317b8f047d4da64]
local_file.hello_world: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
```
We can check that it worked:
```bash
ls demo.txt && cat demo.txt
```
```console
ls: cannot access 'demo.txt': No such file or directory
```

---

## Provision a VM in Azure
### Create a Directory
This directory will contain all OpenTofu configuration files for this deployment so the infrastructure can be managed and destroyed as a single unit.
```bash
mkdir tofu_azure_del03 && cd tofu_azure_del03
```

<a id="create-providers-vm"></a>
### Create a `providers.tf` File
When creating a resource using Azure, we need to specify our providers. This can optionally be done directly in `main.tf`. We will use the hashicorp provider, since that is from Terraform and is reasonably trustworthy.
Create a `providers.tf` with the following code:
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
}

provider "azurerm" {
  features {}
}
```
Docs on the provider `hashicorp/azurerm` can be found [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

<a id="create-main-vm"></a>
### Create a `main.tf` File
The file `main.tf` will have the information about the resources we want to create. Many pieces need to be created to provision a VM. Each piece is outlined below. [This example](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/examples/virtual-machines/linux/basic-password/main.tf) was used to make the code.

#### A.) Resource Group
This code will create a new `azurerm_resource_group` for the VM. The resource group acts as a logical container for all Azure resources created by this configuration, allowing them to be managed and deleted together.
```hcl
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}
```

#### B.) Public IP
This code will create a public IP for the VM. A public IP address is required to allow external access to the virtual machine, such as SSH connections from outside Azure.
```hcl
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pub-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
}
```

#### C.) Virtual Network
This code will create a new `azurerm_virtual_network` for the VM. The virtual network provides isolated networking for the VM and defines the address space in which subnets and resources can be created.
```hcl
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
```

#### D.) Subnet
This code will create a new `azurerm_subnet` for the VM. The subnet divides the virtual network into a smaller address range where the virtual machine’s network interface will reside.
```hcl
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
```

#### E.) Network Interface (NIC)
This code will create a new `azurerm_network_interface` for the VM. The network interface connects the virtual machine to the subnet and associates it with both private and public IP addresses.
```hcl
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}
```

#### F.) Virtual Machine (VM)
This code will create the actual VM. This resource defines the compute instance itself, including the operating system image, VM size, authentication method, and attached network interface.
```hcl
resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2ats_v2"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "24_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
```

#### G.) Network Security Group
The network security group controls inbound and outbound traffic rules and is used here to explicitly allow SSH access on port 22.
```hcl
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
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

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.main.id
}
```

<a id="create-variables-vm"></a>
### Create a `variables.tf` File
The `variables.tf` will hold the variables used in `main.tf`. **Note**: mark the credentials as `sensitive` to keep them from being displayed in logs or CLI output.  [This example](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/examples/virtual-machines/linux/basic-password/variables.tf) was used to create the code.

```hcl
variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
  default     = "del03A-"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
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
```
