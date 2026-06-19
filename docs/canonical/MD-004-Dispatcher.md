# MD-004 — Dispatcher

## Status

Documento Canônico Fundacional.

Este documento define a entrada única do sistema.

---

## Objetivo

Garantir que todas as operações executáveis entrem pelo dispatcher canônico.

---

## Endpoint Único

```text
POST /api/runtime/dispatch
```

---

## Payload Padrão

```json
{
  "acao": "FILA.CHAMAR",
  "payload": {}
}
```

---

## Fluxo Obrigatório

```text
Frontend
  ↓
Dispatcher
  ↓
SP
  ↓
Evento
  ↓
Resposta
```

---

## Responsabilidades do Dispatcher

O dispatcher é responsável por:

```text
Validar sessão
Validar contexto
Validar permissão
Validar idempotência
Rotear ação
Chamar Stored Procedure
Retornar resposta padronizada
```

---

## Proibições

São proibidos:

```text
SQL direto
Controller com regra de negócio
Service com regra de negócio
Procedure chamada diretamente pelo frontend
Procedure chamada diretamente por controller
Dispatcher próprio por domínio
Rota de escrita fora do dispatcher
```

---

## Lei

```text
Toda operação executável deve passar pelo dispatcher.
```
