# CORE-LEGACY-REUSE-MATRIX

> Status: Aprovado  
> Fase: KILO ENGINE v8  
> Objetivo: Transformar o conhecimento do núcleo legado em matéria-prima para a plataforma SaaS Enterprise, sem reintroduzir a arquitetura antiga.  
> Regra: este documento é uma **biblioteca de regras**, não um caminho obrigatório. Usar para consulta, não para reconstrução.

---

## 1. Como usar este documento

Quando precisar de uma regra, tabela, SP, fluxo ou decisão de negócio que já existia no legado:

1. Busque o conceito na tabela abaixo.
2. Verifique a **situação atual**.
3. Aplique a **ação** indicada.
4. Se não existir aqui, consulte:
   - `docs/database/procedures/*.md`
   - `docs/database/tables/**/*.md`
   - dump: `database/dump/Dump20260618.sql`

Não recrie a arquitetura antiga. Apenas reaproveite o conhecimento.

---

## 2. Matriz de reaproveitamento

| Conceito legado | Situação atual | Ação |
| --------------- | -------------- | ---- |
| Autenticação | CORE-001 implementado | ADAPT — manter SPs `sp_master_login`, `sp_sessao_abrir`, `sp_sessao_assert`, `sp_auth_menu_get`; expor via API canônica `/auth/*` |
| Sessão | CORE-001 implementado | ADAPT — `sessao_usuario` continua como base; contratos normalizados em `AuthSessionContract` |
| Contexto | CORE-002 implementado | ADAPT — `sp_auth_contexto_get`, `sp_auth_contexto_set`, `sp_sessao_contexto_get`, `sp_sessao_contexto_set` consumidos por `/auth/context/*` |
| Pessoa / Usuário | REUSE | REUSE — tabelas `pessoa`, `usuario`, `usuario_perfil`, `usuario_unidade`, `usuario_local` mantidas; contratos `PersonContract`, `UserContract` |
| Tenant / Unidade | REUSE | REUSE — `tenant_registry`, `unidade`, `contexto_atendimento` mantidas; contratos `TenantContract`, `ContextContract` |
| Permissão / Perfil | ADAPT | ADAPT — `permissao`, `perfil`, `perfil_permissao` mantidas; frontend consome via `ApplicationContract.permission`, `NavigationItemContract.permission` |
| Menu / Navigation | CORE-003 implementado | ADAPT — `sp_auth_menu_get` adaptado para `/portal/navigation`; `PortalService.navigation()` lê o OUT `p_resultado` JSON e traduz para `NavigationContract[]`; consumido via `PortalRuntime`/`usePortalRuntime` (ver `CORE-003-PORTAL-METADATA.md`) |
| Branding | CORE-003 (mock controlado) | ADAPT/PROPOSE — `portal_categoria` existe no dump; branding de tenant ainda sem tabela específica; `PortalService.branding()` retorna fallback (`Enterprise Portal`); propor `tenant_branding` via ADR-006 |
| News / Portal Content | REUSE futura | REUSE — `portal_categoria`, `portal_noticia` existem no dump; integrar via módulo Portal quando houver demanda |
| Dispatcher / Guard / Router / Executor | Futuro Workflow Engine | REUSE — modelo conceitual válido; SPs existentes no dump (`sp_master_dispatcher`, `sp_gatekeeper_assistencial`, `sp_orquestrador_assistencial`, `sp_fluxo_guardiao_transicao`, `sp_fluxo_executor_matriz`, `sp_executor_*`); criar runtime próprio sem expor SPs diretamente |
| Ledger / Event Store | Futuro Event Platform | REUSE — tabelas `kernel_ledger`, `auditoria_evento`, `atendimento_evento`, `evento_geral`, `tombstone_evento_assistencial` existem; criar camada de eventos canônica sem acoplar ao frontend |
| Auditoria | ADAPT | ADAPT — `auditoria_evento`, `auth_log`, `log_acesso_prontuario`, `menu_evento` mantidas; criar `AuditContext` no frontend quando necessário |
| Workflow / FFA | Futuro módulo | FORA DO ESCOPO CORE — manter no legado até CORE fechar |
| HIS / Farma / Faturamento | Futuro módulo | FORA DO ESCOPO CORE — manter no legado até CORE fechar |
| Dashboard Metadata | CORE-003 (mock controlado) | ADAPT/PROPOSE — sem tabela/SP específica no dump; `PortalService.dashboard()` retorna dashboard vazio (mock controlado) até decisão de proposta |
| Application Registry | CORE-003 implementado | ADAPT — `PortalService.applications()` deriva `ApplicationContract[]` da navegação real (`sp_auth_menu_get`); módulos = aplicações; widgets registry fica como PROPOSE |

---

## 3. Conceitos reaproveitáveis por domínio

### 3.1 Identidade e Acesso
- Pessoa, Usuário, Perfil, Permissão
- Sessão, Refresh, Token
- Tenant, Unidade, Contexto
- Vínculos: `usuario_perfil`, `usuario_unidade`, `usuario_local`, `usuario_contexto`

### 3.2 Operação Assistencial
- FFA, Atendimento, Triagem, Internação
- Prescrição, Medicacao, Exame, Laboratorio
- Fila, Senha, Painel
- Dispatcher/Guard/Router/Executor
- Eventos assistenciais e ledger

### 3.3 Suporte
- Farmácia, Estoque
- Faturamento, Financeiro
- Agenda, Escala, Plantão
- Integração, Mensageria
- CRM, Chamados, SAC

### 3.4 Plataforma
- Auditoria
- Eventos
- Workflow
- Configuração
- Kernel/Locks/Heartbeat

---

## 4. Regras de reaproveitamento

1. Nunca expor tabela/SP legada diretamente ao frontend.
2. Sempre passar pela camada API (`packages/api`).
3. Sempre normalizar em contratos (`packages/contracts`).
4. Nunca duplicar regras entre legado e nova plataforma.
5. Quando a tabela legada for suficiente: **ADAPT**.
6. Quando a tabela legada não existir: **PROPOSE** via ADR-006.
7. Nunca criar código novo baseado apenas em "precisa ter"; sempre rastrear para documento canônico aprovado.

---

## 5. Fontes

- `database/dump/Dump20260618.sql`
- `docs/database/procedures/*.md`
- `docs/database/tables/**/*.md`
- `docs/canonical/AUTH_CORE_COVERAGE.md`
- `docs/canonical/ADR-006-CORE-PLATFORM.md`
- FRONT-000 até FRONT-005
- MD-100, MD-101, MD-102, MD-103, MD-104, MD-105, MD-107, MD-108, MD-120, MD-123, MD-124

---

*Última atualização: 2026-07-07*
