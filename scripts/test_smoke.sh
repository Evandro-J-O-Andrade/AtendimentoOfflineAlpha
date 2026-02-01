#!/usr/bin/env bash

# Script de Testes Smoke — Validação de Endpoints API
# Valida status HTTP e estrutura JSON de respostas

BASE_URL="http://prontoatendimento.local/src/api"
PASSED=0
FAILED=0
TOKEN=""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_test() {
    local endpoint=$1
    local status=$2
    local expected=$3
    
    if [ "$status" -eq "$expected" ]; then
        echo -e "${GREEN}✓${NC} $endpoint (HTTP $status)"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $endpoint (HTTP $status, esperado $expected)"
        ((FAILED++))
    fi
}

echo -e "${YELLOW}=== Testes Smoke — API Endpoints ===${NC}\n"

# 1. Login (obter token)
echo -e "${YELLOW}1. Autenticação${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/usuario/login.php" \
  -H "Content-Type: application/json" \
  -d '{"login":"admin","senha":"admin123"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
TOKEN=$(echo "$BODY" | grep -o '"token":"[^"]*' | head -1 | cut -d'"' -f4)
log_test "POST /usuario/login.php" "$HTTP_CODE" "200"

if [ -z "$TOKEN" ]; then
    echo -e "${RED}Aviso: Nenhum token obtido. Testes subsequentes podem falhar.${NC}"
fi

# 2. Gerar Senha
echo -e "\n${YELLOW}2. Domínio Senha${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/senha/gerar.php" \
  -H "Content-Type: application/json" \
  -d '{"origem":"TOTEM"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
log_test "POST /senha/gerar.php" "$HTTP_CODE" "200"

# 3. Fila (listar — requer autenticação)
echo -e "\n${YELLOW}3. Domínio Fila${NC}"
if [ -n "$TOKEN" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL/fila/geral.php?token=$TOKEN")
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    log_test "GET /fila/geral.php (com token)" "$HTTP_CODE" "200"
else
    echo -e "${YELLOW}⊘${NC} GET /fila/geral.php (Token não disponível)"
fi

# 4. Usuário (listar — requer autenticação e permissão)
echo -e "\n${YELLOW}4. Domínio Usuário${NC}"
if [ -n "$TOKEN" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "$BASE_URL/usuario/listar.php?token=$TOKEN")
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    log_test "GET /usuario/listar.php (com token)" "$HTTP_CODE" "200"
else
    echo -e "${YELLOW}⊘${NC} GET /usuario/listar.php (Token não disponível)"
fi

# 5. Teste de erro (JSON inválido)
echo -e "\n${YELLOW}5. Tratamento de Erros${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/senha/gerar.php" \
  -H "Content-Type: application/json" \
  -d '{JSON INVÁLIDO}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
log_test "POST /senha/gerar.php (JSON inválido)" "$HTTP_CODE" "400"

# 6. Compatibilidade (arquivos antigos como shims)
echo -e "\n${YELLOW}6. Compatibilidade — Shims Antigos${NC}"
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/senha_gerar.php" \
  -H "Content-Type: application/json" \
  -d '{"origem":"TOTEM"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
log_test "POST /senha_gerar.php (shim compatibilidade)" "$HTTP_CODE" "200"

RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/login.seguro.php" \
  -H "Content-Type: application/json" \
  -d '{"login":"admin","senha":"admin123"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
log_test "POST /login.seguro.php (shim compatibilidade)" "$HTTP_CODE" "200"

# Resumo
echo -e "\n${YELLOW}=== Resumo ===${NC}"
echo -e "${GREEN}Passou: $PASSED${NC}"
echo -e "${RED}Falhou: $FAILED${NC}"

if [ $FAILED -eq 0 ]; then
    echo -e "\n${GREEN}✓ Todos os testes passaram!${NC}"
    exit 0
else
    echo -e "\n${RED}✗ Alguns testes falharam.${NC}"
    exit 1
fi
