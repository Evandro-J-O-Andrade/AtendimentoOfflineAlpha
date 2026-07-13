# REAUDITORIA-CORE-005-MIGRATION

## Resultado Geral

```text
APPROVED
```

Todos os 6 pontos da reauditoria fecharam os bloqueios identificados na primeira auditoria.

---

## 1. Contrato de entrada

```text
PASS
```

| Campo | Status | Observação |
|-------|--------|------------|
| `id_sessao` | ✅ Presente | `IN p_id_sessao BIGINT` |
| `id_usuario` | ✅ Presente | `IN p_id_usuario BIGINT` |
| `id_tenant` | ✅ Presente | `IN p_id_tenant BIGINT` |
| `id_contexto` | ✅ Presente | `IN p_id_contexto BIGINT` |
| `capability_codigo` | ✅ Presente | `IN p_capability_codigo VARCHAR(80)` |

Confirma que a autorização ocorre dentro do modelo canônico:

```text
Identidade
    ↓
Sessão
    ↓
Contexto
    ↓
Capability
    ↓
Permissão
```

---

## 2. Contrato de saída

```text
PASS
```

Antes da correção:

```json
[
  "PORTAL_VIEW",
  "ESTOQUE_READ"
]
```

Depois da correção:

```json
{
  "allowed": true,
  "capability": "PORTAL.DASHBOARD.VIEW",
  "context": {
    "id_contexto": 123,
    "id_local": 1,
    "id_unidade": 1
  },
  "reason": "PERMISSION_GRANTED",
  "audit_reference": "uuid"
}
```

| Campo | Status | Observação |
|-------|--------|------------|
| `allowed` | ✅ Presente | `OUT p_allowed BOOLEAN` |
| `capability` | ✅ Presente | `OUT p_capability VARCHAR(80)` |
| `context` | ✅ Presente | `OUT p_context JSON` |
| `reason` | ✅ Presente | `OUT p_reason TEXT` |
| `audit_reference` | ✅ Presente | `OUT p_audit_ref VARCHAR(64)` |

Isso torna a SP compatível com:
- Runtime
- Discovery
- IA/MCP
- auditoria

Diferença fundamental:
- catálogo responde "o que existe"
- evaluate responde "pode executar agora?"

---

## 3. Segurança de execução

```text
PASS
```

`DEFINER` removido.

Sem dependência de:

```text
root@localhost
```

Criação segue padrão:

```sql
CREATE PROCEDURE ...
```

Sem proprietário fixo.

---

## 4. Dependências Banco Vivo

```text
PASS
```

Confirmado: `permissao_local` removido da SP.

Agora depende apenas de:

- `sessao_usuario`
- `permissao`
- `perfil_permissao`

DT-001 permanece documentado como dívida separada.

A SP não fica bloqueada por uma entidade ainda não materializada.

---

## 5. Neutralidade arquitetural

```text
PASS
```

Scan da SQL por termos de domínio:

| Termo | Presente | Status |
|-------|----------|--------|
| farmacia | ❌ | ✅ |
| estoque | ❌ | ✅ |
| portal | ❌ | ✅ |
| dashboard | ❌ | ✅ |
| tela | ❌ | ✅ |
| modulo específico | ❌ | ✅ |

A SP permanece como Kernel:

```text
Avaliar autorização
≠
Executar negócio
```

---

## 6. Integração futura com Registry

```text
PASS
```

Confirmado que a SP pode ser descoberta futuramente:

```text
Capability
      |
      v
Permission Evaluate
      |
      v
Runtime
      |
      v
Master
      |
      v
Executor
```

Sem vínculo fixo em código.

---

## Critério de fechamento

| Dimensão | Status |
|----------|--------|
| Contrato | ✅ |
| Banco Vivo | ✅ |
| Segurança | ✅ |
| Neutralidade | ✅ |
| Rastreabilidade | ✅ |

**Classificação final: APPROVED**

---

## Encaminhamento aprovado

```text
GATE-CORE-005
        ↓
Aplicação SQL
        ↓
Teste real no Banco Vivo
        ↓
Fechamento do bloqueio Discovery
```

---

## Observação positiva

Remover `permissao_local` foi uma decisão importante. Evitou transformar uma dependência ainda não comprovada do Banco Vivo em uma nova tabela criada por conveniência. Isso manteve a regra principal:

**O banco decide a existência; a arquitetura decide a evolução.**
