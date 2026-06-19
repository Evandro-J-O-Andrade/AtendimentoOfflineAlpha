# MD-006 — Portal

## Status

Documento Canônico Fundacional.

Este documento define o Portal Corporativo Universal.

---

## Objetivo

Definir o Portal como ponto central de acesso às aplicações da plataforma.

---

## Fluxo Obrigatório

```text
Login
  ↓
Portal
  ↓
Aplicação
  ↓
Contexto Operacional, quando necessário
```

---

## Portal Contém

```text
Aplicações
Documentos
Comunicação
Agenda
BI
CRM
Financeiro
Chamados
Wiki
AVA
Ouvidoria
```

---

## Responsabilidades do Portal

O Portal é responsável por:

```text
Apresentar aplicações
Apresentar documentos
Apresentar comunicação
Apresentar agenda
Apresentar BI
Apresentar CRM
Apresentar chamados
Apresentar ouvidoria
Redirecionar para contexto operacional quando necessário
```

---

## Não Responsabilidades do Portal

O Portal não executa:

```text
Regra assistencial
Regra farmacêutica
Regra de fila
Regra de estoque
Regra de faturamento
Regra financeira
Regra operacional
```

---

## Proibições

São proibidos:

```text
Portal executando regra de domínio
Portal criando dispatcher próprio
Portal criando auditoria própria
Portal criando evento próprio fora do Event Store
Portal ignorando App Registry
```

---

## Lei

```text
Portal é ponto de acesso, não motor de negócio.
```
