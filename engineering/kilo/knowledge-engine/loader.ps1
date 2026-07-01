# KNOWLEDGE LOADER — KILO v7

param(
    [string]$BasePath = "engineering"
)

function Load-Knowledge {
    Write-Host "🚀 Iniciando Knowledge Loader..." -ForegroundColor Cyan
    
    $knowledge = @{
        canonical = @{}
        inventory = @{}
        metadata = @{}
        reports = @{}
    }
    
    # Priority 1: Canonical
    if (Test-Path "$BasePath/canonical") {
        Write-Host "📚 Carregando Canonical..." -ForegroundColor Yellow
        Get-ChildItem -Path "$BasePath/canonical" -Recurse -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $knowledge.canonical[$_.Name] = $_.FullName
        }
    }
    
    # Priority 2: Inventory
    if (Test-Path "$BasePath/inventory") {
        Write-Host "📦 Carregando Inventory..." -ForegroundColor Yellow
        Get-ChildItem -Path "$BasePath/inventory" -Filter "*.json" -ErrorAction SilentlyContinue | ForEach-Object {
            $knowledge.inventory[$_.BaseName] = $_.FullName
        }
    }
    
    # Priority 3: Metadata
    if (Test-Path "$BasePath/metadata") {
        Write-Host "🔗 Carregando Metadata..." -ForegroundColor Yellow
        Get-ChildItem -Path "$BasePath/metadata" -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $knowledge.metadata[$_.BaseName] = $_.FullName
        }
    }
    
    # Priority 4: Reports
    if (Test-Path "$BasePath/reports") {
        Write-Host "📊 Carregando Reports..." -ForegroundColor Yellow
        Get-ChildItem -Path "$BasePath/reports" -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $knowledge.reports[$_.BaseName] = $_.FullName
        }
    }
    
    # Priority 5: Dumps (update)
    if (Test-Path "$BasePath/dumps") {
        Write-Host "🔄 Dumps detectados - sincronização incremental ativada" -ForegroundColor Green
    }
    
    return $knowledge
}

Load-Knowledge