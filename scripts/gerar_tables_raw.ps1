# Gerar documentação completa de tabelas a partir dos JSONs raw
param()

$rawDir = "docs/database/tables_raw"
$outDir = "docs/database/tables_geradas"
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

$files = Get-ChildItem $rawDir -Filter "*.json"
$processed = 0

foreach ($f in $files) {
    $name = $f.BaseName
    $json = Get-Content $f.FullName -Raw | ConvertFrom-Json
    $block = $json.block
    
    # Extrair definição CREATE TABLE
    if ($block -match 'CREATE TABLE\s+(?:IF NOT EXISTS\s+)?`([^`]+)`\s*\((.*?)\)\s*ENGINE=InnoDB') {
        $tableName = $Matches[1]
        $body = $Matches[2]
    } else {
        continue
    }
    
    $lines = $body -split "`n"
    $cols = @()
    $fks = @()
    $indices = @()
    $uniques = @()
    
    foreach ($line in $lines) {
        $line = $line.Trim()
        if ($line -match '^`([^`]+)`\s+([^\s,]+)(?:\s*\([^)]*\))?\s*(NOT NULL|NULL|DEFAULT[^,]*)?') {
            $colName = $Matches[1]
            $colType = $Matches[2]
            $colNull = if ($line -match 'NOT NULL') { 'NOT NULL' } else { 'YES' }
            $cols += "$colName|$colType|$colNull"
        }
        elseif ($line -match 'PRIMARY KEY\s*\(`([^`]+)`\)') {
            $indices += "PRIMARY KEY ($($Matches[1]))"
        }
        elseif ($line -match 'UNIQUE KEY\s+`[^`]*`\s*\(([^)]+)\)') {
            $key = $Matches[1] -replace '`', ''
            $uniques += "UNIQUE KEY ($key)"
        }
        elseif ($line -match 'KEY\s+`[^`]*`\s*\(([^)]+)\)') {
            $key = $Matches[1] -replace '`', ''
            $indices += "KEY ($key)"
        }
        elseif ($line -match 'CONSTRAINT\s+`[^`]+`\s+FOREIGN KEY\s*\(`([^`]+)`\)\s*REFERENCES\s*`([^`]+)`\s*\(`([^`]+)`\)') {
            $fks += "$($Matches[1]) -> $($Matches[2]).$($Matches[3])"
        }
    }
    
    $md = "# $tableName`n`n"
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
    
    Set-Content -Path "$outDir/$tableName.md" -Value $md -Encoding UTF8
    $processed++
}

Write-Output "Processadas $processed tabelas em $outDir"
