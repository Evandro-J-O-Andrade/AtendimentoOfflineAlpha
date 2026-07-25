# KERNEL MATERIALIZATION — Plano de Construção

## Status: ✅ CORE Runtimes Materializados

### O que foi construído

Pacote `@atendimentooffline/kernel` com **11 runtimes canônicos** + infraestrutura:

```
packages/kernel/src/
├── index.ts                          # Barrel de exportações
├── lib/
│   ├── DispatcherContracts.ts        # Contratos unificados (DispatcherRequest/Response/Client/Event)
│   ├── DispatcherClientAdapter.ts    # ApiDispatcherClientAdapter (transporte HTTP)
│   └── LocalEventBus.ts              # Event bus local para rastreabilidade
└── runtimes/
    ├── identity/                      # MD-KERNEL-001
    ├── tenant/                        # MD-KERNEL-002
    ├── session/                       # MD-KERNEL-003
    ├── context/                       # MD-KERNEL-004
    ├── authorization/                 # MD-KERNEL-005
    ├── discovery/                     # MD-KERNEL-006
    ├── registry/                      # MD-KERNEL-007
    ├── capability/                    # MD-KERNEL-008
    ├── navigation/                    # MD-KERNEL-010
    ├── workflow/                      # MD-KERNEL-011
    └── event/                         # MD-KERNEL-012
```

### Cadeia de dependência

```
DispatcherContracts (base)
        ↓
IdentityRuntime ──→ SessionRuntime ──→ ContextRuntime ──→ AuthorizationRuntime
        ↓                ↓                    ↓
    TenantRuntime   EventRuntime          DiscoveryRuntime
                                    ↓
                            RegistryRuntime
                            CapabilityRuntime
                            NavigationRuntime
                            WorkflowRuntime
```

### Contratos por Runtime

| Runtime | Arquivo | Métodos principais |
|---------|---------|-------------------|
| Identity | `IdentityContracts.ts` | `loadPerson`, `loadUser`, `isAuthenticated`, `compose` |
| Tenant | `TenantContracts.ts` | `loadTenant`, `listTenants`, `compose` |
| Session | `SessionContracts.ts` | `create`, `validate`, `refresh`, `terminate`, `compose` |
| Context | `ContextContracts.ts` | `loadUnidades`, `loadPerfis`, `loadLocais`, `selectContext`, `compose` |
| Authorization | `AuthorizationContracts.ts` | `evaluate`, `assert`, `loadRoles`, `hasPermission`, `compose` |
| Discovery | `DiscoveryContracts.ts` | `discover`, `register`, `listCapabilities`, `getEndpoint`, `compose` |
| Registry | `RegistryContracts.ts` | `register`, `unregister`, `findByModulo`, `findByAcao`, `list`, `compose` |
| Capability | `CapabilityContracts.ts` | `list`, `enable`, `disable`, `checkDependencies`, `compose` |
| Navigation | `NavigationContracts.ts` | `load`, `findByRoute`, `filterByPermission`, `compose` |
| Workflow | `WorkflowContracts.ts` | `listDefinitions`, `start`, `executeStep`, `cancel`, `compose` |
| Event | `EventContracts.ts` | `publish`, `query`, `replay`, `subscribe`, `compose` |

### Eventos canônicos suportados

| Runtime | Eventos |
|---------|---------|
| Session | `SESSION_CREATED`, `SESSION_AUTHENTICATED`, `SESSION_STARTED`, `SESSION_EXPIRED`, `SESSION_REVOKED`, `SESSION_CLOSED` |
| Identity | `IDENTITY.PERSON_LOADED`, `IDENTITY.USER_LOADED` |
| Tenant | `TENANT.LOADED` |
| Context | `CONTEXT.UNIDADES_LOADED`, `CONTEXT.PERFIS_LOADED`, `CONTEXT.LOCAIS_LOADED`, `CONTEXT.SELECTED` |
| Authorization | `AUTH.EVALUATED`, `AUTH.ASSERTED`, `AUTH.DENIED`, `AUTH.ROLES_LOADED` |
| Discovery | `DISCOVERY_SYNC_COMPLETED`, `DISCOVERY_ENDPOINT_REGISTERED`, `DISCOVERY_CAPABILITY_DISCOVERED`, `DISCOVERY_ERROR` |
| Registry | `REGISTRY_ENTRY_REGISTERED`, `REGISTRY_ENTRY_UNREGISTERED`, `REGISTRY_SYNC_COMPLETED`, `REGISTRY_ERROR` |
| Capability | `CAPABILITY_ENABLED`, `CAPABILITY_DISABLED`, `CAPABILITY_DEPENDENCY_CHECKED`, `CAPABILITY_SYNC_COMPLETED`, `CAPABILITY_ERROR` |
| Event | `EVENT_PUBLISHED` |

### Regra de comunicação

Todo runtime se comunica exclusivamente via `DispatcherClient`:

```text
Runtime
   ↓
DispatcherClient.send({
  modulo: 'MODULO',
  acao: 'ACAO',
  payload: {},
  idSessao: number
})
   ↓
sp_master_dispatcher
   ↓
SP de domínio
```

### Próximos passos

1. **Integração Backend**: adicionar `@atendimentooffline/kernel` nas dependências do backend
2. **Integração Frontend**: adicionar `@atendimentooffline/kernel` nas dependências do portal
3. **Event Store Canônico**: implementar `kernel_event_store` no MySQL
4. **SP Master Dispatcher**: garantir que `sp_master_dispatcher` esteja operacional
