# MD-007 — App Registry

## Status

Documento Canônico Fundacional.

Este documento define aplicações como módulos registrados.

---

## Objetivo

Transformar módulos em aplicações registradas e impedir carregamento direto de módulos fora do Registry.

---

## Modelo

```json
{
  "codigo": "OPERACIONAL",
  "nome": "Operacional",
  "rota": "/operacional",
  "icone": "...",
  "contexto_obrigatorio": true
}
```

---

## Exemplos

```text
OPERACIONAL
FARMACIA
ESTOQUE
PORTAL
BI
CRM
FINANCEIRO
ADMIN
```

---

## Regras

1. Toda aplicação entra no sistema através do Registry.
2. Toda aplicação possui código único.
3. Toda aplicação possui rota registrada.
4. Toda aplicação declara se exige contexto operacional.
5. Nenhuma aplicação pode carregar módulo não registrado.
6. Nenhuma aplicação pode criar rota operacional fora do Registry.
7. Nenhuma aplicação pode ignorar Auth.
8. Nenhuma aplicação pode ignorar OperationalContext.
9. Nenhuma aplicação pode ignorar Dispatcher.
10. Nenhuma aplicação pode ignorar Event Store.

---

## Proibições

São proibidos:

```text
App sem registry
Rota direta sem registry
Módulo carregado manualmente fora do registry
Aplicação com contexto próprio
Aplicação com auth próprio
Aplicação com dispatcher próprio
```

---

## Lei

```text
Toda aplicação entra no sistema através do Registry.
```
