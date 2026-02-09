# VM SKU Discovery and Filtering Scripts
This directory contains helper scripts used to explore **Azure VM SKU availability**
across regions, architectures, and zones. These scripts were developed to avoid
trial-and-error failures when selecting VM sizes restricted by Azure policy or
regional availability.

The tooling is intended to be run **locally** and produces an **interactive
command-line interface** for exploring VM options.

## Overview
### Scripts
| Script            | Purpose                                                                                                           |
| ----------------- | ----------------------------------------------------------------------------------------------------------------- |
| `get_vm_skus.ps1` | Queries Azure VM SKUs, availability zones, restrictions, and hardware capabilities. Outputs structured JSON.      |
| `get_vm_skus.py`  | Runs the PowerShell script, shows a loading spinner, and provides an interactive filterable CLI using arrow keys. |

### Requirements
#### Azure and PowerShell
- Azure CLI authenticated (`az login`)
- PowerShell Core (`pwsh`)
- Az PowerShell module:
  ```PowerShell
  Install-Module Az -Scope CurrentUser
  ```

#### Python
- Python 3.10+ (tested with 3.12)
- `venv` support installed
  ```powershell
  sudo apt install python3.12-venv python3-pip -y
  ```

## Setup
Creat a virtual environment:
```powershell
cd scripts
python3 -m venv myenv
./myenv/bin/activate.ps1
```
Upgrade pip and install dependencies:
```powershell
pip install --upgrade pip
pip install questionary tabulate
```

## Running the Tool
From the `scripts/` directory:
```powershell
python3 get_vm_skus.py
```
### What happens when you run it
- Python launches the PowerShell script
- A loading spinner is displayed while Azure data is collected
- VM SKU data is returned as JSON
- You are prompted to interactively select filters using arrow keys

### Interactive Filtering
#### Step 1: Select filter categories
You can choose one or more categories:
- Location
- Size
- Family
- Tier
- CpuArchitecture
Use:
- ↑ / ↓ to move
- Space to select
- Enter to confirm

#### Step 2: Select values for each category
For each category selected, the script shows **only unique values**
present across all discovered SKUs.

#### Step 3: View results
Matching VM SKUs are displayed in a formatted table
Each row includes:
- VM size
- vCPUs
- Memory (GB)
- CPU architecture
- OS disk size limits
- Region availability

## Example Output
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

## Inspecting Azure Objects
Azure PowerShell cmdlets often return deep, nested objects that are not fully
documented. To understand the structure of the data returned by Azure (especially
SKU capabilities, zones, and location info), this project relied heavily on
PowerShell’s object inspection tools.

The primary tool used was `Get-Member`:
```powershell
$sku | Get-Member
```

This command was used to:
- Discover available properties and methods
- Identify nested objects such as: 
  - `LocationInfo`
  - `Zones`
  - `Capabilities`
- Determine correct property paths (e.g. `$sku.LocationInfo.Zones`)
