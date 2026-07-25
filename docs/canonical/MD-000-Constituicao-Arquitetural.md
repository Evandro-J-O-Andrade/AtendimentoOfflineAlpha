# MD-000 — Constituição Arquitetural da Plataforma Enterprise

**Status:** Canônico  
**Versão:** 1.0  
**Projeto:** AtendimentoOfflineAlpha  
**Data:** 2026-07-25  

---

# Objetivo

Este documento estabelece as leis arquiteturais da Plataforma Enterprise e define os princípios obrigatórios para qualquer evolução futura.

Nenhuma implementação pode contrariar este documento.

---

# Visão Geral

A plataforma não deve ser tratada como um sistema CRUD tradicional.

Ela é definida como um:

```text
DB-Driven Distributed Workflow Engine

com

SP Master Layer
+
Domain Executors
+
Event Driven Architecture
+
State Machine
+
Frontend Declarativo
```

---

# Princípios Fundamentais

## 1. SP-First

Toda regra de negócio deve ser executada por Stored Procedures.

Frontend, API e demais camadas nunca implementam regras de domínio.

---

## 2. Dispatcher First

Existe um único ponto lógico de entrada.

```
Frontend

↓

Dispatcher

↓

Orquestrador

↓

Executor

↓

Persistência
```

---

## 3. Frontend Declarativo

O React é um cliente operacional.

Ele envia comandos.

Ele nunca decide regras de negócio.

---

## 4. Separação de Responsabilidades

Frontend

↓

API

↓

Dispatcher

↓

Orquestrador

↓

Executor

↓

Eventos

↓

Estado

Cada camada possui responsabilidade única.

---

## 5. Event Driven

Toda alteração importante deve gerar rastreabilidade.

Na versão atual isso ocorre por múltiplas tabelas de eventos.

No futuro haverá um Event Store Canônico.

---

## 6. Estado

O estado é consequência da execução.

Nunca a origem da regra.

---

# Arquitetura Oficial

```
React

↓

API

↓

SP Master Dispatcher

↓

SP Master Orquestradora

↓

Executores

↓

Tabelas de Domínio

↓

Eventos

↓

Estado
```

---

# Camadas Oficiais

## Frontend

Responsável apenas pela experiência do usuário.

---

## API

Responsável apenas pelo transporte.

---

## Dispatcher

Responsável pelo roteamento.

---

## Orquestrador

Responsável pela decisão do fluxo.

---

## Executor

Responsável pela regra de negócio.

---

## Evento

Responsável pela rastreabilidade.

---

## Estado

Responsável pela representação atual do sistema.

---

# Hierarquia de Decisão

Em caso de conflito entre documentos, implementações ou interpretações, a ordem de autoridade é:

1. **MD-000 — Constituição Arquitetural** (este documento)
2. **MDs de domínio** (`MD-KERNEL-*`, `MD-IDENTITY-*`, etc.)
3. **MYSQLBANCO.md** (especificação do banco)
4. **Implementação SQL** (Stored Procedures, triggers, views)
5. **Backend** (controllers, services, repositories)
6. **Frontend** (components, hooks, state)

**Nenhum código pode substituir uma decisão arquitetural documentada.**

Se uma implementação parecer contrariar a arquitetura:
- Primeiro verifique se a interpretação está correta.
- Se confirmada a divergência, a implementação deve ser ajustada, não a arquitetura.

---

# Contrato do Frontend

O frontend envia apenas comandos.

```
Dispatcher.send()

↓

SP Master Dispatcher

↓

Resposta JSON
```

Nenhuma consulta direta ao banco é permitida.

Nenhuma regra de domínio é implementada em React.

---

# Organização do Frontend

A implementação seguirá obrigatoriamente esta sequência:

1. Contratos (MDs)
2. Gateway de integração
3. Estrutura de pastas
4. Dispatcher Client
5. Estado do Frontend
6. Interface por domínio

---

# Estrutura Canônica do React

```
core/

engine/

domains/

shared/

infrastructure/

app
```

---

# Fluxo Oficial

```
Usuário

↓

React

↓

Dispatcher Client

↓

API

↓

sp_master_dispatcher

↓

sp_master_orquestradora

↓

sp_executor_*

↓

Domínio

↓

Evento

↓

Estado

↓

Resposta

↓

React
```

---

# Eventos

Situação atual:

* Eventos distribuídos por domínio.

Objetivo:

```
kernel_event_store
```

como barramento único.

---

# Estratégia de Evolução

A plataforma não será reescrita.

Ela evoluirá por estrangulamento arquitetural.

Cada melhoria deverá preservar compatibilidade com o legado.

---

# Roadmap Arquitetural

## Fase 1

Arquitetura Canônica

(MDs)

✔

---

## Fase 2

Dispatcher

✔

---

## Fase 3

Frontend Core

* Dispatcher Client
* Session Store
* UI State
* Contracts

---

## Fase 4

Domínios React

* Assistencial
* Estoque
* Fila
* Financeiro

---

## Fase 5

Event Store Canônico

---

## Fase 6

Replay Engine

---

## Fase 7

Observabilidade

---

# Leis da Plataforma

1. Toda regra passa por SP.
2. Todo comando entra pelo Dispatcher.
3. O Orquestrador decide; o Executor executa.
4. O Frontend nunca contém regras de negócio.
5. Toda mudança relevante deve ser rastreável.
6. O estado é derivado da execução.
7. A arquitetura evolui sem reescrita do sistema.
8. Compatibilidade com o legado é obrigatória durante a migração.
9. Os MDs são a fonte oficial da arquitetura.

---

# Referências

| Documento | Caminho | Descrição |
|-----------|---------|-----------|
| Constituição Suprema | `000-CONSTITUICAO-PLATAFORMA.md` | Lei máxima da plataforma |
| Guia Operacional das IAs | `000-CONSTITUICAO-IA.md` | Regras para IAs colaboradoras |
| Mapa de Rastreabilidade | `docs/TRACEABILITY_MAP.md` | Mapeamento Frontend → Backend → Dispatcher → SP |
| Arquitetura do Banco | `docs/canonical/MD-001-Arquitetura-Banco.md` | Estrutura do banco de dados |
| Master SP Architecture | `docs/MASTER_SP_ARCHITECTURE_MAP.md` | Mapeamento das SPs mestres |

---

# Histórico de Versões

| Versão | Data | Autor | Alterações |
|--------|------|-------|-----------|
| 1.0 | 2026-07-25 | Kilo | Criação inicial do documento canônico |

---

**Fim do documento.**
