# AUDIT-VIEW-CATALOG

## Status

```text
AUDITORIA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Catálogo auditado de views.
```

---

## 1. Propósito

Este documento é o **catálogo auditado de views** do Kernel Enterprise.

Ele serve para:
- Listar todas as views existentes e propostas
- Classificar cada view: REUSE / ADAPT / EXTEND / MERGE / PROPOSE
- Identificar gaps de leitura
- Garantir que views não duplicam funcionalidade de SPs

Fonte: Dump20260618.sql (0 views) + docs/database/views/kilo-views.json (vazio) + MODEL-PHYSICAL-KERNEL.md.

---

## 2. Metodologia

```text
Para cada view:
1. Existe? (Sim/Não)
2. Está correta? (Sim/Não/Parcial)
3. Usa colunas existentes?
4. Usa FKs válidas?
5. Depende de outra view/SP?
6. Classificar: REUSE/ADAPT/EXTEND/MERGE/PROPOSE
```

---

## 3. Views Existentes

| View | Existe | Classificação | Evidência |
|------|--------|---------------|-----------|
| (nenhuma) | Não | — | Dump20260618.sql não contém views |

**Conclusão**: O banco atual **não possui views**. O arquivo `docs/database/views/kilo-views.json` está vazio (`{}`). Todas as views são PROPOSE.

---

## 4. Views Propostas pelo Modelo Físico (PROPOSE)

| View | Classificação | Descrição | Tabelas Fonte | Dependências |
|------|---------------|-----------|---------------|--------------|
| vw_usuario_summary | PROPOSE | Resumo de usuário com pessoa | usuario, pessoa | — |
| vw_sessao_ativa | PROPOSE | Sessões ativas | sessao_usuario, usuario, tenant | — |
| vw_contexto_ativo | PROPOSE | Contextos ativos | usuario_contexto, usuario, tenant, sessao | — |
| vw_tenant_summary | PROPOSE | Resumo de tenants | saas_entidade, tenant_registry, saas_contrato | — |
| vw_auth_decision | PROPOSE | Decisões de auth | kernel_authz_policy, auth_decision | — |
| vw_runtime_active | PROPOSE | Execuções ativas | runtime_execution_queue | — |
| vw_navigation_active | PROPOSE | Navegação ativa | portal_categoria, usuario_perfil, permissao | — |
| vw_workflow_active | PROPOSE | Workflows ativos | workflow_process, workflow_state | — |
| vw_event_stream | PROPOSE | Stream de eventos | kernel_ledger, evento_geral, eventos_fluxo | — |
| vw_ledger_audit | PROPOSE | Auditoria de ledger | kernel_ledger | — |

---

## 5. Views por Camada

### 5.1 Foundation Layer

| View | Descrição | Motivo |
|------|-----------|--------|
| vw_usuario_summary | JOIN usuario + pessoa para exibição | Evitar JOIN repetido em SPs de consulta |
| vw_sessao_ativa | Sessões não encerradas e não expiradas | Usado por monitoramento e heartbeat |
| vw_contexto_ativo | Contextos em estado ativo | Usado por runtime e navigation |

### 5.2 Governance Layer

| View | Descrição | Motivo |
|------|-----------|--------|
| vw_tenant_summary | JOIN saas_entidade + tenant_registry + saas_contrato | Painel de tenants |
| vw_auth_decision | Histórico de decisões de auth | Auditoria e debug |

### 5.3 Runtime Layer

| View | Descrição | Motivo |
|------|-----------|--------|
| vw_runtime_active | Execuções em andamento | Monitoramento runtime |

### 5.4 Integration Layer

| View | Descrição | Motivo |
|------|-----------|--------|
| vw_navigation_active | Navegação disponível para contexto | Portal dinâmico |
| vw_workflow_active | Workflows em andamento | Monitoramento workflows |
| vw_event_stream | Eventos consolidados | Event sourcing |
| vw_ledger_audit | Ledger para auditoria | Compliance |

---

## 6. Decisões

```text
1. Nenhuma view existente no banco atual.
2. Todas as 10 views propostas são PROPOSE.
3. Views são apenas para leitura (conforme princípio fundamental).
4. Nenhuma view deve conter lógica de negócio — apenas JOIN e filtro.
5. Views não devem substituir SPs — SPs continuam sendo a única porta de escrita.
```

---

## 7. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Criar vw_usuario_summary | Mais utilizada — base para login |
| Alta | Criar vw_sessao_ativa | Base para heartbeat e monitoramento |
| Alta | Criar vw_contexto_ativo | Base para runtime |
| Média | Criar vw_tenant_summary | Painel admin |
| Média | Criar views de runtime | Monitoramento |
| Baixa | Criar views de workflow | Quando workflow for materializado |

---

## 8. Referências

- MODEL-PHYSICAL-KERNEL
- GATE-MODEL-PHYSICAL
- AUDIT-MODEL-PHYSICAL-VS-BANCO
- Dump20260618.sql
- docs/database/views/kilo-views.json

---

## 9. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Catálogo auditado de views |

---

Documento Canônico — AUDIT-VIEW-CATALOG

**Este é o catálogo auditado oficial de views da plataforma New Wave Enterprise.**
