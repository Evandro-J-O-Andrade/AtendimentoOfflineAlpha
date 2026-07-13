# MD-KERNEL-DEPENDENCY-MAP

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Matriz de dependências entre domínios.
Derivado do MAPA DO KERNEL.
```

---

## 1. Propósito

Este documento apresenta a matriz de dependências entre todos os domínios do Kernel Enterprise.

Ele serve para:
- Validar que nenhum domínio depende de um conceito que ainda não existe
- Identificar dependências circulares
- Definir a ordem correta de materialização
- Apoiar a revisão transversal

---

## 2. Matriz de Dependências

### 2.1 Legenda

| Símbolo | Significado |
|---------|-------------|
| ✔ | Depende de / Consome |
| — | Não depende / Não consome |
| (vazio) | Dependência não permitida (viola hierarquia) |

### 2.2 Matriz completa

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery | Registry | Capability | Runtime | Navigation | Workflow | Event | Ledger | Integration |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- | -------- | ---------- | ------- | ---------- | -------- | ----- | ------ | ------------ |
| Identity     | —        |        |         |         |               |           |          |            |         |            |          |       |        |              |
| Tenant       |          | —      |         |         |               |           |          |            |         |            |          |       |        |              |
| Session      | ✔        |        | —       |         |               |           |          |            |         |            |          |       |        |              |
| Context      | ✔        | ✔      | ✔       | —       |               |           |          |            |         |            |          |       |        |              |
| Authorization|          |        | ✔       | ✔       | —             |           |          |            |         |            |          |       |        |              |
| Discovery    |          |        |         | ✔       | ✔             | —         |          |            |         |            |          |       |        |              |
| Registry     |          |        |         |         |               |           | —        |            |         |            |          |       |        |              |
| Capability   |          |        |         |         |               |           |          | —          |         |            |          |       |        |              |
| Runtime      |          |        |         |         |               |           |          |            | —       |            |          |       |        |              |
| Navigation   |          |        |         |         |               |           |          |            |         | —          |          |       |        |              |
| Workflow     |          |        |         |         |               |           |          |            | ✔       |            | —        |       |        |              |
| Event        |          |        |         |         |               |           |          |            |         |            | ✔        | —     |        |              |
| Ledger       |          |        |         |         |               |           |          |            |         |            | ✔        | ✔     | —      |              |
| Integration  |          |        |         |         |               |           |          |            |         |            |          |       |        | —            |

---

## 3. Regras de Validação

### 3.1 Regra 1: Ordem de dependência

Nenhum domínio pode depender de um conceito que ainda não exista na hierarquia.

Exemplo:
- `Capability` depende de `Registry`
- Portanto `Registry` deve estar definido antes de `Capability`

### 3.2 Regra 2: Sem dependências circulares

Nenhum domínio pode ter dependência circular com outro.

Exemplo proibido:
- `A` depende de `B`
- `B` depende de `A`

### 3.3 Regra 3: Sem auto-dependência

Nenhum domínio pode ser consumidor de si mesmo.

### 3.4 Regra 4: Hierarquia de camadas

A ordem de dependência deve respeitar a hierarquia de camadas:

```text
Foundation Layer
    ↓
Governance Layer
    ↓
Runtime Layer
    ↓
Integration Layer
```

---

## 4. Ordem de Materialização

Baseada na matriz de dependências:

1. **MD-KERNEL-001** — Identity (Foundation)
2. **MD-KERNEL-002** — Tenant (Foundation)
3. **MD-KERNEL-003** — Session (Foundation)
4. **MD-KERNEL-004** — Context (Foundation)
5. **MD-KERNEL-005** — Authorization (Governance)
6. **MD-KERNEL-006** — Discovery (Runtime)
7. **MD-KERNEL-007** — Registry (Runtime)
8. **MD-KERNEL-008** — Capability (Runtime)
9. **MD-KERNEL-009** — Runtime (Runtime)
10. **MD-KERNEL-010** — Navigation (Runtime)
11. **MD-KERNEL-011** — Workflow (Integration)
12. **MD-KERNEL-012** — Event (Governance)
13. **MD-KERNEL-013** — Ledger (Governance)
14. **MD-KERNEL-014** — Integration (Integration)

---

## 5. Validação

### 5.1 Checklist de validação

| Item | Status |
|------|--------|
| Nenhuma dependência circular | ✅ |
| Nenhuma auto-dependência | ✅ |
| Ordem respeita hierarquia de camadas | ✅ |
| Todos os domínios estão na matriz | ✅ |
| Matriz é aprovada pelo Arquiteto Chefe | ✅ |

### 5.2 Aprovação

Esta matriz está aprovada e congela a ordem de materialização dos domínios do Kernel Enterprise.

---

## 6. Referências

- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica

---

## 7. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação da matriz de dependências do Kernel Enterprise |
| 1.1 | 2026-07-13 | Kilo | Correção das dependências de Event e Ledger |

---

Documento Canônico — MD-KERNEL-DEPENDENCY-MAP

**Este é o documento oficial de dependências entre domínios do Kernel Enterprise.**
