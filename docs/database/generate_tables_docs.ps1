param(
    [string]$InputDir = "D:\AtendimentoOfflineAlpha\docs\database\tables_raw",
    [string]$OutputDir = "D:\AtendimentoOfflineAlpha\docs\database\tables"
)

if (-not (Test-Path -LiteralPath $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

$tables = @(
    "consumo_insumo",
    "consumo_limpeza",
    "consumo_manutencao",
    "contexto_atendimento",
    "contrato",
    "coordenador_estado_global",
    "dispensacao_medicacao",
    "dispositivo",
    "dispositivo_tipo",
    "documento_arquivo",
    "documento_emissao",
    "documento_emissao_evento",
    "documento_tipo_config",
    "enfermagem",
    "enfermagem_aprazamento",
    "enfermagem_diagnosticos",
    "erro_catalogo",
    "erro_evento",
    "escala_medica",
    "escala_plantao",
    "escala_plantao_atual",
    "escala_profissional",
    "especialidade",
    "estoque_alerta",
    "estoque_almoxarifado_central",
    "estoque_audit_stream",
    "estoque_conciliacao_atomica",
    "estoque_conta",
    "estoque_documento_execucao",
    "estoque_evento_confirmacao",
    "estoque_execucao",
    "estoque_execucao_pipeline",
    "estoque_fluxo_assistencial",
    "estoque_inventario",
    "estoque_inventario_item",
    "estoque_item",
    "estoque_ledger",
    "estoque_local",
    "estoque_lote",
    "estoque_lote_snapshot",
    "estoque_movimentacao",
    "estoque_movimentacao_itens",
    "estoque_movimento",
    "estoque_movimento_item",
    "estoque_pipeline_estado",
    "estoque_produto",
    "estoque_produto_codigo_externo",
    "estoque_reserva",
    "estoque_reserva_evento",
    "estoque_saldo"
)

foreach ($tableName in $tables) {
    $jsonPath = Join-Path $InputDir "$tableName.json"
    if (-not (Test-Path -LiteralPath $jsonPath)) {
        Write-Warning "JSON not found for table: $tableName"
        continue
    }

    $json = Get-Content -LiteralPath $jsonPath -Raw | ConvertFrom-Json
    $sql = $json.block
    
    # Extract CREATE TABLE content
    if ($sql -match '(?s)CREATE TABLE `([^`]+)` \((.+)\) ENGINE=') {
        $tableNameRaw = $Matches[1]
        $createContent = $Matches[2]
        $commentMatch = [regex]::Match($sql, "COMMENT='([^']*)'")
        $tableComment = if ($commentMatch.Success) { $commentMatch.Groups[1].Value } else { "" }
    } else {
        Write-Warning "Could not parse CREATE TABLE for: $tableName"
        continue
    }

    # Parse columns
    $columns = @()
    $primaryKeys = @()
    $uniqueKeys = @()
    $foreignKeys = @()
    $checkConstraints = @()
    $indices = @()

    $lines = $createContent -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" -and $_ -ne "," }

    foreach ($line in $lines) {
        # Skip lines that are keys/constraints for now, we'll handle them specially
        if ($line -match '^PRIMARY KEY') {
            if ($line -match '\(`([^`]+)`\)') {
                $pkCols = $Matches[1] -split '`,`'
                $primaryKeys = @($pkCols)
            }
            continue
        }
        if ($line -match '^UNIQUE KEY') {
            if ($line -match '`([^`]+)`\s*\(`([^`]+)`\)') {
                $uniqueKeys += [PSCustomObject]@{
                    Name = $Matches[1]
                    Columns = $Matches[2] -split '`,`'
                }
            }
            continue
        }
        if ($line -match '^KEY') {
            if ($line -match '`([^`]+)`\s*\(`([^`]+)`\)') {
                $indices += [PSCustomObject]@{
                    Name = $Matches[1]
                    Columns = $Matches[2] -split '`,`'
                }
            }
            continue
        }
        if ($line -match '^CONSTRAINT') {
            if ($line -match 'FOREIGN KEY\s*\(`([^`]+)`\)\s*REFERENCES\s*`([^`]+)`\s*\(`([^`]+)`\)') {
                $foreignKeys += [PSCustomObject]@{
                    Name = ""
                    Column = $Matches[1]
                    RefTable = $Matches[2]
                    RefColumn = $Matches[3]
                }
            } elseif ($line -match 'CHECK\s*\((.+)\)') {
                $checkConstraints += $Matches[1]
            }
            continue
        }

        # Parse column definition
        if ($line -match '^`([^`]+)`\s+(.+)') {
            $colName = $Matches[1]
            $colDef = $Matches[2]
            
            # Extract type
            $type = ""
            if ($colDef -match '^([a-zA-Z0-9_]+(\([^)]+\))?(\s+unsigned)?)') {
                $type = $Matches[1]
            }
            
            # Nullable
            $nullable = "YES"
            if ($colDef -match 'NOT NULL') {
                $nullable = "NO"
            }
            
            # Default
            $default = ""
            $defaultMatch = [regex]::Match($colDef, "DEFAULT\s+([^,\s]+)")
            if ($defaultMatch.Success) {
                $default = $defaultMatch.Groups[1].Value
            }
            if ($colDef -match 'DEFAULT\s+CURRENT_TIMESTAMP') {
                $default = "CURRENT_TIMESTAMP"
            }
            
            $columns += [PSCustomObject]@{
                Name = $colName
                Type = $type
                Nullable = $nullable
                Default = $default
            }
        }
    }

    # Build markdown
    $md = "# $tableName`n`n"
    $md += "Objetivo: Tabela de armazenamento de dados do sistema`n`n"
    $md += "Descrição: $tableComment`n`n"
    $md += "## Colunas`n`n"
    $md += "| Coluna | Tipo | Nullable | Default | Função/Descrição |`n"
    $md += "|---------|------|----------|---------|------------------|`n"

    foreach ($col in $columns) {
        $desc = $col.Name -replace '_', ' '
        $md += "| $($col.Name) | $($col.Type) | $($col.Nullable) | $($col.Default) | $desc |`n"
    }

    $md += "`n## Chaves`n`n"
    $md += "- Primária: $($primaryKeys -join ', ').`n"
    if ($uniqueKeys.Count -gt 0) {
        $md += "- Únicas:`n"
        foreach ($uk in $uniqueKeys) {
            $md += "  - $($uk.Name) ($($uk.Columns -join ', '))`n"
        }
    }
    if ($foreignKeys.Count -gt 0) {
        $md += "- Estrangeiras:`n"
        foreach ($fk in $foreignKeys) {
            $md += "  - $($fk.Column) referencia $($fk.RefTable).$($fk.RefColumn)`n"
        }
    }

    $md += "`n## Índices`n`n"
    if ($indices.Count -gt 0) {
        foreach ($idx in $indices) {
            $md += "- $($idx.Name) em ($($idx.Columns -join ', '))`n"
        }
    } else {
        $md += "- Nenhum índice adicional.`n"
    }

    $md += "`n## Constraints`n`n"
    if ($foreignKeys.Count -gt 0) {
        foreach ($fk in $foreignKeys) {
            $md += "- FOREIGN KEY ($($fk.Column)) REFERENCES $($fk.RefTable)($($fk.RefColumn))`n"
        }
    }
    if ($checkConstraints.Count -gt 0) {
        foreach ($ck in $checkConstraints) {
            $md += "- CHECK ($ck)`n"
        }
    }
    if ($foreignKeys.Count -eq 0 -and $checkConstraints.Count -eq 0) {
        $md += "- Nenhuma constraint adicional.`n"
    }

    $md += "`n## Relacionamentos e Cardinalidade`n`n"
    if ($foreignKeys.Count -gt 0) {
        foreach ($fk in $foreignKeys) {
            $md += "- $tableName ($($fk.Column)) -> $($fk.RefTable) ($($fk.RefColumn)): N:1`n"
        }
    } else {
        $md += "- Nenhum relacionamento externo declarado.`n"
    }

    $md += "`n## Dependências`n`n"
    if ($foreignKeys.Count -gt 0) {
        $tablesReferenced = $foreignKeys | ForEach-Object { $_.RefTable } | Sort-Object -Unique
        $md += "- Depende de: $($tablesReferenced -join ', ').`n"
    } else {
        $md += "- Nenhuma dependência externa declarada.`n"
    }

    $md += "`n## Fluxo de utilização dentro do sistema`n`n"
    $md += "- Dados são inseridos e consultados conforme regras de negócio associadas.`n"

    $outPath = Join-Path $OutputDir "$tableName.md"
    Set-Content -LiteralPath $outPath -Value $md -Encoding UTF8
    Write-Host "Created: $outPath"
}

Write-Host "Done. Total tables: $($tables.Count)"
