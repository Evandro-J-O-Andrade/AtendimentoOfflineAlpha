# CORE-003 — PORTAL METADATA

> Status: 🟡 Em implementação (real_metadata)
> Depende de: CORE-001 (Auth), CORE-002 (Context)
> Fonte da verdade: `database/dump/Dump20260618.sql` (banco real)
> Regra: reuso antes de criação. Mocks controlados apenas onde não há decisão de schema.

## Matriz de reaproveitamento

| Item            | Origem no legado/banco real                     | Status      | Decisão | Ação no código |
| --------------- | ----------------------------------------------- | ----------- | ------- | -------------- |
| Navigation      | `sp_auth_menu_get` (OUT `p_resultado` JSON)     | REUSE/ADAPT | ADAPT   | `PortalService.navigation()` chama a SP e traduz para `NavigationContract[]`. O frontend nunca vê "menu": consome `/portal/navigation` e `PortalRuntimeContract.navigation`. |
| Categoria       | `portal_categoria` (tabela real)                | REUSE       | REUSE   | Tabela já existe no dump. Agrupamento/categoria vem do banco; sem nova tabela de aplicativo. |
| Applications    | derivado de `NavigationContract`                | ADAPT       | ADAPT   | `PortalService.applications()` deriva `ApplicationContract[]` da navegação (módulo = aplicação). |
| Widgets         | inexistente no banco/schema (auditoria IA-007: `painel_*` ≠ Portal) | PROPOSE | MOCK | `PortalService.widgets()` retorna `[]` (mock controlado). **Não reutilizar `painel_*`** (domínio clínico/TV Display). Propor `portal_widget`/`portal_dashboard_*` via **ADR** (ver "Auditoria de Domínio"). |
| Dashboard       | inexistente no banco/schema                      | PROPOSE     | MOCK    | `PortalService.dashboard()` retorna dashboard vazio (mock controlado). Propor `portal_dashboard`/`portal_layout` via ADR. |
| Branding        | inexistente por tenant no banco                 | PROPOSE     | MOCK    | `PortalService.branding()` retorna fallback `Enterprise Portal` (mock controlado). Propor `tenant_branding` via ADR-006. |
| Runtime         | composição backend → contrato                   | ADAPT       | ADAPT   | `PortalService.runtime()` monta `PortalRuntimeContract` completo a partir de navigation/applications/branding/dashboard/widgets/notifications. |
| user/tenant/context | `sessao_usuario` (via AuthService)           | ADAPT       | MOCK    | Runtime retorna `null` por enquanto (mock controlado); preenchimento real fica para o fechamento de CORE-002/Auth no Portal. |

## Fluxo (contrato, não implementação)

```
Portal
  ↓ GET /portal/navigation  (ou /portal/runtime/:idSessao)
  ↓ PortalApi.navigation()
  ↓ PortalService
  ↓ sp_auth_menu_get
  ↓ NavigationContract
  ↓ PortalRuntime
  ↓ usePortalRuntime()
```

O Portal não sabe que a navegação veio de uma SP antiga. Recebe contrato.

## Trava semântica

O endpoint de frontend é `/portal/navigation`, **não** `/auth/menu`. A tradução SP → contrato fica dentro do `PortalService`. O conceito de domínio é maior que "menu" (Application Registry + Navigation + Permissions + Widgets no futuro), e o backend faz essa tradução.

## Auditoria de Domínio — Portal Enterprise vs `painel_*` (IA-007 / Lei do Banco Vivo)

Regra aplicada: **procurar responsabilidade, não nome**. O dump é fonte de verdade;
só se provada a ausência de domínio equivalente é que se PROPOSE.

### Metodologia
Entradas: Dump SQL completo (`Dump20260618.sql`), Knowledge Graph (MD-054 / MD-084),
MDs (MD-002 Auth, MD-003 Context, MD-006 Portal, MD-007 AppRegistry, MD-034 IAM),
FRONTs (FRONT-003 Portal Enterprise, FRONT-012 Widget Framework), código atual
(backend, `packages/runtime`, `apps/portal`, `modules/painel`) e o analyzer de SPs
(`tools/sp-analyzer`).

### Evidências — `painel_*` (EXISTENTE · Operacional/Assistencial)
- Tabelas: `painel`, `painel_config`, `painel_config_def`, `painel_lane`,
  `painel_local`, `painel_grupo`, `painel_grupo_local`, `painel_fila_tipo`,
  `painel_evento_stream`, `painel_consumo_evento`, `painel_monitoramento_especialidade`,
  `painel_alertas_tempo`.
- FKs apontam para entidades **operacionais**: `painel.id_unidade → unidade`,
  `painel.id_local_operacional → local`, `painel_config.id_painel → painel`,
  `painel_fila_tipo.id_painel → painel`, `painel_evento_stream.id_painel → painel`.
- Procedures `sp_painel_*` classificadas como **`operations`** pelo
  `tools/sp-analyzer` (`'sp_painel_': 'operations'`) — fila/chamada/TV, não Portal.
- Frontend: `modules/painel` é um **módulo clínico/operacional** (Dashboard de painel),
  não o shell da plataforma.
- Nomes semanticamente assistenciais: `painel_monitoramento_especialidade`,
  `painel_evento_stream`, `painel_consumo_evento`, `painel_alertas_tempo`.

**Conclusão:** `painel_*` = domínio **Painel Clínico / Kiosk / TV Display**
(telas assistenciais, monitores, displays, TVs, painéis de chamada).
**REUSE** — manter e evoluir; **não** utilizar para Portal Enterprise.

### Evidências — Portal Enterprise (NÃO EXISTENTE)
- Banco: única tabela `portal_*` é `portal_categoria` (**órfã, sem dados** — apenas
  agrupamento/categoria). Nenhuma `portal_dashboard`, `portal_widget`, `portal_layout`,
  `portal_preference`, `portal_registry`.
- SPs: nenhuma `sp_portal_*` nem `sp_master_portal` no dump.
- Código: contratos (`WidgetContract`, `PortalRuntimeContract`) e runtime
  (`PortalRuntimeEngine`, `WidgetRenderer` registry) existem; **persistência
  inexistente**.
- `PortalService.widgets()` e `dashboard()` retornam mock `[]` (PROPOSE/MOCK).

**Conclusão:** Portal Enterprise é **domínio novo** → **PROPOSE** legítimo
(não é duplicação de `painel_*`).

### Decisão
| Domínio | Status | Decisão |
| --- | --- | --- |
| `painel_*` (Clínico / TV Display) | EXISTENTE | **REUSE** (não confundir com Portal) |
| Portal Enterprise (`portal_*`) | NÃO EXISTENTE | **PROPOSE** (aguardar ADR + proposta de SQL) |

O Portal nasce **acima** do operacional:
`Pessoa → Usuario → Sessão → Tenant → Contexto → IAM → Portal Runtime → Applications → Widgets → Dashboards`.

### Proposta de schema (PROPOSE · PENDENTE ADR)
Materializar como migration **após** aprovação do ADR. Esboço alinhado à
responsabilidade do Portal Enterprise (não ao `painel_*`):
- `portal_widget` (catálogo de widgets da plataforma)
- `portal_dashboard` (dashboards)
- `portal_dashboard_widget` (associação + ordem + override de config)
- `portal_widget_config` (config global por widget)
- `portal_layout` (layouts)
- `portal_usuario_dashboard` (dashboards do usuário + padrão)
- `portal_dashboard_permission` (permissão de visualização)
- Master: `sp_master_portal` (WIDGETS/DASHBOARD/LAYOUT/PREFERENCES/NOTIFICATIONS)
  → executores `sp_executor_portal_*` (seguir padrão `sp_executor_*` do Kernel; ex.:
  `sp_executor_portal_widgets`, `sp_executor_portal_dashboard`).

> Trava de governança: migrations de `portal_*` **não** são criadas antes da
> aprovação do ADR derivado desta auditoria (MD-CANONICO-IA-005 / IA-007).

## Itens fora do escopo CORE-003

- `widget_registry`, `dashboard_*`, `tenant_branding`: aguardam ADR + proposta de SQL.
- Dispatcher/Guard/Workflow (CORE-007): reuso conceitual do legado, runtime próprio, sem expor SPs.
- HIS/Farma/Faturamento: permanecem no legado até o núcleo CORE fechar.

## Estado de Implementação

CORE-003 saiu da fase de definição e entrou em materialização real.

### Implementado

- `sp_auth_menu_get` validada no dump real (`Dump20260618.sql:17623`); devolve o menu via `OUT p_resultado JSON`.
- `portal_categoria` identificado como fonte existente e classificado como REUSE.
- `PortalService.navigation()` lê os OUT params via variáveis de sessão (`@resultado/@sucesso/@mensagem`) e traduz para `NavigationContract[]`.
- `PortalService.applications()` deriva `ApplicationContract[]` da navegação real.
- `PortalService.runtime()` monta `PortalRuntimeContract` completo.
- `EnterpriseShell` consome `usePortalRuntime()` e renderiza navegação dinâmica real.
- `PortalPage` renderiza a partir de `usePortalRuntime()` (sem mocks de navegação).
- `backend`, `packages/api` e `apps/portal` passam em `tsc --noEmit`.

### Decisões preservadas

- Endpoint frontend oficial: `/portal/navigation` (nunca `/auth/menu`).
- Tradução SP → Contract permanece dentro do `PortalService`.
- Frontend não conhece regras do banco; `packages/api` é a fronteira que impõe os contratos.
- Branding/Dashboard/Widgets/Notifications permanecem como mock controlado (PROPOSE) até ADR.

### Pendências

- Validar OUT params da SP no MySQL vivo (leitura via `@resultado` é a forma portável/agnóstica de driver).
- Executar fluxo completo: Login → Contexto → Portal → Navegação dinâmica.
- Preencher `user/tenant/context` no runtime (hoje `null`) quando o fechamento de identidade no Portal avançar.

### Próximo passo

Após validação do CORE-003, avançar para **Permission Runtime** (CORE-004), consolidando Tenant → Unidade → Contexto Operacional → Permissão → Aplicação → Ação.
