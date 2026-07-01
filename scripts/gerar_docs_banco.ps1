# Script de geração automática de documentação de banco
# Parseia Dump20260606.sql e gera markdowns

param(
    [string]$DumpPath = "legacy/backend_antigo/sql/Dump20260606.sql",
    [string]$OutputDir = "docs/database"
)

$content = Get-Content $DumpPath -Raw -Encoding UTF8

# Criar pastas se não existirem
New-Item -ItemType Directory -Path "$OutputDir/tables_auto" -Force | Out-Null
New-Item -ItemType Directory -Path "$OutputDir/views_auto" -Force | Out-Null
New-Item -ItemType Directory -Path "$OutputDir/functions_auto" -Force | Out-Null
New-Item -ItemType Directory -Path "$OutputDir/triggers_auto" -Force | Out-Null
New-Item -ItemType Directory -Path "$OutputDir/events_auto" -Force | Out-Null

# Extrair tabelas
$tables = [regex]::Matches($content, '(?ms)^CREATE TABLE\s+(?:IF NOT EXISTS\s+)?`([^`]+)`\s*\((.*?)\)\s*ENGINE=InnoDB.*?DEFAULT CHARSET=utf8mb4.*?;', 'IgnoreCase')

foreach ($t in $tables) {
    $name = $t.Groups[1].Value
    $body = $t.Groups[2].Value
    
    $cols = @()
    $fks = @()
    $indices = @()
    $uniques = @()
    
    # Parse linhas
    $lines = $body -split "`n"
    foreach ($line in $lines) {
        $line = $line.Trim()
        if ($line -match '^`([^`]+)`\s+([^\s,]+)\s*(\([^)]*\))?\s*(NOT NULL|NULL|DEFAULT[^,]*)?') {
            $colName = $Matches[1]
            $colType = $Matches[2]
            $colNull = if ($Matches[3] -eq 'NOT NULL') { 'NOT NULL' } else { 'YES' }
            $cols += "$colName|$colType|$colNull"
        }
        elseif ($line -match 'PRIMARY KEY\s*\(`([^`]+)`\)') {
            $indices += "PRIMARY KEY ($($Matches[1]))"
        }
        elseif ($line -match 'UNIQUE KEY\s+`[^`]*`\s*\(`([^`]+)`(?:,\s*`([^`]+)`)*\)') {
            $key = $Matches[0] -replace 'UNIQUE KEY\s+`[^`]+`\s*\(', '' -replace '\)', ''
            $uniques += "UNIQUE KEY ($key)"
        }
        elseif ($line -match 'KEY\s+`[^`]*`\s*\(`([^`]+)`(?:,\s*`([^`]+)`)*\)') {
            $key = $Matches[0] -replace 'KEY\s+`[^`]+`\s*\(', '' -replace '\)', ''
            $indices += "KEY ($key)"
        }
        elseif ($line -match 'CONSTRAINT\s+`[^`]+`\s+FOREIGN KEY\s*\(`([^`]+)`\)\s*REFERENCES\s*`([^`]+)`\s*\(`([^`]+)`\)') {
            $fks += "$($Matches[1]) -> $($Matches[2]).$($Matches[3])"
        }
    }
    
    $md = "# $name`n`n"
    $md += "Objetivo: (Documentar)`n`n"
    $md += "Descricao: (Documentar)`n`n"
    $md += "## Colunas`n`n| Coluna | Tipo | Nullable | Default | Funcao |`n"
    $md += "|---------|------|----------|---------|--------|`n"
    foreach ($c in $cols) {
        $parts = $c -split '\|'
        $md += "| $($parts[0]) | $($parts[1]) | $($parts[2]) | - | (Documentar) |`n"
    }
    $md += "`n## Chaves`n`n"
    $md += "- Primaria: (Documentar)`n"
    if ($uniques.Count -gt 0) {
        foreach ($u in $uniques) { $md += "- Unica: $u`n" }
    }
    if ($fks.Count -gt 0) {
        foreach ($fk in $fks) { $md += "- Estrangeira: $fk`n" }
    }
    $md += "`n## Indices`n`n"
    foreach ($i in $indices) { $md += "- $i`n" }
    $md += "`n## Dependencias`n`n- (Documentar)`n"
    $md += "`n## Fluxo`n`n- (Documentar)`n"
    
    Set-Content -Path "$OutputDir/tables_auto/$name.md" -Value $md -Encoding UTF8
}

Write-Output "Tabelas processadas: $($tables.Count)"
