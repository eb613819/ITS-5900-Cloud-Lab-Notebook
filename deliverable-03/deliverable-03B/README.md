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
   - [Testing the Code](#testing-the-code)
      - [Update Subscription ID](#update-subscription-id)
      - [Update Location](#update-location)
      - [Format File](#format-file)
      - [Initialize the Working Directory](#initialize-the-working-directory)
      - [Validate File](#validate-file)
      - [Generate and Execute Plan](#generate-and-execute-plan)
      - [SSH Into VM](#ssh-into-vm)
      - [Cleanup Resources](#cleanup-resources)
- [Task 4 - Ansible Initialization](#task-4)
   - [Install Ansible](#install-ansible)
   - [Test the Ansible Configuration](#test-the-ansible-configuration)
      - [Move to Task 4 Folder](#move-to-task-4-folder)
      - [Run the Test Playbook](#run-the-test-playbook)
   - [Identify Programming Concepts](#identify-programming-concepts)
      - [Variables](#variables)
      - [Variable Manipulation](#variable-manipulation)
      - [Conditional Statements](#conditional-statements)
      - [Proposed Looping Task](#proposed-looping-task)
- [Task 5 - Automation From Start to Finish](#task-5)
   - [Project Structure](#project-structure)
   - [Update File Values](#update-file-values)
      - [Load SSH Key](#load-ssh-key)
      - [Load Subscription ID](#load-subscription-id)
      - [Change Location](#change-location)
   - [Infrastructure Provisioning](#infrastructure-provisioning)
      - [`variables-account.tf`](#variables-accounttf)
      - [`variables-project.tf`](#variables-projecttf)
      - [`main.tf`](#maintf)
      - [Provision the Infrastructure](#provision-the-infrastructure)
   - [Infrastructure Configuring](#infrastructure-configuring)
      - [`inventory.yml`](#inventoryyml)
      - [`configuration.yml`](#configurationyml)
      - [Configure the Infrastructure](#configure-the-infrastructure)
   - [Accessing the Provisioned and Configured Infrastructure](#accessing-the-provisioned-and-configured-infrastructure)
      - [Allow HTTP Access](#allow-http-access)
      - [Access the Web Server](#access-the-web-server)
      - [Improve Security](#improve-security)
   - [Clean Up](#clean-up)
     
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
The first two blocks of `main.tf` describe the provider Tofu should use. Optionally, this could be moved to a `providers.tf` file.

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
**IMPORTANT**: the admin username and password were provided directly in the file. This is not a safe practice. One way to fix this is using variables that the user is prompted for at runtime.

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

### Testing the Code
I performed the following steps to test the provided `main.tf` file.

#### Update Subscription ID
A subscription ID was provided in the file that did not match my subscription. I removed the `subscription_id` option from the `provider` block, since OpenTofu’s AzureRM provider authenticates using the Azure CLI and I am already logged in with the correct subscription selected. I checked using the following command:
```bash
az account show
```

#### Update Location
My student subscription does not have access to `westus2` so I changed the location to `northcentralus`.

#### Format File
I formatted `main.tf` using the following command:
```bash
tofu fmt
```

#### Initialize the Working Directory
I initialized `~/Cloud/ITS-4900-CloudRelease/Deliverable_3/Task_3` as a Tofu working directory by running:
```bash
tofu init
```

#### Validate File
I validated the syntax of `main.tf` using:
```bash
tofu validate
```

#### Generate and Execute Plan
I generated a speculative plan using:
```bash
tofu plan
```
Everything looked good so I executed using:
```bash
tofu apply
```
Which output:
```console
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Still creating... [10s elapsed]
azurerm_resource_group.main: Still creating... [20s elapsed]
azurerm_resource_group.main: Creation complete after 22s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b]
azurerm_network_security_group.main: Creating...
azurerm_public_ip.main: Creating...
azurerm_virtual_network.main: Creating...
azurerm_network_security_group.main: Creation complete after 2s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Network/networkSecurityGroups/nsg]
azurerm_public_ip.main: Creation complete after 2s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Network/publicIPAddresses/del01-testvm-wus2-0101]
azurerm_virtual_network.main: Creation complete after 5s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Network/virtualNetworks/vnet]
azurerm_subnet.main: Creating...
azurerm_subnet.main: Creation complete after 4s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet]
azurerm_network_interface.main: Creating...
azurerm_network_interface.main: Creation complete after 2s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Network/networkInterfaces/nic]
azurerm_network_interface_security_group_association.main: Creating...
azurerm_linux_virtual_machine.main: Creating...
azurerm_network_interface_security_group_association.main: Creation complete after 4s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Network/networkInterfaces/nic|/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Network/networkSecurityGroups/nsg]
azurerm_linux_virtual_machine.main: Still creating... [10s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [20s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [30s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [40s elapsed]
azurerm_linux_virtual_machine.main: Still creating... [50s elapsed]
azurerm_linux_virtual_machine.main: Creation complete after 51s [id=/subscriptions/789db197-194a-4cca-9770-b4018ed723a8/resourceGroups/its-cloud-del2b/providers/Microsoft.Compute/virtualMachines/del01-testvm-wus2-01]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

public_ip_address = "REDACTED"
ssh_connection = "ssh azureuser@REDACTED"
```

#### SSH Into VM:
First, I tried to SSH using the output command:
```bash
ssh azureuser@REDACTED
```
As expected, this did not work since `azureuser` was not the `admin_username` provided. After using the provided username, I was able to connect over SSH.
```console
REDACTED@del01-testvm-wus2-01:~$
```
**Note**: I did not update the names of the resources when I changed the location, which is why the machine is called `del01-testvm-wus2-01` even though it is in `northcentralus`. Changing the names would be much simpler if we used a variable for the names:
```hcl
   name                            = "${var.prefix}-vm"
```

#### Cleanup Resources
I destroyed all created resources using the following command.
```bash
tofu destroy
```

---

<a id="task-4"></a>
## Task 4 - Ansible Initialization
### Install Ansible
When installing software on the gHost, we want to be careful to not run full system updates; that can make them unstable and force instructors to reset the gHost to a known good state. We can safely install Ansible on the gHost with the following command:
```bash
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible software-properties-common python-is-python3 python3-pip python3-tabulate python3-lxml

pip install pydantic==1.9 --break-system-packages
```

### Test the Ansible Configuration
After installing Ansible, we want to test that it works. `~/Cloud/ITS-4900-Cloud-Release/Deliverable_3/Task_4/` has an Ansible playbook we can test.

#### Move to Task 4 Folder
```bash
cd `~/Cloud/ITS-4900-Cloud-Release/Deliverable_3/Task_4/`
```

#### Run the Test Playbook
Ansible playbooks are run using `ansible-playbook`. The test playbook is called `azure-subscription-info.yml`. We can run it using the following command. **Note**: Ansible has a three-level verbosity switch: `-v`, `-vv`, or `-vvv` that can be helpful for debugging.
```bash
ansible-playbook azure-subscription-info.yml
```
This playbook runs locally and:
- Verifies that the Azure CLI is installed.
- Retrieves and displays the currently active Azure subscription (name, ID, and tenant ID).
- Checks Azure Policy assignments to determine if the subscription has restricted/allowed regions.
- Prints the list of policy-allowed regions if found, or warns if no location restrictions are detected.

After running the playbook, it will output something like:
```console
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Azure subscription and regions info] ****************************************************************************

TASK [Check Azure CLI is installed] ***********************************************************************************
changed: [localhost]

TASK [Fail if Azure CLI not found] ************************************************************************************
skipping: [localhost]

TASK [Get current subscription] ***************************************************************************************
changed: [localhost]

TASK [Parse subscription JSON] ****************************************************************************************
ok: [localhost]

TASK [Print subscription summary] *************************************************************************************
ok: [localhost] => {
    "msg": [
        "Subscription Name: Azure for Students",
        "Subscription ID: REDACTED",
        "Tenant ID: REDACTED"
    ]
}

TASK [Get allowed locations from Azure policy assignments] ************************************************************
changed: [localhost]

TASK [Parse allowed locations from policy] ****************************************************************************
ok: [localhost]

TASK [Print policy-restricted regions for this subscription] **********************************************************
ok: [localhost] => {
    "msg": "Policy-allowed regions (1): ['northcentralus', 'westus3', 'eastus2', 'southcentralus', 'mexicocentral']"
}

TASK [Warn if no policy location restrictions found] ******************************************************************
skipping: [localhost]

PLAY RECAP ************************************************************************************************************
localhost                  : ok=7    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
```

### Identify Programming Concepts
#### Variables
This playbook stores output in variables using the `register` option. Variables set in this way include `az_check`, `subscription_raw`, and `policy_raw`.
For example, here is where `az_check` is set:
```yaml
   - name: Check Azure CLI is installed
      ansible.builtin.command:
        cmd: az --version
      register: az_check
      ignore_errors: true
```
The playbook also uses `set_fact` to create variables like `subscription` and `allowed_regions`. For example, here is where `subscription` is set:
```yaml
   - name: Parse subscription JSON
      ansible.builtin.set_fact:
        subscription: "{{ subscription_raw.stdout | from_json }}"
```

#### Variable Manipulation
This playbook uses variable manipulation to transform and process data using Jinja2 filters. For example:
- Parsing JSON:
  ```yaml
  subscription: "{{ subscription_raw.stdout | from_json }}"
  ```
- Handling missing values:
  ```yaml
  {{ subscription.name | default('N/A') }}
  ```
- Processing lists:
  ```yaml
  {{ allowed_regions | join(', ') }}
  ```

#### Conditional Statements
This playbook uses the conditional statement `when` to control task execution. For example:
- Fail if Azure CLI is missing:
  ```yaml
  when: az_check.rc != 0
  ```
- Only parse the policy data if the command succeeded:
  ```yaml
  when: policy_raw.rc == 0 and policy_raw.stdout | length > 0
  ```
- Print messages based on whether regions were found:
  ```yaml
  when: allowed_regions is defined and allowed_regions | length > 0
  ```
  AND
  ```yaml
  when: allowed_regions is not defined or allowed_regions | length == 0
  ```

#### Proposed Looping Task
I propose we loop through the `allowed_regions` array and print them individually to make them more readable. This can be done with the `loop` option. Here is the updated `Print policy-restricted regions for this subscription` task:
```yaml
    - name: Print policy-restricted regions for this subscription
      ansible.builtin.debug:
        msg: "Policy-allowed region: {{ item }}"
      loop: "{{ allowed_regions }}"
      when: allowed_regions is defined and allowed_regions | length > 0
```
**Note**: for the loop to work, we will have to flatten `allowed_regions` when it is parsed since it is actually a nested list:
```yaml
ansible.builtin.set_fact:
        allowed_regions: "{{ policy_raw.stdout | from_json | flatten }}"
```

This task outputs the following:
```console
TASK [Print policy-restricted regions for this subscription] **********************************************************
ok: [localhost] => (item=northcentralus) => {
    "msg": "Policy-allowed region: northcentralus"
}
ok: [localhost] => (item=westus3) => {
    "msg": "Policy-allowed region: westus3"
}
ok: [localhost] => (item=eastus2) => {
    "msg": "Policy-allowed region: eastus2"
}
ok: [localhost] => (item=southcentralus) => {
    "msg": "Policy-allowed region: southcentralus"
}
ok: [localhost] => (item=mexicocentral) => {
    "msg": "Policy-allowed region: mexicocentral"
}
```

---

<a id="task-5"></a>
## Task 5 - Automation From Start to Finish
A partial Tofu/Ansible project was provided in `Deliverable_3/Task_5`. We need to complete the project and personalize the files with out user-specific details.

### Project Structure
The provided project is structured as follows:
```bash
~/Cloud/ITS-4900-Cloud-Release/
└── Deliverable_3
    └── Task_4
        ├── account.auto.tfvars
        ├── ansible.cfg
        ├── configuration.yml
        ├── main.tf
        ├── project.auto.tfvars
        ├── variables-account.tf
        ├── variables-project.tf
        └── .gitignore
```
- **`account.auto.tfvars`** _(OpenTofu)_ – An automatically loaded variable definition file that provides values for variables declared in `variables-account.tf`. The variable names in this file must match the corresponding variable declarations in `variables-account.tf`. Files ending in `.auto.tfvars` are automatically loaded during `tofu plan` and `tofu apply` without needing to specify them on the command line. [Reference Docs](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
- **`ansible.cfg`** _(Ansible)_ – The main Ansible configuration file that controls default execution behavior, including inventory location, connection settings, privilege escalation options, and other runtime configurations. [Reference Docs](https://docs.ansible.com/projects/ansible/latest/reference_appendices/config.html)
- **`configuration.yml`** _(Ansible)_ – An Ansible playbook that defines automation tasks to configure systems after infrastructure provisioning. [Reference docs](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_intro.html)
- **`main.tf`** _(OpenTofu)_ – The primary infrastructure configuration file that defines Azure resources (such as resource groups, networking components, and virtual machines) to be created and managed.
- **`project.auto.tfvars`** _(OpenTofu)_ – An automatically loaded variable definition file that supplies values for variables declared in `variables-project.tf`. The variable names must match those defined in `variables-project.tf`. This allows environment-specific configuration without modifying the core infrastructure code. [Reference Docs](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
- **`variables-account.tf`** _(OpenTofu)_ – A variable declaration file that defines account-related input variables. These variables must be assigned values through `.tfvars` files, environment variables, or CLI arguments before deployment. [Reference Docs](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
- **`variables-project.tf`** _(OpenTofu)_ – A variable declaration file that defines project-level input variables. These variables must be assigned values through `.tfvars` files, environment variables, or CLI arguments before deployment. [Reference Docs](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)
- **`.gitignore`** _(Git)_ – A Git configuration file that specifies which files and directories should not be tracked or committed to version control.

### Update File Values
We must update the values in the provided files to match our user account subscription.

#### Load SSH Key
The following command will load the SSH key generated earlier, `id_ed25519.pub`, into `account.auto.tfvars`:
```bash
sed -i "s|admin_ssh_public_key = \".*\"|admin_ssh_public_key = \"$(cat ~/.ssh/id_ed25519.pub)\"|" account.auto.tfvars
```

#### Load Subscription ID
The following command will load the subscription ID from Azure CLI into `account.auto.tfvars`:
```bash
sed -i "s|subscription_id.*=.*|subscription_id      = \"$(az account show --query id -o tsv)\"|" account.auto.tfvars
```

#### Change Location
We must manually change the `location` value in `account.auto.tfvars` to a region compatible with out Azure account. I chose `northcentralus`.

### Infrastucture Provisioning
The provided OpenTofu files will create Azure infrastructure. We can understand what will be created by inspecting the files.

#### `variables-account.tf`
This file declares variables related to the account that are given values by `account.auto.tfvars` and used in `main.tf`:
- `subscription_id`
- `location`
- `admin_username`
- `admin_ssh_public_key`

#### `variables-project.tf`
This file declares variables related to the project that are given values by `project.auto.tfvars` and used in `main.tf`:
- `resource_group_name`
- `vm_name`
- `vm_size`
- `vnet_address_space`
- `subnet_address_prefix`
- `environment`
- `ansible_group`

#### `main.tf` 
This file describes what resources will be created:
- Azure Resource Group
- Virtual Network
- Subnet
- Public IP - static and standard SKU (required for student subscription)
- Network Security Group (NSG) - with SSH port open
- Network Interface (NIC)
- NSG-toNIC Connection
- Linux Virtual Machine

This file also generates local automation resources:
- **Ansible Inventory File** (`inventory.yml`) - A YAML inventory file containing:
   - The VM’s public IP
   - The configured admin username
   - Python interpreter path
   - Ansible group name
- **SSH Readiness Wait Task** - A local script that:
   - Waits up to 5 minutes for SSH to become available
   - Prevents Ansible from failing due to early connection attempts

This file also generates output after deployment:
- Public IP address
- SSH connection command
- Resource group name
- Assigned Ansible group name
- Path to the generated Ansible inventory file
- Ansible usage note
- Web URL using the VM's FQDN

#### Provision the Infrastructure
We can create the infrastructure by first initializing `/Task_5`as a working directory:
```bash
cd ~/Cloud/ITS-4900-Cloud-Release/Deliverable_3/Task_5
tofu init
```
Then inspecting a speculative plan:
```bash
tofu plan
```
Then executing the plan:
```bash
tofu execute
```
If everything works, the infrastructure will be created and the outputs will be printed:
```console
ansible_group = "webservers"
ansible_inventory_file = "./inventory.yml"
ansible_inventory_note = "Use 'ansible-playbook -i ./inventory.yml configuration.yml' to run playbooks"
public_ip_address = "20.25.210.242"
resource_group_name = "ITS-Cloud-Systems"
ssh_connection = "ssh itsclass@20.25.210.242"
web_url = "http://del0305-testvm-01.northcentralus.cloudapp.azure.com"
```

### Infrastructure Configuring
The provided and generated Ansible files will create Azure infrastructure. We can understand what will be created by inspecting the files.

#### `inventory.yml`
This is an Ansible inventory file generated by OpenTofu that defines which hosts Ansible should manage and how to connect to them:
```yaml
"all":
  "children":
    "webservers":
      "hosts":
        "20.25.210.242":
          "ansible_python_interpreter": "/usr/bin/python3"
          "ansible_user": "itsclass"
```
- `all` – The top-level group that includes every host in the inventory.
- `children` – Defines subgroups under all.
- `webservers` – A group name (in this case, for web server hosts).
- `hosts` – Lists the individual machines in that group.
- `20.25.210.242` – The public IP address of the target VM Ansible will connect to.
- `ansible_user: "itsclass"` – The SSH username Ansible will use to log in.
- `ansible_python_interpreter: "/usr/bin/python3"` – Tells Ansible which Python interpreter to use on the remote machine (required for many modules).

We can see the structure better by running the following Ansible command:
```bash
ansible-inventory -i inventory.yml --graph
```
```console
@all:
  |--@ungrouped:
  |--@webservers:
  |  |--20.25.210.242
```

We can test the connection to the webserver using the following Ansible command:
```bash
ansible -i inventory.yml webservers -m ping
```
```console
20.25.210.242 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

#### `configuration.yml`
This is an Ansible playbook that installs and configures NGINX on a target server and deploys a simple web page displaying the server’s hostname. This is the play definition:
```yaml
- name: Configure the Server
  hosts: all
  become: true
```
- `name` – Describes what the play does.
- `hosts: all` – Runs against all hosts defined in the inventory.
- `become: true` – Uses privilege escalation (sudo) to perform administrative tasks.

The first task installs NGINX:
```yaml
  tasks:
    - name: Update apt cache and install NGINX
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true
```
The second task starts NGINX and enables it at boot:
```yaml
    - name: Ensure NGINX is started and enabled at boot
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```
The third task deploys an `index.html` with the server hostname:
```yaml
    - name: Deploy index.html with server hostname
      ansible.builtin.copy:
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: "0644"
        content: |
          <!DOCTYPE html>
          <html>
            <head><title>{{ ansible_facts["hostname"] }}</title></head>
            <body>
              <h1>{{ ansible_facts["hostname"] }}</h1>
            </body>
          </html>
```

#### Configure the Infrastructure
We can configure the infrastructure by running the playbook:
```bash
ansible-playbook -i inventory.yml configuration.yml
```
If everything works, it will output something like this:
```console
PLAY [Configure the Server] *******************************************************************************************

TASK [Gathering Facts] ************************************************************************************************
ok: [20.25.210.242]

TASK [Update apt cache and install NGINX] *****************************************************************************
changed: [20.25.210.242]

TASK [Ensure NGINX is started and enabled at boot] ********************************************************************
ok: [20.25.210.242]

TASK [Deploy index.html with server hostname] *************************************************************************
changed: [20.25.210.242]

PLAY RECAP ************************************************************************************************************
20.25.210.242              : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Now a webserver is running on the VM and a web page is hosted on the VM's public IP address.

### Accessing the Provisioned and Configured Infrastructure
The web page is currently hosted on the public IP address of the VM, but it is not accessible:
```bash
curl -I http://20.25.210.242
```
```console
curl: (28) Failed to connect to 20.25.210.242 port 80 after 133944 ms: Couldn't connect to server
```
This is because we only opened the SSH port, and not the HTTP port.

#### Allow HTTP Access
We can allow HTTP access by adding a new `security_rule` to `azurerm_network_security_group` in `main.tf` that opens port 80 (HTTP). **Note**: each rule needs a unique priority (lower numbers are evaluated first).
```hcl
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
```
Then we can apply these changes:
```bash
tofu plan
tofu apply
```

#### Access the Web Server
Now that port 80 is allowing inbound traffic, we can access the hosted web page:
```bash
curl -I http://20.25.210.242
```
```console
HTTP/1.1 200 OK
Server: nginx/1.24.0 (Ubuntu)
Date: Mon, 23 Feb 2026 09:50:58 GMT
Content-Type: text/html
Content-Length: 129
Last-Modified: Mon, 23 Feb 2026 09:29:38 GMT
Connection: keep-alive
ETag: "699c1e02-81"
Accept-Ranges: bytes
```

#### Improve Security
We can improve SSH security by limiting access to Ohio University and home residence IP ranges:
```hcl
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = [
      "132.235.0.0/16",   # Ohio University
      "64.247.64.0/18",   # Ohio University
      "75.188.104.149/32" # Home
    ]
    destination_address_prefix = "*"
  }
```

### Clean Up
We can clean up all created resources using:
```bash
tofu destroy
```
