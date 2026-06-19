# MD-005 — Event Store

## Status

Documento Canônico Fundacional.

Este documento define a obrigatoriedade de eventos para toda ação relevante.

---

## Objetivo

Garantir que toda ação relevante gere evento rastreável.

---

## Lei

```text
Sem evento, não existe operação.
```

---

## Modelo Conceitual

```text
Evento
  ↓
Quem executou
  ↓
Onde executou
  ↓
Quando executou
  ↓
Resultado
```

---

## Campos Canônicos

```json
{
  "evento_uuid": "UUID",
  "uuid_transacao": "UUID",
  "dominio": "FILA",
  "acao": "SENHA_CHAMADA",
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "payload": {},
  "resultado": {},
  "timestamp": "datetime"
}
```

---

## Exemplos de Eventos

```text
SENHA_GERADA
SENHA_CHAMADA
TRIAGEM_INICIADA
MEDICAMENTO_DISPENSADO
PACIENTE_ENCAMINHADO
```

---

## Regras

1. Toda ação relevante gera evento.
2. Todo evento possui transação.
3. Todo evento possui sessão.
4. Todo evento possui contexto.
5. Todo evento possui resultado.
6. Evento não é tabela de domínio.
7. Evento não substitui auditoria.
8. Evento alimenta reconstrução de estado.

---

## Proibições

São proibidos:

```text
Operação sem evento
Evento fragmentado por domínio
Auditoria própria sem Event Store
Evento sem sessão
Evento sem contexto
Evento sem uuid_transacao
```

---

## Lei Final

```text
Toda ação relevante gera evento.
```
