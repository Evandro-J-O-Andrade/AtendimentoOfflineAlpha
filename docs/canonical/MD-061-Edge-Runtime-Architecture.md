# MD-061 — Edge Runtime Architecture

## Status

Documento Canônico da Arquitetura de Runtime Edge da Plataforma Enterprise.

---

## Objetivo

Definir o Runtime Local que permite execução offline, sincronização e resiliência.

Plataforma funciona sem internet.

Dados ficam locais. Sync acontece quando conecta.

---

## Princípio Fundamental

```text
A operação não pode parar
porque a internet caiu.
```

---

## Edge Runtime Concept

```text
Portal Cloud
+
Runtime Local
```

Runtime Local é:

```text
Cache inteligente
Fila de eventos local
Validação local
Sync engine
SP local
Runtime Offline First
```

Runtime Local não é:

```text
Servidor por filial
Réplica do banco central
Clone do Portal
Instalação complexa
Dependência de infraestrutura local pesada
```

---

## Runtime Architecture

```text
Portal Cloud
    ├── Portal Core
    ├── Dispatcher Central
    ├── Event Store
    └── Sync Gateway
            ↕ sync (WebSocket / HTTP)
Runtime Local (Filial / Device / Mobile)
    ├── Local Cache (IndexedDB / SQLite)
    ├── Local Queue (eventos pendentes)
    ├── Local SP Engine (validação local)
    ├── Auth Local (token + grace period)
    ├── Context Local (tenant + perfil)
    └── File Storage Local
```

---

## Responsibilities

### Execução Local

```text
Executar SPs subset offline
Validação de contexto sem cloud
Cache de dados frequentes
Processamento de formulários
Validação de regras de negócio
Geração de eventos locais
```

### Cache Local

```text
IndexedDB / SQLite como storage primário
Cache por tenant
Cache por app
Cache por contexto operacional
Invalidation policy
TTL por tipo de dado
Prefetching inteligente
```

### Fila Offline

```text
Eventos pendentes de sync
Mensagens pendentes
Ações aguardando confirmação
Uploads pendentes
Notificações pendentes
Retry automático
Priorização de sync
```

### Validação Local

```text
JWT validado offline (com grace period)
Tenant validado (local cache)
Contexto validado (local cache)
Permissões cached
Schema validation
Business rules validation
Input sanitization
```

### Autenticação Local Temporária

```text
Sessão cached com expiry
Refresh com token rotation
Device fingerprint local
Offline grace period (24h padrão)
Re-auth obrigatório após grace period
```

---

## Runtime Components

### Local Cache Engine
### Local Queue Engine
### Local SP Engine
### Sync Engine Core

---

## Integration with Display Management

### Display Runtime Mode
Dispositivos kiosk/TV/Totem possuem runtime otimizado:

```text
Always-on mode
Local cache prioritized  
Scheduled sync (periodic)
Minimal UI
Remote management
```

### Display Event Consumption
Displays consomem eventos do Event Store:

```text
SenhaChamada
ExameLiberado
PacientePrioritario
AlertaCritico
Notificacao
```

### Offline Display Behavior
Quando offline:

```text
Exibir última atualização
Mostrar "Desconectado"
Continuar exibindo filas locais
Persistir eventos localmente
Sync automático ao reconectar
```

---

## SP-First Integration for Offline

### SPs Offline Executáveis
Stored Procedures que podem executar offline:

```text
sp_senha_criar
sp_senha_chamar
sp_fila_consultar
sp_paciente_consultar
sp_dashboard_load
```

### SPs Online-Only
Stored Procedures que exigem conexão:

```text
sp_auth_login
sp_integration_sync
sp_ai_request
sp_media_upload
```

### SP Wrapper Pattern
Offline actions seguem:

```text
User Action
↓
Local Validation
↓
SP Local Engine
↓
Generate Event
↓
Add to Queue
↓
Optimistic UI Update
↓
Background Sync
```

```text
Change detection
Delta computation
Batch assembly
Compression
Transport (WebSocket / HTTP)
Conflict detection
Confirmation handling
```

---

## Deployment Models

### Browser PWA

```text
Service Worker
Cache API
IndexedDB
Background Sync
Push Notifications
```

### Desktop (Electron/Tauri)

```text
Full IndexedDB access
File system access
Native integrations
Auto-updater
Background sync
```

### Mobile (Capacitor/React Native)

```text
SQLite local
Background sync
Push notifications
Biometric auth
Offline maps
Native file access
```

### Kiosk/Totem/Panel

```text
Always-on mode
Local cache prioritized
Scheduled sync
Minimal UI
Remote management
```

---

## Offline Resilience

### Grace Periods

```text
Auth grace: 24h (must re-auth after)
Data freshness: configurable per data type
  - Critical (tickets, orders): 5 min
  - Important (CRM, SAC): 1 hour
  - Reference (catalogs, policies): 24h
  - Static (help, policies): 7 days
```

### Degradation Strategy

```text
Full Online → Full features
Degraded → Core features only
Offline → Read-only + local actions
Critical Offline → Emergency mode
```

---

## Integration with Other MDs

- **MD-002 (Auth)**: auth local + offline grace.
- **MD-003 (Operational Context)**: contexto cached localmente.
- **MD-004 (Dispatcher)**: dispatcher local para actions offline.
- **MD-005 (Event Store)**: eventos locais viram eventos cloud.
- **MD-017 (MultiTenant)**: tenant isolation no cache local.
- **MD-020 (Portal Core)**: portal funciona offline.
- **MD-034 (IAM)**: permissões cached localmente.
- **MD-035 (Security Trust Architecture)**: security local.
- **MD-036 (Mobile PWA)**: runtime no mobile.
- **MD-062 (Offline First Engine)**: estratégia offline-first.
- **MD-063 (Sync Engine)**: sincronização.
- **MD-064 (Conflict Resolution)**: conflitos.

---

## Próximo MD recomendado

```text
MD-062 — Offline First Engine
```

Estratégia offline para apps.

---

## Regras Canônicas

1. Runtime local existe em todo dispositivo.
2. Offline é first class, não fallback.
3. Cache é automático e inteligente.
4. Queue é persistente e confiável.
5. Sync é transparente ao usuário.
6. Auth tem grace period offline.
7. Contexto é cached localmente.
8. Permissões são cached localmente.
9. SPs críticos executam offline.
10. Eventos locais são preservados.
11. Conflict resolution é automática quando possível.
12. Manual review quando necessário.
13. Data priorities guiam sync.
14. Degradation é graceful.
15. Runtime respeita tenant isolation.
16. Runtime respeita security.
17. Runtime é observável.
18. Runtime é atualizável remotamente.
19. Runtime não armazena secrets.
20. Runtime é a ponte entre offline e online.

---

## Proibições

São proibidos:

```text
Runtime como servidor local pesado
Cache sem tenant isolation
Queue sem persistência
Sync sem compressão
Auth sem grace period
Secret armazenado no cache
Cache de dados sensíveis sem criptografia
Sync que bloqueie UI
Offline que perca dados
Conflict sem resolução
Runtime sem kill switch
Runtime sem observabilidade
Offline mode sem documentation
Cache invalidation sem política
```
