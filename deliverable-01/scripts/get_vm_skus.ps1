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
        Write-Host "SKU zones: " $sku.Zones
        $allowedZones = @()
        if ($sku.Zones) {
            # Zones come in like {1, 2, 3}
            $allowedZones = $matches[1].Trim() -split '\s*,\s*'
        }
        Write-Host "Allowed zones: " $allowedZones
        
        $locationRestricted = $false

        foreach ($r in $sku.RestrictionInfo) {
            Write-Host $r
            $obj = @{
                type      = $null
                locations = @()
                zones     = @()
            }
            
            # type
            if ($r -match 'type\s*:\s*([^,]+)') {
                $obj.type = $matches[1].Trim()
            }
            
            # locations
            if ($r -match 'locations\s*:\s*([^,]+)') {
                $obj.locations = $matches[1].Trim() -split '\s*,\s*'
            }
            
            # zones (capture REST of line)
            if ($r -match 'zones\s*:\s*(.+)$') {
                $obj.zones = $matches[1].Trim() -split '\s*,\s*'
            }
            
            if ($DebugMode) {
                Write-Host "Parsed restriction:"
                Write-Host "  type      =" $obj.type
                Write-Host "  locations =" ($obj.locations -join ', ')
                Write-Host "  zones     =" ($obj.zones -join ', ')
            }

            # Skip SKU entirely if it is restricted in this region
            if ($obj.type -eq 'Location' -and $obj.locations -contains $region) {
                if ($DebugMode) { Write-Host "  SKU $($sku.Name) is restricted in this region!" }
                $locationRestricted = $true
                break
            }

            # # Zone restrictions: remove blocked zones
            # if ($obj['type'] -eq 'Zone' -and $obj['locations'] -contains $region) {
            #     $restrictedZones = @($obj['zones']) # normalize
            #     $allowedZones = $allowedZones | Where-Object { $restrictedZones -notcontains $_ }
            # }
        }

        if ($locationRestricted) {
            if ($DebugMode) { Write-Host "Skipping SKU $($sku.Name) without adding to results due to location restriction." }
            continue
        }

        # # Drop SKU if it had zones but all were restricted
        # if ($sku.Zones -and $allowedZones.Count -eq 0) {
        #     if ($DebugMode) { Write-Host "Skipping SKU $($sku.Name) due to all zones in restriction." }
        #     continue
        # }

        # # Default to "None" if no allowed zones remain
        # if (-not $allowedZones) { $allowedZones = @("None") }

        # if ($DebugMode) { Write-Host "  Allowed zones:" ($allowedZones -join ", ") }

        # # Add SKU to results
        # $results += [pscustomobject]@{
        #     SKU    = $sku.Name
        #     Region = $region
        #     Zones  = if ($allowedZones.Count -gt 0) { $allowedZones -join "," } else { "None" }
        # }
    }
}

# Print results
$results
