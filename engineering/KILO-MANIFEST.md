# KILO ENGINE v7 — MANIFEST

## 📁 ESTRUTURA DEFINITIVA

```text
engineering/
├── kilo/
│   ├── core/           # Motor principal
│   ├── engines/        # Discovery, Analysis, Sync, Generation
│   ├── generators/     # MD, BR, MAP, FRONT, Contracts
│   ├── analyzers/      # Drift, Impact, Dependency
│   ├── rules/          # SP-First, Event-Driven, Canonical
│   ├── templates/      # SQL, API, React, OpenAPI
│   ├── reports/        # Output de execução
│   └── config/         # Configuração
│
├── dumps/              # INPUT - SQL/JSON dumps (quando disponíveis)
├── md/                 # OUTPUT - MD-XXX (atualizados)
├── br/                 # OUTPUT - BR-XXX
├── map/                # OUTPUT - MAP-XXX
├── adr/                # OUTPUT - ADR-XXX
├── front/              # OUTPUT - FRONT-XXX
├── contracts/          # OUTPUT - SPC-XXX, APIC-XXX, EVC-XXX, DBC-XXX
├── diagrams/           # OUTPUT - Mermaid
└── roadmap/            # OUTPUT - Backlog + Plano
```

## 📊 STATUS ATUAL (sem dumps)

- Templates: 6 (SQL, Backend, Frontend, OpenAPI, Events, Contracts)
- Relatórios: 12 (Architecture, Drift, Call Graph, Knowledge Graph, Impact, etc.)
- Estrutura: ✅ pronta
- Próximo passo: aguardar dumps para inventário completo