$ErrorActionPreference = 'Stop'
$BaseUrl = 'http://localhost:3001'
$SessionId = '197'
$passed = 0
$failed = 0

function Assert-Equals($actual, $expected, $testName) {
    if ($actual -eq $expected) {
        Write-Host "  PASS: $testName"
        $global:passed++
    } else {
        Write-Host "  FAIL: $testName - Expected '$expected', got '$actual'"
        $global:failed++
    }
}

function Invoke-Dispatcher($modulo, $acao, $payload, $idSessao, $uuid) {
    $body = @{ modulo = $modulo; acao = $acao; payload = $payload; id_sessao = [long]$idSessao } | ConvertTo-Json -Compress
    if ($uuid) {
        $bodyObj = $body | ConvertFrom-Json
        $bodyObj | Add-Member -NotePropertyName uuid_transacao -NotePropertyValue $uuid -Force
        $body = $bodyObj | ConvertTo-Json -Compress
    }
    try {
        return Invoke-RestMethod -Uri "$BaseUrl/dispatcher/" -Method Post -ContentType 'application/json' -Body $body
    } catch {
        return @{ sucesso = $false; mensagem = $_.Exception.Message }
    }
}

Write-Host ""
Write-Host "Kernel Regression Suite"
Write-Host ""

Write-Host "Test 1: Comando simples"
$r1 = Invoke-Dispatcher -modulo 'ASSISTENCIAL' -acao 'ATENDIMENTO_FINALIZAR' -payload @{id_referencia = 1} -idSessao $SessionId
Assert-Equals $r1.sucesso $true "sucesso=true"
Assert-Equals $r1.resultado.status 'SUCCESS' "status=SUCCESS"
Assert-Equals $r1.resultado.executor 'sp_executor_assistencial_atendimento_finalizar' "executor correto"

Write-Host ""
Write-Host "Test 2: Comando com referência + payload"
$r2 = Invoke-Dispatcher -modulo 'ASSISTENCIAL' -acao 'ATENDIMENTO_FINALIZAR' -payload @{id_referencia = 1; cid = 'J18'; conduta = 'Antibiotico'; diagnostico = 'Pneumonia'} -idSessao $SessionId
Assert-Equals $r2.sucesso $true "sucesso=true"
Assert-Equals $r2.resultado.status 'SUCCESS' "status=SUCCESS"

Write-Host ""
Write-Host "Test 3: Executor inexistente"
$r3 = Invoke-Dispatcher -modulo 'DESCONHECIDO' -acao 'ACAO_INEXISTENTE' -payload @{} -idSessao $SessionId
Assert-Equals $r3.sucesso $false "sucesso=false"
Assert-Equals $r3.mensagem 'EXECUTOR_INVALIDO_OU_NAO_MAPEADO' "mensagem preservada"

Write-Host ""
Write-Host "Test 4: Sessão inválida"
$r4 = Invoke-Dispatcher -modulo 'ASSISTENCIAL' -acao 'ATENDIMENTO_FINALIZAR' -payload @{} -idSessao 999999
Assert-Equals $r4.sucesso $false "sucesso=false"
Assert-Equals $r4.mensagem 'SESSAO_INVALIDA' "mensagem preservada"

Write-Host ""
Write-Host "Test 5: Idempotência"
$uuid = 'regression-' + [guid]::NewGuid().ToString("N").Substring(0,16)
$r5a = Invoke-Dispatcher -modulo 'ASSISTENCIAL' -acao 'ATENDIMENTO_FINALIZAR' -payload @{id_referencia = 1} -idSessao $SessionId -uuid $uuid
Start-Sleep -Milliseconds 500
$r5b = Invoke-Dispatcher -modulo 'ASSISTENCIAL' -acao 'ATENDIMENTO_FINALIZAR' -payload @{id_referencia = 1} -idSessao $SessionId -uuid $uuid
Assert-Equals $r5a.sucesso $true "1ª chamada sucesso"
Assert-Equals $r5b.sucesso $true "2ª chamada sucesso"
Assert-Equals $r5b.resultado.idempotente 1 "idempotente=1"
Assert-Equals $r5a.resultado.uuid $uuid "uuid preservado 1"
Assert-Equals $r5b.resultado.uuid $uuid "uuid preservado 2"

Write-Host ""
Write-Host "========================================"
Write-Host " Kernel Regression Summary"
Write-Host "========================================"
$total = 5
Write-Host "  Total: $total | Passed: $passed | Failed: $failed"
if ($failed -eq 0) {
    Write-Host "  Result: ALL PASSED"
    exit 0
} else {
    Write-Host "  Result: FAILED"
    exit 1
}
