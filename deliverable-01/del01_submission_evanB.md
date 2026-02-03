# Deliverable 1 - Tooling, Azure Setup, and Initial VM Deployment

## Objective
The purpose of this deliverable is to select and document the development tools used for this course, configure the Azure development environment on the gHost, and deploy a basic virtual server using Azure CLI.

## Tools/Environment

### Large Language Model (LLM)
**Selected LLM**: ChatGPT (Free Tier)  
**Justification**: I do not expect to rely heavily on an LLM for this course, but if one is needed I will use ChatGPT. This is the LLM I have experience with and I do not want to introduce friction by switching tools when not necessary.


### Programming Language
**Selected Language**: Python and PowerShell  
**Justification**: Python will be used for data processing and orchestration. I have taught a Python programming course, so I am very familiar with it. And, this way I will be on the same page as the instructor. PowerShell will be used for interacting directly with Azure, since it has native support and tight integration with Azure services.


### Software Development Environment
**Selected Environment**: Visual Studio Code (VSCode)  
**Justification**: VSCode supports tight integration with Azure tooling, powershell, and GitHub. Plus, using it will keep me on the same page as the instructor.


### Development Venue
**Selected Venue**: GNS3 gHost  
**Justification**: The gHost is a blank slate to develop on, which will make identifying and resolving issues more straightforward. This venue also provides support from the instructor.


### Free Azure Student Account
**Login Info**: Azure for Students via OHIO credentials
- $100 credit verified.
- Azure Portal accessed.

## Deploying a VM
### The Configuration
The following is the configuration for deploying the server:
```powershell
$azVmParams = @{
    ResourceGroupName   = 'ITS-Cloud-Systems'
    Name                = 'del01-testvm-ncus-01'
    Credential          = (Get-Credential)
    Location            = 'northcentralus'
    Image               = 'Canonical:ubuntu-24_04-lts:server:latest'
    Size                = 'Standard_B2ats_v2'
    OpenPorts           = 22
    PublicIpAddressName = 'del01-testvm-ncus-0101'
}
```

Where 
- **`ResourceGroupName`** must match the [Resource Group](#create-a-resource-group) created earlier
- **`Name`** is just a name I chose that stands for `deliverable01-testvm-northcentralus-01`
- **`(Get-Credential)`** runs the PS command `Get-Credential` which prompts the user for input and then places the responses into the variable to be used later in the process. **Note**: the password must be between 6-72 characters long and must satisfy at least 3 of password complexity requirements from the following:
1) Contains an uppercase character                                           
2) Contains a lowercase character                                            
3) Contains a numeric digit                                                  
4) Contains a special character                                              
5) Control characters are not allowed
- **`Location`** is the [region](#choose-a-region) chosen earlier
- **`Image`** is the [image](#choose-an-image) chosen earlier
-  **`Size`** is the [size](#choose-a-vm-size) chosen earlier
-  **`OpenPorts`** is the ports to leave open
-  **`PublicIpAddressName`** is the name of the IP Address


### Execute the configuration
The following command executes the [configuration](#the-configuration):
```powershell
New-AzVm @azVmParams
```

The command will return this with the previous [configuration](#the-configuration):
```powershell
ResourceGroupName        : ITS-Cloud-Systems                                 
Id                       : /subscriptions/789db197-194a-4cca-9770-b4018ed723 
a8/resourceGroups/ITS-Cloud-Systems/providers/Microsoft.Compute/virtualMachi 
nes/del01-testvm-ncus-01                                                     
VmId                     : 47ad1ff7-3c9b-4a65-8de2-fb6cd4c4e065              
Name                     : del01-testvm-ncus-01                              
Type                     : Microsoft.Compute/virtualMachines                 
Location                 : northcentralus                                    
Tags                     : {}                                                
HardwareProfile          : {VmSize}                                          
NetworkProfile           : {NetworkInterfaces}                               
OSProfile                : {ComputerName, AdminUsername,                     
LinuxConfiguration, Secrets, AllowExtensionOperations,                       
RequireGuestProvisionSignal}                                                 
ProvisioningState        : Succeeded                                         
StorageProfile           : {ImageReference, OsDisk, DataDisks,               
DiskControllerType, AlignRegionalDisksToVMZone}                              
FullyQualifiedDomainName :                                                   
del01-testvm-ncus-01-9721c2.northcentralus.cloudapp.azure.com                
TimeCreated              : 1/21/2026 2:39:39 PM                              
Etag                     : "2"
```

### Cleanup the VM
This command cleans up the VM:
```powershell
Remove-AzVM -ResourceGroupName 'ITS-Cloud-Systems' -Name 'del01-testvm-ncus-01' -Force
```

And will output something like:
```powershell
OperationId : cfa55967-74c3-471c-8e3e-9992f3b939a5
Status      : Succeeded
StartTime   : 1/21/2026 10:10:04 AM
EndTime     : 1/21/2026 10:10:45 AM
Error       :
```

## SKU-Region Script
During VM deployment, determining which VM sizes are actually usable for a given
subscription and region can be non-trivial due to Azure policy restrictions,
zone limitations, and architecture compatibility.

To address this, I developed a custom **SKU discovery script**.

### Implementation Overview

The solution consists of two parts:

1.) **PowerShell (`get_vm_skus.ps1`)**
  - Queries Azure using the Az PowerShell module
  - Collects user account locations, VM SKU availability, zones, restrictions, and capabilities
  - Outputs the results as structured JSON

2.) **Python (`get_vm_skus.py`)**
  - Executes the PowerShell script
  - Displays a loading indicator while data is collected
  - Presents the results in an interactive, arrow-key-driven CLI
  - Allows filtering by location, family, tier, and CPU architecture

### Example Output
```powershell
(myenv) PS /home/itsvm/Desktop/ITS-5900-Cloud-Lab-Notebook/deliverable-01/scripts> python3 ./get_vm_skus.py
Data Collected!        
? Select filter categories: done (3 selections)
? Select values for CpuArchitecture: [x64]
? Select values for Location: [northcentralus]
? Select values for Size: done (9 selections)

Filtered SKUs:
╒═══════════════════╤════════════════╤═════════╤══════════╤═════════════════════╤══════════╤═══════════════════╤═════════╤════════════╤═══════════════╕
│ Name              │ Location       │ Zones   │ Size     │ Family              │ Tier     │ CpuArchitecture   │   vCPUs │   MemoryGB │   OSVhdSizeMB │
╞═══════════════════╪════════════════╪═════════╪══════════╪═════════════════════╪══════════╪═══════════════════╪═════════╪════════════╪═══════════════╡
│ Standard_B2als_v2 │ northcentralus │         │ B2als_v2 │ standardBasv2Family │ Standard │ x64               │       2 │          4 │       1047552 │
├───────────────────┼────────────────┼─────────┼──────────┼─────────────────────┼──────────┼───────────────────┼─────────┼────────────┼───────────────┤
│ Standard_B2as_v2  │ northcentralus │         │ B2as_v2  │ standardBasv2Family │ Standard │ x64               │       2 │          8 │       1047552 │
├───────────────────┼────────────────┼─────────┼──────────┼─────────────────────┼──────────┼───────────────────┼─────────┼────────────┼───────────────┤
│ Standard_B2ats_v2 │ northcentralus │         │ B2ats_v2 │ standardBasv2Family │ Standard │ x64               │       2 │          1 │       1047552 │
╘═══════════════════╧════════════════╧═════════╧══════════╧═════════════════════╧══════════╧═══════════════════╧═════════╧════════════╧═══════════════╛
? Would you like to re-search? (Y/n)
```
