# MD-064 — Conflict Resolution Engine

## Status

Documento Canônico do Motor de Resolução de Conflitos da Plataforma Enterprise.

---

## Objetivo

Resolver conflitos de sincronização entre Runtime Local e Cloud.

Automático quando possível.

Manual quando necessário.

Auditável sempre.

---

## Princípio Fundamental

```text
Conflito não é erro.

Conflito é natural em sistemas distribuídos.

Todo conflito gera evento.
```

---

## Conflito São

```text
Mesmo registro
Modificado localmente
Modificado na cloud
Sem ordem clara de vencedor
```

### Quando Ocorrem

```text
Usuário edita offline
Outro usuário edita online
Ambos sincronizam depois
Sem timestamp ordenado
Com mesma versão base
```

---

## Estratégias de Resolução

### 1. Last Write Wins (LWW)

```text
Vence o mais recente
Usa timestamp do servidor
Perde alteração local mais antiga
Rápido, mas pode perder dados
Usado para: dados não críticos
Aplicações: feed social, analytics
```

### 2. Priority Source

```text
Cloud sempre vence para certos tipos
Local sempre vence para outros
Exemplo: cloud vence em financeiro
Exemplo: local vence em rascunho offline
Configurável por entidade
```

### 3. Manual Review

```text
Conflito detectado
Ambas versões preservadas
Usuário escolhe qual manter
UI mostra diff das versões
Usado para: dados críticos
Aplicações: contratos, valores financeiros
```

### 4. Business Rule

```text
Regra específica por entidade
Exemplo: maior valor vence em desconto
Exemplo: último status valida mais
Exemplo: soma de quantidade (não overwrite)
Exemplo: merge de campos complementares
```

### 5. Auto Merge

```text
Campos não conflitantes: merge automático
Campos conflitantes: aplicar estratégia
Exemplo: título + descrição (merge ok)
Exemplo: valor (escolher maior ou menor)
Exemplo: status (machine decide)
```

---

## Conflito Detection

```text
Compare: base version
Compare: local changes
Compare: cloud changes
Intersect: modified fields

If intersection empty: auto-merge
If intersection non-empty: resolve
```

### Conflito Model

```json
{
  "conflito_uuid": "UUID",
  "tenant_id": 0,
  "entidade": "string",
  "entidade_id": "UUID",
  "versao_base": "string",
  "versao_local": {},
  "versao_cloud": {},
  "campos_conflitantes": [],
  "estrategia_aplicada": "LWW|PRIORITY|MANUAL|BUSINESS_RULE",
  "resolucao": {},
  "resolvido_por": "SISTEMA|USUARIO|BUSINESS_RULE",
  "usuario_id": "UUID",
  "status": "PENDING|RESOLVED|ESCALATED",
  "created_at": "datetime",
  "resolved_at": "datetime"
}
```

---

## Auditoria

Todo conflito gera evento:

```text
CONFLITO_DETECTADO
CONFLITO_RESOLVIDO_AUTO
CONFLITO_RESOLVIDO_MANUAL
CONFLITO_ESCALADO
CONFLITO_PERDIDO
```

### Evento Canônico

```json
{
  "evento_uuid": "UUID",
  "dominio": "SYNC",
  "acao": "CONFLITO_DETECTADO",
  "tenant_id": 0,
  "payload": {
    "entidade": "PEDIDO",
    "entidade_id": "UUID",
    "estrategia": "LWW",
    "versao_vencedora": "LOCAL"
  },
  "timestamp": "datetime"
}
```

---

## Regras

1. Todo conflito é registrado no Event Store.
2. Todo conflito é preservado (não descartado).
3. Resolução automática é preferida quando segura.
4. Manual review para dados críticos.
5. Usuário sempre pode ver o que foi perdido.
6. Nenhuma resolução silenciosa em dados financeiros.
7. Conflito não bloqueia sync de outros dados.
8. Business Rules tem precedência sobre estratégias genéricas.
9. Conflitos recorrentes geram alerta de treinamento.
10. Conflito não resolvido em 72h é escalado.

---

## Integration with Other MDs

- **MD-063 (Sync Engine)**: detecta conflitos e solicita resolução.
- **MD-005 (Event Store)**: conflitos são eventos.
- **MD-010 (Security)**: conflitos são auditados.
- **MD-017 (MultiTenant)**: conflitos respeitam tenant.

---

## Próximo MD recomendado

```text
MD-065 — Observability Platform
```

Observabilidade total.