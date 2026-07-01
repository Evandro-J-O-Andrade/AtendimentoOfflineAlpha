# CHECKLIST DE INTEGRIDADE CANÔNICA
# Executa antes de qualquer alteração no banco/documentação

param()

$errors = @()
$warnings = @()
$ok = @()

# 1. Ler documentos canônicos obrigatórios
$canonicalDocs = @(
    "000-CONSTITUICAO-IA.md",
    "docs/canonical/MD-CANONICO-IA-001-Lei-Evolucao-Documental.md",
    "docs/canonical/MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md",
    "docs/canonical/MD-CANONICO-IA-003-Lei-Evolucao-Core.md",
    "docs/canonical/MD-CANONICO-IA-004-Matriz-Evolucao-Projeto.md",
    "docs/canonical/MD-110-Canonical-Laws.md",
    "docs/canonical/MD-100-Unified-Enterprise-Operating-System.md",
    "docs/canonical/MAP-001-Enterprise-Domain-Architecture.md"
)

Write-Output "=== CHECKLIST DE INTEGRIDADE CANÔNICA ===" -ForegroundColor Cyan
Write-Output ""

# Verificar documentos canônicos
foreach ($doc in $canonicalDocs) {
    if (Test-Path $doc) {
        $size = (Get-Item $doc).Length
        $ok += "✅ $doc ($size bytes)"
    } else {
        $errors += "❌ FALTA: $doc"
    }
}

# 2. Contar MDs, MAPs, BRs, FRONTs, ADRs
$mdCount = (Get-ChildItem docs/canonical -Filter "MD-*.md" -ErrorAction SilentlyContinue).Count
$mapCount = (Get-ChildItem docs/canonical -Filter "MAP-*.md" -ErrorAction SilentlyContinue).Count
$brCount = (Get-ChildItem docs/canonical -Filter "BR-*.md" -ErrorAction SilentlyContinue).Count
$frontCount = (Get-ChildItem docs/canonical -Filter "FRONT-*.md" -ErrorAction SilentlyContinue).Count
$adrCount = (Get-ChildItem docs/canonical -Filter "ADR-*.md" -ErrorAction SilentlyContinue).Count

Write-Output "=== DOCUMENTOS CANÔNICOS ===" -ForegroundColor Cyan
Write-Output "MDs: $mdCount"
Write-Output "MAPs: $mapCount"
Write-Output "BRs: $brCount"
Write-Output "FRONTs: $frontCount"
Write-Output "ADRs: $adrCount"
Write-Output ""

# 3. Contar arquivos de banco
$tableDocs = (Get-ChildItem docs/database/tables -Filter "*.md" -ErrorAction SilentlyContinue).Count
$procedureDocs = (Get-ChildItem docs/database/procedures -Filter "*.md" -ErrorAction SilentlyContinue).Count
$viewDocs = (Get-ChildItem docs/database/views -Filter "*.md" -ErrorAction SilentlyContinue).Count
$functionDocs = (Get-ChildItem docs/database/functions -Filter "*.md" -ErrorAction SilentlyContinue).Count
$triggerDocs = (Get-ChildItem docs/database/triggers -Filter "*.md" -ErrorAction SilentlyContinue).Count
$eventDocs = (Get-ChildItem docs/database/events -Filter "*.md" -ErrorAction SilentlyContinue).Count

Write-Output "=== DOCUMENTOS DE BANCO ===" -ForegroundColor Cyan
Write-Output "Tables: $tableDocs"
Write-Output "Procedures: $procedureDocs"
Write-Output "Views: $viewDocs"
Write-Output "Functions: $functionDocs"
Write-Output "Triggers: $triggerDocs"
Write-Output "Events: $eventDocs"
Write-Output ""

# 4. Analisar Dump20260606.sql (BANCO REAL)
$dumpPath = "legacy/backend_antigo/sql/Dump20260606.sql"
if (Test-Path $dumpPath) {
    $dumpContent = Get-Content $dumpPath -Raw -Encoding UTF8
    
    # Contar tabelas
    $dumpTables = [regex]::Matches($dumpContent, 'CREATE TABLE\s+(?:IF NOT EXISTS\s+)?`([^`]+)`', 'IgnoreCase')
    $dumpTableCount = $dumpTables.Count
    
    # Contar procedures
    $dumpProcs = [regex]::Matches($dumpContent, 'CREATE PROCEDURE\s+(?:IF NOT EXISTS\s+)?`([^`]+)`', 'IgnoreCase')
    $dumpProcCount = $dumpProcs.Count
    
    # Contar views
    $dumpViews = [regex]::Matches($dumpContent, 'CREATE VIEW\s+(?:IF NOT EXISTS\s+)?`([^`]+)`', 'IgnoreCase')
    $dumpViewCount = $dumpViews.Count
    
    # Contar functions
    $dumpFuncs = [regex]::Matches($dumpContent, 'CREATE FUNCTION\s+(?:IF NOT EXISTS\s+)?`([^`]+)`', 'IgnoreCase')
    $dumpFuncCount = $dumpFuncs.Count
    
    # Contar triggers
    $dumpTriggers = [regex]::Matches($dumpContent, 'CREATE TRIGGER\s+(?:IF NOT EXISTS\s+)?`([^`]+)`', 'IgnoreCase')
    $dumpTriggerCount = $dumpTriggers.Count
    
    # Contar events
    $dumpEvents = [regex]::Matches($dumpContent, 'CREATE EVENT\s+(?:IF NOT EXISTS\s+)?`([^`]+)`', 'IgnoreCase')
    $dumpEventCount = $dumpEvents.Count
    
    Write-Output "=== DUMP20260606 (BANCO REAL) ===" -ForegroundColor Cyan
    Write-Output "Tabelas: $dumpTableCount"
    Write-Output "Procedures: $dumpProcCount"
    Write-Output "Views: $dumpViewCount"
    Write-Output "Functions: $dumpFuncCount"
    Write-Output "Triggers: $dumpTriggerCount"
    Write-Output "Events: $dumpEventCount"
    Write-Output ""
    
    # 5. Comparar tabelas
    $dumpTableNames = @{}
    foreach ($m in $dumpTables) {
        $dumpTableNames[$m.Groups[1].Value] = $true
    }
    
    $docTableNames = @{}
    Get-ChildItem docs/database/tables -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        $docTableNames[$_.BaseName] = $true
    }
    
    $missingTables = $dumpTableNames.Keys | Where-Object { -not $docTableNames.ContainsKey($_) }
    $extraTables = $docTableNames.Keys | Where-Object { -not $dumpTableNames.ContainsKey($_) }
    
    Write-Output "=== ANÁLISE TABELAS ===" -ForegroundColor Cyan
    Write-Output "No dump: $dumpTableCount"
    Write-Output "Documentadas: $($docTableNames.Count)"
    Write-Output "Faltantes: $($missingTables.Count)"
    Write-Output "Extras (não no dump): $($extraTables.Count)"
    
    if ($missingTables.Count -gt 0) {
        $warnings += "⚠️ $($missingTables.Count) tabelas faltantes no docs/database/tables/"
    }
    if ($extraTables.Count -gt 0) {
        $warnings += "⚠️ $($extraTables.Count) tabelas extras (não constam no dump): $($extraTables -join ', ')"
    }
    Write-Output ""
    
    # 6. Analisar procedures
    $dumpProcNames = @{}
    foreach ($m in $dumpProcs) {
        $dumpProcNames[$m.Groups[1].Value] = $true
    }
    
    $docProcNames = @{}
    Get-ChildItem docs/database/procedures -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        $docProcNames[$_.BaseName] = $true
    }
    
    $missingProcs = $dumpProcNames.Keys | Where-Object { -not $docProcNames.ContainsKey($_) }
    $extraProcs = $docProcNames.Keys | Where-Object { -not $dumpProcNames.ContainsKey($_) }
    
    Write-Output "=== ANÁLISE PROCEDURES ===" -ForegroundColor Cyan
    Write-Output "No dump: $($dumpProcNames.Count)"
    Write-Output "Documentadas: $($docProcNames.Count)"
    Write-Output "Faltantes: $($missingProcs.Count)"
    Write-Output "Extras: $($extraProcs.Count)"
    
    if ($missingProcs.Count -gt 0) {
        $warnings += "⚠️ $($missingProcs.Count) procedures faltantes no docs/database/procedures/"
    }
    if ($extraProcs.Count -gt 0) {
        $warnings += "⚠️ $($extraProcs.Count) procedures extras (não constam no dump)"
    }
    Write-Output ""
    
    # 7. Analisar views, functions, triggers, events
    Write-Output "=== ANÁLISE VIEWS/FUNCTIONS/TRIGGERS/EVENTS ===" -ForegroundColor Cyan
    Write-Output "Views no dump: $dumpViewCount | Documentadas: $viewDocs"
    Write-Output "Functions no dump: $dumpFuncCount | Documentadas: $functionDocs"
    Write-Output "Triggers no dump: $dumpTriggerCount | Documentadas: $triggerDocs"
    Write-Output "Events no dump: $dumpEventCount | Documentadas: $eventDocs"
    Write-Output ""
    
    if ($dumpViewCount -gt 0 -and $viewDocs -eq 0) {
        $warnings += "⚠️ $dumpViewCount views não documentadas"
    }
    if ($dumpFuncCount -gt 0 -and $functionDocs -eq 0) {
        $warnings += "⚠️ $dumpFuncCount functions não documentadas"
    }
    if ($dumpTriggerCount -gt 0 -and $triggerDocs -eq 0) {
        $warnings += "⚠️ $dumpTriggerCount triggers não documentadas"
    }
    if ($dumpEventCount -gt 0 -and $eventDocs -eq 0) {
        $warnings += "⚠️ $dumpEventCount events não documentadas"
    }
    
    # 8. Analisar qualidade das procedures documentadas
    $incompleteProcs = 0
    $emptyObjective = 0
    $noTransaction = 0
    
    Get-ChildItem docs/database/procedures -Filter "*.md" -ErrorAction SilentlyContinue | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        if ($content -match 'conforme definida no dump SQL') { $emptyObjective++ }
        if ($content -match 'Commit: nao detectado') { $noTransaction++ }
    }
    
    Write-Output "=== QUALIDADE DAS PROCEDURES ===" -ForegroundColor Cyan
    Write-Output "Total documentadas: $procedureDocs"
    Write-Output "Objetivo genérico: $emptyObjective"
    Write-Output "Sem commit detectado: $noTransaction"
    Write-Output ""
    
    if ($emptyObjective -gt 0) {
        $warnings += "⚠️ $emptyObjective procedures com objetivo genérico (precisam ser detalhadas)"
    }
} else {
    $errors += "❌ Dump não encontrado: $dumpPath"
}

# 9. Gerar relatório final
Write-Output "=== RELATÓRIO FINAL ===" -ForegroundColor Cyan
Write-Output ""

if ($errors.Count -gt 0) {
    Write-Output "❌ ERROS ($($errors.Count)):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Output "  $_" }
    Write-Output ""
}

if ($warnings.Count -gt 0) {
    Write-Output "⚠️ AVISOS ($($warnings.Count)):" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Output "  $_" }
    Write-Output ""
}

if ($ok.Count -gt 0) {
    Write-Output "✅ OK ($($ok.Count)):" -ForegroundColor Green
    $ok | ForEach-Object { Write-Output "  $_" }
    Write-Output ""
}

# 10. Salvar relatório
$reportPath = "docs/database/CHECKLIST_INTEGRIDADE.md"
$report = @"
# CHECKLIST DE INTEGRIDADE CANÔNICA
**Data:** $(Get-Date -Format 'yyyy-MM-dd HH:mm')
**Status:** $(if($errors.Count -eq 0){'✅ APROVADO'}else{'❌ REPROVADO'})

---

## Documentos Canônicos Obrigatórios

| Documento | Status |
|-----------|--------|
"@

foreach ($doc in $canonicalDocs) {
    $status = if (Test-Path $doc) { "✅" } else { "❌ FALTA" }
    $report += "| $doc | $status |`n"
}

$report += @"

---

## Inventário do Banco Real (Dump20260606.sql)

| Tipo | No Dump | Documentados | Status |
|------|---------|--------------|--------|
| Tabelas | $dumpTableCount | $($docTableNames.Count) | $(if($missingTables.Count -eq 0){'✅'}else{'❌ Faltam: '$missingTables.Count''}) |
| Procedures | $($dumpProcNames.Count) | $($docProcNames.Count) | $(if($missingProcs.Count -eq 0){'✅'}else{'❌ Faltam: '$missingProcs.Count''}) |
| Views | $dumpViewCount | $viewDocs | $(if($dumpViewCount -gt 0 -and $viewDocs -eq 0){'❌'}else{'✅'}) |
| Functions | $dumpFuncCount | $functionDocs | $(if($dumpFuncCount -gt 0 -and $functionDocs -eq 0){'❌'}else{'✅'}) |
| Triggers | $dumpTriggerCount | $triggerDocs | $(if($dumpTriggerCount -gt 0 -and $triggerDocs -eq 0){'❌'}else{'✅'}) |
| Events | $dumpEventCount | $eventDocs | $(if($dumpEventCount -gt 0 -and $eventDocs -eq 0){'❌'}else{'✅'}) |

---

## Tabelas Faltantes
$(if($missingTables.Count -gt 0){$missingTables | ForEach-Object { "- $_`n" }}else{"Nenhuma. ✅"})

## Tabelas Extras
$(if($extraTables.Count -gt 0){$extraTables | ForEach-Object { "- $_`n" }}else{"Nenhuma. ✅"})

## Procedures Faltantes
$(if($missingProcs.Count -gt 0){$missingProcs | Select-Object -First 20 | ForEach-Object { "- $_`n" }}else{"Nenhuma. ✅"})

## Ações Necessárias
1. $(if($missingTables.Count -gt 0){"Documentar $($missingTables.Count) tabelas faltantes"}else{"Tabelas OK"})
2. $(if($missingProcs.Count -gt 0){"Documentar $($missingProcs.Count) procedures faltantes"}else{"Procedures OK"})
3. $(if($dumpViewCount -gt 0){"Documentar views, functions, triggers, events"}else{"Nada a fazer"})
4. $(if($emptyObjective -gt 0){"Melhorar $emptyObjective procedures com objetivo genérico"}else{"Qualidade OK"})

---

**Próximo passo:** Executar o inventário consolidado completo.
"@

Set-Content -Path $reportPath -Value $report -Encoding UTF8
Write-Output "Relatório salvo em: $reportPath" -ForegroundColor Green
