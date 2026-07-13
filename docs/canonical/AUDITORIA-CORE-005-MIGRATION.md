# AUDITORIA-CORE-005-MIGRATION

## Status da Auditoria

```text
PRIMEIRA AUDITORIA: APROVADA COM AJUSTES
REAUDITORIA:     APPROVED
GATE-CORE-005:   ACCEPTED
```

Migration aplicada e testada no Banco Vivo.

---

## Resultado dos testes funcionais

| Item | Status | Evidência |
|------|--------|-----------|
| Login real | ✅ | `sp_master_login` criou sessão 268 |
| Contexto real | ✅ | `sp_auth_contexto_set` aplicou perfil 42, unidade 1, local 1 |
| Autorizado | ✅ | `allowed=1`, `reason=PERMISSION_GRANTED` para `ADMIN` |
| Negado | ✅ | `allowed=0`, `reason=CAPABILITY_NOT_FOUND` para `INVALID.CAPABILITY.XYZ` |
| Isolamento | ⏳ | Não havia outra sessão ativa no banco no momento do teste |

---

## Encaminhamento aprovado

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

## Ajustes aplicados (primeira auditoria)

1. **Adicionar `id_contexto` na entrada** — ✅ Aplicado
2. **Adicionar `capability` na entrada** — ✅ Aplicado
3. **Modificar contrato de saída** — ✅ Aplicado
4. **Adicionar auditoria** — ✅ Aplicado
5. **Remover `DEFINER`** — ✅ Aplicado
6. **Resolver `permissao_local`** — ✅ Removida da SP; DT-001 como dívida separada

### Importantes (não bloqueiam, mas devem ser endereçados)

7. **Cobertura de `auth_grupo_permissao`**
   - SP atual não considera grupos de permissão
   - Avaliar se grupos devem ser incorporados na avaliação

8. **`usuario_contexto` não utilizada**
   - Avaliar se contexto operacional deve influenciar autorização

9. **Charset/Collation explícito**
   - Adicionar `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci` se padrão do banco for diferente

---

## Histórico

### Primeira auditoria

- **Data:** 2026-07-11
- **Classificação:** APROVADA COM AJUSTES
- **Ajustes obrigatórios:** 6
- **Documento de referência:** `REAUDITORIA-CORE-005-MIGRATION.md`
