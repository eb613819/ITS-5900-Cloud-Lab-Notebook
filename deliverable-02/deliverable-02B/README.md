# Deliverable 2B - Infrastructure as Code

## Objective
The purpose of this deliverable is to get OpenTofu setup on the gHost and use it to provision a VM in Azure.

---

## Table of Contents
- [Objective](#objective)
- [OpenTofu Setup](#opentofu-setup)
  - [Installation](#installation)
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

```bash
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```
- Blocks are used to group related settings and usually represent an object, like a resource. Each block has a specific type, can include labels for identification, and contains a body with arguments and other nested blocks. Most of the key features in OpenTofu are controlled through these top-level blocks in configuration files.
- Arguments are used inside blocks to assign specific values to names, defining settings for a resource or feature.
- Expressions represent values, either directly or by referencing or combining other values. These expressions are used as values for arguments or within other expressions.
