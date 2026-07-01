$ErrorActionPreference = 'SilentlyContinue'
$rawDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures_raw"
$outDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures"

if (!(Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$files = Get-ChildItem -LiteralPath $rawDir -Filter "*.json" | Sort-Object Name

foreach ($f in $files) {
    $raw = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8
    $json = $raw | ConvertFrom-Json
    $name = $json.name
    $text = $json.text
    
    # Remove backticks e aspas do nome para uso interno se necessário
    $cleanName = $name
    
    # Extrai parâmetros
    $params = @()
    if ($text -match 'CREATE\s+DEFINER[^`]+`\w+`@`[^`]+`\s+PROCEDURE\s+`\w+`\s*\(([\s\S]*?)\)\s*(AS\s*)?(?:\s*SQL\s+SECURITY\s+\w+\s*)?BEGIN') {
        $paramBlock = $Matches[1]
        foreach ($line in ($paramBlock -split "`n")) {
            $line = $line.Trim()
            if ($line -match '^(IN|OUT|INOUT)\s+([\w]+)\s+([\w]+(?:\([^)]*\))?)\s*$') {
                $params += "$($Matches[2])|$($Matches[3])|$($Matches[1])"
            }
        }
    }
    
    # Identifica variáveis declaradas para filtrar de tabelas/funções/views
    $declaredVars = @()
    foreach ($m in [regex]::Matches($text, '(?i)DECLARE\s+((?:\s*\w+\s+\w+,?\s*)+);')) {
        $declStr = $m.Groups[1].Value
        foreach ($v in ($declStr -split ',')) {
            if ($v -match '^\s*([\w_]+)\s+') { $declaredVars += $Matches[1].Trim() }
        }
    }
    
    # Tabelas
    $tablesSelect = @(); $tablesInsert = @(); $tablesUpdate = @(); $tablesDelete = @()
    foreach ($m in [regex]::Matches($text, '(?i)(?:FROM|JOIN|TABLE)\s+(\w+)')) {
        if ($declaredVars -notcontains $m.Groups[1].Value) { $tablesSelect += $m.Groups[1].Value }
    }
    foreach ($m in [regex]::Matches($text, '(?i)INSERT\s+INTO\s+(\w+)')) {
        if ($declaredVars -notcontains $m.Groups[1].Value) { $tablesInsert += $m.Groups[1].Value }
    }
    foreach ($m in [regex]::Matches($text, '(?i)UPDATE\s+(\w+)\s+SET')) {
        if ($declaredVars -notcontains $m.Groups[1].Value) { $tablesUpdate += $m.Groups[1].Value }
    }
    foreach ($m in [regex]::Matches($text, '(?i)DELETE\s+FROM\s+(\w+)')) {
        if ($declaredVars -notcontains $m.Groups[1].Value) { $tablesDelete += $m.Groups[1].Value }
    }
    $tablesSelect = $tablesSelect | Sort-Object -Unique
    $tablesInsert = $tablesInsert | Sort-Object -Unique
    $tablesUpdate = $tablesUpdate | Sort-Object -Unique
    $tablesDelete = $tablesDelete | Sort-Object -Unique
    
    # Chamadas
    $calls = @()
    foreach ($m in [regex]::Matches($text, '(?i)CALL\s+(\w+)')) { $calls += $m.Groups[1].Value }
    $calls = $calls | Sort-Object -Unique
    
    # Functions
    $funcs = @()
    $funcList = @('SHA2','JSON_UNQUOTE','JSON_EXTRACT','JSON_OBJECT','JSON_ARRAY','JSON_CONTAINS','JSON_LENGTH','JSON_VALID','IFNULL','COALESCE','NOW','CURRENT_TIMESTAMP','CURRENT_DATE','LAST_INSERT_ID','CONCAT','CONCAT_WS','UPPER','LOWER','LENGTH','TRIM','LTRIM','RTRIM','COUNT','SUM','MAX','MIN','AVG','DATE_FORMAT','DATE_ADD','DATE_SUB','DATEDIFF','TIMESTAMPDIFF','CAST','CONVERT','IF','NULLIF','ISNULL','FOUND_ROWS','ROW_COUNT','SIGNAL','RESIGNAL','GET_LOCK','RELEASE_LOCK','UUID','UUID_TO_BIN','BIN_TO_UUID','AES_ENCRYPT','AES_DECRYPT','MD5','SHA1','SHA2','LEFT','RIGHT','SUBSTRING','SUBSTRING_INDEX','LOCATE','POSITION','INSTR','REPLACE','REPEAT','SPACE','REVERSE','STRCMP','FORMAT','ROUND','CEIL','CEILING','FLOOR','TRUNCATE','ABS','SIGN','MOD','POWER','EXP','LN','LOG','LOG10','LOG2','SQRT','PI','RAND','DEGREES','RADIANS','SIN','COS','TAN','ASIN','ACOS','ATAN','ATAN2','COT','BIT_LENGTH','CHAR_LENGTH','CHARACTER_LENGTH','FIND_IN_SET','INET_ATON','INET_NTOA','IS_IPV4','IS_IPV6')
    foreach ($fn in $funcList) {
        if ($text -match "\b$fn\b") { $funcs += $fn }
    }
    $funcs = $funcs | Sort-Object -Unique
    
    # Views
    $views = @()
    foreach ($m in [regex]::Matches($text, '\b(vw|view|v)_\w+\b')) { 
        if ($declaredVars -notcontains $m.Value) { $views += $m.Value }
    }
    $views = $views | Sort-Object -Unique
    
    # Events
    $events = @()
    $eventTables = @('auditoria_evento','evento','log_evento','ledger_evento','senha_eventos','historico','historico_evento','fluxo_evento')
    foreach ($et in $eventTables) {
        if ($text -match $et) { $events += $et }
    }
    $events = $events | Sort-Object -Unique
    
    # Error handling
    $hasHandler = $false; $hasSignal = $false
    if ($text -match 'DECLARE\s+(EXIT|CONTINUE)\s+HANDLER') { $hasHandler = $true }
    if ($text -match 'SIGNAL\s+SQLSTATE|RESIGNAL') { $hasSignal = $true }
    
    # Transactions
    $hasCommit = $false; $hasRollback = $false
    if ($text -match '(?i)COMMIT') { $hasCommit = $true }
    if ($text -match '(?i)ROLLBACK') { $hasRollback = $true }
    
    # Logic explanation
    $lines = $text -split "`n"
    $logicLines = New-Object System.Collections.Generic.List[string]
    $ln = 0
    foreach ($line in $lines) {
        $ln++
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) { continue }
        
        if ($trimmed -match '^--') {
            $comment = $trimmed -replace '^--\s*',''
            $logicLines.Add("- **Linha $ln** (comentário): $comment")
        } elseif ($trimmed -match '^CREATE\s+DEFINER') {
            $logicLines.Add("- **Linha $ln**: Definição da procedure com o definer.")
        } elseif ($trimmed -match '^PROCEDURE\s+`?\w+`?\s*\(') {
            $logicLines.Add("- **Linha $ln**: Declaração do nome da procedure e seus parâmetros.")
        } elseif ($trimmed -match '^(IN|OUT|INOUT)\s+\w+\s+\w+') {
            $logicLines.Add("- **Linha $ln**: Declaração de parâmetro.")
        } elseif ($trimmed -match '^BEGIN$') {
            $logicLines.Add("- **Linha $ln**: Início do bloco de execução.")
        } elseif ($trimmed -match '^DECLARE\s+(\w+)\s+') {
            $logicLines.Add("- **Linha $ln**: Declaração de variável local `$($Matches[1])`.")
        } elseif ($trimmed -match '^SET\s+(\w+)\s*=') {
            $logicLines.Add("- **Linha $ln**: Atribuição de valor à variável `$($Matches[1])`.")
        } elseif ($trimmed -match '^SELECT\s+') {
            $logicLines.Add("- **Linha $ln**: Execução de query SELECT para consulta de dados.")
        } elseif ($trimmed -match '^INSERT\s+INTO\s+(\w+)') {
            $logicLines.Add("- **Linha $ln**: Insere um novo registro na tabela `$($Matches[1])`.")
        } elseif ($trimmed -match '^ON\s+DUPLICATE\s+KEY\s+UPDATE') {
            $logicLines.Add("- **Linha $ln**: Atualiza o registro se a chave única já existir (UPSERT).")
        } elseif ($trimmed -match '^UPDATE\s+(\w+)\s+SET') {
            $logicLines.Add("- **Linha $ln**: Atualiza registros existentes na tabela `$($Matches[1])`.")
        } elseif ($trimmed -match '^DELETE\s+FROM\s+(\w+)') {
            $logicLines.Add("- **Linha $ln**: Remove registros da tabela `$($Matches[1])`.")
        } elseif ($trimmed -match '^CALL\s+(\w+)') {
            $logicLines.Add("- **Linha $ln**: Invoca a procedure `$($Matches[1])`.")
        } elseif ($trimmed -match '^(IF|ELSEIF|ELSE|END\s+IF)') {
            $logicLines.Add("- **Linha $ln**: Estrutura condicional de controle de fluxo.")
        } elseif ($trimmed -match '^(WHILE|LOOP|REPEAT|UNTIL|LEAVE|ITERATE)') {
            $logicLines.Add("- **Linha $ln**: Estrutura de repetição/controle de loop.")
        } elseif ($trimmed -match '^END\s*;;?\s*$') {
            $logicLines.Add("- **Linha $ln**: Fim do bloco da procedure.")
        } elseif ($trimmed -match '^(AND|OR)\s+') {
            continue
        } else {
            $logicLines.Add("- **Linha $ln**: $trimmed")
        }
    }
    
    # Build markdown
    $md = New-Object System.Collections.Generic.List[string]
    [void]$md.Add("# $cleanName")
    [void]$md.Add("")
    
    # Infer objective
    $objName = $cleanName -replace '^sp_','' -replace '_',' '
    [void]$md.Add("Objetivo: $objName conforme definida no dump SQL do sistema.")
    [void]$md.Add("")
    
    [void]$md.Add("## Parâmetros")
    [void]$md.Add("| Nome | Tipo | Direção | Descrição |")
    [void]$md.Add("|------|------|---------|-----------|")
    if ($params.Count -eq 0) {
        [void]$md.Add("| - | - | - | Nenhum parâmetro declarado. |")
    } else {
        foreach ($p in $params) {
            $parts = $p -split '\|'
            [void]$md.Add("| $($parts[0]) | $($parts[1]) | $($parts[2]) | |")
        }
    }
    [void]$md.Add("")
    
    [void]$md.Add("## Retorno")
    [void]$md.Add("")
    [void]$md.Add("Procedure sem valor de retorno explícito (procedimento SQL).")
    [void]$md.Add("")
    
    [void]$md.Add("## Validações")
    [void]$md.Add("")
    [void]$md.Add("- Validações implementadas diretamente no corpo da procedure via queries SELECT INTO e verificações de contagem/condição.")
    [void]$md.Add("")
    
    [void]$md.Add("## Regras de Negócio")
    [void]$md.Add("")
    [void]$md.Add("- Regras implícitas na lógica da procedure, verificadas via relacionamentos entre tabelas e restrições em cláusulas WHERE e JOIN.")
    [void]$md.Add("")
    
    [void]$md.Add("## Tabelas Utilizadas")
    [void]$md.Add("- SELECT: $(if ($tablesSelect.Count -gt 0) { $tablesSelect -join ', ' } else { '(nenhuma)' })")
    [void]$md.Add("- INSERT: $(if ($tablesInsert.Count -gt 0) { $tablesInsert -join ', ' } else { '(nenhuma)' })")
    [void]$md.Add("- UPDATE: $(if ($tablesUpdate.Count -gt 0) { $tablesUpdate -join ', ' } else { '(nenhuma)' })")
    [void]$md.Add("- DELETE: $(if ($tablesDelete.Count -gt 0) { $tablesDelete -join ', ' } else { '(nenhuma)' })")
    [void]$md.Add("")
    
    [void]$md.Add("## Chamadas para outras Procedures")
    if ($calls.Count -gt 0) { foreach ($c in $calls) { [void]$md.Add("- $c") } } else { [void]$md.Add("- (nenhuma)") }
    [void]$md.Add("")
    
    [void]$md.Add("## Functions Utilizadas")
    if ($funcs.Count -gt 0) { foreach ($f in $funcs) { [void]$md.Add("- $f") } } else { [void]$md.Add("- (nenhuma)") }
    [void]$md.Add("")
    
    [void]$md.Add("## Views Utilizadas")
    if ($views.Count -gt 0) { foreach ($v in $views) { [void]$md.Add("- $v") } } else { [void]$md.Add("- (nenhuma)") }
    [void]$md.Add("")
    
    [void]$md.Add("## Eventos Gerados")
    if ($events.Count -gt 0) { foreach ($e in $events) { [void]$md.Add("- $e") } } else { [void]$md.Add("- (nenhum)") }
    [void]$md.Add("")
    
    [void]$md.Add("## Tratamento de Erros")
    [void]$md.Add("")
    if ($hasHandler) { [void]$md.Add("- Handler de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).") }
    if ($hasSignal) { [void]$md.Add("- Uso de SIGNAL/RESIGNAL para gerar erros customizados.") }
    if (-not $hasHandler -and -not $hasSignal) { [void]$md.Add("- Sem tratamento de erro explícito detectado.") }
    [void]$md.Add("")
    
    [void]$md.Add("## Transações")
    [void]$md.Add("- TRY/CATCH: $(if ($hasCommit -or $hasRollback) { 'Não aplicável (MySQL não usa TRY/CATCH nativo em stored procedures, usa DECLARE HANDLER)' } else { 'Não aplicável' })")
    [void]$md.Add("- Rollback: $(if ($hasRollback) { 'Sim' } else { 'Não detectado' })")
    [void]$md.Add("- Commit: $(if ($hasCommit) { 'Sim' } else { 'Não detectado' })")
    [void]$md.Add("")
    
    [void]$md.Add("## Lógica Linha por Linha")
    [void]$md.Add("")
    foreach ($item in $logicLines) { [void]$md.Add($item) }
    [void]$md.Add("")
    [void]$md.Add("### Código Fonte Completo")
    [void]$md.Add("")
    [void]$md.Add("```sql")
    [void]$md.Add($text)
    [void]$md.Add("```")
    [void]$md.Add("")
    
    $outPath = Join-Path $outDir "$cleanName.md"
    [System.IO.File]::WriteAllLines($outPath, $md, [System.Text.Encoding]::UTF8)
    $count++
}

Write-Host "Documentadas $count procedures."
