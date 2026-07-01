$ErrorActionPreference = 'SilentlyContinue'
$rawDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures_raw"
$outDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures"

if (!(Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$files = Get-ChildItem -LiteralPath $rawDir -Filter "*.json" | Sort-Object Name

foreach ($f in $files) {
    $json = Get-Content -LiteralPath $f.FullName -Raw | ConvertFrom-Json
    $name = $json.name
    $text = $json.text
    
    # Extrai parâmetros
    $params = @()
    if ($text -match '\(\s*([\s\S]*?)\)\s*BEGIN|\r?\nBEGIN') {
        $paramBlock = $Matches[1]
        foreach ($line in $paramBlock -split "`n") {
            $line = $line.Trim()
            if ($line -match '^(IN|OUT|INOUT)\s+(\w+)\s+(\w+\([^)]*\)|\w+)') {
                $params += [ordered]@{
                    Nome = $Matches[2]
                    Tipo = $Matches[3]
                    Direcao = $Matches[1]
                }
            }
        }
    }
    
    # Tabelas utilizadas por operação
    $tablesSelect = @(); $tablesInsert = @(); $tablesUpdate = @(); $tablesDelete = @()
    $tablesFrom = @()
    
    if ($text -match 'FROM\s+(\w+)') { $tablesFrom += $Matches[1] }
    if ($text -match 'JOIN\s+(\w+)') { $tablesFrom += $Matches[1] }
    if ($text -match 'INTO\s+(\w+)') { $tablesInsert += $Matches[1] }
    if ($text -match 'INSERT\s+INTO\s+(\w+)') { $tablesInsert += $Matches[1] }
    if ($text -match 'UPDATE\s+(\w+)') { $tablesUpdate += $Matches[1] }
    if ($text -match 'DELETE\s+FROM\s+(\w+)') { $tablesDelete += $Matches[1] }
    
    $tablesFrom = $tablesFrom | Sort-Object -Unique
    $tablesSelect = $tablesFrom
    $tablesInsert = $tablesInsert | Sort-Object -Unique
    $tablesUpdate = $tablesUpdate | Sort-Object -Unique
    $tablesDelete = $tablesDelete | Sort-Object -Unique
    
    # Chamadas a outras procedures
    $calls = @()
    if ($text -match 'CALL\s+(\w+)') {
        foreach ($m in [regex]::Matches($text, 'CALL\s+(\w+)')) { $calls += $m.Groups[1].Value }
    }
    $calls = $calls | Sort-Object -Unique
    
    # Functions utilizadas
    $funcs = @()
    $funcPatterns = @('\bSHA2\b','\bJSON_UNQUOTE\b','\bJSON_EXTRACT\b','\bJSON_OBJECT\b','\bIFNULL\b','\bCOALESCE\b','\bNOW\b','\bCURRENT_TIMESTAMP\b','\bLAST_INSERT_ID\b','\bCONCAT\b','\bUPPER\b','\bLOWER\b','\bLENGTH\b','\bTRIM\b','\bCOUNT\b','\bSUM\b','\bMAX\b','\bMIN\b','\bDATE_FORMAT\b','\bDATE_ADD\b','\bDATE_SUB\b','\bDATEDIFF\b','\bTIMESTAMPDIFF\b','\bCAST\b','\bCONVERT\b','\bIF\b','\bCASE\b','\bNULLIF\b','\bISNULL\b','\bEXISTS\b','\bFOUND_ROWS\b','\bROW_COUNT\b','\bSIGNAL\b','\bRESIGNAL\b','\bGET_LOCK\b','\bRELEASE_LOCK\b','\bIS_USED_LOCK\b','\bRELEASE_ALL_LOCKS\b','\bSLEEP\b','\bUUID\b','\bUUID_TO_BIN\b','\bBIN_TO_UUID\b','\bJSON_ARRAY\b','\bJSON_OBJECT\b','\bJSON_CONTAINS\b','\bJSON_LENGTH\b','\bJSON_VALID\b','\bMDSYS\.ST_GEOMFROMTEXT\b','\bST_ASWKT\b','\bST_WKTTOID\b','\bST_GEOMFROMWKB\b')
    foreach ($p in $funcPatterns) {
        if ($text -match $p) { $funcs += $Matches[0] }
    }
    $funcs = $funcs | Sort-Object -Unique
    
    # Views utilizadas
    $views = @()
    $viewPatterns = @('vw_\w+','view_\w+','v_\w+')
    foreach ($p in $viewPatterns) {
        if ($text -match $p) {
            foreach ($m in [regex]::Matches($text, $p)) { $views += $m.Value }
        }
    }
    $views = $views | Sort-Object -Unique
    
    # Detecta transações ( comentários ou uso de COMMIT/ROLLBACK)
    $hasTryCatch = $false; $hasCommit = $false; $hasRollback = $false
    if ($text -match 'BEGIN\s+TRY|TRY:') { $hasTryCatch = $true }
    if ($text -match 'COMMIT') { $hasCommit = $true }
    if ($text -match 'ROLLBACK') { $hasRollback = $true }
    
    # Detecta handlers de erro
    $hasErrorHandler = $false
    if ($text -match 'DECLARE\s+EXIT\s+HANDLER\s+FOR\s+SQLEXCEPTION|DECLARE\s+CONTINUE\s+HANDLER|DECLARE\s+EXIT\s+HANDLER') { $hasErrorHandler = $true }
    
    # Detecta eventos gerados (INSERTS em tabelas de evento/auditoria)
    $events = @()
    $eventTablePatterns = @('auditoria_evento','evento','log_evento','ledger_evento','senha_eventos','historico','historico_evento','fluxo_evento')
    foreach ($p in $eventTablePatterns) {
        if ($text -match $p) { $events += $p }
    }
    $events = $events | Sort-Object -Unique
    
    # Gera markdown
    $md = "# $name`n`n"
    $md += "Objetivo: Procedure `$name`. Detalhamento extraído do dump SQL.`n`n"
    
    $md += "## Parâmetros`n"
    $md += "| Nome | Tipo | Direção | Descrição |`n"
    $md += "|------|------|---------|-----------|`n"
    foreach ($p in $params) {
        $md += "| $($p.Nome) | $($p.Tipo) | $($p.Direcao) | |`n"
    }
    if ($params.Count -eq 0) { $md += "| (sem parâmetros) | - | - | - |`n" }
    $md += "`n"
    
    $md += "## Retorno`n`n"
    $md += "Procedure sem valor de retorno explícito.`n`n"
    
    $md += "## Validações`n`n"
    $md += "- Nenhuma validação documentada no código-fonte extraído.`n`n"
    
    $md += "## Regras de Negócio`n`n"
    $md += "- Regras implícitas no corpo da procedure.`n`n"
    
    $md += "## Tabelas Utilizadas`n"
    $md += "- SELECT: $($tablesSelect -join ', ')`n"
    $md += "- INSERT: $($tablesInsert -join ', ')`n"
    $md += "- UPDATE: $($tablesUpdate -join ', ')`n"
    $md += "- DELETE: $($tablesDelete -join ', ')`n`n"
    
    $md += "## Chamadas para outras Procedures`n"
    foreach ($c in $calls) { $md += "- $c`n" }
    if ($calls.Count -eq 0) { $md += "- (nenhuma)`n" }
    $md += "`n"
    
    $md += "## Functions Utilizadas`n"
    foreach ($f in $funcs) { $md += "- $f`n" }
    if ($funcs.Count -eq 0) { $md += "- (nenhuma)`n" }
    $md += "`n"
    
    $md += "## Views Utilizadas`n"
    foreach ($v in $views) { $md += "- $v`n" }
    if ($views.Count -eq 0) { $md += "- (nenhuma)`n" }
    $md += "`n"
    
    $md += "## Eventos Gerados`n"
    foreach ($e in $events) { $md += "- $e`n" }
    if ($events.Count -eq 0) { $md += "- (nenhum)`n" }
    $md += "`n"
    
    $md += "## Tratamento de Erros`n`n"
    if ($hasErrorHandler) { $md += "- Handler de erro declarado.`n" } else { $md += "- Sem handler explícito detectado.`n" }
    $md += "`n"
    
    $md += "## Transações`n"
    $md += "- TRY/CATCH: $(if ($hasTryCatch) { 'Sim' } else { 'Não detectado' })`n"
    $md += "- Rollback: $(if ($hasRollback) { 'Sim' } else { 'Não detectado' })`n"
    $md += "- Commit: $(if ($hasCommit) { 'Sim' } else { 'Não detectado' })`n`n"
    
    $md += "## Lógica Linha por Linha`n`n"
    $md += "```sql`n$text`n````n`n"
    
    $outPath = Join-Path $outDir "$name.md"
    Set-Content -LiteralPath $outPath -Value $md -Encoding UTF8
}

Write-Host "Documentadas $($files.Count) procedures."
