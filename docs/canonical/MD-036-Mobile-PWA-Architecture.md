# MD-036 — Mobile PWA Architecture

## Status

Documento Canônico da Arquitetura Mobile e PWA da Plataforma Enterprise.

---

## Objetivo

Portal como PWA completo.

Mobile first mas desktop igualmente.

Offline first integrado.

Aplicativos mobile para todo ecossistema.

---

## Lei Fundamental

```text
Portal não é só web.

Portal é qualquer tela.

Qualquer tela é offline capable.

Offline é sync.
```

---

## PWA Architecture

```text
Service Worker
Cache Strategy
Push Notifications
Install Prompt
Offline Fallback
Background Sync
```

### Capabilities

```text
Add to Home Screen
Push notifications
Camera access
Geolocation
Biometric auth
File system
Background processing
App shortcuts
Share target
```

---

## Mobile First Design

Prioriza:

```text
Touch targets mínimo 44x44px
Responsive layouts
Gesture support
Performance (LCP < 2.5s)
Battery efficiency
Data efficiency
Connection resilience
Progressive enhancement
```

### Breakpoints

```text
Mobile: < 768px
Tablet: 768px - 1024px
Desktop: > 1024px
Wide: > 1440px
```

---

## Offline First

### Strategy

```text
Cache first
Network fallback
Background sync
Conflict resolution
Data merge
Offline queues
```

### Data Synchronization

```text
Local DB (IndexedDB)
Sync queue
Conflict detection
Merge strategies
Timestamp resolution
User resolution
Queue persistence
Sync status indicators
```

---

## Native Mobile

Para apps críticos:

```text
Mobile SDK
Native bridge
Biometric integration
Push nativo
Deep linking
App store deployment
```

---

## Apps Registradas

```text
Portal Mobile
CRM Mobile
Field Service
Atendimento
Gestor
Vendas
Chat
Social
AVA
PWA_ENGINE
MOBILE_SDK
OFFLINE_MANAGER
SYNC_SERVICE
PUSH_SERVICE
DEVICE_MANAGER
```

---

## Integração com Outros MDs

- **MD-002 (Auth Core)**: auth mobile.
- **MD-003 (Operational Context)**: contexto mobile.
- **MD-005 (Event Store)**: eventos mobile.
- **MD-010 (Security Core)**: security mobile.
- **MD-014 / MD-019 (App Registry)**: apps mobile.
- **MD-020 (Portal Core)**: portal mobile.
- **MD-026 (Security Zero Trust)**: security mobile.
- **MD-034 (IAM)**: permissões mobile.
- **MD-035 (Security Trust Architecture)**: threat mobile.
- **MD-037 (Customer Experience Platform)**: CX mobile.

---

## Próximo MD recomendado

```text
MD-037 — Customer Experience Platform
```

Experiência cliente integrada.

---

## Regras Canônicas

1. Mobile é primeiro.
2. Portal é PWA.
3. Offline é first.
4. Sync é automático.
5. Mobile respeita tenant.
6. Mobile respeita security.
7. Mobile integra com Biometric.
8. Mobile integra com Push.
9. PWA integra com Portal.
10. Qualquer tela é Portal.
11. Offline tem cache.
12. Cache tem estratégia.
13. Sync tem conflito.
14. Conflito tem resolução.
15. Mobile integra com IA.
16. Mobile integra com Social.
17. Mobile integra com Analytics.
18. Mobile é instalar.
19. PWA é responsivo.
20. Portal é universal.
21. Apps mobile usam Design System.
22. Offline respeita multitenant.
23. Push respeita privacy.
24. Biometric é fallback, não primário.
25. Mobile Security é MD-035.
