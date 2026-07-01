$ErrorActionPreference = 'SilentlyContinue'
$rawDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures_raw"
$outDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures"

if (!(Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

$files = Get-ChildItem -LiteralPath $rawDir -Filter "*.json" | Sort-Object Name

foreach ($f in $files) {
    $jsonText = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8
    $json = $jsonText | ConvertFrom-Json
    $name = $json.name
    $text = $json.text
    
    # Normaliza quebras de linha
    $text = $text -replace "`r`n", "`n"
    
    # Parse parâmetros linha por linha
    $params = @()
    $inParams = $false
    $paramLines = @()
    foreach ($line in ($text -split "`n")) {
        $trimmed = $line.Trim()
        if ($trimmed -match 'PROCEDURE\s+') {
            $inParams = $true
            continue
        }
        if ($inParams) {
            if ($trimmed -eq ')' -or $trimmed -match '^(BEGIN|AS\s+BEGIN|SQL\s+SECURITY)') {
                break
            }
            $paramLines += $trimmed
        }
    }
    
    foreach ($line in $paramLines) {
        if ($line -match '^(IN|OUT|INOUT)\s+([\w]+)\s+([\w]+(?:\([^)]*\))?)\s*,?\s*$') {
            $params += "$($Matches[2])|$($Matches[3])|$($Matches[1])"
        }
    }
    
    # Variáveis declaradas
    $declaredVars = @()
    foreach ($m in [regex]::Matches($text, '(?i)DECLARE\s+((?:\s*\w+\s+\w+,?\s*)+);')) {
        $declStr = $m.Groups[1].Value
        foreach ($v in ($declStr -split ',')) {
            if ($v -match '^\s*([\w_]+)\s+') { $declaredVars += $Matches[1].Trim() }
        }
    }
    
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
    
    $calls = @()
    foreach ($m in [regex]::Matches($text, '(?i)CALL\s+(\w+)')) { $calls += $m.Groups[1].Value }
    $calls = $calls | Sort-Object -Unique
    
    $funcs = @()
    $funcList = @('SHA2','JSON_UNQUOTE','JSON_EXTRACT','JSON_OBJECT','JSON_ARRAY','JSON_CONTAINS','JSON_LENGTH','JSON_VALID','IFNULL','COALESCE','NOW','CURRENT_TIMESTAMP','CURRENT_DATE','LAST_INSERT_ID','CONCAT','CONCAT_WS','UPPER','LOWER','LENGTH','TRIM','LTRIM','RTRIM','COUNT','SUM','MAX','MIN','AVG','DATE_FORMAT','DATE_ADD','DATE_SUB','DATEDIFF','TIMESTAMPDIFF','CAST','CONVERT','IF','NULLIF','ISNULL','FOUND_ROWS','ROW_COUNT','SIGNAL','RESIGNAL','GET_LOCK','RELEASE_LOCK','UUID','UUID_TO_BIN','BIN_TO_UUID','AES_ENCRYPT','AES_DECRYPT','MD5','SHA1','LEFT','RIGHT','SUBSTRING','SUBSTRING_INDEX','LOCATE','POSITION','INSTR','REPLACE','REPEAT','SPACE','REVERSE','STRCMP','FORMAT','ROUND','CEIL','CEILING','FLOOR','TRUNCATE','ABS','SIGN','MOD','POWER','EXP','LN','LOG','LOG10','LOG2','SQRT','PI','RAND','DEGREES','RADIANS','SIN','COS','TAN','ASIN','ACOS','ATAN','ATAN2','COT','BIT_LENGTH','CHAR_LENGTH','CHARACTER_LENGTH','FIND_IN_SET')
    foreach ($fn in $funcList) {
        if ($text -match "\b$fn\b") { $funcs += $fn }
    }
    $funcs = $funcs | Sort-Object -Unique
    
    $views = @()
    foreach ($m in [regex]::Matches($text, '\b(vw|view|v)_\w+\b')) { 
        if ($declaredVars -notcontains $m.Value) { $views += $m.Value }
    }
    $views = $views | Sort-Object -Unique
    
    $events = @()
    $eventTables = @('auditoria_evento','evento','log_evento','ledger_evento','senha_eventos','historico','historico_evento','fluxo_evento')
    foreach ($et in $eventTables) {
        if ($text -match $et) { $events += $et }
    }
    $events = $events | Sort-Object -Unique
    
    $hasHandler = $false; $hasSignal = $false
    if ($text -match 'DECLARE\s+(EXIT|CONTINUE)\s+HANDLER') { $hasHandler = $true }
    if ($text -match 'SIGNAL\s+SQLSTATE|RESIGNAL') { $hasSignal = $true }
    
    $hasCommit = $false; $hasRollback = $false
    if ($text -match '(?i)COMMIT') { $hasCommit = $true }
    if ($text -match '(?i)ROLLBACK') { $hasRollback = $true }
    
    $lines = $text -split "`n"
    $logicLines = @()
    $ln = 0
    foreach ($line in $lines) {
        $ln++
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) { continue }
        
        if ($trimmed -match '^--') {
            $comment = $trimmed -replace '^--\s*',''
            $logicLines += "- **Linha $ln** (comentário): $comment"
        } elseif ($trimmed -match '^CREATE\s+DEFINER') {
            $logicLines += "- **Linha $ln**: Definição da procedure com o definer."
        } elseif ($trimmed -match '^PROCEDURE\s+`?\w+`?\s*\(') {
            $logicLines += "- **Linha $ln**: Declaração do nome da procedure e seus parâmetros."
        } elseif ($trimmed -match '^(IN|OUT|INOUT)\s+\w+\s+\w+') {
            $logicLines += "- **Linha $ln**: Declaração de parâmetro."
        } elseif ($trimmed -match '^BEGIN$') {
            $logicLines += "- **Linha $ln**: Início do bloco de execução."
        } elseif ($trimmed -match '^DECLARE\s+(\w+)\s+') {
            $logicLines += "- **Linha $ln**: Declaração de variável local $($Matches[1])."
        } elseif ($trimmed -match '^SET\s+(\w+)\s*=') {
            $logicLines += "- **Linha $ln**: Atribuição de valor à variável $($Matches[1])."
        } elseif ($trimmed -match '^SELECT\s+') {
            $logicLines += "- **Linha $ln**: Execução de query SELECT para consulta de dados."
        } elseif ($trimmed -match '^INSERT\s+INTO\s+(\w+)') {
            $logicLines += "- **Linha $ln**: Insere um novo registro na tabela $($Matches[1])."
        } elseif ($trimmed -match '^ON\s+DUPLICATE\s+KEY\s+UPDATE') {
            $logicLines += "- **Linha $ln**: Atualiza o registro se a chave única já existir (UPSERT)."
        } elseif ($trimmed -match '^UPDATE\s+(\w+)\s+SET') {
            $logicLines += "- **Linha $ln**: Atualiza registros existentes na tabela $($Matches[1])."
        } elseif ($trimmed -match '^DELETE\s+FROM\s+(\w+)') {
            $logicLines += "- **Linha $ln**: Remove registros da tabela $($Matches[1])."
        } elseif ($trimmed -match '^CALL\s+(\w+)') {
            $logicLines += "- **Linha $ln**: Invoca a procedure $($Matches[1])."
        } elseif ($trimmed -match '^(IF|ELSEIF|ELSE|END\s+IF)') {
            $logicLines += "- **Linha $ln**: Estrutura condicional de controle de fluxo."
        } elseif ($trimmed -match '^(WHILE|LOOP|REPEAT|UNTIL|LEAVE|ITERATE)') {
            $logicLines += "- **Linha $ln**: Estrutura de repetição/controle de loop."
        } elseif ($trimmed -match '^END\s*;;?\s*$') {
            $logicLines += "- **Linha $ln**: Fim do bloco da procedure."
        } elseif ($trimmed -match '^\)$') {
            $logicLines += "- **Linha $ln**: Fechamento da lista de parâmetros."
        } elseif ($trimmed -match '^(AND|OR)\s+') {
            continue
        } elseif ($trimmed -match '^ON\s+') {
            $logicLines += "- **Linha $ln**: Condição de chave ou tratamento de duplicidade."
        } else {
            $logicLines += "- **Linha $ln**: $trimmed"
        }
    }
    
    $outPath = Join-Path $outDir "$name.md"
    
    $content = New-Object System.Collections.Generic.List[string]
    [void]$content.Add("# $name")
    [void]$content.Add("")
    
    $objName = $name -replace '^sp_','' -replace '_',' '
    [void]$content.Add("Objetivo: $objName conforme definida no dump SQL do sistema.")
    [void]$content.Add("")
    
    [void]$content.Add("## Parâmetros")
    [void]$content.Add("| Nome | Tipo | Direção | Descrição |")
    [void]$content.Add("|------|------|---------|-----------|")
    if ($params.Count -eq 0) {
        [void]$content.Add("| - | - | - | Nenhum parâmetro declarado. |")
    } else {
        foreach ($p in $params) {
            $parts = $p -split '\|'
            [void]$content.Add("| $($parts[0]) | $($parts[1]) | $($parts[2]) | |")
        }
    }
    [void]$content.Add("")
    
    [void]$content.Add("## Retorno")
    [void]$content.Add("")
    [void]$content.Add("Procedure sem valor de retorno explícito (procedimento SQL).")
    [void]$content.Add("")
    
    [void]$content.Add("## Validações")
    [void]$content.Add("")
    [void]$content.Add("- Validações implementadas diretamente no corpo da procedure via queries SELECT INTO e verificações de contagem/condição.")
    [void]$content.Add("")
    
    [void]$content.Add("## Regras de Negócio")
    [void]$content.Add("")
    [void]$content.Add("- Regras implícitas na lógica da procedure, verificadas via relacionamentos entre tabelas e restrições em cláusulas WHERE e JOIN.")
    [void]$content.Add("")
    
    [void]$content.Add("## Tabelas Utilizadas")
    [void]$content.Add("- SELECT: $(if ($tablesSelect.Count -gt 0) { $tablesSelect -join ', ' } else { '(nenhuma)' })")
    [void]$content.Add("- INSERT: $(if ($tablesInsert.Count -gt 0) { $tablesInsert -join ', ' } else { '(nenhuma)' })")
    [void]$content.Add("- UPDATE: $(if ($tablesUpdate.Count -gt 0) { $tablesUpdate -join ', ' } else { '(nenhuma)' })")
    [void]$content.Add("- DELETE: $(if ($tablesDelete.Count -gt 0) { $tablesDelete -join ', ' } else { '(nenhuma)' })")
    [void]$content.Add("")
    
    [void]$content.Add("## Chamadas para outras Procedures")
    if ($calls.Count -gt 0) { foreach ($c in $calls) { [void]$content.Add("- $c") } } else { [void]$content.Add("- (nenhuma)") }
    [void]$content.Add("")
    
    [void]$content.Add("## Functions Utilizadas")
    if ($funcs.Count -gt 0) { foreach ($f in $funcs) { [void]$content.Add("- $f") } } else { [void]$content.Add("- (nenhuma)") }
    [void]$content.Add("")
    
    [void]$content.Add("## Views Utilizadas")
    if ($views.Count -gt 0) { foreach ($v in $views) { [void]$content.Add("- $v") } } else { [void]$content.Add("- (nenhuma)") }
    [void]$content.Add("")
    
    [void]$content.Add("## Eventos Gerados")
    if ($events.Count -gt 0) { foreach ($e in $events) { [void]$content.Add("- $e") } } else { [void]$content.Add("- (nenhum)") }
    [void]$content.Add("")
    
    [void]$content.Add("## Tratamento de Erros")
    [void]$content.Add("")
    if ($hasHandler) { [void]$content.Add("- Handler de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).") }
    if ($hasSignal) { [void]$content.Add("- Uso de SIGNAL/RESIGNAL para gerar erros customizados.") }
    if (-not $hasHandler -and -not $hasSignal) { [void]$content.Add("- Sem tratamento de erro explícito detectado.") }
    [void]$content.Add("")
    
    [void]$content.Add("## Transações")
    [void]$content.Add("- TRY/CATCH: Não aplicável (MySQL usa DECLARE HANDLER, não TRY/CATCH nativo)")
    [void]$content.Add("- Rollback: $(if ($hasRollback) { 'Sim' } else { 'Não detectado' })")
    [void]$content.Add("- Commit: $(if ($hasCommit) { 'Sim' } else { 'Não detectado' })")
    [void]$content.Add("")
    
    [void]$content.Add("## Lógica Linha por Linha")
    [void]$content.Add("")
    foreach ($item in $logicLines) { [void]$content.Add($item) }
    [void]$content.Add("")
    [void]$content.Add("### Código Fonte Completo")
    [void]$content.Add("")
    [void]$content.Add('```sql')
    foreach ($line in $lines) { [void]$content.Add($line) }
    [void]$content.Add('```')
    [void]$content.Add("")
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($outPath, $content, $utf8NoBom)
}

exit 0
