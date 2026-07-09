# ADR-010 — Platform Runtime & Operation Runtime

## Status

ACEITO

## Problema

A plataforma precisa de um objeto de sessão unificado no frontend e de um kernel de operações idempotente no backend. Hoje essas responsabilidades estão espalhadas entre `AuthSessionContract`, `PortalRuntimeContract`, contratos fragmentados e lógica de módulo.

## Decisão

Congelar dois kernels canônicos antes de implementar qualquer CORE subsequente:

1. **PlatformRuntime**
2. **OperationRuntime**

### PlatformRuntime

Objeto unificado que representa tudo que a plataforma conhece sobre a sessão autenticada.

```ts
PlatformRuntime {
  session,
  identity,
  tenant,
  context,
  portal,
  permissions,
  capabilities,
  security,
  features,
  branding,
  locale,
  audit,
  operation
}
```

Campos obrigatórios:

* `session`: dados da sessão canônica.
* `identity`: pessoa, usuário, perfis, credenciais.
* `tenant`: entidade, marca, domínio.
* `context`: unidade, local, setor, perfil operacional.
* `portal`: navigation, applications, dashboard.
* `permissions`: lista plana de códigos autorizados.
* `capabilities`: checagens dinâmicas adicionais para a ação no momento atual.
* `security`: requestId, csrf, antiReplay.
* `features`: feature flags efectivas para a sessão.
* `branding`: identidade visual por tenant.
* `locale`: idioma, timezone, formato.
* `audit`: contexto de auditoria corrente.
* `operation`: último `OperationRuntime` quando aplicável.

### OperationRuntime

Kernel responsável por toda escrita crítica. Nenhuma operação de escrita pode escapar dele.

```ts
OperationRuntime {
  request_id,
  operation_id,
  correlation_id,
  audit_id,
  tenant,
  session,
  timestamp,
  attempt,
  status,
  result,
  rollback,
  retry,
  fallback,
  recovery
}
```

Regras:

1. Toda escrita exige um `request_id`.
2. `request_id` é único por intenção de negócio.
3. Se a mesma intenção for reenviada, retorna o resultado anterior.
4. Reimpressão reutiliza `operation_id` anterior.
5. Reemissão gera novo `operation_id` com referência ao anterior.
6. Cancelamento/Substituição altera estado sem apagar histórico.
7. Auditoria é obrigatória para todas as transições.

## Consequências

* `PortalRuntimeContract` deixa de ser fragmentado e vira `PlatformRuntime`.
* Todos os endpoints do Portal retornam `PlatformRuntime` completo.
* Todos os write operations usam `OperationRuntime`.
* Módulos futuros herdam identidade, contexto, permissão e operação automaticamente.
* Validação E2E do CORE-004 deve confirmar que `permissions` é a fonte primária antes de avançar para CORE-005.

## Restrições de Implementação

Toda implementação decorrente desta ADR deve seguir obrigatoriamente:

- **MD-CANONICO-IA-005** — Lei de Engenharia e Materialização
- Ciclo: SCAN → REUSE → ADAPT → PROPOSE → SQL → IMPLEMENT → VALIDATE
- Análise de impacto obrigatória antes de alterar contratos
- Cobertura mínima de 95% do Dump Canônico relevante antes de propor objetos novos
- Nenhum nome versionado (`_v2`, `_new`, `_next`)
- SQL materializado para todo PROPOSE

## Estado

| Item | Status |
|------|--------|
| ADR aprovada | Sim |
| Plataforma atual | CORE-001 a CORE-004 em andamento |
| Próximo CORE | CORE-005 — Platform Runtime |
| CORE paralelo | CORE-006 — Operation Runtime |
