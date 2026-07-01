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
    
    # Normaliza quebras de Linha
    $text = $text -replace "`r`n", "`n"
    
    # Parse Parametros Linha por Linha
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
    $DECLAREdVars = @()
    foreach ($m in [regex]::Matches($text, '(?i)DECLARE\s+((?:\s*\w+\s+\w+,?\s*)+);')) {
        $declStr = $m.Groups[1].Value
        foreach ($v in ($declStr -split ',')) {
            if ($v -match '^\s*([\w_]+)\s+') { $DECLAREdVars += $Matches[1].Trim() }
        }
    }
    
    $tablesSelect = @(); $tablesInsert = @(); $tablesUpdate = @(); $tablesDelete = @()
    foreach ($m in [regex]::Matches($text, '(?i)(?:FROM|JOIN|TABLE)\s+(\w+)')) {
        if ($DECLAREdVars -notcontains $m.Groups[1].Value) { $tablesSelect += $m.Groups[1].Value }
    }
    foreach ($m in [regex]::Matches($text, '(?i)INSERT\s+INTO\s+(\w+)')) {
        if ($DECLAREdVars -notcontains $m.Groups[1].Value) { $tablesInsert += $m.Groups[1].Value }
    }
    foreach ($m in [regex]::Matches($text, '(?i)UPDATE\s+(\w+)\s+SET')) {
        if ($DECLAREdVars -notcontains $m.Groups[1].Value) { $tablesUpdate += $m.Groups[1].Value }
    }
    foreach ($m in [regex]::Matches($text, '(?i)DELETE\s+FROM\s+(\w+)')) {
        if ($DECLAREdVars -notcontains $m.Groups[1].Value) { $tablesDelete += $m.Groups[1].Value }
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
    
    $Views = @()
    foreach ($m in [regex]::Matches($text, '\b(vw|view|v)_\w+\b')) { 
        if ($DECLAREdVars -notcontains $m.Value) { $Views += $m.Value }
    }
    $Views = $Views | Sort-Object -Unique
    
    $events = @()
    $eventTables = @('auditoria_evento','evento','log_evento','ledger_evento','senha_Eventos','historico','historico_evento','fluxo_evento')
    foreach ($et in $eventTables) {
        if ($text -match $et) { $events += $et }
    }
    $events = $events | Sort-Object -Unique
    
    $hasHANDLER = $false; $hasSignal = $false
    if ($text -match 'DECLARE\s+(EXIT|CONTINUE)\s+HANDLER') { $hasHANDLER = $true }
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
            $logicLines += "- **Linha $ln** (Comentario): $comment"
        } elseif ($trimmed -match '^CREATE\s+definer') {
            $logicLines += "- **Linha $ln**: Definicao da procedure com o definer."
        } elseif ($trimmed -match '^PROCEDURE\s+`?\w+`?\s*\(') {
            $logicLines += "- **Linha $ln**: Declaracao do nome da procedure e seus Parametros."
        } elseif ($trimmed -match '^(IN|OUT|INOUT)\s+\w+\s+\w+') {
            $logicLines += "- **Linha $ln**: Declaracao de parâmetro."
        } elseif ($trimmed -match '^BEGIN$') {
            $logicLines += "- **Linha $ln**: inicio do bloco de execucao."
        } elseif ($trimmed -match '^DECLARE\s+(\w+)\s+') {
            $logicLines += "- **Linha $ln**: Declaracao de variavel local $($Matches[1])."
        } elseif ($trimmed -match '^SET\s+(\w+)\s*=') {
            $logicLines += "- **Linha $ln**: atribuicao de valor à variavel $($Matches[1])."
        } elseif ($trimmed -match '^SELECT\s+') {
            $logicLines += "- **Linha $ln**: execucao de query SELECT para consulta de dados."
        } elseif ($trimmed -match '^INSERT\s+INTO\s+(\w+)') {
            $logicLines += "- **Linha $ln**: Insere um novo registro na tabela $($Matches[1])."
        } elseif ($trimmed -match '^ON\s+DUPLICATE\s+KEY\s+UPDATE') {
            $logicLines += "- **Linha $ln**: Atualiza o registro se a chave unica já existir (UPSERT)."
        } elseif ($trimmed -match '^UPDATE\s+(\w+)\s+SET') {
            $logicLines += "- **Linha $ln**: Atualiza registros existentes na tabela $($Matches[1])."
        } elseif ($trimmed -match '^DELETE\s+FROM\s+(\w+)') {
            $logicLines += "- **Linha $ln**: Remove registros da tabela $($Matches[1])."
        } elseif ($trimmed -match '^CALL\s+(\w+)') {
            $logicLines += "- **Linha $ln**: Invoca a procedure $($Matches[1])."
        } elseif ($trimmed -match '^(IF|ELSEIF|ELSE|END\s+IF)') {
            $logicLines += "- **Linha $ln**: Estrutura condicional de controle de fluxo."
        } elseif ($trimmed -match '^(WHILE|loop|REPEAT|UNTIL|LEAVE|ITERATE)') {
            $logicLines += "- **Linha $ln**: Estrutura de repeticao/controle de loop."
        } elseif ($trimmed -match '^END\s*;;?\s*$') {
            $logicLines += "- **Linha $ln**: Fim do bloco da procedure."
        } elseif ($trimmed -match '^\)$') {
            $logicLines += "- **Linha $ln**: fechamento da lista de Parametros."
        } elseif ($trimmed -match '^(AND|OR)\s+') {
            continue
        } elseif ($trimmed -match '^ON\s+') {
            $logicLines += "- **Linha $ln**: Condição de chave ou Tratamento de duplicidade."
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
    
    [void]$content.Add("## Parametros")
    [void]$content.Add("| Nome | Tipo | Direcao | Descricao |")
    [void]$content.Add("|------|------|---------|-----------|")
    if ($params.Count -eq 0) {
        [void]$content.Add("| - | - | - | nenhum parâmetro declarado. |")
    } else {
        foreach ($p in $params) {
            $parts = $p -split '\|'
            [void]$content.Add("| $($parts[0]) | $($parts[1]) | $($parts[2]) | |")
        }
    }
    [void]$content.Add("")
    
    [void]$content.Add("## Retorno")
    [void]$content.Add("")
    [void]$content.Add("Procedure sem valor de Retorno explicito (procedimento SQL).")
    [void]$content.Add("")
    
    [void]$content.Add("## Validacoes")
    [void]$content.Add("")
    [void]$content.Add("- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificações de contagem/condicao.")
    [void]$content.Add("")
    
    [void]$content.Add("## Regras de Negocio")
    [void]$content.Add("")
    [void]$content.Add("- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.")
    [void]$content.Add("")
    
    [void]$content.Add("## tabelas Utilizadas")
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
    if ($Views.Count -gt 0) { foreach ($v in $Views) { [void]$content.Add("- $v") } } else { [void]$content.Add("- (nenhuma)") }
    [void]$content.Add("")
    
    [void]$content.Add("## Eventos Gerados")
    if ($events.Count -gt 0) { foreach ($e in $events) { [void]$content.Add("- $e") } } else { [void]$content.Add("- (nenhum)") }
    [void]$content.Add("")
    
    [void]$content.Add("## Tratamento de Erros")
    [void]$content.Add("")
    if ($hasHANDLER) { [void]$content.Add("- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).") }
    if ($hasSignal) { [void]$content.Add("- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.") }
    if (-not $hasHANDLER -and -not $hasSignal) { [void]$content.Add("- Sem Tratamento de erro explicito detectado.") }
    [void]$content.Add("")
    
    [void]$content.Add("## Transacoes")
    [void]$content.Add("- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)")
    [void]$content.Add("- Rollback: $(if ($hasRollback) { 'Sim' } else { 'nao detectado' })")
    [void]$content.Add("- Commit: $(if ($hasCommit) { 'Sim' } else { 'nao detectado' })")
    [void]$content.Add("")
    
    [void]$content.Add("## Logica Linha por Linha")
    [void]$content.Add("")
    foreach ($item in $logicLines) { [void]$content.Add($item) }
    [void]$content.Add("")
    [void]$content.Add("### Codigo Fonte Completo")
    [void]$content.Add("")
    [void]$content.Add('```sql')
    foreach ($line in $lines) { [void]$content.Add($line) }
    [void]$content.Add('```')
    [void]$content.Add("")
    
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($outPath, $content, $utf8NoBom)
}

exit 0


