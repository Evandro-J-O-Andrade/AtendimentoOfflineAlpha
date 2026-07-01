# MASTER-CONSOLIDADO — Enterprise Platform Architecture

## Um documento. Uma visão. Tudo junto.

---

## 1. ARQUITETURA ENTERPRISE (Internet → Banco)

```text
Internet
├── HTTPS
│
Load Balancer (L7)        ← MAP-021
├── SSL Termination
├── Health Checks
├── Path Routing
│
API Gateway               ← MD-038, MAP-021
├── Auth Middleware (IAM) ← MD-034
├── Rate Limiting
├── Circuit Breaker
│
API Pool (Stateless)      ← MAP-021, LEI 22
├── Node.js instances
├── Runtime stateless
│
Dispatcher / Kernel         ← MD-004, SP-FIRST
├── sp_dispatcher_kernel
├── sp_executor_*
├── sp_master_*
│
MySQL (Core Database)     ← LEI 21
├── CORE_ENTERPRISE (80 tabelas) ← Pessoa, Usuário, Portal, FFA
├── SHARED_SERVICES (15 tabelas) ← Notificações, Configurações
├── CONTEXT_OP (11 tabelas) ← Unidade, Setor, Local
├── INFRA (40 tabelas) ← runtime_*, kernel_*, circuit_breaker
├── DOMAIN_HIS (200 tabelas) ← Atendimento, Farmácia, Laboratório
└── DOMAIN_OTHER (40 tabelas) ← Financeiro, RH, CRM
│
Event Store / Ledger        ← MD-005, MD-025
└── eventos imutáveis
│
Observability               ← MD-065, MAP-021, LC-RES-004
├── Logs
├── Traces
├── Metrics
└── Alerts
```

---

## 2. 4 NÍVEIS DE AUDITORIA DO BANCO

### Nível 1 — CORE ENTERPRISE ⭐⭐⭐⭐⭐
```
pessoa → usuario → sessao_usuario → ffa → atendimento
         ↓         ↓                ↓
      perfil    auth_sessao      senha_*, senha_status
         ↓         ↓                ↓
    permissao   auth_token      filas, status_timeout
         ↓
     saas_entidade (tenant) → unidade
```
**Tabelas**: 80  
**Procedures**: sp_auth_*, sp_usuario_*, sp_sessao_*, sp_master_*

### Nível 2 — SHARED SERVICES (Context-Independent)
```
Notificações, Arquivos, Configurações, Preferências
     ↓
Agenda, Chat, Integrações, Documentos
```
**Tabelas**: 15  
**Modules**: AVA, GLPI, Rede Social, Ramal, Central de Ajuda

### Nível 3 — CONTEXT_OP
```
Unidade → Setor → Local → Local Operacional
     ↓       ↓       ↓         ↓
  agendas   leitos   painéis   triagens
```
**Tabelas**: 11  
**Uso**: HIS requer seleção; outros módulos não

### Nível 4 — DOMAIN (Context-Dependent)
```
HIS, Finance, RH, CRM, SAC, Logística
```
**Tabelas**: 268

---

## 3. CLASSIFICAÇÃO DETALHADA

| Classificação | Tabelas | Procedures | Módulos/Apps |
|--------------|---------|------------|--------------|
| CORE_ENTERPRISE | 80 | 59 (sp_master_*, sp_kernel_*, sp_ledger_*) | Portal, IAM, Auth |
| SHARED_SERVICES | 15 | 10 | Chat, Agenda, Notificações |
| CONTEXT_OP | 11 | 5 | Unidade, Setor, Local |
| INFRA | 40 | 13 (sp_runtime_*, sp_sync_*) | Runtime, Sync, Circuit |
| DOMAIN_HIS | 200 | 99 (sp_recepcao_*, sp_triagem_*, sp_atendimento_*) | HIS |
| DOMAIN_OTHER | 40 | 20 | Finance, RH, CRM, SAC |
| **TOTAL** | **481** | **228** | **10 domínios** |

---

## 4. FLUXOS ENTERPRISE (Portal → Operação)

### Fluxo 1 — Login Global (sem contexto operacional)
```
Login
    ↓
Portal
    ↓
APP sem contexto (Chat, AVA, GLPI, Social)
    ↓
Ação direta (não requer unidade)
```

### Fluxo 2 — Login Operacional (HIS)
```
Login
    ↓
Portal
    ↓
APP HIS
    ↓
Selecionar Unidade
    ↓
Selecionar Especialidade
    ↓
FFA (orquestradora) ← sp_master_criar_ffa
    ↓
Senhas, Atendimentos, Farmácia, Laboratório
```

### Fluxo 3 — Async Execution (Shared State)
```
API (qualquer) → runtime_execution_queue → Worker (qualquer)
                    ↓
              Job processado
                    ↓
              Evento registrado
                    ↓
              runtime_contexto atualizado
```

---

## 5. LEIS IMPLEMENTADAS

| Lei | Documento | Aplicação |
|-----|-----------|-----------|
| LEI 05 | MD-110 | SP-FIRST (sp_* procedures) |
| LEI 14 | MD-CANONICO-IA-001 | Classificação CORE/SHARED/CONTEXT/DOMAIN |
| LEI 21 | MD-110 | MySQL é Fonte da Verdade |
| LEI 22 | MD-110 | APIs Stateless |
| LC-RES-001 | MD-110 | Operação Contínua |
| LC-RES-002 | MD-110 | APIs Stateless |
| LC-RES-003 | MD-110 | Failover Automático |

---

## 6. LACUNAS TÉCNICAS

### Tabelas Core Faltando
| Tabela | Necessidade | Impacto |
|--------|-------------|---------|
| feature | Controlar features por tenant | Medium |
| workspace | Grupos de trabalho/personalizados | Low |
| favorite | Favoritos do usuário | Low |
| notification_center | Central de notificações (única) | High |

### Procedures Core Faltando
| Procedure | Necessidade | Impacto |
|-----------|-------------|---------|
| sp_workspace_* | Workspace CRUD | Low |
| sp_feature_* | Feature toggle | Medium |
| sp_favorite_* | Favorite CRUD | Low |

---

## 7. PRÓXIMOS PASSOS

1. **Validar estado compartilhado** - runtime_contexto + runtime_execution_queue
2. **Consolidar Notification Engine** - unificar notificações fragmentadas
3. **Implementar Feature Toggle System** - permitir rollout gradual
4. **Definir API contract** - OpenAPI para todas as APIs
5. **Mapear contexto global** - separar de contexto operacional
6. **Validar multi-tenant isolation** - RLS + id_entidade

---

## 8. REFERÊNCIAS

| Documento | Link |
|-----------|------|
| MD-110 Canonical Laws | docs/canonical/MD-110-Canonical-Laws.md |
| MAP-021 Infrastructure | docs/canonical/MAP-021-Platform-Infrastructure-Domain.md |
| Audit by Level | docs/canonical/AUDITORIA-DE-TABELAS-CORE-POR-NIVEL.md |
| Inventário Completo | docs/database/tables/INVENTARIO_COMPLETO.md |

---

**Master Consolidado — 2026-06-30**  
Um só documento. Uma só visão.