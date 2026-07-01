# ENGINEERING — KILO Architecture Kernel

## 🎯 MISSÃO
Banco (via dumps) alimenta automaticamente MDs, BRs, FRONTs, MAPs, ADRs e contratos.

---

## 📁 ESTRUTURA CANÔNICA

```
engineering/
├── dumps/              # INPUT - SQL/JSON dumps (pendente envio)
├── canonical/          # Fonte oficial - arquitetura congelada
│   ├── md/
│   ├── br/
│   ├── map/
│   ├── adr/
│   ├── front/
│   ├── contracts/
│   ├── glossary/
│   ├── index.md
│   └── manifest.json
├── inventory/          # Inventário automático do dump
│   ├── tables.json
│   ├── procedures.json
│   ├── events.json
│   ├── functions.json
│   ├── views.json
│   ├── indexes.json
│   ├── constraints.json
│   ├── foreign_keys.json
│   └── domains.json
├── metadata/           # Grafos e metadados gerados
│   ├── domain-mapping.md
│   └── md-mapping-index.md
├── templates/          # Templates de geração
│   ├── MD-template.md
│   ├── BR-template.md
│   └── FRONT-template.md
├── reports/            # Relatórios executivos
├── diagrams/           # Diagramas Mermaid
├── workspace/          # Arquivos temporários (descartáveis)
└── kilo/               # Motor KILO ENGINE v7
```

---

## 🔄 FLUXO CANÔNICO

```text
KNOWLEDGE LOADING → DISCOVERY → INVENTORY → CANONICAL MAPPING → DOMAIN MAPPING → METADATA UPDATE → SYNCHRONIZATION → GENERATION → VALIDATION → ARCHITECTURE REPORT
```

---

## 🔎 KNOWLEDGE LOADER

```text
Priority 1: canonical/
Priority 2: inventory/
Priority 3: metadata/
Priority 4: reports/
Priority 5: dumps/
```

Sem dumps → KILO usa conhecimento existente
Novos dumps → KILO sincroniza apenas diferenças

---

## 🚀 COMANDOS

```bash
# Descobrir do dump
kilo --discover --dumps engineering/dumps/

# Atualizar MDs
kilo --sync --target md

# Gerar contratos
kilo --generate --type api --domain assistencial

# Ver impacto
kilo --impact --change "ALTER TABLE"
```

---

## 📊 STATUS ATUAL

- **DUMP**: pendente envio
- **Domínios mapeados**: 8 detectados
- **Domínios faltando**: 3 (agendamento, SAC, regulação)
- **Templates**: 3 criados (MD, BR, FRONT)
- **Relatórios KILO**: 35 arquivos
- **Inventory files**: prontos para auto-geração