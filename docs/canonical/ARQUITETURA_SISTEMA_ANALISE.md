# 🔍 ANÁLISE COMPLETA DO SISTEMA - CMDPro

## 📋 VISÃO GERAL DO PROJETO

**Sistema:** CMDPro - Comando de Prontuário Médico Profissional  
**Diretório:** `d:/AtendimentoOfflineAlpha`  
**Stack:** Node.js/Express + MySQL + React

---

## 📁 ESTRUTURA ATUAL DO PROJETO

```
AtendimentoOfflineAlpha/
├── backend/
│   ├── src/
│   │   ├── app.js                    # Express app principal
│   │   ├── auth/                     # Módulo de autenticação
│   │   │   ├── authController.js    # Controller de login
│   │   │   ├── authMiddleware.js    # Middleware JWT
│   │   │   ├── authRoutes.js        # Rotas /api/auth
│   │   │   ├── authService.js       # Lógica de autenticação
│   │   │   ├── permissionMiddleware.js
│   │   │   └── permissionService.js
│   │   ├── config/
│   │   │   ├── database.js          # Pool MySQL
│   │   │   └── jwt.js               # Config JWT
│   │   ├── context/
│   │   │   └── contextService.js    # Gerenciamento de contexto
│   │   ├── controllers/
│   │   │   ├── farmaciaController.js
│   │   │   └── auth/loginController.js
│   │   ├── routes/
│   │   │   ├── farmaciaRoutes.js    # /api/operacional/farmacia
│   │   │   ├── operacionalRoutes.js
│   │   │   └── painelRoutes.js
│   │   ├── runtime/                 # ⚠️ CORE RUNTIME
│   │   │   ├── runtimeGuard.js      # ✅ GUARDIÃO RUNTIME
│   │   │   ├── sessionGuard.js
│   │   │   ├── oracleEngine.js
│   │   │   ├── snapshotValidator.js
│   │   │   └── syncQueueManager.js  # ✅ OFFLINE SYNC
│   │   └── ledger/
│   │       ├── ledgerRoutes.js
│   │       └── ledgerService.js
│   └── sql/
│       ├── farmacia_tables.sql        # Tabelas farmácia
│       ├── seed_autenticacao_completo.sql
│       └── Dump20260305.sql         # Dump do banco
│
├── frontend/
│   └── src/
│       └── apps/operacional/
│           ├── auth/
│           │   └── RuntimeAuthContext.jsx
│           ├── components/
│           │   ├── PatientQueue.jsx
│           │   └── PatientQueue.css
│           ├── layout/
│           │   ├── Layout.jsx        # Sidebar + Router
│           │   └── Layout.css
│           ├── pages/
│           │   ├── Login.jsx        # ✅ Login completo
│           │   ├── Dashboard.jsx
│           │   ├── recepcao/        # ✅ Recepção
│           │   ├── triagem/         # ✅ Triagem
│           │   ├── medico/          # ✅ Médico
│           │   ├── farmacia/        # ✅ Farmácia
│           │   └── enfermagem/       # ✅ Enfermagem
│           ├── runtime/
│           └── security/
│               └── SecurityGuard.jsx
│
├── Captures/                        # 📹 Videos e screenshots
│   ├── CMDPRO FOR HEALTH.mp4
│   └── *.png                       # Screenshots das telas
│
└── *.md                            # Documentação
```

---

## ✅ 1. CORE IMUTÁVEL - JÁ EXISTE

### Runtime Guardião ✅
- [`runtimeGuard.js`](backend/src/runtime/runtimeGuard.js) - Valida sessão JWT
- Valida token estrutural
- Valida sessão server-side via SP
- Heartbeat watchdog

### Autenticação ✅
- JWT com 15min validade
- Refresh token com 7 dias
- Bcryptjs hash de senha
- Sessão por contexto

### Ledger/Auditoria ✅ (parcial)
- [`ledgerService.js`](backend/src/ledger/ledgerService.js)
- Estrutura de logging

### Offline-First ✅ (estrutura)
- [`syncQueueManager.js`](backend/src/runtime/syncQueueManager.js)
- Estrutura para sync offline

---

## ❌ 2. O QUE FALTA - GAPS IDENTIFICADOS

### 2.1 Dispatcher Central ❌ CRÍTICO
**Problema:** Não há um ponto único de entrada para todas as ações.

**O que precisa:**
```
sp_master_dispatcher_runtime
```

**Estratégia:**
- Frontend → POST /runtime/dispatch → Guardião → Motor → Ledger → Return
- Todas as ações passam por um único endpoint

---

### 2.2 Ledger Auditoria Completa ❌ CRÍTICO
**Problema:** O ledger existente é parcial.

**O que precisa criar:**
```sql
-- Tabela de eventos append-only
CREATE TABLE atendimento_evento_ledger (
    id_evento BIGINT AUTO_INCREMENT,
    uuid_transacao CHAR(36) NOT NULL,
    id_usuario BIGINT NOT NULL,
    id_perfil BIGINT NOT NULL,
    acao VARCHAR(100) NOT NULL,
    estado_origem VARCHAR(50),
    estado_destino VARCHAR(50),
    payload JSON,
    hash_sha256 CHAR(64),
    created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
    PRIMARY KEY (id_evento),
    INDEX idx_transacao (uuid_transacao),
    INDEX idx_usuario (id_usuario),
    INDEX idx_created (created_at)
);
```

---

### 2.3 Painéis Configuráveis ❌ IMPORTANTE
**O que precisa:**

| Tabela | Objetivo |
|--------|----------|
| `painel` | Cadastro de painéis |
| `painel_filtro` | Filtros por painel |
| `painel_local` | Locais de'affichage |
| `painel_perfil` | Perfis que veem cada painel |
| `painel_setor` | Setores |

**Frontend:**
- Página de configuração de painéis
- Carregamento dinâmico por perfil

---

### 2.4 Motor de Workflow❌ IMPORTANTE
**Já existe (parcial):**
- `fluxo_status` - Status do atendimento
- `fluxo_transicao` - Transições permitidas
- `senha` - Fila de atendimento

**Falta:**
- Procedure `sp_atendimento_transicionar` 
- Validação de transição por perfil
- Histórico de transições

---

### 2.5 API Semântica para Frontend ❌ IMPORTANTE
**Problema:** Frontend chama endpoints específicos.

**Solução:** Criar endpoint único:
```javascript
// POST /api/runtime/dispatch
{
    "sessao": "uuid-sessao",
    "acao": "ATENDIMENTO_INICIAR",
    "contexto": "RECEPCAO",
    "payload": {
        "id_paciente": 123,
        "tipo": "CLINICO"
    }
}
```

---

## 📊 3. ANÁLISE POR MÓDULO

### 3.1 Recepção ✅ (Funcionando)
- [x] Login
- [x] Criar senha
- [x] Buscar paciente
- [x] Encaminhar para triagem

**Melhorias possíveis:**
- Workflow de transição automático
- Ledger de eventos

### 3.2 Triagem ✅ (Funcionando)
- [x] Buscar senhas aguardando
- [x] Registrar sinais vitais
- [x] Encaminhar para médico

**Melhorias possíveis:**
- Validation de campos
- Histórico de triagens

### 3.3 Médico ✅ (Funcionando)
- [x] Receber paciente
- [x] Prescrição de medicamentos
- [x] Encaminhar para farmácia/enfermagem

**Melhorias possíveis:**
- Integração com `atendimento_prescricao`
- Prescrição via dispatcher

### 3.4 Farmácia ✅ (Recém-corrigido)
- [x] Buscar prescrições por senha
- [x] Dispensar medicamentos
- [x] Histórico de dispensação

**Tabela usada:** `atendimento_prescricao` + `dispensacao_medicacao`

### 3.5 Enfermagem ✅ (Funcionando)
- [x] Lista de pacientes
- [x] Registrar medicação
- [x] Acompanhamento

---

## 🎯 4. PRIORIDADES DE IMPLEMENTAÇÃO

### PRIORIDADE 1 - CRÍTICO
1. **Dispatcher Central** - `sp_master_dispatcher_runtime`
2. **Ledger de Auditoria** - `atendimento_evento_ledger`

### PRIORIDADE 2 - IMPORTANTE
3. **API Semântica** - Endpoint único `/runtime/dispatch`
4. **Workflow Engine** - Procedure de transição

### PRIORIDADE 3 - BOM
5. **Painéis Configuráveis** - Tabelas + UI
6. **Offline Sync** - Implementação completa

---

## 📝 5. ARQUIVOS DE REFERÊNCIA

### Documentação Existente:
- `PROJECT_COMPLETE_STATUS.md` - Status geral
- `MAPA_BANCO_DADOS_COMPLETO.md` - Schema do banco
- `REFERENCIA_TECNICA_PROCEDURES.md` - Procedures técnicas

### Assets:
- `Captures/CMDPRO FOR HEALTH.mp4` - Vídeo demo
- `Captures/*.png` - Screenshots das telas
- `Captures/CMDPro.pdf` - Documentação visual

---

## 🔧 6. PRÓXIMOS PASSOS RECOMENDADOS

1. **Implementar Dispatcher** - Ponto único de entrada
2. **Criar Ledger** - Auditoria completa
3. **API Semântica** - Frontend genérico
4. **Painéis Config** - Runtime UI

---

## 📞 CONCLUSÃO

O sistema já possui uma **base sólida**:
- ✅ Autenticação funcionando
- ✅ Runtime Guardião implementado
- ✅ Todas as páginas do frontend
- ✅ Estrutura offline-first

**Falta:**
- ❌ Dispatcher central
- ❌ Ledger completo
- ❌ API semântica
- ❌ Painéis configuráveis

**Recomendação:** Começar pelo dispatcher para evitar fragmentação futura.
