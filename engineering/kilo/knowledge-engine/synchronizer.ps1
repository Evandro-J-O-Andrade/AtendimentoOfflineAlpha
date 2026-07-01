# INCREMENTAL SYNCHRONIZER

param(
    [string]$DumpPath = "engineering/dumps",
    [string]$InventoryPath = "engineering/inventory"
)

function Sync-Dump {
    param([string]$NewDump)
    
    $hash = Get-FileHash -Path $NewDump -Algorithm SHA256
    $hashFile = "$NewDump.hash"
    
    if (Test-Path $hashFile) {
        $oldHash = Get-Content $hashFile
        if ($hash.Hash -eq $oldHash) {
            Write-Host "✅ Dump não modificado - pulando" -ForegroundColor Green
            return $false
        }
    }
    
    $hash.Hash | Set-Content $hashFile
    Write-Host "🔄 Dump modificado - executando sincronização" -ForegroundColor Yellow
    return $true
}

function Compare-WithInventory {
    param([string]$DumpFile)
    
    $tablesJson = "$InventoryPath/tables.json"
    if (Test-Path $tablesJson) {
        $inventory = Get-Content $tablesJson | ConvertFrom-Json
        Write-Host "📊 Comparando com inventory: $($inventory.Count) tabelas" -ForegroundColor Cyan
    }
}

Write-Host "🔬 Incremental Synchronizer ativo" -ForegroundColor Cyan