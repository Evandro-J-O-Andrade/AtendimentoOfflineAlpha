# Refatoração de API — Resumo de Mudanças (Feb 2026)

## Visão Geral

Refatoração completa da API backend (`/src/api/`) para:
- ✓ Organizar endpoints por domínio (pasta estrutura semântica)
- ✓ Padronizar respostas JSON
- ✓ Validação consistente de entrada
- ✓ Tratamento de erros uniforme
- ✓ Compatibilidade com código legado

---

## Estrutura de Pastas

### Antes
```
/src/api/
├── atendimento_recepcao.php
├── atendimento_abrir.php
├── atendimento_finalizar.php
├── atendimento_mudar_local.php
├── senha_gerar.php
├── triagem_registra.php
├── internacao_inicial.php
├── internacao_alta.php
├── usuario_criar.php
├── usuario_listar.php
├── usuario_atualizar.php
└── ...
```

### Depois
```
/src/api/
├── atendimento/
│   ├── recepcao.php       (novo handler)
│   ├── abrir.php          (novo handler)
│   ├── finalizar.php      (novo handler)
│   └── mudar_local.php    (novo handler)
├── senha/
│   └── gerar.php          (novo handler)
├── triagem/
│   └── registrar.php      (novo handler)
├── internacao/
│   ├── inicial.php        (novo handler)
│   └── alta.php           (novo handler)
├── usuario/
│   ├── login.php          (novo handler)
│   ├── criar.php          (novo handler)
│   ├── listar.php         (novo handler)
│   └── atualizar.php      (novo handler)
├── fila/
│   ├── geral.php          (novo handler)
│   └── chamar.php         (novo handler)
│
├── atendimento_recepcao.php    (shim → /atendimento/recepcao.php)
├── atendimento_abrir.php       (shim → /atendimento/abrir.php)
├── atendimento_finalizar.php   (shim → /atendimento/finalizar.php)
├── atendimento_mudar_local.php (shim → /atendimento/mudar_local.php)
├── senha_gerar.php             (shim → /senha/gerar.php)
├── triagem_registra.php        (shim → /triagem/registrar.php)
├── internacao_inicial.php      (shim → /internacao/inicial.php)
├── internacao_alta.php         (shim → /internacao/alta.php)
├── usuario_criar.php           (shim → /usuario/criar.php)
├── usuario_listar.php          (shim → /usuario/listar.php)
├── usuario_atualizar.php       (shim → /usuario/atualizar.php)
├── login.seguro.php            (shim → /usuario/login.php)
└── ...
```

---

## Padrão de Resposta JSON

### Antes (inconsistente)
```json
{
  "ok": true,
  "mensagem": "...",      // ou "erro", ou "message"
  "id_usuario": 1         // ou "dados" ou estrutura variável
}
```

### Depois (padronizado)
```json
{
  "ok": true|false,
  "data": { ... },        // contém resultado da operação
  "error": "mensagem"     // apenas se ok=false
}
```

---

## Mudanças por Domínio

### 1. **SENHA**

| Endpoint | Antes | Depois |
|----------|-------|--------|
| POST `/senha_gerar.php` | Inconsistente | `POST /senha/gerar.php` |

**Mudanças:**
- ✓ JSON validado
- ✓ Resposta com `data: { id_senha, numero, origem, data_hora }`
- ✓ Erro 400 se JSON inválido

---

### 2. **ATENDIMENTO**

| Operação | Antes | Depois |
|----------|-------|--------|
| Recepção | POST `/atendimento_recepcao.php` | `POST /atendimento/recepcao.php` |
| Abrir | POST `/atendimento_abrir.php` | `POST /atendimento/abrir.php` |
| Finalizar | POST `/atendimento_finalizar.php` | `POST /atendimento/finalizar.php` |
| Mudar Local | POST `/atendimento_mudar_local.php` | `POST /atendimento/mudar_local.php` |

**Mudanças:**
- ✓ Validação de campos obrigatórios
- ✓ Respostas com `data: { mensagem, id_atendimento, id_senha }`
- ✓ Transações (BEGIN/COMMIT/ROLLBACK)
- ✓ Erro 500 com mensagem descriptiva

---

### 3. **TRIAGEM**

| Endpoint | Antes | Depois |
|----------|-------|--------|
| Registrar | POST `/triagem_registra.php` | `POST /triagem/registrar.php` |

**Mudanças:**
- ✓ JSON obrigatório
- ✓ Validação: `id_atendimento`, `id_risco`, `id_usuario`
- ✓ Resposta com `data: { mensagem }`

---

### 4. **FILA**

| Operação | Antes | Depois |
|----------|-------|--------|
| Listar | GET `/routes/fila.php?proximo=1` | `GET /fila/geral.php` |
| Chamar | POST `/routes/chamada.php` | `POST /fila/chamar.php` |

**Mudanças:**
- ✓ Autenticação obrigatória
- ✓ Resposta com `data: [ ...pacientes ]`
- ✓ Chamada com auditoria automática

---

### 5. **INTERNAÇÃO**

| Operação | Antes | Depois |
|----------|-------|--------|
| Iniciar | POST `/internacao_inicial.php` | `POST /internacao/inicial.php` |
| Alta | POST `/internacao_alta.php` | `POST /internacao/alta.php` |

**Mudanças:**
- ✓ JSON validado
- ✓ Campos obrigatórios: `id_atendimento`, `id_usuario`
- ✓ Resposta com `data: { mensagem }`
- ✓ Transações

---

### 6. **USUÁRIO**

| Operação | Antes | Depois |
|----------|-------|--------|
| Login | POST `/login.seguro.php` | `POST /usuario/login.php` |
| Criar | POST `/usuario_criar.php` | `POST /usuario/criar.php` |
| Listar | GET `/usuario_listar.php` | `GET /usuario/listar.php` |
| Atualizar | POST `/usuario_atualizar.php` | `POST /usuario/atualizar.php` |

**Mudanças:**
- ✓ Login: resposta com `data: { token, usuario: { id_usuario, nome, perfis } }`
- ✓ Criar: validação de `login` e `senha`
- ✓ Listar: autenticação + perfis (ADMIN/SUPORTE)
- ✓ Atualizar: suporta múltiplos perfis (`id_perfis` array)
- ✓ Transações

---

## Compatibilidade (Backward Compatibility)

Todos os arquivos antigos foram convertidos em **shims** que incluem os novos handlers:

```php
<?php
// Antes: lógica completa
require "config.php";
$pdo = getPDO();
...

// Depois: apenas um include do novo handler
<?php
require_once __DIR__ . '/atendimento/recepcao.php';
```

**Benefício:** URLs antigas continuam funcionando sem quebrar código legado.

---

## Frontend — Atualizações de Services

Os serviços em `/src/services/` foram atualizados para apontar para as novas URLs:

| Service | Método | Antes | Depois |
|---------|--------|-------|--------|
| `atendimento.service.js` | `abrirRecepcao()` | `/atendimento_recepcao.php` | `/atendimento/recepcao.php` |
| `senha.service.js` | `gerarSenha()` | `/senha_gerar.php` | `/senha/gerar.php` |
| `triagem.service.js` | `registrarTriagem()` | `/triagem_registra.php` | `/triagem/registrar.php` |
| `fila.service.js` | `chamar()` | `/routes/chamada.php` | `/fila/chamar.php` |
| `internacao.service.js` | `inicializar()` | `/internacao_inicial.php` | `/internacao/inicial.php` |
| `usuario.service.js` | `login()` | `/auth/auth.php` | `/usuario/login.php` |

---

## Documentação

### Novos Arquivos de Documentação

1. **`/docs/API_ENDPOINTS.md`**
   - Todos os endpoints com exemplos de request/response
   - Códigos HTTP esperados
   - Descrição de autenticação e transações

2. **`/docs/TESTES.md`**
   - Como executar testes smoke
   - Cenários de testes de integração
   - Troubleshooting

3. **`/docs/ARQUITETURA_FRONTEND.md`** (anterior)
   - Hooks do frontend: `useAtendimento()`, `useFila()`, `useTriagem()`, etc.
   - Domain naming: português e alinhado ao banco

---

## Scripts de Teste

### `/scripts/test_smoke.sh` (Linux/Mac)
```bash
bash ./scripts/test_smoke.sh
```

### `/scripts/test_smoke.ps1` (Windows PowerShell)
```powershell
.\scripts\test_smoke.ps1
```

Ambos validam:
- Status HTTP dos endpoints
- Resposta JSON válida
- Compatibilidade de shims

---

## Migração para Novo Frontend

### Passo 1: Instalar Dependências
```bash
cd d:\AtendimentoOfflineAlpha
npm install
```

### Passo 2: Iniciar Dev Server
```bash
npm run dev
```

### Passo 3: Usar Hooks do Frontend
```jsx
import { useAtendimento } from '@shared/hooks/useAtendimento';

function MinhaComponente() {
  const { abrirRecepcao, finalizarAtendimento } = useAtendimento();
  
  const handleAbrirAtendimento = async () => {
    try {
      const resultado = await abrirRecepcao({
        nome_completo: "João Silva",
        tipo_atendimento: "CLINICO",
        id_usuario_logado: 1
      });
      console.log("Atendimento aberto:", resultado.data);
    } catch (error) {
      console.error("Erro:", error.message);
    }
  };
  
  return <button onClick={handleAbrirAtendimento}>Abrir Atendimento</button>;
}
```

### Passo 4: Executar Testes
```bash
npm run test:smoke
```

---

## Rollback (Se Necessário)

Caso precise reverter para versão anterior:

```bash
git revert HEAD~1    # Desfaz último commit
npm install          # Reinstala dependências antigas (se necessário)
npm run dev          # Reinicia dev server
```

---

## Checklist de Validação

- [ ] Todos os endpoints retornam status HTTP correto
- [ ] Respostas JSON seguem padrão `{ ok, data, error }`
- [ ] Autenticação funciona em endpoints protegidos
- [ ] Campos obrigatórios são validados
- [ ] Transações funcionam corretamente
- [ ] Shims de compatibilidade funcionam
- [ ] Frontend services apontam para URLs novas
- [ ] Testes smoke passam (7/7)
- [ ] Componentes React migradas para novos hooks
- [ ] Auditoria registra eventos corretamente

---

## Contato / Suporte

Para dúvidas ou problemas com a refatoração:

1. Verificar logs: `/var/log/apache2/error.log`
2. Executar testes: `.\scripts\test_smoke.ps1`
3. Validar JSON: usar ferramentas como JSONLint
4. Checar documentação: `/docs/API_ENDPOINTS.md`

---

**Data:** 2026-02-01  
**Status:** ✓ Refatoração Completa
