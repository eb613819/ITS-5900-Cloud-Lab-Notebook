# Deliverable 1 - Tooling, Azure Setup, and Initial VM Deployment

## Objective
The purpose of this deliverable is to select and document the development tools used for this course, configure the Azure development environment on the gHost, and deploy a basic virtual server using Azure CLI.

---

## Task 1 - Select Tools

### Large Language Model (LLM)
**Selected LLM**: ChatGPT (Free Tier)  
**Justification**: I do not expect to use an LLM for this course, but if I do I will use ChatGPT. This is the only LLM I have experience with. If for some reason ChatGPT does not meet my needs, I will switch to the instructor recommendation (Claude).

### Programming Language
**Selected Language**: Python  
**Justification**: Python is widely used in cloud automation and scripting. I also taught a Python programming course last semester, so I am very familiar with it. And, this way I will be on the same page as the instructor.

### Software Development Environment
**Selected Environment**: Visual Studio Code (VSCode)  
**Justification**: VSCode supports tight integration with Azure tooling, powershell, and GitHub. Plus, using it will keep me on the same page as the instructor.

### Development Venue
**Selected Venue**: GNS3 gHost  
**Justification**: The gHost is a blank slate to develop on, which will make identifying and resolving issues more straightforward. This venue also provides support from the instructor.

### Free Azure Student Account
**Login Info**: OHIO Credentials (eb613819@ohio.edu)
- $100 credit verified.
- Azure Portal accessed.

---

## Task 2 - VSCode Development Environment Setup
- Installed the `Azure App Service` extension in VSCode by following unit 3 of [this guide](https://learn.microsoft.com/en-us/training/modules/prepare-your-dev-environment-for-azure-development/3-exercise-set-up-dev-environment?pivots=vscode).
- Signed in to Azure by clicking the `A` icon in the left toolbar -> `Sign in toAzure...`.
  ![azure_extension](./images/Azure-Extension.png)
- Azure Resources are visable in the extension:
  ![azure_resources](./images/Azure-Resources.png)

---

## Task 3 - Setup Powershell
**Note**: the gHost is running Ubuntu

### PowerShell Install
Installed PowerShell by doing the following:
- Update `apt-get`:
  ```bash
  sudo apt-get update
  ```
- Install prerequisite packages:
  ```bash
  sudo apt-get install -y wget apt-transport-https software-properties-common
  ```
- Set Ubuntu `$VERSION_ID` variable:
  ```bash
  source /etc/os-release
  ```
- Download the Microsoft repository keys:
  ```bash
  wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
  ```
- Register the Microsoft repository keys:
  ```bash
  sudo dpkg -i packages-microsoft-prod.deb
  ```
- Delete the Microsoft repository keys file:
  ```bash
  rm packages-microsoft-prod.deb
  ```
- Update the list of packages after adding the Microsoft repository:
  ```bash
  sudo apt-get update
  ```
- Install PowerShell:
  ```bash
  sudo apt-get install -y powershell
  ```
- Start PowerShell:
  ```bash
  pwsh
  ```
### Az Powershell Module Install
Installed the Az PowerShell module by doing the following:
- Launch PowerShell:
  ```bash
  pwsh
  ```
- Install the Az PowerShell Module:
  ```powershell
  Install-Module -Name Az -Scope CurrentUser -Repository PSGallery
  ```
- Confirm it's ok to install from an untrusted repository:
  ```bash
  Y
  ```

### Connect to Azure
- Connected to Azure by running:
  ```bash
  Connect-AzAccount
  ```
  Then signing in using the pop-up window.
- Select the `Azure for Students` subscription

### Changing Subscription
- Active subscription can be checked by running:
  ```bash
  Get-AzContext
  ```
- A list of subscriptions can be shown by running (this will show Subscription ID):
  ```bash
  Get-AzSubscription
  ```
- The active subscription can be changed by running:
  ```bash
  Set-AzContext -Subscription '00000000-0000-0000-0000-000000000000'
  ```

### Find Allowed Resource Deployment Regions
I found allowed resource regions by going to:  
`Policy` -> `Assignments` -> `Allowed resource deployment regions`  
This is what it said:  
`["northcentralus","westus3","eastus2","southcentralus","mexicocentral"]`

### Create a Resource Group
Created a Resource Group for this class by running:
```bash
New-AzResourceGroup -Name ITS-Cloud-Systems -Location eastus2
```

### Future Use
To reload Powershell and Login to Azure in the future:
```bash
pwsh
Connect-AzAccount
```
  
