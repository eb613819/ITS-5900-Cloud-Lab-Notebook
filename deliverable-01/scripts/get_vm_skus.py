import subprocess
import json

# Path to PowerShell script
ps_script = "get_vm_skus.ps1"

# Run PowerShell and capture JSON output
result = subprocess.run(
    ["pwsh", "-File", ps_script],
    capture_output=True,
    text=True
)

if result.returncode != 0:
    print("PowerShell script failed:")
    print(result.stderr)
    exit(1)

# Parse JSON
try:
    skus = json.loads(result.stdout)
except json.JSONDecodeError as e:
    print("Failed to parse JSON:")
    print(result.stdout)
    exit(1)

# Display results
for sku in skus:
    print(f"SKU: {sku['Name']}")
    print(f"  Location: {sku['Location']}")
    print(f"  Zones: {sku['Zones']}")
    print(f"  vCPUs: {sku['vCPUs']}")
    print(f"  MemoryGB: {sku['MemoryGB']}")
    print(f"  OSVhdSizeMB: {sku['OSVhdSizeMB']}")
    print(f"  CPU Architecture: {sku['CpuArchitecture']}")
    print("-" * 40)
