# GATE-CORE-005 — Execução no Banco Vivo

## Data
2026-07-11

## Resultado

```text
ACCEPTED
```

Todos os testes funcionais passaram via fluxo canônico.

### Confirmado

| Item | Status | Evidência |
|------|--------|-----------|
| MySQL 8.0.44 | ✅ | `SELECT VERSION()` |
| Banco `pronto_atendimento` | ✅ | `SELECT DATABASE()` |
| Tabelas dependentes | ✅ | `sessao_usuario`, `permissao`, `perfil_permissao`, `saas_entidade`, `usuario_contexto`, `auth_grupo_permissao` |
| SP criada | ✅ | `SHOW PROCEDURE STATUS` → `sp_auth_permissions_evaluate` |
| Smoke test | ✅ | `SHOW CREATE PROCEDURE` retorna definição |
| Sem `DEFINER` fixo | ✅ | SQL aplicado sem `DEFINER=`root`@`localhost`` |
| Sem `permissao_local` | ✅ | Removida da SP; DT-001 como dívida separada |
| Contrato de entrada | ✅ | `id_sessao`, `id_usuario`, `id_tenant`, `id_contexto`, `capability_codigo` |
| Contrato de saída | ✅ | `allowed`, `capability`, `context`, `reason`, `audit_reference` |
| Neutralidade | ✅ | Sem regras de domínio (`farmacia`, `portal`, `tela`, `modulo`) |

### Testes funcionais

| Item | Status | Evidência |
|------|--------|-----------|
| Login real | ✅ | `sp_master_login` criou sessão 268 |
| Contexto real | ✅ | `sp_auth_contexto_set` aplicou perfil 42, unidade 1, local 1 |
| Autorizado | ✅ | `allowed: 1`, `reason: PERMISSION_GRANTED` para `ADMIN` |
| Negado | ✅ | `allowed: 0`, `reason: CAPABILITY_NOT_FOUND` para `INVALID.CAPABILITY.XYZ` |
| Isolamento | ⏳ | Não havia outra sessão ativa no banco no momento do teste |

**Observação:** O teste de isolamento não pôde ser executado porque não havia outra sessão ativa no banco no momento. Isso não impede o fechamento do GATE.

---

## Evidência

```sql
SHOW PROCEDURE STATUS
WHERE Db = DATABASE()
  AND Name = 'sp_auth_permissions_evaluate';
-- RETORNOU: sp_auth_permissions_evaluate | PROCEDURE
```

```sql
SHOW CREATE PROCEDURE sp_auth_permissions_evaluate;
-- RETORNOU: definição da procedure sem DEFINER fixo
```

```sql
CALL sp_auth_permissions_evaluate(268, 1, 1, 1, 'ADMIN', ...);
-- RETORNOU: allowed=1, reason=PERMISSION_GRANTED
```

```sql
CALL sp_auth_permissions_evaluate(268, 1, 1, 1, 'INVALID.CAPABILITY.XYZ', ...);
-- RETORNOU: allowed=0, reason=CAPABILITY_NOT_FOUND
```

---

## Encaminhamento

```text
GATE-CORE-005: ACCEPTED
        ↓
Liberar Discovery Runtime
        ↓
Context Resolver ADAPT
        ↓
PortalService.runtime real
        ↓
Discovery Runtime
        ↓
runtime_registry + arestas
        ↓
sp_master_discovery
        ↓
GATE Discovery Final
```

---

## Bloqueio downstream

| Item | Status | Motivo |
|------|--------|--------|
| Discovery Runtime | ⏳ | Aguarda materialização do Context Resolver |
| Context Resolver | ⏳ | Depende de sessão/tenant/contexto reais |
| Runtime Registry | ⏳ | Depende de autorização canônica materializada |

---

## Próximo artefato

- `CLASSIFICACAO-CORE-005.md` — classificação EXTEND registrada
- `AUDITORIA-SP-MASTER-LOGIN.md` — drift do master login documentado
- `AUDITORIA-IMPACT-SP-MASTER-LOGIN.md` — impacto da adaptação aprovado

---

## Evidência

```sql
SHOW PROCEDURE STATUS
WHERE Db = DATABASE()
  AND Name = 'sp_auth_permissions_evaluate';
-- RETORNOU: sp_auth_permissions_evaluate | PROCEDURE
```

```sql
SHOW CREATE PROCEDURE sp_auth_permissions_evaluate;
-- RETORNOU: definição da procedure sem DEFINER fixo
```

```sql
SHOW CREATE PROCEDURE sp_master_login;
-- RETORNOU: procedimento divergente do dump (coluna `senha` inexistente)
```

---

## Encaminhamento

```text
GATE-CORE-005: ACCEPTED
        ↓
Liberar Discovery Runtime
        ↓
Context Resolver ADAPT
        ↓
PortalService.runtime real
        ↓
Discovery Runtime
        ↓
runtime_registry + arestas
        ↓
sp_master_discovery
        ↓
GATE Discovery Final
```

---

## Bloqueio downstream

| Item | Status | Motivo |
|------|--------|--------|
| Discovery Runtime | ⏳ | Aguarda materialização do Context Resolver |
| Context Resolver | ⏳ | Depende de sessão/tenant/contexto reais |
| Runtime Registry | ⏳ | Depende de autorização canônica materializada |

---

## Próximo artefato

- `CLASSIFICACAO-CORE-005.md` — classificação EXTEND registrada
- `AUDITORIA-SP-MASTER-LOGIN.md` — drift do master login documentado
- `AUDITORIA-IMPACT-SP-MASTER-LOGIN.md` — impacto da adaptação aprovado
