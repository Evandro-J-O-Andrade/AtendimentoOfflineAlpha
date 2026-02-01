# Testes — Integração Frontend/Backend

## Testes Smoke (Básicos)

Os testes smoke validam que os endpoints retornam status HTTP correto e estrutura JSON válida.

### Executar Testes (Windows PowerShell)

```powershell
cd d:\AtendimentoOfflineAlpha
.\scripts\test_smoke.ps1
```

**Saída esperada:**
```
✓ POST /usuario/login.php (HTTP 200)
✓ POST /senha/gerar.php (HTTP 200)
✓ GET /fila/geral.php (com token) (HTTP 200)
✓ GET /usuario/listar.php (com token) (HTTP 200)
✓ POST /senha/gerar.php (JSON inválido) (HTTP 400)
✓ POST /senha_gerar.php (shim) (HTTP 200)
✓ POST /login.seguro.php (shim) (HTTP 200)

=== Resumo ===
Passou: 7
Falhou: 0

✓ Todos os testes passaram!
```

### Executar Testes (Linux/Mac Bash)

```bash
cd /d/AtendimentoOfflineAlpha
bash ./scripts/test_smoke.sh
```

---

## Pontos de Validação Importantes

### 1. Resposta Padrão
- ✓ Todos os endpoints retornam JSON com campos: `ok` (boolean), `data` (object), `error` (string se ok=false)
- ✓ Códigos HTTP alinhados: 200 (sucesso), 400 (validação), 401 (auth), 403 (permissão), 500 (erro)

### 2. Autenticação
- ✓ Token é gerado ao fazer login em `/usuario/login.php`
- ✓ Token é enviado como parâmetro query (`?token=...`) ou header `Authorization: Bearer ...`
- ✓ Endpoints protegidos retornam 401 sem token válido

### 3. Validação de Campos
- ✓ Campos obrigatórios são validados (ex: `id_usuario`, `id_atendimento`)
- ✓ JSON inválido retorna HTTP 400 com mensagem descritiva

### 4. Transações
- ✓ Operações multi-passo (recepção, triagem, internação) usam `BEGIN/COMMIT/ROLLBACK`
- ✓ Em caso de erro, a transação é automaticamente revertida

### 5. Compatibilidade
- ✓ Arquivos antigos (ex: `senha_gerar.php`, `login.seguro.php`) funcionam como shims que incluem os novos handlers
- ✓ URLs antigas continuam funcionando (backward compatibility)

---

## Testes Manuais (via Postman ou cURL)

### Login
```bash
curl -X POST http://prontoatendimento.local/src/api/usuario/login.php \
  -H "Content-Type: application/json" \
  -d '{"login":"admin","senha":"admin123"}'
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "token": "abc123def456...",
    "usuario": {
      "id_usuario": 1,
      "login": "admin",
      "nome": "Administrador",
      "perfis": ["ADMIN"]
    }
  }
}
```

### Gerar Senha
```bash
curl -X POST http://prontoatendimento.local/src/api/senha/gerar.php \
  -H "Content-Type: application/json" \
  -d '{"origem":"TOTEM"}'
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "id_senha": 1,
    "numero": 101,
    "origem": "TOTEM",
    "data_hora": "2026-02-01 10:30:00"
  }
}
```

### Abrir Atendimento (Recepção)
```bash
curl -X POST http://prontoatendimento.local/src/api/atendimento/recepcao.php \
  -H "Content-Type: application/json" \
  -d '{
    "nome_completo":"João Silva",
    "cpf":"123.456.789-00",
    "data_nascimento":"1990-05-15",
    "sexo":"M",
    "tipo_atendimento":"CLINICO",
    "id_usuario_logado":1
  }'
```

**Response:**
```json
{
  "ok": true,
  "data": {
    "id_senha": 1,
    "id_atendimento": 10
  }
}
```

### Listar Fila (requer token)
```bash
curl -X GET "http://prontoatendimento.local/src/api/fila/geral.php?token=abc123def456..." \
  -H "Content-Type: application/json"
```

**Response:**
```json
{
  "ok": true,
  "data": [
    {
      "id_ffa": 1,
      "numero_senha": 101,
      "status": "AGUARDANDO",
      "local": "Triagem",
      "horario_chegada": "2026-02-01 10:30:00"
    }
  ]
}
```

---

## Testes de Integração (Frontend ↔ Backend)

### Cenário 1: Fluxo Completo de Atendimento
1. ✓ Frontend chama `/usuario/login.php` → recebe token
2. ✓ Frontend chama `/senha/gerar.php` → recebe id_senha
3. ✓ Frontend chama `/atendimento/recepcao.php` com id_senha → recebe id_atendimento
4. ✓ Frontend chama `/triagem/registrar.php` com id_atendimento → triagem registrada
5. ✓ Frontend chama `/atendimento/finalizar.php` → atendimento encerrado

### Cenário 2: Painel de Chamadas
1. ✓ Frontend chama `/usuario/login.php` (perfil PAINEL)
2. ✓ Frontend faz polling em `/fila/geral.php` a cada 5s
3. ✓ Usuário clica em "Chamar Próximo" → frontend chama `/fila/chamar.php`
4. ✓ Painel é atualizado com novo paciente e auditoria é registrada

### Cenário 3: Gerenciamento de Usuários
1. ✓ Admin faz login → obtem token com perfil ADMIN
2. ✓ Admin chama `/usuario/listar.php` → lista todos os usuários
3. ✓ Admin chama `/usuario/criar.php` → novo usuário criado
4. ✓ Admin chama `/usuario/atualizar.php` → usuário atualizado com novos perfis

---

## Troubleshooting

### "Token inválido" em endpoints protegidos
→ Faça login novamente em `/usuario/login.php` e use o novo token

### "Acesso negado" em `/usuario/listar.php`
→ Usuário deve ter perfil ADMIN ou SUPORTE

### "JSON inválido"
→ Verifique se o body está em formato JSON válido (sem erros de sintaxe)

### "Falha ao registrar triagem"
→ Verifique se `id_risco` existe em `classificacao_risco` e `id_atendimento` é válido

### "Campos obrigatórios ausentes"
→ Verifique requisição; certifique-se de enviar todos os campos marcados como obrigatórios

---

## Monitoramento Contínuo

Para monitorar o backend em tempo real durante testes:

```bash
# Terminal 1: Monitorar logs de erro PHP
tail -f /var/log/apache2/error.log

# Terminal 2: Monitorar logs de aplicação (se houver)
tail -f d:/AtendimentoOfflineAlpha/logs/api.log

# Terminal 3: Executar testes
.\scripts\test_smoke.ps1
```

---

**Última atualização:** 2026-02-01
