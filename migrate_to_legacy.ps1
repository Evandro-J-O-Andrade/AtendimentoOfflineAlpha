# Script de migração controlada para legacy.
# Move o código atual para legacy/ e recria uma estrutura limpa para reconstrução.
# Preserva docs, database, sql, imagens, assets públicos, .env.example e arquivos de configuração da raiz.

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $root

$legacyRoot = Join-Path $root "legacy"
$legacyFrontend = Join-Path $legacyRoot "frontend_antigo"
$legacyBackend = Join-Path $legacyRoot "backend_antigo"
$legacyCypress = Join-Path $legacyRoot "cypress_antigo"
$legacyRootCode = Join-Path $legacyRoot "root_antigo"
$legacyArchives = Join-Path $legacyRoot "arquivos_antigos"

$frontendPath = Join-Path $root "frontend"
$backendPath = Join-Path $root "backend"
$cypressPath = Join-Path $root "cypress"

function New-LegacyStructure {
    New-Item -ItemType Directory -Path $legacyFrontend -Force | Out-Null
    New-Item -ItemType Directory -Path $legacyBackend -Force | Out-Null
    New-Item -ItemType Directory -Path $legacyCypress -Force | Out-Null
    New-Item -ItemType Directory -Path $legacyRootCode -Force | Out-Null
    New-Item -ItemType Directory -Path $legacyArchives -Force | Out-Null
}

function Move-DirectoryContentToLegacy {
    param(
        [string] $SourcePath,
        [string] $DestinationPath
    )

    if (!(Test-Path -LiteralPath $SourcePath)) {
        Write-Host "Ignorado: $SourcePath não existe."
        return
    }

    if (Test-Path -LiteralPath $DestinationPath) {
        $existingItems = Get-ChildItem -LiteralPath $DestinationPath -Force | Where-Object { $_.Name -notin @(".", "..") }
        if ($existingItems) {
            Write-Host "Ignorado: $DestinationPath já possui conteúdo. Nada foi movido de $SourcePath."
            return
        }
    }

    New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null

    Get-ChildItem -LiteralPath $SourcePath -Force |
        Where-Object { $_.Name -notin @("node_modules", "dist", ".vite") } |
        ForEach-Object {
            Move-Item -LiteralPath $_.FullName -Destination $DestinationPath -Force
            Write-Host "Movido para legacy: $($_.FullName)"
        }

    Remove-Item -LiteralPath (Join-Path $SourcePath "node_modules") -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath (Join-Path $SourcePath "dist") -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath (Join-Path $SourcePath ".vite") -Recurse -Force -ErrorAction SilentlyContinue
}

function Move-RootCodeItemsToLegacy {
    $items = @(
        "auth.ts",
        "index.ts",
        "extract_fks.ps1",
        "server_err.log",
        "server_out.log",
        "base64.txt",
        "frontend.zip",
        "frontendgemini.zip",
        "frontendrefatorado.zip",
        "frontendrefatorado2.zip"
    )

    foreach ($name in $items) {
        $source = Join-Path $root $name
        if (Test-Path -LiteralPath $source) {
            Move-Item -LiteralPath $source -Destination $legacyRootCode -Force
            Write-Host "Movido para legacy/root_antigo: $source"
        }
    }

    if (Test-Path -LiteralPath $cypressPath) {
        Move-Item -LiteralPath $cypressPath -Destination $legacyCypress -Force
        Write-Host "Movido para legacy/cypress_antigo: $cypressPath"
    }
}

function Preserve-PublicAssets {
    $frontendPublic = Join-Path $frontendPath "public"
    if (Test-Path -LiteralPath $frontendPublic) {
        $publicRoot = Join-Path $root "public"
        New-Item -ItemType Directory -Path $publicRoot -Force | Out-Null
        Copy-Item -LiteralPath $frontendPublic -Destination $publicRoot -Recurse -Force
        Write-Host "Assets públicos preservados em: $publicRoot"
    }

    if (Test-Path -LiteralPath (Join-Path $root "public")) {
        Write-Host "Pasta public preservada na raiz."
    }
}

function New-CleanStructure {
    $paths = @(
        (Join-Path $root "frontend/src/app/core"),
        (Join-Path $root "frontend/src/app/providers"),
        (Join-Path $root "frontend/src/apps/portal"),
        (Join-Path $root "frontend/src/shared/components"),
        (Join-Path $root "backend/src/auth"),
        (Join-Path $root "backend/src/shared/database"),
        (Join-Path $root "backend/src/shared/middleware"),
        (Join-Path $root "backend/src/shared/services"),
        (Join-Path $root "backend/src/shared/utils")
    )

    foreach ($path in $paths) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        New-Item -ItemType File -Path (Join-Path $path ".gitkeep") -Force | Out-Null
    }
}

New-LegacyStructure
Preserve-PublicAssets
Move-DirectoryContentToLegacy -SourcePath $frontendPath -DestinationPath $legacyFrontend
Move-DirectoryContentToLegacy -SourcePath $backendPath -DestinationPath $legacyBackend
Move-RootCodeItemsToLegacy
New-CleanStructure

Write-Host "Migracao concluida."
Write-Host "Codigo antigo preservado em: $legacyFrontend"
Write-Host "Codigo antigo preservado em: $legacyBackend"
Write-Host "Estrutura limpa criada em frontend/src e backend/src."
Write-Host "Proxima etapa: reconstruir frontend/src e backend/src usando docs/, database/ e sql/ como fonte da verdade."
