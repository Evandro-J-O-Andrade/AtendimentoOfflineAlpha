# KILO ENGINE v8 — BASELINE GENERATOR
# Fonte canônica: Dump20260606.sql (congelado)
# Saída: engineering/kilo/snapshots/baseline-v8/

param(
    [string]$DumpPath = "legacy/backend_antigo/sql/Dump20260606.sql",
    [string]$OutputDir = "engineering/kilo/snapshots/baseline-v8",
    [switch]$SkipIfExists = $true
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function Ensure-Path($path) {
    if (-not (Test-Path -LiteralPath $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

function Read-Dump {
    param([string]$Path)
    Write-Host "📥 Lendo dump: $Path" -ForegroundColor Cyan
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Dump não encontrado: $Path"
    }
    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8
    Write-Host "📊 Dump carregado: $($content.Length) bytes" -ForegroundColor Green
    return $content
}

function Extract-Tables {
    param([string]$Sql)
    $regex = [regex]::new('CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)`?\s*\((.*?)\)\s*(?:ENGINE|DEFAULT|COLLATE|;)', [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $matches = $regex.Matches($Sql)
    Write-Host "🔍 Regex aplicada. Match count: $($matches.Count)" -ForegroundColor Yellow

    $tables = @{}
    foreach ($m in $matches) {
        $name = $m.Groups[1].Value
        $body = $m.Groups[2].Value
        $tables[$name] = $body
    }
    Write-Host "🗂️ Tabelas extraídas: $($tables.Count)" -ForegroundColor Green
    return $tables
}

function Extract-PrimaryKeys {
    param([hashtable]$Tables)
    $pks = @{}
    foreach ($name in $Tables.Keys) {
        $body = $Tables[$name]
        if ($body -match 'PRIMARY\s+KEY\s*\(`?(\w+)`?\)') {
            $pks[$name] = $Matches[1]
        }
    }
    return $pks
}

function Extract-ForeignKeys {
    param([hashtable]$Tables)
    $fks = @()
    $regex = [regex]::new('CONSTRAINT\s+`?\w+`?\s+FOREIGN\s+KEY\s*\(`?(\w+)`?\)\s*REFERENCES\s+`?(\w+)`?\s*\(`?(\w+)`?\)', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($name in $Tables.Keys) {
        $body = $Tables[$name]
        $matching = $regex.Matches($body)
        foreach ($m in $matching) {
            $fks += @{ from_table = $name; from_col = $m.Groups[1].Value; to_table = $m.Groups[2].Value; to_col = $m.Groups[3].Value }
        }
    }
    return $fks
}

function Extract-Procedures {
    param([string]$Sql)
    $regex = [regex]::new('CREATE\s+(?:OR\s+REPLACE\s+)?DEFINER\s*=\s*`[^`]+`\s*PROCEDURE\s+`?(\w+)`?\s*\((.*?)\)\s*(?:CHARACTER\s+SET|COLLATE|BEGIN|DETERMINISTIC|SQL\s+SECURITY|COMMENT|LANGUAGE)', [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $matches = $regex.Matches($Sql)
    $procedures = @{}
    foreach ($m in $matches) {
        $name = $m.Groups[1].Value
        $params = $m.Groups[2].Value
        $param_count = ([regex]::Matches($params, 'IN\s+|OUT\s+|INOUT\s+', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
        $procedures[$name] = @{
            name = $name
            params = $params
            param_count = $param_count
        }
    }
    return $procedures
}

function Extract-Functions {
    param([string]$Sql)
    $regex = [regex]::new('CREATE\s+(?:OR\s+REPLACE\s+)?DEFINER\s*=\s*`[^`]+`\s*FUNCTION\s+`?(\w+)`?\s*\((.*?)\)\s*(?:RETURNS|CHARACTER\s+SET|COLLATE|DETERMINISTIC|SQL\s+SECURITY|COMMENT|LANGUAGE)', [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $matches = $regex.Matches($Sql)
    $functions = @{}
    foreach ($m in $matches) {
        $name = $m.Groups[1].Value
        $params = $m.Groups[2].Value
        $functions[$name] = @{
            name = $name
            params = $params
        }
    }
    return $functions
}

function Extract-Views {
    param([string]$Sql)
    $regex = [regex]::new('CREATE\s+(?:OR\s+REPLACE\s+)?(?:ALGORITHM\s*=\s*\w+\s+)?DEFINER\s*=\s*`[^`]+`\s+VIEW\s+`?(\w+)`?\s+AS\s+(.*?)(?=;\s*CREATE|$)', [System.Text.RegularExpressions.RegexOptions]::Singleline -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $matches = $regex.Matches($Sql)
    $views = @{}
    foreach ($m in $matches) {
        $name = $m.Groups[1].Value
        $definition = $m.Groups[2].Value.Trim()
        if ($definition.Length -gt 200) { $definition = $definition.Substring(0, 200) + "..." }
        $views[$name] = $definition
    }
    return $views
}

function Extract-Calls {
    param([hashtable]$Procedures, [hashtable]$Functions, [string]$Sql)
    $calls = @{}
    $allNames = @($Procedures.Keys) + @($Functions.Keys)
    foreach ($name in $allNames) {
        $escaped = [regex]::Escape($name)
        $pattern = "(?i)CALL\s+$escaped\b|\b$escaped\s*\("
        $count = ([regex]::Matches($Sql, $pattern)).Count
        if ($count -gt 0) {
            $calls[$name] = $count
        }
    }
    return $calls
}

function Resolve-Domain {
    param([string]$Name)
    $n = $Name.ToLower()
    switch -Regex ($n) {
        '^(pessoa|usuario|sessao|portal|tenant|entidade|unidade|setor|sistema|perfil|permissao|grupo|papel|acl|login|auth|token|bloqueio|log_acesso|reset_senha|refresh|contexto|alocacao|profissional|vinculo|endereco|telefone|documento|email|alergia|conselho|identificador|logradouro|especialidade|funcionario|medico|colaborador|rh|registro_profissional)' { return 'CORE'; break }
        '^(senha|fila|triagem|totem|ffa|atendimento|internacao|triage|sumario|desfecho|movimentacao|pre_hospitalar|acompanhante|checagem|identidade|reabertura|evolucao|anamnese|exame|pedido|solicitacao_exame|prescricao|medicacao|administracao|aprazamento|diagnostico|sinais|vital|alta|obito|interconsulta|internacao|cuidados|dietas|dispositivos|ferida|braden|medicamento|dispensacao|reavaliacao|prescritor|ordem|procedimento|protocolo|protocolo_sequencia|lab|amostra|resultado|exame_fisico|historico_exame|pedido_medico|intercorrencia|transferencia|remocao|ambulancia|viatura|gaso|gasoterapia|cat|notificacao|epidemiologica|violencia|assinatura|documento|arquivo|emissao|tipo_documento|tipo_config|painel|config|local|dispositivo|tipo_local|tipo_sala|sala|capacidade|fila|turno|leito|leitos|tv|rotativo|display|painel|totem)' { return 'HIS'; break }
        '^(farmac|farm|estoque|almoxarifado|produto|lote|saldo|movimento|inventario|reserva|pipeline|conciliacao|fluxo_estoque|consumo|insumo|limpeza|manutencao|audit_stream|ledger|documento_execucao|execucao)' { return 'FARMACY'; break }
        '^(faturamento|conta|convenio|item|producao|sigtap|tuss|codigo|regra_validacao|sus|competencia|cnes|cid10|pdv|venda|pagamento|cliente|forma|caixa)' { return 'BILLING'; break }
        '^(financeiro|repasse|medico|faturamento|conta|pagamento|caixa|pdv|venda)' { return 'FINANCE'; break }
        '^(crm|chamado|manutencao|suporte|sac|ouvidoria|solicitacao|ticket|cliente)' { return 'CRM'; break }
        '^(agenda|agendamento|disponibilidade|escala|plantao|turno|alocacao)' { return 'SCHEDULE'; break }
        '^(bi|indicador|dashboard|relatorio|analytics|painel_monitoramento|painel_fila|painel_local|painel_lane|painel_grupo|painel_config|painel_evento|painel_mensagem|painel_consumo|painel_alertas)' { return 'BI'; break }
        '^(integracao|webhook|endpoint|mensageria|externa|n8n|api|sincronizacao|federada|reconciliacao|edge|evento)' { return 'INTEGRATION'; break }
        '^(automacao|workflow|fluxo|transicao|status|substatus|prioridade|evento|tempo|timeout|excecao|erro|cat)' { return 'WORKFLOW'; break }
        default { return 'GENERIC'; break }
    }
}

function Group-ByDomain {
    param([hashtable]$Tables)
    $byDomain = @{}
    foreach ($name in $Tables.Keys) {
        $domain = Resolve-Domain -Name $name
        if (-not $byDomain.ContainsKey($domain)) { $byDomain[$domain] = @() }
        $byDomain[$domain] += $name
    }
    return $byDomain
}

function Build-ModuleMap {
    param([hashtable]$ByDomain)
    $map = @()
    foreach ($domain in $ByDomain.Keys) {
        $tables = $ByDomain[$domain]
        $modules = @()
        if ($domain -eq 'HIS') {
            $modules = @('auth','contexto','recepcao','triagem','consultorio','enfermagem','internacao','gpat','ffa','senha','fila','totem','painel','documentos')
        } elseif ($domain -eq 'CORE') {
            $modules = @('auth','tenant','context','portal','identity','professionals')
        } elseif ($domain -eq 'FARMACY') {
            $modules = @('farmacia','estoque','dispensacao')
        } elseif ($domain -eq 'BILLING') {
            $modules = @('faturamento','financeiro','sus')
        } elseif ($domain -eq 'FINANCE') {
            $modules = @('financeiro','faturamento','pdv')
        } elseif ($domain -eq 'CRM') {
            $modules = @('sac','ouvidoria','chamados')
        } elseif ($domain -eq 'SCHEDULE') {
            $modules = @('agenda','plantao','escala')
        } elseif ($domain -eq 'BI') {
            $modules = @('bi','dashboards','analytics')
        } elseif ($domain -eq 'INTEGRATION') {
            $modules = @('integracoes','n8n','webhooks')
        } elseif ($domain -eq 'WORKFLOW') {
            $modules = @('workflow','automacoes','fila')
        } else {
            $modules = @('generic')
        }
        $map += @{ domain = $domain; table_count = $tables.Count; modules = $modules }
    }
    return $map
}

function Build-UIMap {
    param([hashtable]$ByDomain, [hashtable]$Tables)
    $map = @{ devices = @{}; flows = @{} }
    $map.devices['totem'] = @('senha','fila','totem')
    $map.devices['painel'] = @('fila','tv_rotativo','painel')
    $map.devices['mobile'] = @('recepcao','triagem','atendimento')
    $map.devices['tablet'] = @('enfermagem','medicacao')
    $map.devices['kiosk'] = @('atendimento','contexto')
    $map.devices['tv'] = @('tv_rotativo','painel')

    $map.flows['entrada_paciente'] = @('contexto','senha','fila','triagem')
    $map.flows['atendimento_medico'] = @('atendimento','prescricao','exame','internacao')
    $map.flows['triagem'] = @('triagem','classificacao_risco','senha')
    $map.flows['farmacia'] = @('farmacia','dispensacao','estoque')
    $map.flows['faturamento'] = @('faturamento','conta','convenio','producao')
    $map.flows['recepcao'] = @('recepcao','agendamento','contexto')
    $map.flows['laboratorio'] = @('lab','amostra','protocolo','resultado')
    $map.flows['internacao'] = @('internacao','leito','prescricao','enfermagem','evolucao')
    $map.flows['fila'] = @('fila','senha','chamada','timeout','retorno')
    $map.flows['ffa'] = @('ffa','item','gpat','prioridade','transicao')
    return $map
}

function Build-CallGraph {
    param([hashtable]$Calls)
    $graph = @{ nodes = @(); edges = @() }
    foreach ($name in $Calls.Keys) {
        $graph.nodes += $name
    }
    return $graph
}

function Build-RelationshipMatrix {
    param([array]$Fks, [hashtable]$Tables)
    $matrix = @{ edges = @(); density = 0 }
    $total = $Tables.Count
    if ($total -eq 0) { return $matrix }
    foreach ($fk in $Fks) {
        $matrix.edges += @{ from = $fk.from_table; to = $fk.to_table; from_col = $fk.from_col; to_col = $fk.to_col }
    }
    $possible = $total * ($total - 1)
    if ($possible -gt 0) { $matrix.density = [math]::Round(($matrix.edges.Count / $possible), 4) }
    return $matrix
}

function Build-SPDependencies {
    param([hashtable]$Procedures, [hashtable]$Calls)
    $deps = @()
    foreach ($name in $Calls.Keys) {
        $deps += @{ sp = $name; calls = $Calls[$name] }
    }
    return $deps | Sort-Object calls -Descending
}

function Build-FKMap {
    param([array]$Fks, [hashtable]$Tables)
    $map = @{}
    foreach ($fk in $Fks) {
        $key = "$($fk.from_table).$($fk.from_col)"
        if (-not $map.ContainsKey($key)) { $map[$key] = @() }
        $map[$key] += @{ table = $fk.to_table; col = $fk.to_col }
    }
    return $map
}

function Build-ExtendedContracts {
    param([hashtable]$Procedures)
    $contracts = @()
    foreach ($name in $Procedures.Keys) {
        $domain = Resolve-Domain -Name $name
        $contracts += @{
            sp = $name
            domain = $domain
            params = $Procedures[$name].params
            param_count = $Procedures[$name].param_count
            tenant_required = $true
        }
    }
    return $contracts
}

# =============================================================================
# MAIN
# =============================================================================

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptRoot
$projectRoot = Split-Path -Parent $projectRoot

$dumpPath = Join-Path $projectRoot $DumpPath
$outputDir = Join-Path $projectRoot $OutputDir

if ($SkipIfExists -and (Test-Path -LiteralPath $outputDir)) {
    Write-Host "⏭️  Baseline já existe em $outputDir. Use -SkipIfExists:`$false para sobrescrever." -ForegroundColor Yellow
    exit 0
}

Ensure-Path -path $outputDir

$sql = Read-Dump -Path $dumpPath

Write-Host "🧠 KILO ENGINE v8 — Executando baseline canônico..." -ForegroundColor Cyan
Write-Host "📂 Saída: $outputDir" -ForegroundColor Cyan

Write-Host "1/7 Extraindo tabelas..." -ForegroundColor Magenta
$tables = Extract-Tables -Sql $sql

Write-Host "2/7 Extraindo chaves primárias..." -ForegroundColor Magenta
$pks = Extract-PrimaryKeys -Tables $tables

Write-Host "3/7 Extraindo chaves estrangeiras..." -ForegroundColor Magenta
$fks = Extract-ForeignKeys -Tables $tables

Write-Host "4/7 Extraindo stored procedures..." -ForegroundColor Magenta
$procedures = Extract-Procedures -Sql $sql

Write-Host "5/7 Extraindo functions..." -ForegroundColor Magenta
$functions = Extract-Functions -Sql $sql

Write-Host "6/7 Extraindo views..." -ForegroundColor Magenta
$views = Extract-Views -Sql $sql

Write-Host "7/7 Analisando relacionamentos e dependências..." -ForegroundColor Magenta
$calls = Extract-Calls -Procedures $procedures -Functions $functions -Sql $sql

Write-Host "🏗️ Agrupando por domínio..." -ForegroundColor Magenta
$byDomain = Group-ByDomain -Tables $tables
$moduleMap = Build-ModuleMap -ByDomain $byDomain
$uiMap = Build-UIMap -ByDomain $byDomain -Tables $tables
$callGraph = Build-CallGraph -Calls $calls
$matrix = Build-RelationshipMatrix -Fks $fks -Tables $tables
$spDeps = Build-SPDependencies -Procedures $procedures -Calls $calls
$fkMap = Build-FKMap -Fks $fks -Tables $tables
$contracts = Build-ExtendedContracts -Procedures $procedures

# =============================================================================
# EXPORT
# =============================================================================

Write-Host "💾 Exportando artefatos..." -ForegroundColor Cyan

$artifactPath = Join-Path $outputDir "kilo-tables-by-domain.json"
$byDomain | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-procedures-catalog.json"
$procedures.Values | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-functions-catalog.json"
$functions.Values | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-views.json"
$views.Values | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-domain-map.json"
@{
    generated_at = (Get-Date -Format "o")
    source = "Dump20260606.sql"
    status = "FROZEN"
    total_tables = $tables.Count
    total_procedures = $procedures.Count
    total_functions = $functions.Count
    total_views = $views.Count
    total_fks = $fks.Count
    domains = $byDomain.Keys | Sort-Object
    by_domain = $byDomain
    pks_count = $pks.Count
    call_graph_nodes = $callGraph.nodes.Count
    relationship_density = $matrix.density
} | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-callgraph.json"
$callGraph | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-sp-dependencies.json"
$spDeps | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-table-dependencies.json"
$matrix | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-fk-map.json"
$fkMap | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-module-map.json"
$moduleMap | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-ui-map.json"
$uiMap | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-frontend-contracts.json"
@{
    source = "Dump20260606.sql"
    total_contracts = $contracts.Count
    contracts = $contracts
} | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-relationships.txt"
$out = @()
$out += "TABLES: $($tables.Count)"
$out += "PROCEDURES: $($procedures.Count)"
$out += "FUNCTIONS: $($functions.Count)"
$out += "VIEWS: $($views.Count)"
$out += "FOREIGN_KEYS: $($fks.Count)"
$out += "PRIMARY_KEYS: $($pks.Count)"
$out += "RELATIONSHIP_DENSITY: $($matrix.density)"
$out += ""
$out += "BY DOMAIN:"
foreach ($d in ($byDomain.Keys | Sort-Object)) {
    $out += "  $d : $($byDomain[$d].Count) tables"
}
$out += ""
$out += "TOP PROCEDURES BY CALL COUNT:"
foreach ($dep in ($spDeps | Select-Object -First 20)) {
    $out += "  $($dep.sp) => $($dep.calls)"
}
$out += ""
$out += "TOP FK RELATIONSHIPS:"
foreach ($edge in ($matrix.edges | Select-Object -First 20)) {
    $out += "  $($edge.from).$($edge.from_col) -> $($edge.to).$($edge.to_col)"
}
Set-Content -LiteralPath $artifactPath -Value ($out -join "`n") -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-frontend-summary.md"
$summary = @"
# KILO ENGINE v8 — Frontend Summary

> **Status:** FROZEN BASELINE  
> **Source:** `legacy/backend_antigo/sql/Dump20260606.sql`  
> **Generated:** $(Get-Date -Format 'yyyy-MM-dd HH:mm')

## Numbers

| Metric | Count |
|--------|-------|
| Tables | $($tables.Count) |
| Procedures | $($procedures.Count) |
| Functions | $($functions.Count) |
| Views | $($views.Count) |
| Foreign Keys | $($fks.Count) |
| Primary Keys | $($pks.Count) |
| Call Graph Nodes | $($callGraph.nodes.Count) |
| Relationship Density | $($matrix.density) |

## Domains

| Domain | Tables | Modules |
|--------|--------|---------|
"@
foreach ($entry in ($moduleMap | Sort-Object table_count -Descending)) {
    $summary += "| $($entry.domain) | $($entry.table_count) | $($entry.modules -join ', ') |`n"
}
$summary += @"
## Top Procedures

| Procedure | Calls |
|-----------|-------|
"@
foreach ($dep in ($spDeps | Select-Object -First 15)) {
    $summary += "| $($dep.sp) | $($dep.calls) |`n"
}
$summary += @"
## Frontend Readiness

- Total front contracts extracted: **$($contracts.Count)**
- Devices mapped: **$($uiMap.devices.Keys.Count)**
- Clinical flows mapped: **$($uiMap.flows.Keys.Count)**

## Next Steps

1. Validate this baseline against current running DB.
2. Freeze artifacts in version control.
3. Generate SP client SDKs from `kilo-frontend-contracts.json`.
4. Generate backend controllers/routes from `kilo-procedures-catalog.json`.
5. Generate React hooks/stores from `kilo-tables-by-domain.json`.

---
*Generated by KILO ENGINE v8*
"@
Set-Content -LiteralPath $artifactPath -Value $summary -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-api-endpoints.json"
$endpoints = @()
foreach ($proc in $procedures.Values) {
    $domain = Resolve-Domain -Name $proc.name
    $base = $proc.name -replace '^sp_', '' -replace '_', '/'
    $endpoints += @{
        method = 'POST'
        path = "/api/$domain/$base"
        procedure = $proc.name
        domain = $domain
        params = $proc.param_count
    }
}
$endpoints | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $artifactPath -Encoding UTF8

$artifactPath = Join-Path $outputDir "kilo-inventory.txt"
$inv = @()
$inv += "=== KILO v8 CANONICAL INVENTORY ==="
$inv += ""
$inv += "TABLES: $($tables.Count)"
$inv += "PROCEDURES: $($procedures.Count)"
$inv += "FUNCTIONS: $($functions.Count)"
$inv += "VIEWS: $($views.Count)"
$inv += "FKS: $($fks.Count)"
$inv += "PKS: $($pks.Count)"
$inv += ""
$inv += "=== DOMAINS ==="
foreach ($d in ($byDomain.Keys | Sort-Object)) {
    $inv += "$d : $($byDomain[$d].Count) tables"
}
$inv += ""
$inv += "=== TABLES ==="
foreach ($name in ($tables.Keys | Sort-Object)) {
    $pk = if ($pks.ContainsKey($name)) { $pks[$name] } else { '' }
    $inv += "$name | PK:$pk"
}
$inv += ""
$inv += "=== PROCEDURES ==="
foreach ($name in ($procedures.Keys | Sort-Object)) {
    $inv += "$name"
}
$inv += ""
$inv += "=== FUNCTIONS ==="
foreach ($name in ($functions.Keys | Sort-Object)) {
    $inv += "$name"
}
$inv += ""
$inv += "=== VIEWS ==="
foreach ($name in ($views.Keys | Sort-Object)) {
    $inv += "$name"
}
Set-Content -LiteralPath $artifactPath -Value ($inv -join "`n") -Encoding UTF8

Write-Host ""
Write-Host "✅ KILO ENGINE v8 concluído com sucesso!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Artefatos em: $outputDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "📄 Arquivos gerados:" -ForegroundColor White
Get-ChildItem -LiteralPath $outputDir -File | ForEach-Object {
    Write-Host "  - $($_.Name) ($($_.Length) bytes)" -ForegroundColor Gray
}
Write-Host ""
Write-Host "🚀 Próximo: valide o baseline e execute o v9/codegen." -ForegroundColor Yellow
