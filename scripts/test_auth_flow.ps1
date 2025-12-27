param(
    [string]$Login = "recepcao1",
    [string]$Senha = "Senha123!",
    [string]$BaseUrl = "http://localhost"
)

Write-Host "Login: $Login"

$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

$loginBody = @{ login = $Login; senha = $Senha } | ConvertTo-Json
$loginResp = Invoke-RestMethod -Uri "$BaseUrl/api/auth.php" -Method Post -Body $loginBody -ContentType 'application/json' -WebSession $session

Write-Host "Login response:`n" (ConvertTo-Json $loginResp -Depth 4)

if (-not $loginResp.token) { Write-Error "Login falhou"; exit 1 }

$token = $loginResp.token

Write-Host "Calling /api/auth/me.php with token..."
$me = Invoke-RestMethod -Uri "$BaseUrl/api/auth/me.php" -Method Get -Headers @{ Authorization = "Bearer $token" } -WebSession $session
Write-Host "me:`n" (ConvertTo-Json $me -Depth 4)

# Simular refresh (cookie-based)
Write-Host "Refreshing token (via cookie)..."
$refreshResp = Invoke-RestMethod -Uri "$BaseUrl/api/auth/refresh.php" -Method Post -Body '{}' -ContentType 'application/json' -WebSession $session
Write-Host "refresh response:`n" (ConvertTo-Json $refreshResp -Depth 4)

# Logout
Write-Host "Logging out (revogando refresh cookie)..."
$logoutResp = Invoke-RestMethod -Uri "$BaseUrl/api/auth/logout.php" -Method Post -Body '{}' -ContentType 'application/json' -WebSession $session
Write-Host "logout response:`n" (ConvertTo-Json $logoutResp -Depth 4)

Write-Host "Teste concluído."
Write-Host "Teste concluído."