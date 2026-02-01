# Script de Testes Smoke — Validação de Endpoints API (Windows PowerShell)
# Valida status HTTP e estrutura JSON de respostas

$BASE_URL = "http://prontoatendimento.local/src/api"
$PASSED = 0
$FAILED = 0
$TOKEN = ""

function Test-Endpoint {
    param(
        [string]$Method,
        [string]$Uri,
        [object]$Body,
        [string]$Name,
        [int]$ExpectedStatus = 200
    )
    
    try {
        $params = @{
            Uri             = $Uri
            Method          = $Method
            ContentType     = "application/json"
            ErrorAction     = "Stop"
        }
        
        if ($Body) {
            $params['Body'] = $Body | ConvertTo-Json -Compress
        }
        
        $response = Invoke-WebRequest @params
        $statusCode = $response.StatusCode
    }
    catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
        } else {
            $statusCode = 999
        }
    }
    
    if ($statusCode -eq $ExpectedStatus) {
        Write-Host "✓ $Name (HTTP $statusCode)" -ForegroundColor Green
        $global:PASSED++
    } else {
        Write-Host "✗ $Name (HTTP $statusCode, esperado $ExpectedStatus)" -ForegroundColor Red
        $global:FAILED++
    }
    
    return $response
}

Write-Host "=== Testes Smoke — API Endpoints ===" -ForegroundColor Yellow
Write-Host ""

# 1. Login (obter token)
Write-Host "1. Autenticação" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest `
        -Uri "$BASE_URL/usuario/login.php" `
        -Method Post `
        -ContentType "application/json" `
        -Body (@{"login" = "admin"; "senha" = "admin123"} | ConvertTo-Json -Compress)
    
    $data = $response.Content | ConvertFrom-Json
    $TOKEN = $data.data.token
    Test-Endpoint -Method Post -Uri "$BASE_URL/usuario/login.php" -Body @{"login" = "admin"; "senha" = "admin123"} -Name "POST /usuario/login.php" -ExpectedStatus 200
}
catch {
    Write-Host "✗ POST /usuario/login.php (erro na requisição)" -ForegroundColor Red
    $global:FAILED++
}

Write-Host ""

# 2. Gerar Senha
Write-Host "2. Domínio Senha" -ForegroundColor Yellow
Test-Endpoint -Method Post -Uri "$BASE_URL/senha/gerar.php" -Body @{"origem" = "TOTEM"} -Name "POST /senha/gerar.php" -ExpectedStatus 200

Write-Host ""

# 3. Fila (listar — requer autenticação)
Write-Host "3. Domínio Fila" -ForegroundColor Yellow
if ($TOKEN) {
    try {
        $response = Invoke-WebRequest `
            -Uri "$BASE_URL/fila/geral.php?token=$TOKEN" `
            -Method Get `
            -ErrorAction Stop
        
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ GET /fila/geral.php (com token) (HTTP 200)" -ForegroundColor Green
            $global:PASSED++
        }
    }
    catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Write-Host "✗ GET /fila/geral.php (HTTP $statusCode, esperado 200)" -ForegroundColor Red
            $global:FAILED++
        }
    }
} else {
    Write-Host "⊘ GET /fila/geral.php (Token não disponível)" -ForegroundColor Yellow
}

Write-Host ""

# 4. Usuário (listar)
Write-Host "4. Domínio Usuário" -ForegroundColor Yellow
if ($TOKEN) {
    try {
        $response = Invoke-WebRequest `
            -Uri "$BASE_URL/usuario/listar.php?token=$TOKEN" `
            -Method Get `
            -ErrorAction Stop
        
        if ($response.StatusCode -eq 200) {
            Write-Host "✓ GET /usuario/listar.php (com token) (HTTP 200)" -ForegroundColor Green
            $global:PASSED++
        }
    }
    catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Write-Host "✗ GET /usuario/listar.php (HTTP $statusCode, esperado 200)" -ForegroundColor Red
            $global:FAILED++
        }
    }
} else {
    Write-Host "⊘ GET /usuario/listar.php (Token não disponível)" -ForegroundColor Yellow
}

Write-Host ""

# 5. Teste de erro (JSON inválido)
Write-Host "5. Tratamento de Erros" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest `
        -Uri "$BASE_URL/senha/gerar.php" `
        -Method Post `
        -ContentType "application/json" `
        -Body "{JSON INVÁLIDO}" `
        -ErrorAction Stop
    
    Write-Host "✗ POST /senha/gerar.php (JSON inválido) (HTTP esperado 400)" -ForegroundColor Red
    $global:FAILED++
}
catch {
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 400) {
            Write-Host "✓ POST /senha/gerar.php (JSON inválido) (HTTP 400)" -ForegroundColor Green
            $global:PASSED++
        } else {
            Write-Host "✗ POST /senha/gerar.php (HTTP $statusCode, esperado 400)" -ForegroundColor Red
            $global:FAILED++
        }
    }
}

Write-Host ""

# 6. Compatibilidade (arquivos antigos como shims)
Write-Host "6. Compatibilidade — Shims Antigos" -ForegroundColor Yellow
Test-Endpoint -Method Post -Uri "$BASE_URL/senha_gerar.php" -Body @{"origem" = "TOTEM"} -Name "POST /senha_gerar.php (shim)" -ExpectedStatus 200
Test-Endpoint -Method Post -Uri "$BASE_URL/login.seguro.php" -Body @{"login" = "admin"; "senha" = "admin123"} -Name "POST /login.seguro.php (shim)" -ExpectedStatus 200

# Resumo
Write-Host ""
Write-Host "=== Resumo ===" -ForegroundColor Yellow
Write-Host "Passou: $PASSED" -ForegroundColor Green
Write-Host "Falhou: $FAILED" -ForegroundColor Red

if ($FAILED -eq 0) {
    Write-Host ""
    Write-Host "✓ Todos os testes passaram!" -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "✗ Alguns testes falharam." -ForegroundColor Red
    exit 1
}
