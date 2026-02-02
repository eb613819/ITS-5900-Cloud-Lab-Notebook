import subprocess
import json
import sys
import time
import threading
import questionary
from tabulate import tabulate

# --------------------------- Get Data ---------------------------
ps_script = "get_vm_skus.ps1"

def spinner(stop_event):
    symbols = "|/-\\"
    idx = 0
    while not stop_event.is_set():
        sys.stdout.write("\rCollecting Data... " + symbols[idx % len(symbols)])
        sys.stdout.flush()
        idx += 1
        time.sleep(0.1)
    sys.stdout.write("\rData Collected!        \n")

stop_event = threading.Event()
thread = threading.Thread(target=spinner, args=(stop_event,))
thread.start()

# Run PowerShell and capture JSON output
try:
    proc = subprocess.run(
        ["pwsh", "-File", ps_script],
        capture_output=True,
        text=True
    )
finally:
    # Stop spinner
    stop_event.set()
    thread.join()

if proc.returncode != 0:
    print("PowerShell script failed:")
    print(proc.stderr)
    exit(1)

# Parse JSON
try:
    skus = json.loads(proc.stdout)
except json.JSONDecodeError as e:
    print("Failed to parse JSON:")
    print(proc.stdout)
    exit(1)

# ------------------------- Display Data -------------------------
while True:
    filtered_skus = skus.copy()
    no_filters = False
    # Choose filter catagories
    top_filters = ["Location", "Size", "Family", "Tier", "CpuArchitecture"]
    selected_filters = questionary.checkbox(
        "Select filter categories:",
        choices=top_filters
    ).ask()

    if not selected_filters:
        print("No filters selected. Showing all results.")
        no_filters = True

    # Choose filters
    filters_selected = {}
    for f in selected_filters:
        unique_values = list({sku[f] for sku in filtered_skus})
        choices = questionary.checkbox(
            f"Select values for {f}:",
            choices=unique_values
        ).ask()
        filters_selected[f] = choices

    # Apply filters
    for key, values in filters_selected.items():
        filtered_skus = [sku for sku in filtered_skus if sku[key] in values]

    # Display results in a table
    if filtered_skus:
        if no_filters:
            print("\nAll SKUs:")
        else:
            print("\nFiltered SKUs:")
        headers = ["Name", "Location", "Zones", "Size", "Family", "Tier", "CpuArchitecture", "vCPUs", "MemoryGB", "OSVhdSizeMB"]
        table = [
            [
                sku.get("Name", ""),
                sku.get("Location", ""),
                sku.get("Zones", ""),
                sku.get("Size", ""),
                sku.get("Family", ""),
                sku.get("Tier", ""),
                sku.get("CpuArchitecture", ""),
                sku.get("vCPUs", ""),
                sku.get("MemoryGB", ""),
                sku.get("OSVhdSizeMB", "")
            ]
            for sku in filtered_skus
        ]
        print(tabulate(table, headers=headers, tablefmt="fancy_grid"))
    else:
        print("No SKUs match your filter selection!")

    # Ask about research
    continue_filtering = questionary.confirm(
        "Would you like to re-search?"
    ).ask()

    if not continue_filtering:
        break

print("Done. Exiting.")