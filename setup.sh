#!/bin/bash
# ========================================================
# Start Script - Iniciar Backend + Frontend Simultaneamente
# ========================================================
# Windows: Executar em PowerShell ou renomear para start.bat
# Linux/Mac: chmod +x start.sh && ./start.sh

echo "=========================================="
echo "Pronto Atendimento - Full Stack Setup"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verifica Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠️  Node.js não está instalado. Por favor, instale Node.js 18+${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Node.js$(node --version) encontrado${NC}"
echo ""

# Verifica se nos estamos no diretório correto
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo -e "${YELLOW}⚠️  Execute este script no diretório raiz do projeto${NC}"
    exit 1
fi

# ========================================
# Backend Setup
# ========================================
echo -e "${BLUE}📦 Configurando Backend...${NC}"

cd backend

# Instala dependências se não existem
if [ ! -d "node_modules" ]; then
    echo "  Instalando dependências do backend..."
    npm install
fi

# Cria .env se não existir
if [ ! -f ".env" ]; then
    echo "  Criando .env do backend..."
    cp .env.example .env
    echo -e "${YELLOW}  ⚠️  Configure o arquivo backend/.env com suas credenciais MySQL${NC}"
fi

echo -e "${GREEN}✓ Backend preparado${NC}"
echo ""

cd ..

# ========================================
# Frontend Setup
# ========================================
echo -e "${BLUE}📦 Configurando Frontend...${NC}"

cd frontend

# Instala dependências se não existem
if [ ! -d "node_modules" ]; then
    echo "  Instalando dependências do frontend..."
    npm install
fi

# Cria .env se não existir
if [ ! -f ".env.local" ]; then
    echo "  Criando .env.local do frontend..."
    cp .env.example .env.local
fi

echo -e "${GREEN}✓ Frontend preparado${NC}"
echo ""

cd ..

# ========================================
# Resumo
# ========================================
echo -e "${GREEN}✓ Setup completo!${NC}"
echo ""
echo "=========================================="
echo "Para iniciar o sistema:"
echo "=========================================="
echo ""
echo -e "${BLUE}Terminal 1 - Backend:${NC}"
echo "  cd backend"
echo "  npm start"
echo ""
echo -e "${BLUE}Terminal 2 - Frontend:${NC}"
echo "  cd frontend"
echo "  npm run dev"
echo ""
echo "URLs:"
echo "  Backend: http://localhost:3000"
echo "  Frontend: http://localhost:5173"
echo ""
echo "Não esqueça de:"
echo "  1. Configurar backend/.env com suas credenciais MySQL"
echo "  2. Ter o MySQL rodando"
echo "  3. Ter o dump importado no banco pronto_atendimento"
echo ""
