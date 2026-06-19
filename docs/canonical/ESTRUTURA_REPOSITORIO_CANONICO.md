AtendimentoOfflineAlpha/
│
├── docs/
│   └── canonical/
│       ├── ARQUITETURA_CANONICA_PLATAFORMA_NEW_WAVE_SAAS.md
│       ├── MIGRACAO_CANONICA_2026.md
│       ├── ESTRUTURA_ENTERPRISE_CANONICA_NEW_WAVE_SAAS.md
│       ├── MODELO_DOMINIO_CANONICO.md
│       ├── DOMINIO_EMPRESARIAL_CANONICO.md
│       ├── FRONTEND_CANONICO.md
│       ├── BACKEND_CANONICO.md
│       ├── EVENTOS_E_WORKFLOW_CANONICO.md
│       ├── OFFLINE_FIRST_CANONICO.md
│       ├── SEGURANCA_E_IDENTIDADE_CANONICO.md
│       └── FREEZE_ARQUITETURAL_2026.md
│
├── frontend/
│   ├── shell/
│   │   ├── bootstrap/
│   │   │   ├── main.tsx
│   │   │   ├── runtimeLoader.ts
│   │   │   ├── tenantResolver.ts
│   │   │   └── authBootstrap.ts
│   │   ├── layout/
│   │   │   ├── AppShell.tsx
│   │   │   ├── Sidebar.tsx
│   │   │   ├── Topbar.tsx
│   │   │   ├── Workspace.tsx
│   │   │   └── MultiWindowManager.tsx
│   │   ├── router/
│   │   │   ├── AppRouter.tsx
│   │   │   ├── routeRegistry.ts
│   │   │   └── permissionGuard.ts
│   │   └── runtime/
│   │       ├── moduleLoader.ts
│   │       ├── appRegistry.ts
│   │       └── eventBridge.ts
│   ├── core/
│   │   ├── dispatcher/
│   │   │   ├── dispatcherClient.ts
│   │   │   ├── eventEnvelope.ts
│   │   │   ├── idempotencyManager.ts
│   │   │   └── retryPolicy.ts
│   │   ├── event-model/
│   │   │   ├── EventContract.ts
│   │   │   ├── EventTypes.ts
│   │   │   ├── DomainTypes.ts
│   │   │   └── PayloadSchemas.ts
│   │   ├── workflow/
│   │   │   ├── workflowClient.ts
│   │   │   ├── stateMachineProxy.ts
│   │   │   └── executionTracker.ts
│   │   ├── state/
│   │   │   ├── globalStateStore.ts
│   │   │   ├── cacheLayer.ts
│   │   │   └── eventReplay.ts
│   │   └── observability/
│   │       ├── logger.ts
│   │       ├── metrics.ts
│   │       └── traceClient.ts
│   ├── domains/
│   │   ├── assistencial/
│   │   │   ├── pages/
│   │   │   ├── components/
│   │   │   ├── hooks/
│   │   │   └── domainEvents.ts
│   │   ├── farmacia/
│   │   ├── financeiro/
│   │   ├── logistica/
│   │   ├── operacional/
│   │   └── plataforma/
│   ├── apps/
│   │   ├── painel_operacional/
│   │   ├── painel_farmacia/
│   │   ├── painel_recepcao/
│   │   ├── totem_senha/
│   │   ├── dashboard_executivo/
│   │   └── console_admin/
│   ├── shared/
│   │   ├── ui/
│   │   │   ├── buttons/
│   │   │   ├── tables/
│   │   │   ├── modals/
│   │   │   ├── forms/
│   │   │   └── charts/
│   │   ├── hooks/
│   │   ├── utils/
│   │   ├── constants/
│   │   └── types/
│   ├── services/
│   │   ├── apiDispatcher.ts
│   │   ├── authService.ts
│   │   ├── eventService.ts
│   │   ├── stateService.ts
│   │   └── websocketGateway.ts
│   ├── runtime/
│   │   ├── offlineQueue/
│   │   ├── syncEngine/
│   │   ├── localCache/
│   │   └── conflictResolver.ts
│   ├── tenants/
│   │   ├── tenantContext.ts
│   │   ├── tenantConfigLoader.ts
│   │   └── featureFlags.ts
│   ├── pages/
│   │   ├── login/
│   │   ├── selectTenant/
│   │   ├── unauthorized/
│   │   └── error/
│   ├── config/
│   │   ├── env.ts
│   │   ├── appConfig.ts
│   │   └── featureMatrix.ts
│   └── tests/
│       ├── integration/
│       ├── e2e/
│       └── contract/
│
├── apps/
│   ├── portal/
│   ├── saude/
│   ├── farmacia/
│   ├── financeiro/
│   ├── faturamento/
│   ├── suprimentos/
│   ├── logistica/
│   ├── rh/
│   ├── ti/
│   ├── crm/
│   ├── compliance/
│   ├── bi/
│   ├── administracao/
│   ├── comercial/
│   ├── contratos/
│   ├── convenios/
│   ├── atendimento/
│   ├── ouvidoria/
│   ├── juridico/
│   ├── patrimonio/
│   └── projetos/
│
├── dispositivos/
│   ├── painel/
│   ├── totem/
│   ├── kiosk/
│   ├── mobile/
│   ├── tablet/
│   └── tv_corporativa/
│
├── packages/
│   ├── auth/
│   ├── identidade/
│   ├── sessao/
│   ├── contexto/
│   ├── workflow/
│   ├── eventos/
│   ├── auditoria/
│   ├── notificacoes/
│   ├── dashboard/
│   ├── sdk/
│   ├── api_client/
│   ├── webhooks/
│   ├── n8n/
│   ├── ai_sdk/
│   ├── documentos/
│   ├── anexos/
│   ├── formularios/
│   ├── tabelas/
│   ├── ui/
│   ├── themes/
│   ├── hooks/
│   └── runtime/
│
├── backend/
│   ├── auth/
│   ├── portal/
│   ├── identidade/
│   ├── sessao/
│   ├── contexto/
│   ├── workflow/
│   ├── eventos/
│   ├── auditoria/
│   ├── notificacoes/
│   ├── documentos/
│   ├── anexos/
│   ├── integracoes/
│   ├── webhooks/
│   ├── automacoes/
│   ├── ai/
│   ├── api_publica/
│   ├── api_privada/
│   ├── api_mobile/
│   ├── api_dispositivos/
│   ├── sync/
│   └── runtime/
│
├── database/
│   ├── schema/
│   ├── migrations/
│   ├── procedures/
│   ├── functions/
│   ├── views/
│   ├── triggers/
│   ├── eventos/
│   ├── auditoria/
│   ├── seeds/
│   ├── exportacoes/
│   └── dicionario_dados/
│
├── dashboards/
│   ├── executivo/
│   ├── gestor/
│   ├── assistencial/
│   ├── farmacia/
│   ├── financeiro/
│   ├── faturamento/
│   ├── logistica/
│   ├── suprimentos/
│   ├── rh/
│   ├── ti/
│   ├── crm/
│   ├── compliance/
│   └── bi/
│
├── workflow/
│   ├── portal/
│   ├── saude/
│   ├── farmacia/
│   ├── financeiro/
│   ├── faturamento/
│   ├── suprimentos/
│   ├── logistica/
│   ├── rh/
│   ├── ti/
│   ├── crm/
│   ├── compliance/
│   └── corporativo/
│
├── ia/
│   ├── assistentes/
│   ├── copilots/
│   ├── classificadores/
│   ├── triagem_ia/
│   ├── atendimento_ia/
│   ├── sac_ia/
│   ├── cat_ia/
│   ├── analytics_ia/
│   ├── recomendacoes/
│   ├── automacoes/
│   └── modelos/
│
├── runtime/
│   ├── edge/
│   ├── offline/
│   ├── cache/
│   ├── fila_local/
│   ├── reconciliacao/
│   ├── sincronizacao/
│   ├── eventos/
│   └── auditoria_local/
│
├── integracoes/
│   ├── entrada/
│   ├── saida/
│   ├── configuracoes/
│   └── monitoramento/
│
├── infra/
│   ├── docker/
│   ├── kubernetes/
│   ├── terraform/
│   └── monitoramento/
│
├── tests/
│   ├── unit/
│   ├── integration/
│   ├── e2e/
│   └── performance/
│
├── scripts/
│   ├── build/
│   ├── deploy/
│   ├── migrations/
│   └── utils/
│
├── assets/
│   ├── styles/
│   ├── images/
│   └── icons/
│
└── legacy/
    ├── frontend_antigo/
    ├── backend_antigo/
    ├── docs_antigos/
    ├── frontend_rebuild_candidate/
    └── backend_rebuild_candidate/