# MD-062 — Offline First Engine

## Status

Documento Canônico do Motor Offline First da Plataforma Enterprise.

---

## Objetivo

Toda aplicação deve suportar operação offline.

Dados disponíveis localmente.

Sync automático quando online.

---

## Lei Fundamental

```text
Offline não é exceção.

Offline é requisito.
```

---

## Offline First Strategy

```text
Local First
Write Locally
Read Locally
Sync Later
Resolve Conflicts
```

---

## Apps Offline Compatible

```text
CRM: clientes, visitas, pedidos
PDV: vendas, estoque local, cupom
Operacional: ordens, checklist, produção
SAC: tickets offline, fotos, áudio
Agenda: eventos, compromissos
Marketplace: produtos, pedidos
Financeiro: despesas, comprovantes
Chat: mensagens offline
Social: posts agendados
Chatbot: respostas cacheadas
```

---

## Data Local Strategy

### Dados que DEVEM estar offline

```text
Perfil do usuário
Tenant configuration
App registry
Permissions (cached)
Catálogos (produtos, serviços)
Políticas e FAQ
Calendário próximo
Tickets ativos
Pedidos em andamento
Formulários padrão
```

### Dados que DEVEM estar online

```text
Pagamentos
Autorizações de alto valor
Envio de NF-e
Integrações externas
IA generation em tempo real
Webhooks de terceiros
Alteração de permissões
```

### Dados que PODEM estar cached

```text
Relatórios históricos
Analytics
Feed social
Chat antigo
Documentos arquivados
```

---

## Offline Write Pattern

```text
User writes data
    ↓
Validation (local rules)
    ↓
Generate event locally
    ↓
Save to local queue
    ↓
Apply optimistic UI update
    ↓
Background sync attempt
    ↓
Success: confirm locally, clear queue
Failure: retry with backoff
Offline: keep in queue
```

---

## Offline Read Pattern

```text
App needs data
    ↓
Check local cache
    ↓
Cache hit + fresh enough: return
Cache hit + stale: return + background refresh
Cache miss: show empty + load from cloud
```

---

## Sync Modes

### Automatic Sync

```text
Trigger: online detection
Trigger: periodic timer
Trigger: app focus
Trigger: critical event
User action: transparent
```

### Manual Sync

```text
Pull-to-refresh
Sync button in settings
Force sync on critical screens
```

---

## Integration with Other MDs

- **MD-061 (Edge Runtime)**: runtime local é a base.
- **MD-002 (Auth)**: auth offline com grace period.
- **MD-003 (Operational Context)**: contexto cached.
- **MD-004 (Dispatcher)**: dispatcher local.
- **MD-005 (Event Store)**: eventos locais.
- **MD-017 (MultiTenant)**: tenant isolation local.
- **MD-020 (Portal Core)**: portal offline.
- **MD-034 (IAM)**: permissões cached.
- **MD-035 (Security Trust Architecture)**: security local.
- **MD-036 (Mobile PWA)**: offline no mobile.
- **MD-063 (Sync Engine)**: sincronização cloud.

---

## Próximo MD recomendado

```text
MD-063 — Sync Engine
```

Motor de sincronização universal.

---

## Regras Canônicas

1. Offline é first class citizen.
2. Local first é a regra.
3. Nenhuma operação bloqueia por conexão.
4. Dados críticos sempre disponíveis.
5. Write nunca perde dado.
6. Sync é transparente.
7. Conflict resolution é automática quando possível.
8. Manual review quando necessário.
9. Grace period para auth.
10. Cache é inteligente.
11. Prioridades guiam sync.
12. Degradation é graceful.
13. Status de sync é visível.
14. Retry é automático.
15. Compressão reduz banda.
16. Delta sync reduz transferência.
17. Background sync não trava UI.
18. Offline mode é funcional, não dummy.
19. Every app respects offline-first.
20. Offline é competitivo advantage.