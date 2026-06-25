# MD-124 — Context First Architecture

## Status
Documento Canônico da Plataforma. Fronteira operacional do sistema.

## Classificação
```text
Tipo: Foundation Architecture
Camada: Platform Core
Prioridade: Máxima
Obrigatoriedade: Global
```

---

## Objetivo
Contexto é a fronteira operacional. Toda operação nasce de um contexto ativo.

---

## Lei Canônica MD-124-001
```text
Contexto é fronteira operacional.
Identidade precede autenticação.
Dashboard é porta de entrada de cada app.
```

---

## Context Lifecycle

```text
Context Selection
├── Unidade
├── Setor
├── Área
└── Perfil

Identity Resolution
├── Pessoa → Papel → Permissões
├── Multi-contexto único
└── Vinculo persistente

Dashboard Entry
├── KPIs do contexto
├── Ações primárias
└── Atalhos
```

---

## Context Switch Flow

```text
1. Portal (sem contexto)
2. Seleciona Unidade/Setor
3. Dashboard do Domínio (com contexto)
4. Navega para aplicação
5. Operação (context-bound)
```

---

## Context Scope

```text
Operacional
├── Unidade: UPA Centro
├── Setor: Recepção
└── Área: Triagem

Corporativo
├── Unidade: Matriz
├── Setor: Diretoria
└── Área: Operacional
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-120 | Party Identity Architecture |
| MD-124 | Context First Architecture |
| MD-130 | Unified Enterprise Operating System |