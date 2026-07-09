# CORE-005 — Platform Runtime

## Propósito

Transformar a sessão autenticada em um objeto canônico unificado (`PlatformRuntime`), eliminando fragmentação entre `AuthSessionContract`, `PortalRuntimeContract`, contratos avulsos e estado espalhado no frontend.

## Conceito

Hoje o frontend consome múltiplas fontes:

```
AuthSessionContract
AuthState
PortalRuntimeContract
ContextContract
TenantContract
NavigationContract
ApplicationContract
...
```

A partir de CORE-005, o portal passa a consumir apenas:

```
PlatformRuntime
```

Esse objeto é composto por:

| Camada | Finalidade |
|--------|------------|
| `session` | Dados canônicos da sessão (`id_sessao_usuario`, tokens, expiração) |
| `identity` | Pessoa, usuário, perfis, credenciais |
| `tenant` | Entidade, marca, domínio |
| `context` | Unidade, local, setor, perfil operacional |
| `portal` | Navigation, applications, dashboard |
| `permissions` | Lista plana de códigos autorizados |
| `capabilities` | Regras dinâmicas adicionais (horário, licença, feature flag, status clínico) |
| `security` | Request ID, CSRF, anti replay |
| `features` | Feature flags efetivas para a sessão |
| `branding` | Identidade visual por tenant |
| `locale` | Idioma, timezone, formato |
| `audit` | Contexto de auditoria corrente |
| `operation` | Último `OperationRuntime` quando aplicável |

## Matriz REUSE / ADAPT / PROPOSE

### REUSE

| Artefato | Tipo | Razão |
|----------|------|-------|
| `sessao_usuario` | Tabela | Fonte oficial de sessão, já materializa contexto |
| `AuthSessionContract` | Interface | Base para `session` |
| `TenantContract` | Interface | Reaproveitada em `tenant` |
| `ContextContract` | Interface | Reaproveitada em `context` |
| `PortalRuntimeContract` | Interface | Estendida para `PlatformRuntimeContract` |
| `PERMISSION_RUNTIME` | Runtime | Herdado diretamente em `permissions` |

### ADAPT

| Artefato | Tipo | Adaptação |
|----------|------|-----------|
| `PortalRuntimeContract` | Interface | Renomear top-level para `PlatformRuntimeContract` e manter compatibilidade de runtime por meio de type narrowing/alias |
| `usuario_contexto` | Tabela | Manter estrutura; readings já são feitos via `sp_auth_contexto_get` |

### PROPOSE

| Artefato | Tipo | Finalidade |
|----------|------|-----------|
| `PlatformRuntimeContract` | Interface | Contrato unificado com todas as camadas acima |
| `PlatformRuntimeEngine` | Runtime | Compor `PlatformRuntime` a partir de contratos e dados de API |
| `PlatformRuntimeBuilder` | Builder | Construção fluida do runtime |
| `permissions` | Campo | Já existe via CORE-004 |
| `capabilities` | Campo/camada | Nova avaliação dinâmica além da permissão binária |
| `security` | Campo | Request ID, CSRF, anti replay metadata |
| `features` | Campo | Feature flags efetivas |
| `locale` | Campo | Locale efetivo por sessão/tenant |
| `audit` | Campo | Contexto mínimo de auditoria para UI/logs |
| `operation` | Campo | Referência ao último `OperationRuntime` aplicável |
| `/portal/platform` | Endpoint | Retorna o `PlatformRuntime` completo para a sessão |

## Regras

1. `PlatformRuntime` é a fonte única de verdade para o shell/portal.
2. Módulos frontend não devem manter estado paralelo de auth/context/permissions.
3. Campos ausentes devem ser `null` ou arrays vazios, nunca `undefined`.
4. Qualquer contrato novo que dependa de identidade/autorização deve ser agregado ao `PlatformRuntime`.
5. CORE-005 não cria regra HIS; apenas agrega runtime.
6. Implementação obrigatoriamente segue **MD-CANONICO-IA-005** (SCAN → REUSE → ADAPT → PROPOSE → SQL → IMPLEMENT → VALIDATE).
7. Nenhum objeto novo será criado sem esgotar REUSE e ADAPT do Dump Canônico.

## Estado

| Item | Status |
|------|--------|
| Doc canônica | Criada |
| Dossiê de Engenharia | Criado |
| Contratos | Pendente |
| Runtime | Pendente |
| Backend Service | Pendente |
| Endpoint `/portal/platform` | Pendente |
| Frontend consumo unificado | Pendente |
| E2E com banco vivo | Pendente |
| Bloqueio | Dossiê não aprovado; nenhum código será alterado antes da aprovação. |
