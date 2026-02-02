#Get all allowed regions for the user
$allowedRegions = (
  Get-AzPolicyAssignment | 
  Where-Object {
    $_.DisplayName -like '*deployment*' -or 
    $_.DisplayName -like '*Allowed resource*'
  }
).Parameter.listOfAllowedLocations.value


# Toggle debug prints
$DebugMode = $true   # set to $false to silence debug output

$results = @()

foreach ($region in $allowedRegions) {
    if ($DebugMode) { Write-Host "`nChecking region: $region" }

    # Get all Standard_B[12]* SKUs for this region
    $skus = Get-AzComputeResourceSku -Location $region |
        Where-Object { $_.Name -like 'Standard_B[12][a-z]*' }

    if ($DebugMode) { Write-Host "Found SKUs:" ($skus.Name -join ", ") }
    foreach ($sku in $skus) {
        if ($DebugMode) { Write-Host "`nChecking SKU: $($sku.Name)" }
        $allowedZones = @()
        $regionInfo = $sku.LocationInfo | Where-Object { $_.Location -eq $region }
        if ($regionInfo -and $regionInfo.Zones) {
            $allowedZones = @($regionInfo.Zones)  # Already an array of zone numbers
        }
        
        if ($DebugMode) { Write-Host "Allowed zones: " $allowedZones }
        
        $locationRestricted = $false

        foreach ($r in $sku.RestrictionInfo) {
            if ($DebugMode) { Write-Host "Restriction: " $r }
            $restrict_obj = @{
                type      = $null
                locations = @()
                zones     = @()
            }
            
            # type
            if ($r -match 'type\s*:\s*([^,]+)') {
                $restrict_obj.type = $matches[1].Trim()
            }
            
            # locations
            if ($r -match 'locations\s*:\s*([^,]+)') {
                $restrict_obj.locations = $matches[1].Trim() -split '\s*,\s*'
            }
            
            # zones (capture REST of line)
            if ($r -match 'zones\s*:\s*(.+)$') {
                $restrict_obj.zones = $matches[1].Trim() -split '\s*,\s*'
            }
            
            if ($DebugMode) {
                Write-Host "Parsed restriction:"
                Write-Host "  type      =" $restrict_obj.type
                Write-Host "  locations =" ($restrict_obj.locations -join ', ')
                Write-Host "  zones     =" ($restrict_obj.zones -join ', ')
            }

            # Skip SKU entirely if it is restricted in this region
            if ($restrict_obj.type -eq 'Location' -and $restrict_obj.locations -contains $region) {
                if ($DebugMode) { Write-Host "  SKU $($sku.Name) is restricted in this region!" }
                $locationRestricted = $true
                break #break ends the restriction loop
            }

            # Zone restrictions: remove blocked zones
            if ($restrict_obj.type -eq 'Zone' -and $restrict_obj.locations -contains $region) {
                $allowedZones = $allowedZones | Where-Object { $restrict_obj.zones -notcontains $_ }
                if ($DebugMode) { Write-Host "New allowed zones: " $allowedZones }
            }
        }

        if ($locationRestricted) {
            if ($DebugMode) { Write-Host "Skipping SKU $($sku.Name) without adding to results due to location restriction." }
            continue #continue moves to the next SKU
        }

        # Drop SKU if it had zones but all were restricted
        if ($sku.LocationInfo.Zones -and $allowedZones.Count -eq 0) {
            if ($DebugMode) { Write-Host "Skipping SKU $($sku.Name) due to all zones in restriction." }
            continue
        }

        # Add SKU to results
        $results += [pscustomobject]@{
            SKU    = $sku.Name
            Region = $region
            Zones  = if ($allowedZones.Count -gt 0) { $allowedZones -join "," } else { "" }
        }
    }
}

if ($DebugMode) { Write-Host "Results: " $results }
