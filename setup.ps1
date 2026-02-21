# ========================================================
# Start Script - Iniciar Backend + Frontend (Windows)
# ========================================================
# Executar em PowerShell como Administrator se necessário:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Write-Host "==========================================" -ForegroundColor Green
Write-Host "Pronto Atendimento - Full Stack Setup" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# Verifica Node.js
try {
    $nodeVersion = node --version
    Write-Host "✓ Node.js $nodeVersion encontrado" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Node.js não está instalado. Por favor, instale Node.js 18+" -ForegroundColor Yellow
    exit 1
}
Write-Host ""

# Verifica se nos estamos no diretório correto
if (-not (Test-Path "backend") -or -not (Test-Path "frontend")) {
    Write-Host "⚠️  Execute este script no diretório raiz do projeto" -ForegroundColor Yellow
    exit 1
}

# ========================================
# Backend Setup
# ========================================
Write-Host "📦 Configurando Backend..." -ForegroundColor Cyan

Set-Location backend

# Instala dependências se não existem
if (-not (Test-Path "node_modules")) {
    Write-Host "  Instalando dependências do backend..."
    npm install
}

# Cria .env se não existir
if (-not (Test-Path ".env")) {
    Write-Host "  Criando .env do backend..."
    Copy-Item ".env.example" ".env"
    Write-Host "  ⚠️  Configure o arquivo backend\.env com suas credenciais MySQL" -ForegroundColor Yellow
}

Write-Host "✓ Backend preparado" -ForegroundColor Green
Write-Host ""

Set-Location ..

# ========================================
# Frontend Setup
# ========================================
Write-Host "📦 Configurando Frontend..." -ForegroundColor Cyan

Set-Location frontend

# Instala dependências se não existem
if (-not (Test-Path "node_modules")) {
    Write-Host "  Instalando dependências do frontend..."
    npm install
}

# Cria .env.local se não existir
if (-not (Test-Path ".env.local")) {
    Write-Host "  Criando .env.local do frontend..."
    Copy-Item ".env.example" ".env.local"
}

Write-Host "✓ Frontend preparado" -ForegroundColor Green
Write-Host ""

Set-Location ..

# ========================================
# Resumo
# ========================================
Write-Host "✓ Setup completo!" -ForegroundColor Green
Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Para iniciar o sistema:" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Terminal 1 - Backend:" -ForegroundColor Cyan
Write-Host "  cd backend"
Write-Host "  npm start"
Write-Host ""
Write-Host "Terminal 2 - Frontend:" -ForegroundColor Cyan
Write-Host "  cd frontend"
Write-Host "  npm run dev"
Write-Host ""
Write-Host "URLs:" -ForegroundColor Yellow
Write-Host "  Backend: http://localhost:3000"
Write-Host "  Frontend: http://localhost:5173"
Write-Host ""
Write-Host "Não esqueça de:" -ForegroundColor Yellow
Write-Host "  1. Configurar backend\.env com suas credenciais MySQL"
Write-Host "  2. Ter o MySQL rodando"
Write-Host "  3. Ter o dump importado no banco pronto_atendimento"
Write-Host ""
