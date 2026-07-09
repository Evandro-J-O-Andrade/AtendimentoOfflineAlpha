# Dossiê de Engenharia — CORE-005 Platform Runtime

## Aviso

Este documento é pré-requisito obrigatório para qualquer implementação do CORE-005.
Nenhum arquivo de código, contrato, SQL ou endpoint será alterado antes da aprovação deste dossiê.

Aplica-se obrigatoriamente:
- MD-CANONICO-IA-005 — Lei de Engenharia e Materialização
- MD-CANONICO-IA-006 — Lei da Evolução Canônica

---

## 1. Objetivo do CORE

### Problema
Hoje o portal consome identidade, contexto, permissões, metadata e aplicações através de múltiplas fontes fragmentadas:
- `AuthSessionContract`
- `ContextContract`
- `PortalRuntimeContract`
- estados locais
- contratos avulsos

Isso fragmenta a semântica, duplica estado e dificulta a evolução.

### Motivação
Criar um objeto canônico unificado no frontend, respeitando:
- banco como fonte da verdade;
- MD-CANONICO-IA-005;
- ADR-010.

### Escopo
- Unificar dados de sessão, identidade, tenant, contexto, portal, permissões, capabilities, security, features, branding, locale, audit e operation no frontend.
- Centralizar consumo no shell/portal.
- Expor endpoint canônico `/portal/platform`.

### Fora do escopo
- Regras HIS.
- Domínios operacionais específicos.
- Tabelas clínicas.

---

## 2. Triangulação Canônica

| Fonte | Situação | Divergência |
|-------|----------|-------------|
| Dump Canônico | Relevante para CORE-005: `sessao_usuario`, `usuario_contexto`, `saas_entidade`, `perfil`, `permissao`, `perfil_permissao`, `permissao_local`, SPs Auth. | **Bloqueio:** `sp_auth_permissions_evaluate` referenciado pelo backend (`PermissionService`) não existe no dump. |
| MD Canônico | CORE-005 define 14 camadas alvo; ADR-010 complementa com `PlatformRuntime` e `OperationRuntime`. | Nenhuma divergência arquitetural. |
| ADR Canônica | ADR-010 aprovada; define estrutura e regras. | Nenhuma divergência. |
| Código Canônico | Backend, runtime, contracts e portal possuem implementação fragmentada, mas suficiente para evolução. | `user`, `tenant` e `context` retornam `null` no backend atual, incomplete. |

Ação obrigatória antes de implementar:
- Confirmar materialização de `sp_auth_permissions_evaluate` no banco.
- Preencher `user`, `tenant` e `context` no backend.

---

## 3. Engenharia Reversa do Banco

### Tabelas

| Objeto | Finalidade | Dependências | Status |
|--------|------------|--------------|--------|
| `sessao_usuario` | Fonte oficial de sessão (tokens, contexto materializado). | `usuario`, `perfil`, `sistema`, `unidade`, `local`, `saas_entidade` | REUSE |
| `usuario_contexto` | Contexto operacional persistido. | `usuario`, `perfil`, `unidade`, `saas_entidade` | ADAPT |
| `saas_entidade` / `tenant_registry` | Tenant/branding. | — | REUSE |
| `unidade`, `local`, `setor` + vínculos usuário | Escopo operacional. | `usuario`, `unidade` | REUSE |
| `permissao`, `perfil_permissao`, `perfil`, `usuario_perfil`, `permissao_local` | Catálogo e RBAC. | — | REUSE |
| `runtime_contexto` | Contexto clínico de runtime (sabor HIS). | `sessao_usuario`, `pessoa` | ADAPT (apenas recuperação) |
| `runtime_api_session_token` | Tokens de API runtime. | `saas_entidade`, dispositivo | REUSE (camada `security`) |
| `portal_categoria`, `portal_noticia` | Agrupamento/menu. | — | REUSE |
| `menu_evento` | Auditoria de menu escrito por `sp_auth_menu_get`. | `sessao_usuario` | REUSE |

### Procedures

| Objeto | Finalidade | Dependências | Status |
|--------|------------|--------------|--------|
| `sp_auth_menu_get` | Monta menu JSON já filtrado por perfil/permissão/local; escreve `menu_evento`. | `sessao_usuario`, `permissao`, `perfil_permissao`, `permissao_local` | REUSE/ADAPT |
| `sp_auth_contexto_get` | Retorna unidades/perfis/salas por sessão. | `sessao_usuario`, `usuario_contexto`, `usuario_unidade`, `usuario_local` | ADAPT |
| `sp_sessao_contexto_get` | Dados de sessão. | `sessao_usuario` | ADAPT |
| `sp_sessao_tem_permissao` | Verifica permissão por sessão. | `sessao_usuario`, `perfil_permissao` | REUSE |
| `sp_permissao_assert` / `sp_permissao_validar` / `sp_contexto_assert_permissao` | Assert/valida assistencial; atual nome/assinatura depende de adaptação prevista em CORE-004. | diverso | ADAPT (quando aplicável) |
| `sp_auth_permissions_evaluate` | **Ausente no dump**. | depende de `sessao_usuario`, `perfil_permissao`, `permissao` | **PROPOSE / BLOQUEIO** |

### Views / Functions / Índices
- Sem view canônica de permissões confirmada no dump (`vw_usuario_permissoes` não encontrada nesta auditoria), consistente com CORE-004 §ADAPT.
- Indexação já existente em `sessao_usuario`.

---

## 4. Engenharia Reversa do Código

| Camada | Arquivo/Ato | Situação | Status |
|--------|-------------|----------|--------|
| contracts | `PortalRuntimeContract` | Base atual; já agrupa user/tenant/context/applications/navigation/widgets/branding/notifications/management/permissions. | ADAPT |
| contracts | `AuthSessionContract`, `TenantContract`, `ContextContract` | Blocos reutilizáveis. | REUSE |
| contracts | `PermissionContract` | Nova em CORE-004, já consolidada. | REUSE |
| runtime | `PortalRuntimeEngine` / `PortalRuntimeBuilder` | `compose()` e `build()` existentes; filtram por permissão; precisam agregar novas camadas. | ADAPT |
| runtime | `resolveApplications`, `resolveNavigation`, `resolveWidgets`, `resolveContext`, `PermissionResolver` | Lógicas reutilizáveis. | REUSE |
| backend | `PortalService` | Orquestra `navigation`, `applications`, `branding`, `dashboard`, `widgets`, `notifications`, `permissions`; retorna `user=tenant=context=null`. | ADAPT |
| backend | `PermissionService` | Chama `sp_auth_permissions_evaluate`. | ADAPT (bloqueado por SQL) |
| backend | `AuthService` | Fonte de session/context por SPs legadas. | REUSE (fonte de dados) |
| backend | `portal.ts` (routes) | Endpoints existentes; faltam `/portal/platform`. | ADAPT |
| frontend | `PortalRuntime`, `EnterpriseShell`, `usePortalRuntime` | Consome runtime atual; precisa passar a consumir `PlatformRuntime` unificado. | ADAPT |

---

## 5. Fluxo Operacional

```
Login
    ↓
SP de autenticação
    ↓
Sessão materializada
    ↓
Contexto
    ↓
Permissões
    ↓
PlatformRuntime agregado
    ↓
Frontend unificado
```

---

## 6. Gap Analysis

| Objeto | Existe | Ação | Justificativa |
|--------|--------|------|---------------|
| `PlatformRuntimeContract` | Não | PROPOSE | Contrato unificado faltante. |
| `PlatformRuntimeEngine` / `PlatformRuntimeBuilder` | Não | PROPOSE | Agregador de todas as camadas. |
| `capabilities`, `security`, `features`, `locale`, `audit`, `operation` | Não | PROPOSE | Camadas novas do runtime. |
| `/portal/platform` | Não | PROPOSE | Endpoint canônico. |
| `sp_auth_permissions_evaluate` | Não | PROPOSE / BLOQUEIO | Backend depende dela; dumping sem SP gera falha. |
| `user/tenant/context` no backend | Parcial | ADAPT | Estão nulos no `PortalService`. |
| `tenant_branding` | Não | PROPOSE futuro | Somente se ADR-006 aprovar. |
| `widget_registry/dashboard_*` | Não | PROPOSE futuro | Somente se houver demanda/ADR. |
| `sp_auth_menu_get` | Sim | ADAPT | Manter assinatura; reaproveitar navegação. |
| `sp_auth_contexto_get` | Sim | ADAPT | Reaproveitar contexto. |

---

## 7. Auditoria Canônica dos Bloqueios

Cada bloqueio foi investigado com evidências diretas de Dump Canônico, MD/ADR e código. Nenhuma suposição.

### Bloqueio 1 — `sp_auth_permissions_evaluate`

| Item | Detalhe |
|------|---------|
| Camada | Banco |
| Objetos envolvidos | `sp_auth_permissions_evaluate` (PROCEDURE proposta), `sessao_usuario`, `perfil_permissao`, `permissao`, `permissao_local` |
| Classificação | **ADAPT** |
| Evidência Dump | `Dump20260618.sql`: 0 ocorrências de `sp_auth_permissions_evaluate`. Lógica equivalente existe em `sp_auth_menu_get` (`Dump20260618.sql:17681-17748`). |
| Evidência MD/ADR | `CORE-004-PERMISSION-RUNTIME.md:37` lista SP como **PROPOSE**; `DOSSIER-CORE-005` §7 indica SQL obrigatório. |
| Evidência código | `backend/src/core/permissions/PermissionService.ts:17`: `CALL sp_auth_permissions_evaluate(?, @permissions)`. |
| Ação | Extrair/adaptar a subconsulta de permissões de `sp_auth_menu_get` para nova procedure, corrigindo bugs/assinatura/dependências faltantes. |
| Risco | Alto — sem ela, `PermissionService.evaluate()` falha e `/portal/permissions` não funciona. |
| Esforço estimado | 3h (análise + SQL + validação) |
| Critério de conclusão | ✓ SQL aplicado; ✓ procedure criada; ✓ executa sem erro; ✓ backend consome; ✓ teste passa. |
| Matriz de dependências | Depende de: nenhum. Desbloqueia: `PermissionService`, `PortalService.runtime()`, endpoint `/portal/permissions`, `PlatformRuntime.permissions`. |
| Impacto arquitetural | Médio — extração de lógica existente; exige refatoro de `sp_auth_menu_get` para consumir nova SP. |
| Compatibilidade | Compatível com CORE-001 a CORE-004. |

#### Evidência Rastreável — Reutilização

Objeto encontrado:
- `sp_auth_menu_get` em `Dump20260618.sql:17623`

Finalidade:
- Monta menu JSON já filtrado por perfil/permissão/local; escreve `menu_evento`.

Regra encontrada:
- A subconsulta de permissões em `sp_auth_menu_get:17681-17748` resolve `JSON_ARRAYAGG` de `permissao.codigo` filtrando por `perfil_permissao.id_perfil`, `permissao.ativo=1`, `permissao.id_entidade`, `permissao_local.id_local=NULL OR =id_local`.

Conclusão:
- A lógica de avaliação de permissões por sessão já existe em `sp_auth_menu_get`. `sp_auth_permissions_evaluate` deve ser **ADAPT**: extrair essa subconsulta para SP standalone, corrigindo bugs/assinatura/dependências faltantes.

#### Ajustes Obrigatórios Antes de Materializar

1. Corrigir chamada `sp_sessao_assert(p_id_sessao)` com assinatura correta (5 parâmetros), ou usar validação inline consistente com `sp_auth_menu_get`.
2. Materializar `permissao_local` ou remover `LEFT JOIN permissao_local` se não existir no banco alvo.
3. Resolver ambiguidade `id_local` vs `id_local_operacional` antes de aplicar.
4. Reconciliar `permissao.modulo` (referenciado em `sp_auth_menu_get`) vs `permissao.grupo_menu` (coluna real na tabela).

#### Separação de Responsabilidades (exigência pré-migration)

Responsabilidade de `sp_auth_menu_get`: apenas navegação/menu.
Responsabilidade de `sp_auth_permissions_evaluate`: apenas autorização/claims.
Não duplicar consultas de `perfil_permissao`/`permissao` entre as duas SPs; se houver sobreposição, extrair regra comum para executor compartilhado.

### Bloqueio 2 — `user`/`person` no backend

| Item | Detalhe |
|------|---------|
| Camada | Backend |
| Objetos envolvidos | `PortalService.runtime()`, `AuthService`, `usuario`, `pessoa`, `PersonContract`, `UserContract` |
| Classificação | **ADAPT** |
| Evidência Dump | `Dump20260618.sql`: tabelas `usuario` e `pessoa` existem; `usuario.id_pessoa` → `pessoa.id_pessoa`. |
| Evidência MD/ADR | `ADR-010:18-46` define `identity`; `PortalRuntimeContract.ts:13` define `user: PersonContract \| null`. |
| Evidência código | `backend/src/core/portal/PortalService.ts:101`: `user: null`. Nenhuma query para `usuario`/`pessoa`. `AuthService.ts` não preenche `user`. |
| Ação | Resolver `user` via `AuthService` ampliado ou SP/query que retorne `PersonContract` a partir de `id_usuario` da sessão e atribuir em `PortalService.runtime()`. |
| Risco | Médio — frontend consome `rt.user.name`. |
| Esforço estimado | 4h (AuthService/PortalService + contrato/mapper) |
| Critério de conclusão | ✓ `user` retorna dados reais; ✓ contrato compatível; ✓ teste passa. |
| Matriz de dependências | Depende de: `AuthService`, `sp_sessao_contexto_get`. Desbloqueia: `PortalService.runtime()`, `PlatformRuntime.identity.user`. |
| Impacto arquitetural | Baixo — amplia serviço existente sem quebrar contratos. |
| Compatibilidade | Compatível com CORE-001 (Auth) e CORE-002 (Context). |

### Bloqueio 3 — `tenant` no backend

| Item | Detalhe |
|------|---------|
| Camada | Backend |
| Objetos envolvidos | `PortalService.runtime()`, `saas_entidade`, `tenant_registry`, `TenantContract` |
| Classificação | **ADAPT** |
| Evidência Dump | `Dump20260618.sql`: `saas_entidade` e `tenant_registry` existem. |
| Evidência MD/ADR | `ADR-010:18-46` define `tenant`; `TenantContract` disponível. |
| Evidência código | `backend/src/core/portal/PortalService.ts:102`: `tenant: null`. Nenhum acesso a `saas_entidade`. |
| Ação | Resolver `tenant` via `id_entidade` da sessão + `saas_entidade`/`tenant_registry` e atribuir em `PortalService.runtime()`. |
| Risco | Médio — frontend consome `rt.tenant.name`. |
| Esforço estimado | 4h (query/service + mapper) |
| Critério de conclusão | ✓ `tenant` retorna dados reais; ✓ contrato compatível; ✓ teste passa. |
| Matriz de dependências | Depende de: `sessao_usuario.id_entidade`, `saas_entidade`. Desbloqueia: `PortalService.runtime()`, `PlatformRuntime.tenant`, branding futuro. |
| Impacto arquitetural | Baixo — consulta direta a tabela existente. |
| Compatibilidade | Compatível com CORE-001 (Auth) e CORE-003 (Portal Metadata). |

### Bloqueio 4 — `AuthService` não injetado no `PortalService`

| Item | Detalhe |
|------|---------|
| Camada | Backend |
| Objetos envolvidos | `PortalService`, `AuthService`, `AuthSessionContract`, `ContextContract` |
| Classificação | **ADAPT** |
| Evidência Dump | N/A — questão de wiring. Fontes de sessão/contexto já existem: `sp_sessao_contexto_get`, `sp_auth_contexto_get`. |
| Evidência MD/ADR | Dossiê §4: `AuthService` = REUSE. `CORE-005` regra 4: contratos de identidade devem agregar ao PlatformRuntime. |
| Evidência código | `backend/src/core/portal/PortalService.ts:1-2`: importa apenas `createConnection` e `permissionService`. Busca por `AuthService` no arquivo = 0 ocorrências. `AuthService.ts:110` exporta `authService`. |
| Ação | Injetar `authService` de `../auth/AuthService` em `PortalService`; usar em `runtime()` para obter `session`/`context` e alimentar `user`/`tenant`/`context`. |
| Risco | Baixo — mudança de import; sem impacto em banco. |
| Esforço estimado | 2h (wiring + mappers) |
| Critério de conclusão | ✓ `PortalService` consome `AuthService`; ✓ `session` e `context` preenchidos; ✓ typecheck ok. |
| Matriz de dependências | Depende de: nenhum. Desbloqueia: Bloqueios 2 e 3, `PortalService.runtime()` completo. |
| Impacto arquitetural | Baixo — melhora arquitetura; elimina duplicação de conexão/contexto. |
| Compatibilidade | Compatível com CORE-001 (Auth), CORE-002 (Context) e CORE-004 (Permission). |

---

## 8. Evidência Rastreável — `sp_sessao_assert`

Objeto existente:
- `sp_sessao_assert` em `Dump20260618.sql:32115`

Finalidade:
- Validar sessão ativa, não expirada, pertencente ao tenant; retorna `JSON`, `sucesso`, `mensagem`.

Regra encontrada:
- Valida `sessao_usuario.ativo`, `expira_em >= NOW()`, `id_entidade IS NOT NULL`.
- Permite validação opcional de permissão via `usuario_perfil`/`perfil_permissao`/`permissao`.

Dependências:
- `sessao_usuario`, `usuario_perfil`, `perfil_permissao`, `permissao`

Chamadas no dump:
- ~74 ocorrências

Conclusão:
- REUSE confirmado. Não há necessidade de criar nova SP de assert. A procedure `sp_auth_permissions_evaluate` deve chamar `sp_sessao_assert(p_id_sessao)` com assinatura correta.

Aviso de drift:
- `sp_sessao_assert` exige 5 parâmetros (2 IN + 3 OUT). O arquivo `sp_auth_permissions_evaluate.sql` atual chama com 1 argumento. Ajuste obrigatório antes de aplicar.

---

## 8. Matriz de Dependências

| Bloqueio | Depende de | Desbloqueia |
|----------|------------|-------------|
| `sp_auth_permissions_evaluate` | nenhum | `PermissionService`, `PortalService.permissions()`, `/portal/permissions`, `PlatformRuntime.permissions` |
| `user`/`person` no backend | `AuthService`, `sp_sessao_contexto_get` | `PortalService.runtime()`, `PlatformRuntime.identity.user` |
| `tenant` no backend | `sessao_usuario.id_entidade`, `saas_entidade` | `PortalService.runtime()`, `PlatformRuntime.tenant`, branding futuro |
| `AuthService` injetado | nenhum | Bloqueios 2 e 3, `PortalService.runtime()` completo |

---

## 9. Ordem de Execução

```text
1. Materializar SP
   sp_auth_permissions_evaluate
        ↓
2. Atualizar PermissionService
   Confirmar chamada e parser JSON
        ↓
3. Atualizar PortalService
   Injetar AuthService
   Preencher session/context/user/tenant
        ↓
4. Atualizar Runtime
   PlatformRuntimeContract / Engine / Builder
        ↓
5. Atualizar Frontend
   Consumir PlatformRuntime unificado
        ↓
6. E2E
   Banco real + fluxo completo
```

---

## 10. Critérios de Conclusão por Bloqueio

| Bloqueio | Done |
|----------|------|
| 1 | ✓ SQL aplicada; ✓ procedure criada; ✓ executa; ✓ backend consome; ✓ teste passa |
| 2 | ✓ `user` retorna dados reais; ✓ contrato compatível; ✓ teste passa |
| 3 | ✓ `tenant` retorna dados reais; ✓ contrato compatível; ✓ teste passa |
| 4 | ✓ `AuthService` injetado; ✓ `session`/`context` preenchidos; ✓ typecheck ok |

---

## 11. Riscos e Esforço

| Bloqueio | Risco | Esforço |
|----------|-------|---------|
| 1 | Alto | 2h |
| 2 | Médio | 4h |
| 3 | Médio | 4h |
| 4 | Baixo | 2h |

Risco global do CORE-005 antes de iniciar implementação:
- ** Médio ** — nenhum bloqueio é arquitetural; todos têm caminho de solução definido.

---

## 12. Regra de Imutabilidade do Dump Canônico

O Dump Canônico é **somente leitura** para engenharia.

Qualquer alteração no banco deve seguir:

```
Dump Canônico (somente leitura)
    ↓
Scripts SQL versionados
    ↓
Aplicação no banco
    ↓
Novo Dump gerado
    ↓
Atualização do inventário
```

Nunca editar o dump manualmente. Ele é um retrato do estado do banco.

---

## 13. Gates de Engenharia

Nenhuma fase é liberada sem passar pelo gate correspondente:

```
GATE 0 — Dossiê aprovado
    ↓
GATE 1 — Banco validado
    ↓
GATE 2 — Backend validado
    ↓
GATE 3 — Runtime validado
    ↓
GATE 4 — Frontend validado
    ↓
GATE 5 — E2E aprovado
```

Cada gate exige:
- documentação atualizada;
- typecheck limpo;
- testes aprovados;
- compatibilidade verificada.

---

## 14. Backend Readiness

| Componente | Prontidão |
|------------|-----------|
| Banco | 80% |
| Backend | 60% |
| Runtime | 70% |
| Frontend | 80% |
| PlatformRuntime | 40% |

---

## 15. Critérios de Aceite da Fase

Antes de sair da fase de preparação do backend:

- [ ] `sp_auth_permissions_evaluate` materializada e validada.
- [ ] `user`, `tenant`, `context` preenchidos no backend.
- [ ] `AuthService` injetado no `PortalService`.
- [ ] SQL aplicado e dump atualizado.
- [ ] MD e ADR consistentes.
- [ ] Typecheck limpo.
- [ ] Testes de integração aprovados.

---

## 16. Plano de Materialização

SQL obrigatório **antes** da implementação:

1. **PROCEDURE**: `sp_auth_permissions_evaluate(id_sessao BIGINT, OUT p_permissions JSON)`
   - usa `sessao_usuario`, `perfil_permissao`, `permissao`, `permissao_local`;
   - retorna `JSON_ARRAYAGG(DISTINCT p.codigo)`;
   - pasta: `docs/database/procedures_raw_texts/sp_auth_permissions_evaluate.sql`.

2. **INDEX** opcional: `idx_sessao_entidade_ativo` em `sessao_usuario(id_entidade, ativo)`.

3. **VIEW** futura opcional: `vw_platform_runtime_session`.

4. **FUNCTION** futura opcional: `fn_runtime_capability_flag(...)`.

Scripts de aplicação podem ser organizados em `backend/sql/future/` quando a aplicação no banco for executada.

---

## 17. Plano de Refatoração

| Arquivo | Movimento | Justificativa |
|---------|-----------|---------------|
| `packages/contracts/src/portal/PortalRuntimeContract.ts` | ADAPT | Base para `PlatformRuntimeContract`. |
| `packages/runtime/src/portal/PortalRuntimeEngine.ts` | ADAPT | Evoluir para agregar todas as camadas. |
| `packages/runtime/src/portal/PortalRuntimeBuilder.ts` | ADAPT | Manter builder fluido. |
| `packages/runtime/src/contracts/RuntimeContracts.ts` | ADAPT | `PortalRuntimeInput` → `PlatformRuntimeInput`. |
| `backend/src/core/portal/PortalService.ts` | ADAPT | Preencher `user/tenant/context`; adicionar `platform()`. |
| `backend/src/core/permissions/PermissionService.ts` | ADAPT | Confirmar `sp_auth_permissions_evaluate` no dump. |
| `backend/src/routes/portal.ts` | ADAPT | Adicionar `/portal/platform`. |
| `apps/portal/src/shell/PortalRuntime.tsx` | ADAPT | `DEFAULT_RUNTIME` completo. |
| `packages/contracts/src/portal/PlatformRuntimeContract.ts` | NOVO | Proposta de contrato unificado. |
| `packages/runtime/src/permission/PermissionResolver.ts` | REUSE | Manter filtros de permissão. |

Nenhum arquivo consolidado será removido nesta etapa.

---

## 18. Análise de Impacto

### COREs afetados
- **CORE-001 Auth**: fonte de sessão.
- **CORE-002 Context**: fonte de contexto.
- **CORE-003 Portal Metadata**: navigation/applications/branding/dashboard/widgets/notifications.
- **CORE-004 Permission Runtime**: `permissions` passa a ser campo central.

### Contratos impactados
- `PortalRuntimeContract` e `PortalRuntimeInput` evoluem para `PlatformRuntimeContract` / `PlatformRuntimeInput`.
- Manutenção de alias/compatibilidade para evitar quebra imediata.

### Compatibilidade
- **Compatibilidade prevista**: 100%, via alias/type narrowing.
- **Breaking changes**: nenhum obrigatório.

### Riscos
- **MÉDIO**: dependência de `sp_auth_permissions_evaluate` não materializada.
- **MÉDIO**: backend atual retorna `user/tenant/context=null`, exigindo integração com `AuthService` e `saas_entidade`.

---

## 19. Plano de Testes

| Categoria | Casos |
|-----------|-------|
| Unitários | Resolvers de navigation/applications/widgets/context; PermissionResolver. |
| Integração | Backend `/portal/platform` retornando estrutura completa; SPs respondendo. |
| Banco | Execução de `sp_auth_permissions_evaluate`; integridade de sessão/contexto/permissões. |
| E2E | Login → Contexto → Plataforma → Navegação filtrável por permissão. |
| Erro | Sessão inválida; contexto ausente; SP indisponível; permissão negada. |
| Rollback/Retry/Fallback | Timeout nas SPs; retry de `/portal/platform`. |
| Idempotência | Reenvio da mesma request preserva resultado. |

---

## 20. Critérios de Aceite

O CORE-005 será considerado concluído quando:

- [ ] Documentação atualizada (`CORE-005`, dossiê e ADR-010).
- [ ] `sp_auth_permissions_evaluate` materializada e validada.
- [ ] `PlatformRuntimeContract` / `PlatformRuntimeInput` definidos.
- [ ] `PlatformRuntimeEngine` / `PlatformRuntimeBuilder` implementados.
- [ ] Backend `/portal/platform` retornando objeto completo.
- [ ] `user`, `tenant`, `context` preenchidos no backend.
- [ ] Frontend consumindo `PlatformRuntime` unificado.
- [ ] Typecheck limpo.
- [ ] Testes e E2E aprovados.
- [ ] Compatibilidade com CORE-001 a CORE-004 preservada.
- [ ] Auditoria de redundância executada.

---

## 21. Decisões de Engenharia

1. **Alias, não substituição:** `PlatformRuntimeContract` = extensão de `PortalRuntimeContract` via type alias; preserva compatibilidade (MD-005 §11.1-11.3).
2. **Endpoint único `/portal/platform`:** consolida `/runtime`, `/navigation`, `/permissions` etc. (CORE-005 §5.80).
3. **Preencher user/tenant/context no backend:** usar `AuthService` + `saas_entidade`/`pessoa`/`usuario`; respeita regra "campo ausente = null, nunca undefined" (CORE-005 §Regras).
4. **SP `sp_auth_permissions_evaluate` é bloqueio duro:** materializar SQL antes de fechar CORE-005.
5. **`capabilities/security/features/locale/audit/operation`:** implementar como campos opcionais; preenchimento progredido sem breaking change.
6. **Branding/Dashboard/Widgets:** manter mock controlado até ADR-006; não criar tabelas fora do ciclo ADR.
7. **Não expor tabelas/SPs legadas ao frontend:** tradução SP→contrato permanece em `PortalService`/`PermissionService`.

---

## 22. GATE 1 — Materialização Canônica do Banco

### Objetivo
Materializar no banco apenas o que foi comprovadamente identificado como PROPOSE após a Triangulação Canônica, preservando integralmente a arquitetura existente.

### Parecer por Dimensão — `sp_auth_permissions_evaluate`

| Dimensão | Parecer |
|----------|---------|
| Estrutural (Dump) | Ajuste |
| Semântica | Aprovado |
| Operacional | Ajuste |
| Banco (Runtime SQL) | Ajuste |
| Segurança | Ajuste |
| Backend (TS) | Aprovado |
| Observabilidade | Ajuste |
| Evolução / Canonicalidade | Pending |

### Ajustes Aplicados
1. Adicionada validação de sessão via `sp_sessao_assert`.
2. Adicionada leitura de `revogado` e `expira_em`.
3. Adicionado bloqueio para sessão inativa, revogada ou expirada.
4. Mantido fallback `JSON_ARRAY()` para ausência de permissões.

### Ajustes Pendentes / Não Bloqueantes
1. Índice composto em `permissao(id_entidade, ativo)` recomendado para performance.
2. Auditoria de avaliação de permissão pode ser adicionada futuramente em tabela dedicada.
3. `permissao_local` não possui `CREATE TABLE` no dump canônico; gap registrado em dívida técnica `DT-001`.

### Critério de Conclusão do GATE 1
- [x] SQL ajustado e documentado
- [ ] SQL aplicado no banco de homologação
- [ ] Procedure executada com sucesso
- [ ] Backend consome sem erro
- [ ] Teste de integração passa

### Status do GATE 1
🔴 BLOQUEADO OPERACIONALMENTE / Liberado arquiteturalmente

- `sp_sessao_assert` confirmada como REUSE no dump (`Dump20260618.sql:32115`), mas com assinatura de 5 parâmetros.
- `sp_auth_permissions_evaluate` ajustada para **ADAPT**: extrai lógica equivalente de `sp_auth_menu_get`, sem chamada inválida a `sp_sessao_assert`.
- SQL pronto em `docs/database/procedures_raw_texts/sp_auth_permissions_evaluate.sql`.
- Aplicação pendente de conexão autorizada.

## 8. Plano de Refatoração

| Arquivo | Movimento | Justificativa |
|---------|-----------|---------------|
| `packages/contracts/src/portal/PortalRuntimeContract.ts` | ADAPT | Base para `PlatformRuntimeContract`. |
| `packages/runtime/src/portal/PortalRuntimeEngine.ts` | ADAPT | Evoluir para agregar todas as camadas. |
| `packages/runtime/src/portal/PortalRuntimeBuilder.ts` | ADAPT | Manter builder fluido. |
| `packages/runtime/src/contracts/RuntimeContracts.ts` | ADAPT | `PortalRuntimeInput` → `PlatformRuntimeInput`. |
| `backend/src/core/portal/PortalService.ts` | ADAPT | Preencher `user/tenant/context` e adicionar `platform()`. |
| `backend/src/core/permissions/PermissionService.ts` | ADAPT | Confirmar `sp_auth_permissions_evaluate` no dump. |
| `backend/src/routes/portal.ts` | ADAPT | Adicionar `/portal/platform`. |
| `apps/portal/src/shell/PortalRuntime.tsx` | ADAPT | `DEFAULT_RUNTIME` completo. |
| `packages/contracts/src/portal/PlatformRuntimeContract.ts` | NOVO | Proposta de contrato unificado. |
| `packages/runtime/src/permission/PermissionResolver.ts` | REUSE | Manter filtros de permissão. |

Nenhum arquivo consolidado será removido nesta etapa.

---

## 9. Análise de Impacto

### COREs afetados
- **CORE-001 Auth**: fonte de sessão.
- **CORE-002 Context**: fonte de contexto.
- **CORE-003 Portal Metadata**: navigation/applications/branding/dashboard/widgets/notifications.
- **CORE-004 Permission Runtime**: `permissions` passa a ser campo central.

### Contratos impactados
- `PortalRuntimeContract` e `PortalRuntimeInput` evoluem para `PlatformRuntimeContract` / `PlatformRuntimeInput`.
- Manutenção de alias/compatibilidade para evitar quebra imediata.

### Compatibilidade
- **Compatibilidade prevista**: 100%, via alias/type narrowing.
- **Breaking changes**: nenhum obrigatório.

### Riscos
- **MÉDIO**: dependência de `sp_auth_permissions_evaluate` não materializada.
- **MÉDIO**: backend atual retorna `user/tenant/context=null`, exigindo integração com `AuthService` e `saas_entidade`.

---

## 10. Plano de Testes

| Categoria | Casos |
|-----------|-------|
| Unitários | Resolvers de navigation/applications/widgets/context; PermissionResolver. |
| Integração | Backend `/portal/platform` retornando estrutura completa; SPs respondendo. |
| Banco | Execução de `sp_auth_permissions_evaluate`; integridade de sessão/contexto/permissões. |
| E2E | Login → Contexto → Plataforma → Navegação filtrável por permissão. |
| Erro | Sessão inválida; contexto ausente; SP indisponível; permissão negada. |
| Rollback/Retry/Fallback | Timeout nas SPs; retry de `/portal/platform`. |
| Idempotência | Reenvio da mesma request preserva resultado. |

---

## 11. Critérios de Aceite

O CORE-005 será considerado concluído quando:

- [ ] Documentação atualizada (`CORE-005`, dossiê e ADR-010).
- [ ] `sp_auth_permissions_evaluate` materializada e validada.
- [ ] `PlatformRuntimeContract` / `PlatformRuntimeInput` definidos.
- [ ] `PlatformRuntimeEngine` / `PlatformRuntimeBuilder` implementados.
- [ ] Backend `/portal/platform` retornando objeto completo.
- [ ] `user`, `tenant`, `context` preenchidos no backend.
- [ ] Frontend consumindo `PlatformRuntime` unificado.
- [ ] Typecheck limpo.
- [ ] Testes e E2E aprovados.
- [ ] Compatibilidade com CORE-001 a CORE-004 preservada.
- [ ] Auditoria de redundância executada.
