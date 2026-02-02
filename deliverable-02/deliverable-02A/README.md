# Deliverable 2A - Cloud Technology Stack

## Objective
The purpose of this deliverable is to evaluate multiple technology options for cloud infrastructure provisioning, orchastration, and management. The context is tools that integrate well with Azure environments. This comparison ends with a justified preferred stack choice.
There are three categories for the tools to be evaluated:
- **Resource Abstraction and Control** 
- **Service Orchestration and Configuration Management**
- **Cloud Service Management and Automation Platforms**

## Resource Abstraction and Control
This category sets up the virtual hardware in the cloud. These tools create and manage things like virtual machines, networks, storage, and firewalls. Instead of using the Azure portal or writing a script, the tool creates the infrastructure and keeps track of it.
| Tool        | Description                                                                                                      | Pros                                                              | Cons                                                                    |
| ----------- | ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------- |
| OpenTofu    | Tool for defining and creating cloud infrastructure using configuration files. Community-driven and open-source. | Fully open-source; compatible with Terraform; works across clouds | Requires managing state files; learning HCL; indirect Azure integration |
| Terraform   | Popular infrastructure tool used to create and manage cloud resources.                                           | Very mature; huge ecosystem; widely used in industry              | More restrictive license; vendor-controlled                             |
| Azure Bicep | Microsoft’s built-in language for defining Azure resources.                                                      | Native Azure support; no external state file; simple syntax       | Azure-only; less portable; tightly coupled to Microsoft                 |
| Pulumi      | Infrastructure tool that uses real programming languages instead of config files.                                | Uses Python/TypeScript/etc.; good for complex logic               | Smaller community; more complexity for simple setups                    |

## Service Orchestration and Configuration Management
This category sets up the software on the virtual machines after they exist. These tools install packages, configure services, apply system settings, and deploy applications. They make sure servers are configured the same way every time and stay that way.
| Tool      | Description                                                              | Pros                                              | Cons                                                         |
| --------- | ------------------------------------------------------------------------ | ------------------------------------------------- | ------------------------------------------------------------ |
| Ansible   | Tool that configures machines over SSH using simple YAML files.          | Easy to start; no agents needed; very readable    | Slower at large scale; weaker enforcement of long-term state |
| Puppet    | Tool that enforces system configuration using agents on each machine.    | Strong consistency; good for long-running systems | More complex; requires agents; steeper learning curve        |
| Chef      | Configuration management tool using Ruby-based scripts.                  | Very powerful; flexible                           | Requires Ruby knowledge; declining popularity                |
| SaltStack | Automation and configuration tool focused on speed and remote execution. | Fast; scalable; event-driven                      | More complex setup; smaller ecosystem                        |

## Cloud Service Management and Automation Platforms
This category provides a control panel for running and managing automation. These tools do not (usually) create infrastructure or configure servers themselves; they manage how and when those tools run and add scheduling, permissions, logging, and visibility.
| Tool                        | Description                                                                | Pros                                                         | Cons                                                 |
| --------------------------- | -------------------------------------------------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------- |
| AWX                         | Web interface and API for running and managing Ansible jobs.               | Centralized UI; role-based access; scheduling                | Requires maintenance; can add complexity             |
| Ansible Automation Platform | Enterprise version of AWX with support and extra features.                 | Enterprise-grade support; security features                  | Paid licensing; vendor lock-in                       |
| Spacelift                   | Platform that manages IaC and automation runs with policies and approvals. | Strong governance; supports multiple tools; free tier        | SaaS-focused; cost for larger account; learning curve|
| Azure Automation            | Microsoft service for running PowerShell and automation jobs.              | Native Azure integration; no extra infrastructure            | Azure-only; procedural scripts; limited IaC features |

## Preferred Stack and Justification

### Chosen Stack
- **OpenTofu** – Resource Abstraction and Control
- **Ansible** – Service Orchestration
- **Spacelift** – Infrastructure and Automation Orchestration

### Justification
#### 1. Widely Used and Well-Supported
Each tool has strong adoption in the industry and active community support:
- OpenTofu is a community-driven Terraform fork, keeping IaC open and compatible.
- Ansible is a leading configuration management and orchestration tool.
- Spacelift is a popular orchestration platform for managing multi-tool workflows.

#### 2. Open Source / Free / Non-Vendor-Locked
- OpenTofu and Ansible are fully open-source.
- Spacelift offers a free tier for small teams.
- This stack does not lock us into Azure-specific tooling and remains portable across cloud providers.

#### 3. Unified Orchestration
Spacelift can manage both OpenTofu and Ansible workflows in a single control plane, enabling:
- Coordinated infrastructure provisioning and configuration
- Policy enforcement and approvals
- Execution tracking and auditing
- Easy extension to other tools in the future
