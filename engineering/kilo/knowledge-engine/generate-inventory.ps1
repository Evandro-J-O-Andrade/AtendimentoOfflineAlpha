# GENERATE INVENTORY

$tablesRaw = "docs/database/tables_raw"
$inventoryPath = "engineering/inventory"

$tableList = @()
Get-ChildItem -Path $tablesRaw -Filter "*.json" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    $tableList += @{
        name = $_.BaseName
        schema = $content.schema ?? "unknown"
        columns = $content.columns?.Count ?? 0
        hasPK = $null -ne $content.primary_key
        hasFK = $content.foreign_keys?.Count -gt 0
        fks = $content.foreign_keys?.Count ?? 0
        events = $content.events?.Count ?? 0
    }
}

@{
    generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    total = $tableList.Count
    tables = $tableList
} | ConvertTo-Json -Depth 10 | Set-Content "$inventoryPath/tables.json"

Write-Host "✅ Inventory generated: $($tableList.Count) tables" -ForegroundColor Green