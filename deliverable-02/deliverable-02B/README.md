# Deliverable 2B - Infrastructure as Code

## Objective
The purpose of this deliverable is to get OpenTofu setup on the gHost and use it to provision a VM in Azure.

---

## Resources
These resources were used to complete this deliverable:
- [Linux Foundation OpenTofu Course](https://trainingportal.linuxfoundation.org/learn/course/getting-started-with-opentofu-lfel1009/)
- [OpenTofu Docs](https://opentofu.org/docs/)
  
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
  If everything worked, a version will show:
  ```bash
  itsvm@ITS-4900-Cloud-GNS3-015-eb613819:~$ tofu version
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

## Local Sandbox / Hello World
### Create a Working Directory
Create a directory to house the OpenTofu code:
```bash
mkdir hello_world_tofu && cd hello_world_tofu
```

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
```bash

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
```bash
Success! The configuration is valid.
```

### Generate a Plan
Next, generate a speculative execution plan. This will show the actions OpenTofu would take to apply the current configuration. It will not actually perform the actions.
```bash
tofu plan
```
```bash
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
```bash
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
ls demo.txt
```
```bash
demo.txt
```
