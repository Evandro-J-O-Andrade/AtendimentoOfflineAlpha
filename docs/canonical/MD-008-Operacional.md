# MD-008 — Operacional

## Status

Documento Canônico Fundacional.

Este documento define o domínio operacional assistencial.

---

## Objetivo

Definir o domínio assistencial como conjunto de subdomínios que compartilham Auth, Contexto, Dispatcher e Event Store canônicos.

---

## Subdomínios

```text
Recepção
Fila
Triagem
Enfermagem
Médico
Farmácia
Laboratório
Imagem
Internação
Faturamento
CAT
Óbito
```

---

## Regras

1. Nenhum subdomínio possui motor próprio de autenticação.
2. Nenhum subdomínio possui dispatcher próprio.
3. Nenhum subdomínio possui auditoria própria.
4. Nenhum subdomínio possui Event Store próprio.
5. Nenhum subdomínio possui contexto operacional próprio.
6. Todo subdomínio usa Auth Canônico.
7. Todo subdomínio usa OperationalContext.
8. Todo subdomínio usa Dispatcher.
9. Todo subdomínio usa Event Store.
10. Toda regra operacional deve ser executada por Stored Procedure.

---

## Fluxo Canônico

```text
Portal
  ↓
App Registry
  ↓
Aplicação Operacional
  ↓
Contexto Operacional
  ↓
Dispatcher
  ↓
SP de Domínio
  ↓
Evento
  ↓
Auditoria
```

---

## Proibições

São proibidos:

```text
Auth próprio por subdomínio
Dispatcher próprio por subdomínio
Auditoria própria por subdomínio
Event Store próprio por subdomínio
Contexto próprio por subdomínio
SQL direto em controller
SQL direto em service
Regra de domínio em frontend
```

---

## Lei

```text
Operacional é domínio, não plataforma independente.
```
