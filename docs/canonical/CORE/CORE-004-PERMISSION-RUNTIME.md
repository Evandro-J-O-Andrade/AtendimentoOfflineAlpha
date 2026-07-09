# CORE-004 Permission Runtime

## Propósito

Definir o motor de permissões que responde: o usuário pode ver/ações em qual tenant, unidade, contexto, aplicação, módulo e ação.

## Matriz REUSE / ADAPT / PROPOSE

### REUSE (usar como está, não alterar assinatura sem ADR)

| Artefato | Tipo | Razão |
|----------|------|-------|
| `perfil` | Tabela | Fonte de perfis/roles sem alteração estrutural |
| `permissao` | Tabela | Catálogo de permissões (`codigo`, `dominio`, `grupo_menu`, `icone`, `ordem_menu`) |
| `perfil_permissao` | Tabela | Vínculo perfil-permissão |
| `usuario_perfil` | Tabela | Vínculo usuário-perfil |
| `usuario_unidade` | Tabela | Vínculo usuário-unidade |
| `usuario_local` | Tabela | Vínculo usuário-local/sala |
| `usuario_contexto` | Tabela | Contexto operacional do usuário (sistema, unidade, local, perfil) |
| `sessao_usuario` | Tabela | Sessão com contexto materializado (`id_perfil`, `id_unidade`, `id_local`, `id_entidade`) |
| `sp_sessao_tem_permissao` | SP | Verificação básica de permissão por sessão |
| `sp_auth_menu_get` | SP | Monta menu com ações e permissões já filtradas |

### ADAPT (manter estrutura, adaptar assinatura/retorno para o runtime)

| Artefato | Tipo | Adaptação |
|----------|------|-----------|
| `sp_permissao_assert` | SP | Renomear para `sp_auth_permission_assert`, usar `id_sessao` como entrada principal |
| `sp_permissao_validar` | SP | Adaptar para consultar permissões gerais, não apenas `fluxo_transicao` |
| `sp_contexto_assert_permissao` | SP | Adaptar para receber `id_sessao` e usar `sessao_usuario` como fonte de contexto |
| `sp_usuario_tem_permissao` | SP | Remover dependência de `vw_usuario_permissoes`, delegar para `sp_sessao_tem_permissao` |

### PROPOSE (novo, a materializar)

| Artefato | Tipo | Finalidade |
|----------|------|-----------|
| `sp_auth_permissions_evaluate` | SP | Retorna JSON array com todos os `codigo` de permissão autorizados para a sessão |
| `PermissionContract` | Interface | Representa uma permissão (`codigo`, `nome`, `dominio`, `modulo`, `acao_frontend`, `metadata`) |
| `PermissionRuntimeInput` | Interface | Entrada do runtime: sessão + tenant + contexto + grantedPermissions |
| `PermissionResolutionResult` | Interface | Resultado: lista de permissões concedidas |
| `PermissionResolver` | Função/Runtime | Resolve permissões a partir do input |
| `PermissionService` | Backend Service | Chama `sp_auth_permissions_evaluate` e expõe API |
| `permissions` em `PortalRuntimeContract` | Campo | Adiciona array de permissões ao runtime do portal |

## Fluxo de Execução

```text
Frontend: usePortalRuntime()
    ↓
API: GET /portal/runtime/:idSessao
    ↓
Backend: PortalService.runtime(idSessao)
    ├── fetched from sp_auth_menu_get (navigation + permissions embedded)
    ├── new: fetched from sp_auth_permissions_evaluate (flat permission list)
    ↓
Retorna: PortalRuntimeContract {
  user, tenant, context,
  navigation,      ← já filtrado pelo SP
  applications,    ← já filtrado
  permissions: [], ← NOVO: lista plana de codigos
  ...
}
    ↓
Frontend: engine.compose(input, grantedPermissions)
    ├── NavigationResolver.filterByPermission(items, grantedPermissions)
    └── ApplicationResolver.filterByPermission(items, grantedPermissions)
```

## Regras

1. `grantedPermissions` é a fonte de verdade no frontend.
2. A origem primária é `sp_auth_permissions_evaluate`, não derivada de navegação.
3. A permissão é avaliada por sessão (`id_sessao_usuario`), não por usuário isolado.
4. Contexto materializado na sessão é imutável durante a requisição.
5. Regras de domínio assistencial continuam em HIS, NUNCA em CORE.

## Estado

| Item | Status |
|------|--------|
| Doc canônica | Concluída |
| ADR-010 | Aprovada |
| Lei MD-CANONICO-IA-005 | Aprovada |
| SP `sp_auth_permissions_evaluate` | Concluída |
| Contratos | Concluídos |
| Runtime | Concluído |
| Backend Service | Concluído |
| Integração Portal | Concluída |
| E2E com banco vivo | Pendente |
