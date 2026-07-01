param()
$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

$rawDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures_raw"
$outDir = "D:\AtendimentoOfflineAlpha\docs\database\procedures"

if (!(Test-Path -LiteralPath $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

function Get-Parameters {
    param([string]$Text)
    $params = @()
    if ($Text -match 'CREATE\s+DEFINER[^`]+`\w+`@`\w+`\s+PROCEDURE\s+`(\w+)`\s*\(([\s\S]*?)\)\s*(AS\s*)?BEGIN') {
        $paramBlock = $Matches[2]
        foreach ($line in ($paramBlock -split "`n")) {
            $line = $line.Trim()
            if ($line -match '^(IN|OUT|INOUT)\s+([\w]+)\s+([\w]+(?:\([^)]*\))?)\s*$') {
                $params += [ordered]@{
                    Nome = $Matches[2]
                    Tipo = $Matches[3]
                    Direcao = $Matches[1]
                }
            }
        }
    }
    return $params
}

function Get-Tables {
    param([string]$Text)
    $sel = @(); $ins = @(); $upd = @(); $del = @(); $all = @()
    
    # Evita pegar variáveis DECLARE
    $declaredVars = @()
    if ($Text -match 'DECLARE\s+([\s\S]*?);') {
        foreach ($v in ($Matches[1] -split ',')) {
            if ($v -match '^\s*[\w_]+\s+\w+') { $declaredVars += ($Matches[0] -replace '^\s+','' -replace '\s+.*','') }
        }
    }
    
    foreach ($m in [regex]::Matches($Text, '(?i)(?:FROM|JOIN|TABLE)\s+(\w+)')) { $all += $m.Groups[1].Value; $sel += $m.Groups[1].Value }
    foreach ($m in [regex]::Matches($Text, '(?i)INSERT\s+INTO\s+(\w+)')) { $all += $m.Groups[1].Value; $ins += $m.Groups[1].Value }
    foreach ($m in [regex]::Matches($Text, '(?i)UPDATE\s+(\w+)\s+SET')) { $all += $m.Groups[1].Value; $upd += $m.Groups[1].Value }
    foreach ($m in [regex]::Matches($Text, '(?i)DELETE\s+FROM\s+(\w+)')) { $all += $m.Groups[1].Value; $del += $m.Groups[1].Value }
    
    $all = $all | Sort-Object -Unique
    $sel = $sel | Sort-Object -Unique
    $ins = $ins | Sort-Object -Unique
    $upd = $upd | Sort-Object -Unique
    $del = $del | Sort-Object -Unique
    
    return [ordered]@{SELECT=$sel; INSERT=$ins; UPDATE=$upd; DELETE=$del; ALL=$all}
}

function Get-ProcedureCalls {
    param([string]$Text)
    $calls = @()
    foreach ($m in [regex]::Matches($Text, '(?i)CALL\s+(\w+)')) { $calls += $m.Groups[1].Value }
    return $calls | Sort-Object -Unique
}

function Get-Functions {
    param([string]$Text)
    $funcs = @()
    $patterns = @('\bSHA2\b','\bJSON_UNQUOTE\b','\bJSON_EXTRACT\b','\bJSON_OBJECT\b','\bJSON_ARRAY\b','\bJSON_CONTAINS\b','\bJSON_LENGTH\b','\bJSON_VALID\b','\bIFNULL\b','\bCOALESCE\b','\bNOW\b','\bCURRENT_TIMESTAMP\b','\bCURRENT_DATE\b','\bLAST_INSERT_ID\b','\bCONCAT\b','\bCONCAT_WS\b','\bUPPER\b','\bLOWER\b','\bLENGTH\b','\bTRIM\b','\bLTRIM\b','\bRTRIM\b','\bCOUNT\b','\bSUM\b','\bMAX\b','\bMIN\b','\bAVG\b','\bDATE_FORMAT\b','\bDATE_ADD\b','\bDATE_SUB\b','\bDATEDIFF\b','\bTIMESTAMPDIFF\b','\bCAST\b','\bCONVERT\b','\bIF\b','\bCASE\b','\bNULLIF\b','\bISNULL\b','\bEXISTS\b','\bFOUND_ROWS\b','\bROW_COUNT\b','\bSIGNAL\b','\bRESIGNAL\b','\bGET_LOCK\b','\bRELEASE_LOCK\b','\bIS_USED_LOCK\b','\bRELEASE_ALL_LOCKS\b','\bSLEEP\b','\bUUID\b','\bUUID_TO_BIN\b','\bBIN_TO_UUID\b','\bAES_ENCRYPT\b','\bAES_DECRYPT\b','\bMD5\b','\bSHA1\b','\bSHA2\b','\bPASSWORD\b','\bENCODE\b','\bDECODE\b','\bLEFT\b','\bRIGHT\b','\bSUBSTRING\b','\bSUBSTRING_INDEX\b','\bLOCATE\b','\bPOSITION\b','\bINSTR\b','\bREPLACE\b','\bREPEAT\b','\bSPACE\b','\bREVERSE\b','\bSTRCMP\b','\bFIELD\b','\bELT\b','\bMAKE_SET\b','\bEXPORT_SET\b','\bBIN\b','\bOCT\b','\bHEX\b','\bUNHEX\b','\bCONV\b','\bFORMAT\b','\bROUND\b','\bCEIL\b','\bCEILING\b','\bFLOOR\b','\bTRUNCATE\b','\bABS\b','\bSIGN\b','\bMOD\b','\bPOWER\b','\bEXP\b','\bLN\b','\bLOG\b','\bLOG10\b','\bLOG2\b','\bSQRT\b','\bPI\b','\bRAND\b','\bDEGREES\b','\bRADIANS\b','\bSIN\b','\bCOS\b','\bTAN\b','\bASIN\b','\bACOS\b','\bATAN\b','\bATAN2\b','\bCOT\b','\bBIT_LENGTH\b','\bCHAR_LENGTH\b','\bCHARACTER_LENGTH\b','\bFIND_IN_SET\b','\bINET_ATON\b','\bINET_NTOA\b','\bIS_IPV4\b','\bIS_IPV6\b')
    foreach ($p in $patterns) {
        if ($Text -match $p) { $funcs += $Matches[0] }
    }
    return $funcs | Sort-Object -Unique
}

function Get-Views {
    param([string]$Text)
    $views = @()
    foreach ($m in [regex]::Matches($Text, '\b(vw|view|v)_\w+\b')) { $views += $m.Value }
    return $views | Sort-Object -Unique
}

function Get-Events {
    param([string]$Text)
    $events = @()
    $patterns = @('auditoria_evento','evento','log_evento','ledger_evento','senha_eventos','historico','historico_evento','fluxo_evento','log_')
    foreach ($p in $patterns) {
        if ($Text -match $p) { $events += $p }
    }
    return $events | Sort-Object -Unique
}

function Get-ErrorHandling {
    param([string]$Text)
    $hasHandler = $false
    $hasSignal = $false
    if ($Text -match 'DECLARE\s+(EXIT|CONTINUE)\s+HANDLER\s+FOR\s+SQLEXCEPTION|DECLARE\s+(EXIT|CONTINUE)\s+HANDLER\s+FOR\s+SQLWARNING|DECLARE\s+(EXIT|CONTINUE)\s+HANDLER\s+FOR\s+NOT\s+FOUND') { $hasHandler = $true }
    if ($Text -match 'SIGNAL\s+SQLSTATE|RESIGNAL') { $hasSignal = $true }
    return [ordered]@{HasHandler=$hasHandler; HasSignal=$hasSignal}
}

function Get-Transactions {
    param([string]$Text)
    $hasTryCatch = $false
    $hasCommit = $false
    $hasRollback = $false
    if ($Text -match 'BEGIN\s+TRY|TRY:') { $hasTryCatch = $true }
    if ($Text -match '(?i)COMMIT') { $hasCommit = $true }
    if ($Text -match '(?i)ROLLBACK') { $hasRollback = $true }
    return [ordered]@{TryCatch=$hasTryCatch; Commit=$hasCommit; Rollback=$hasRollback}
}

function Get-LogicExplanation {
    param([string]$Text)
    $lines = $Text -split "`n"
    $explanation = @()
    $lineNum = 0
    foreach ($line in $lines) {
        $lineNum++
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) { continue }
        $lineWithNum = "$lineNum`: $trimmed"
        
        if ($trimmed -match '^--') {
            $comment = $trimmed -replace '^--\s*',''
            $explanation += "- **Linha $lineNum** (comentário): $comment"
        } elseif ($trimmed -match '^CREATE\s+DEFINER') {
            $explanation += "- **Linha $lineNum**: Definição da procedure com o definer `root@localhost`."
        } elseif ($trimmed -match '^PROCEDURE\s+`?\w+`?\s*\(') {
            $explanation += "- **Linha $lineNum**: Declaração do nome da procedure e seus parâmetros de entrada (IN), saída (OUT) ou entrada/saída (INOUT)."
        } elseif ($trimmed -match '^BEGIN$') {
            $explanation += "- **Linha $lineNum**: Início do bloco de execução da procedure."
        } elseif ($trimmed -match '^(IN|OUT|INOUT)\s+\w+\s+\w+') {
            $explanation += "- **Linha $lineNum**: Declaração de parâmetro: tipo $($Matches[0])"
        } elseif ($trimmed -match '^DECLARE\s+(\w+)\s+') {
            $explanation += "- **Linha $lineNum**: Declaração de variável local `$($Matches[1])`."
        } elseif ($trimmed -match '^SET\s+(\w+)\s*=') {
            $explanation += "- **Linha $lineNum**: Atribuição de valor à variável `$($Matches[1])`."
        } elseif ($trimmed -match '^SELECT\s+COUNT\(') {
            $explanation += "- **Linha $lineNum**: Executa uma query SELECT contando registros para validação ou armazenamento em variável."
        } elseif ($trimmed -match '^SELECT\s+') {
            $explanation += "- **Linha $lineNum**: Executa query SELECT para consulta de dados."
        } elseif ($trimmed -match '^INSERT\s+INTO\s+(\w+)') {
            $explanation += "- **Linha $lineNum**: Insere um novo registro na tabela `$($Matches[1])`."
        } elseif ($trimmed -match '^ON\s+DUPLICATE\s+KEY\s+UPDATE') {
            $explanation += "- **Linha $lineNum**: Atualiza o registro se a chave única já existir (UPSERT)."
        } elseif ($trimmed -match '^UPDATE\s+(\w+)\s+SET') {
            $explanation += "- **Linha $lineNum**: Atualiza registros existentes na tabela `$($Matches[1])`."
        } elseif ($trimmed -match '^DELETE\s+FROM\s+(\w+)') {
            $explanation += "- **Linha $lineNum**: Remove registros da tabela `$($Matches[1])`."
        } elseif ($trimmed -match '^CALL\s+(\w+)') {
            $explanation += "- **Linha $lineNum**: Invoca a procedure `$($Matches[1])`."
        } elseif ($trimmed -match '^WHERE\s+') {
            $explanation += "- **Linha $lineNum**: Filtro de registros com condições WHERE."
        } elseif ($trimmed -match '^JOIN\s+') {
            $explanation += "- **Linha $lineNum**: Junção (JOIN) entre tabelas para relacionar dados."
        } elseif ($trimmed -match '^GROUP\s+BY\s+') {
            $explanation += "- **Linha $lineNum**: Agrupamento de resultados por coluna(s)."
        } elseif ($trimmed -match '^ORDER\s+BY\s+') {
            $explanation += "- **Linha $lineNum**: Ordenação dos resultados."
        } elseif ($trimmed -match '^LIMIT\s+') {
            $explanation += "- **Linha $lineNum**: Limitação da quantidade de registros retornados."
        } elseif ($trimmed -match '^HAVING\s+') {
            $explanation += "- **Linha $lineNum**: Filtro aplicado após agrupamento (HAVING)."
        } elseif ($trimmed -match '^VALUES\s*\(') {
            $explanation += "- **Linha $lineNum**: Especificação dos valores a serem inseridos."
        } elseif ($trimmed -match '^SET\s+') {
            $explanation += "- **Linha $lineNum**: Definição de valores para colunas em UPDATE."
        } elseif ($trimmed -match '^(IF|ELSEIF|ELSE|END\s+IF)') {
            $explanation += "- **Linha $lineNum**: Estrutura condicional de controle de fluxo."
        } elseif ($trimmed -match '^(WHILE|LOOP|REPEAT|UNTIL)') {
            $explanation += "- **Linha $lineNum**: Estrutura de repetição/loop."
        } elseif ($trimmed -match '^LEAVE\s+') {
            $explanation += "- **Linha $lineNum**: Comando LEAVE para sair de um bloco ou loop."
        } elseif ($trimmed -match '^ITERATE\s+') {
            $explanation += "- **Linha $lineNum**: Comando ITERATE para pular para próxima iteração de loop."
        } elseif ($trimmed -match '^RETURN\s+') {
            $explanation += "- **Linha $lineNum**: Retorno de valor de uma função."
        } elseif ($trimmed -match '^END\s*$|^END\s+;;$') {
            $explanation += "- **Linha $lineNum**: Fim do bloco da procedure ou função."
        } elseif ($trimmed -match '^(AND|OR)\s+') {
            # ignored atomic
        } elseif ($trimmed -match '^ON\s+') {
            $explanation += "- **Linha $lineNum**: Condição de chave ou tratamento de duplicidade."
        } else {
            $explanation += "- **Linha $lineNum**: $trimmed"
        }
    }
    return $explanation
}

function New-Markdown {
    param(
        [string]$Name,
        [string]$Text,
        [array]$Params,
        [hashtable]$Tables,
        [array]$Calls,
        [array]$Funcs,
        [array]$Views,
        [array]$Events,
        [hashtable]$ErrorHandling,
        [hashtable]$Transactions,
        [array]$Logic
    )
    $md = "# $Name`n`n"
    $md += "Objetivo: Procedure `$Name` conforme definida no dump SQL.`n`n"
    
    $md += "## Parâmetros`n"
    $md += "| Nome | Tipo | Direção | Descrição |`n"
    $md += "|------|------|---------|-----------|`n"
    if ($Params.Count -eq 0) {
        $md += "| - | - | - | Nenhum parâmetro declarado. |`n"
    } else {
        foreach ($p in $Params) {
            $md += "| $($p.Nome) | $($p.Tipo) | $($p.Direcao) | |`n"
        }
    }
    $md += "`n"
    
    $md += "## Retorno`n`n"
    $md += "Procedure sem valor de retorno explícito (procedimento SQL).`n`n"
    
    $md += "## Validações`n`n"
    $md += "- Validações implementadas diretamente no corpo da procedure via queries SELECT INTO e verificações de contagem/condição.`n`n"
    
    $md += "## Regras de Negócio`n`n"
    $md += "- Regras implícitas na lógica da procedure, verificadas via relacionamentos entre tabelas e restrições em cláusulas WHERE e JOIN.`n`n"
    
    $md += "## Tabelas Utilizadas`n"
    $md += "- SELECT: $(if ($Tables.SELECT.Count -gt 0) { $Tables.SELECT -join ', ' } else { '(nenhuma)' })`n"
    $md += "- INSERT: $(if ($Tables.INSERT.Count -gt 0) { $Tables.INSERT -join ', ' } else { '(nenhuma)' })`n"
    $md += "- UPDATE: $(if ($Tables.UPDATE.Count -gt 0) { $Tables.UPDATE -join ', ' } else { '(nenhuma)' })`n"
    $md += "- DELETE: $(if ($Tables.DELETE.Count -gt 0) { $Tables.DELETE -join ', ' } else { '(nenhuma)' })`n`n"
    
    $md += "## Chamadas para outras Procedures`n"
    if ($Calls.Count -gt 0) { foreach ($c in $Calls) { $md += "- $c`n" } } else { $md += "- (nenhuma)`n" }
    $md += "`n"
    
    $md += "## Functions Utilizadas`n"
    if ($Funcs.Count -gt 0) { foreach ($f in $Funcs) { $md += "- $f`n" } } else { $md += "- (nenhuma)`n" }
    $md += "`n"
    
    $md += "## Views Utilizadas`n"
    if ($Views.Count -gt 0) { foreach ($v in $Views) { $md += "- $v`n" } } else { $md += "- (nenhuma)`n" }
    $md += "`n"
    
    $md += "## Eventos Gerados`n"
    if ($Events.Count -gt 0) { foreach ($e in $Events) { $md += "- $e`n" } } else { $md += "- (nenhum)`n" }
    $md += "`n"
    
    $md += "## Tratamento de Erros`n`n"
    if ($ErrorHandling.HasHandler) { $md += "- Handler de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).`n" }
    if ($ErrorHandling.HasSignal) { $md += "- Uso de SIGNAL/RESIGNAL para gerar erros customizados.`n" }
    if (-not $ErrorHandling.HasHandler -and -not $ErrorHandling.HasSignal) { $md += "- Sem tratamento de erro explícito detectado.`n" }
    $md += "`n"
    
    $md += "## Transações`n"
    $md += "- TRY/CATCH: $(if ($Transactions.TryCatch) { 'Sim' } else { 'Não detectado' })`n"
    $md += "- Rollback: $(if ($Transactions.Rollback) { 'Sim' } else { 'Não detectado' })`n"
    $md += "- Commit: $(if ($Transactions.Commit) { 'Sim' } else { 'Não detectado' })`n`n"
    
    $md += "## Lógica Linha por Linha`n`n"
    foreach ($item in $Logic) {
        $md += "$item`n"
    }
    $md += "`n"
    $md += "### Código Fonte Completo`n`n"
    $md += "```sql`n$Text`n````n`n"
    
    return $md
}

$files = Get-ChildItem -LiteralPath $rawDir -Filter "*.json" | Sort-Object Name
$count = 0

foreach ($f in $files) {
    $json = Get-Content -LiteralPath $f.FullName -Raw | ConvertFrom-Json
    $name = $json.name
    $text = $json.text
    
    $params = Get-Parameters -Text $text
    $tables = Get-Tables -Text $text
    $calls = Get-ProcedureCalls -Text $text
    $funcs = Get-Functions -Text $text
    $views = Get-Views -Text $text
    $events = Get-Events -Text $text
    $errHandling = Get-ErrorHandling -Text $text
    $trans = Get-Transactions -Text $text
    $logic = Get-LogicExplanation -Text $text
    
    $md = New-Markdown -Name $name -Text $text -Params $params -Tables $tables -Calls $calls -Funcs $funcs -Views $views -Events $events -ErrorHandling $errHandling -Transactions $trans -Logic $logic
    
    $outPath = Join-Path $outDir "$name.md"
    Set-Content -LiteralPath $outPath -Value $md -Encoding UTF8
    $count++
}

Write-Host "Documentadas $count procedures."
