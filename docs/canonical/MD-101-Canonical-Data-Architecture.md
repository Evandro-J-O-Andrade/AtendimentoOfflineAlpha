# MD-101 — Canonical Data Architecture

## Status

Documento Canônico Fundacional de Dados da Plataforma Enterprise.

---

## Objetivo

Formalizar o Banco de Dados como Fonte da Verdade da plataforma.

---

## Princípio Fundamental

```text
Banco é a Fonte da Verdade.

Toda verdade está no Banco.

Nenhuma verdade está fora do Banco.

Qualquer sistema ou camada que diga

não precisar do Banco é uma ilha.
```

---

## Lei Suprema

```text
MySQL = Fonte da Verdade
SP = Única forma de escrita
Evento = Rastro Oficial

Frontend nunca é fonte da verdade
IA nunca é fonte da verdade
N8N nunca é fonte da verdade
Node/Backend nunca é fonte da verdade
Cache nunca é fonte da verdade
```

---

## Hierarquia de Verdade

```
┌─────────────────────────────────────┐
│          BANCO DE DADOS              │
│        (MySQL - Fonte Única)         │
│  ┌─────────────────────────────────┐│
│  │  Tabelas Canônicas              ││
│  │  Stored Procedures              ││
│  │  Transações ACID                ││
│  │  Constraints                    ││
│  │  Índices                        ││
│  └─────────────────────────────────┘│
└──────────────┬──────────────────────┘
               │
       ┌───────▼────────┐
       │   EVENT STORE   │
       │ (kernel_ledger) │
       │  Rastro Oficial │
       └───────┬────────┘
               │
   ┌───────────┼───────────┐
   │           │           │
┌──▼───┐  ┌───▼───┐  ┌───▼───┐
│CACHE │  │ SEARCH│  │  BI   │
│Redis │  │Elastic│  │Lakehouse│
└──────┘  └───────┘  └───────┘
   │           │           │
   └───────────┼───────────┘
               │
       ┌───────▼────────┐
       │   FRONTEND      │
       │  (Somente leitura)│
       └─────────────────┘
```

---

## Fontes Permitidas

| Fonte | Tipo | Uso |
|-------|------|-----|
| MySQL | Master | CRUD, regras, negócio |
| Stored Procedures | Writer | Toda escrita passa por SP |
| Event Store | Reader | Auditoria, replay, analytics |
| Cache | Replica | Leitura otimizada, não fonte |
| Search Index | Replica | Busca, não fonte |
| BI/Lakehouse | Replica | Analytics, não fonte |

---

## Fontes PROIBIDAS como verdade

| Fonte | Motivo da proibição |
|-------|---------------------|
| Frontend state (Redux, Context) | Efêmero, restartável, por usuário |
| LocalStorage / IndexedDB | Local, volátil, não compartilhado |
| N8N workflow data | Processo, não dado |
| IA responses | Inferência, não dado canônico |
| Logs de aplicação | Observabilidade, não negócio |
| Arquivos JSON/YAML | Configuração, não dado operacional |

---

## Regras de Escrita

1. Nenhuma camada escreve diretamente em tabela canônica.
2. Toda escrita passa por Stored Procedure.
3. SP valida regras de negócio antes de executar.
4. SP gera evento no Event Store após sucesso.
5. Evento é imutável após registro.
6. Falha em evento não desfaz transação (evento é rastro, não comando).
7. Frontend só escreve via API → Dispatcher → SP.

---

## Regras de Leitura

1. Frontend só lê dados via API oficial.
2. API pode ler de: MySQL replicado, Cache, Search, BI.
3. Dados sensíveis são mascarados por tenant/role.
4. Leitura auditativa é permitida via Event Store (append-only).
5. Cache é invalidado por eventos, nunca por tempo fixo cego.

---

## Regras de Auditoria

1. Toda operação relevante emite evento.
2. Evento contém: quem, quando, o quê, de onde, para onde.
3. Auditoria é append-only (imutável).
4. Auditoria é retida por período legal.
5. Auditoria é consultável por admin com justificativa.

---

## Integrações

```text
MD-003 — Operational Context
MD-005 — Event Store Core
MD-016 — Auditoria
MD-017 — Multi-Tenant
MD-019 — App Registry Canônico
MD-025 — Event Store Core
MD-034 — Identity Access Management
MD-038 — Integration Hub
MD-051 — Data Lake Architecture
MD-085 — Data Lakehouse Platform
```

---

## Responsabilidades

| Camada | Responsabilidade | Restrição |
|--------|------------------|-----------|
| Frontend | Exibir | Não decisão, não regra, não escrita direta |
| Backend/Node | Roteamento | Não regra de negócio, não escrita direta |
| Dispatcher | Orquestração | Não lógica de negócio, apenas fluxo |
| Stored Procedure | Regra de negócio | Única camada de escrita |
| Event Store | Rastro | Imutável, append-only |
| Analytics | Consumo | Deriva de Event Store e Banco |
| IA | Recomendação | Nunca altera dados sem aprovação humana |

---

## Lei Final

```text
Banco é a Fonte da Verdade.
SP é a porta de entrada.
Evento é a memória.
Cache é atalho.
Frontend é janela.
Nada existe fora do Banco.
```
