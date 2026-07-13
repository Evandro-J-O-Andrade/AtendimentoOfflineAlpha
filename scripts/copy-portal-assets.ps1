<#
Script: copy-portal-assets.ps1
Propósito: copiar assets referenciados para `apps/portal/public/assets/*` a partir de `Captures/dashboard`.
Uso: execute na raiz do repositório (PowerShell)
#>

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$root = Split-Path -Parent $scriptDir
$source = Join-Path $root 'Captures\dashboard'
$destBrand = Join-Path $root 'apps\portal\public\assets\branding'
$destLogin = Join-Path $root 'apps\portal\public\assets\login'

Write-Host "Fonte: $source"
Write-Host "Destino branding: $destBrand"
Write-Host "Destino login: $destLogin"

# Criar diretórios se necessário
New-Item -ItemType Directory -Force -Path $destBrand | Out-Null
New-Item -ItemType Directory -Force -Path $destLogin | Out-Null

# Arquivos a copiar (ajuste conforme necessário)
$filesToCopy = @(
    @{ name = 'logo.png'; target = $destBrand },
    @{ name = 'logoSemFundo.png'; target = $destBrand },
    @{ name = 'logoSaaS.png'; target = $destBrand },
    @{ name = 'teladelogin.png'; target = $destLogin }
)

foreach ($item in $filesToCopy) {
    $src = Join-Path $source $item.name
    $dst = Join-Path $item.target $item.name
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "Copiado: $src -> $dst"
    } else {
        Write-Warning "Arquivo não encontrado: $src"
    }
}

Write-Host "Concluído. Verifique apps/portal/public/assets/..."