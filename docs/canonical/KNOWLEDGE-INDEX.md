# KNOWLEDGE-INDEX

## Status

```text
GOVERNAÇA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Índice mestre de todo o conhecimento da plataforma.
```

---

## 1. Propósito

Este documento é o **índice mestre** de todo o conhecimento da plataforma New Wave Enterprise.

Ele serve para:
- Responder: "Onde está cada conceito?"
- Navegar por 2.823 documentos sem perder informação
- Controlar duplicações e documentos órfãos
- Orientar materialização ordenada
- Ser a fonte única de verdade sobre a documentação

---

## 2. Estrutura do Conhecimento

```text
Platform
│
├── 00-CONSTITUICAO
│   ├── CONSTITUICAO-DA-PLATAFORMA.md
│   ├── CONSTITUICAO-IA.md
│   └── 000-CONSTITUICAO-PLATAFORMA.md
│
├── 01-LEIS-CANONICAS
│   ├── MD-110-Canonical-Laws.md
│   ├── MD-100-Unified-Enterprise-Operating-System.md
│   ├── MD-CANONICO-IA-001-Lei-Evolucao-Documental.md
│   ├── MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md
│   ├── MD-CANONICO-IA-003-Lei-Evolucao-Core.md
│   ├── MD-CANONICO-IA-004-Matriz-Evolucao-Projeto.md
│   ├── MD-CANONICO-IA-005-Lei-Engenharia-Materializacao.md
│   ├── MD-CANONICO-IA-006-Lei-Evolucao-Canônica.md
│   └── MD-CANONICO-IA-007-Lei-Banco-Fonte-Verdade.md
│
├── 02-KERNEL
│   ├── MD-KERNEL-000-Arquitetura-Conceitual.md
│   ├── MD-KERNEL-001-Identity.md
│   ├── MD-KERNEL-002-Tenant.md
│   ├── MD-KERNEL-003-Session.md
│   ├── MD-KERNEL-004-Context.md
│   ├── MD-KERNEL-005-Authorization.md
│   ├── MD-KERNEL-006-Discovery.md
│   ├── MD-KERNEL-007-Registry.md
│   ├── MD-KERNEL-008-Capability.md
│   ├── MD-KERNEL-009-Runtime.md
│   ├── MD-KERNEL-010-Navigation.md
│   ├── MD-KERNEL-011-Workflow.md
│   ├── MD-KERNEL-012-Event.md
│   ├── MD-KERNEL-013-Ledger.md
│   └── MD-KERNEL-014-Integration.md
│
├── 03-CORE
│   ├── CORE-001.md
│   ├── CORE-002.md
│   ├── CORE-003.md
│   ├── CORE-004.md
│   ├── CORE-005-Platform-Runtime.md
│   └── CORE-006 a CORE-011 (pendentes)
│
├── 04-BANCO
│   ├── MODEL-PHYSICAL-KERNEL.md
│   ├── MODEL-LOGICAL-KERNEL.md
│   ├── AUDIT-MODEL-PHYSICAL-VS-BANCO.md
│   ├── DATABASE-COVERAGE.md
│   ├── AUDIT-SP-CATALOG.md
│   ├── AUDIT-VIEW-CATALOG.md
│   ├── DEPENDENCY-CATALOG.md
│   ├── SP-KERNEL-CATALOG.md
│   ├── SQL-CATALOG.md
│   ├── SP-TABLE-MAP.md
│   ├── TABLE-SP-MAP.md
│   └── docs/database/
│       ├── tables/ (480 MDs)
│       ├── tables_completas/ (478 MDs)
│       ├── tables_raw/ (478 JSON)
│       ├── procedures/ (229 MDs)
│       ├── procedures_raw/ (228 JSON)
│       └── procedures_raw_texts/ (26 SQL)
│
├── 05-ADRs
│   ├── ADR-CATALOG.md
│   ├── ADR-001-Pessoa-Entidade-Raiz.md
│   ├── ADR-002-Portal-Entry-Point.md
│   ├── ADR-003-SP-Implementacao-nao-Arquitetura.md
│   ├── ADR-006-CORE-PLATFORM.md
│   ├── ADR-006-Database-Evolution.md
│   ├── ADR-010-Platform-Operation-Runtime.md
│   └── ADR-CORE-005-PERMISSION-EVALUATE.md
│
├── 06-BRs
│   ├── BR-CATALOG.md
│   ├── BR-001-Auth-Session-Rules.md
│   ├── BR-002-Password-Flow-Rules.md
│   ├── BR-003-HIS-Clinical-Rules.md
│   ├── BR-004-CRM-Rules.md
│   ├── BR-005-RH-Rules.md
│   ├── BR-REGISTRY-001-capability.md
│   ├── BR-REGISTRY-002-runtime.md
│   └── engineering/canonical/br/ (25 SP-specific BRs)
│
├── 07-MAPs
│   ├── MAP-001-Enterprise-Domain-Architecture.md
│   ├── MAP-002-Dominios.md
│   ├── MAP-002-Tenant-Architecture.md
│   ├── MAP-003-Identity-Architecture.md
│   ├── MAP-003-Tabelas.md
│   ├── MAP-CORE-PLATFORM.md
│   ├── MAP-DATA-CANONICAL.md
│   ├── MAP-KERNEL-COVERAGE.md
│   ├── MAP-RUNTIME-FLOW.md
│   └── (44 MAPs adicionais)
│
├── 08-GATEs
│   ├── GATE-MODEL-PHYSICAL.md
│   ├── GATE-DATABASE-COMPARISON.md
│   ├── GATE-CORE-005.md
│   ├── GATE-PLATFORM-001.md
│   ├── GATE-RUNTIME-CHAIN.md
│   ├── GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION.md
│   └── (4 GATEs adicionais)
│
├── 09-AUDITs
│   ├── AUDIT-MODEL-PHYSICAL-VS-BANCO.md
│   ├── AUDIT-SP-CATALOG.md
│   ├── AUDIT-VIEW-CATALOG.md
│   ├── AUDIT-DISCOVERY-REGISTRY-RUNTIME.md
│   ├── AUDITORIA-DE-TABELAS-CORE-POR-NIVEL.md
│   ├── AUDITORIA_ARQUITETURA_BANCO_SP_MASTER_CANONICA.md
│   └── (vários em docs/auditoria/)
│
├── 10-DOSSIERs
│   ├── DOSSIER-DISCOVERY-REGISTRY-RUNTIME.md
│   └── CORE/DOSSIER-CORE-005-PLATFORM-RUNTIME.md
│
├── 11-FRONT
│   ├── FRONT-CATALOG.md
│   ├── FRONT-CONTRACTS.md
│   ├── FRONT-DESIGN-SYSTEM.md
│   ├── FRONT-KERNEL-MAP.md
│   ├── FRONT-RUNTIME-MAP.md
│   ├── FRONT-001 a FRONT-083
│   └── (100+ documentos de experiência frontend)
│
├── 12-APIs
│   ├── API-CATALOG.md
│   └── API_BRAIN.md
│
├── 13-ENGINEERING
│   ├── engineering/canonical/md/ (488 entity MDs)
│   ├── engineering/canonical/md-columns/ (478 column MDs)
│   ├── engineering/canonical/br/ (25 BRs)
│   ├── engineering/canonical/front/ (5 docs)
│   ├── engineering/kilo/md/ (6 migration SQLs)
│   └── engineering/ (scripts, templates, inventory)
│
└── 14-PRODUTOS
    ├── HIS/
    ├── ERP/
    ├── CRM/
    ├── PORTAL/
    ├── BI/
    ├── MOBILE/
    └── (docs conceituais — módulos runtime em desenvolvimento)
```

---

## 3. Rastreabilidade por Conceito

| Conceito | MD | BR | ADR | MAP | SQL | SP | Backend | Frontend |
|----------|----|----|-----|-----|-----|----|---------|----------|
| **Identity** | MD-KERNEL-001 | BR-001 | ADR-001 | MAP-003-Identity | MD-001-identity.sql | sp_usuario_*, sp_auth_* | packages/auth | apps/portal |
| **Tenant** | MD-KERNEL-002 | — | ADR-001 | MAP-002-Tenant | — | sp_tenant_* | packages/contracts | apps/portal |
| **Session** | MD-KERNEL-003 | BR-001 | — | MAP-003 | — | sp_sessao_* | packages/auth | apps/portal |
| **Context** | MD-KERNEL-004 | — | — | MAP-003 | — | sp_contexto_* | packages/runtime | apps/portal |
| **Authorization** | MD-KERNEL-005 | BR-001 | ADR-CORE-005 | MAP-003 | MD-CORE-005-*.sql | sp_auth_*, sp_permissao_* | packages/auth | apps/portal |
| **Discovery** | MD-KERNEL-006 | — | GATE-DISCOVERY | MAP-RUNTIME-FLOW | — | sp_discovery_* | packages/runtime | apps/portal |
| **Registry** | MD-KERNEL-007 | BR-REGISTRY-001 | GATE-DISCOVERY | MAP-RUNTIME-FLOW | — | sp_registry_* | packages/runtime | apps/portal |
| **Capability** | MD-KERNEL-008 | BR-REGISTRY-001 | — | MAP-RUNTIME-FLOW | — | sp_*_capability | packages/runtime | apps/portal |
| **Runtime** | MD-KERNEL-009 | — | ADR-010 | MAP-RUNTIME-FLOW | — | sp_runtime_* | packages/runtime | apps/portal |
| **Navigation** | MD-KERNEL-010 | — | — | MAP-RUNTIME-FLOW | — | sp_auth_menu_get | packages/contracts | apps/portal |
| **Workflow** | MD-KERNEL-011 | — | — | MAP-001 | — | sp_workflow_* | packages/workflow | apps/portal |
| **Event** | MD-KERNEL-012 | — | — | MAP-DATA-CANONICAL | MD-006-events.sql | sp_evt_*, sp_event_* | packages/events | — |
| **Ledger** | MD-KERNEL-013 | — | — | MAP-DATA-CANONICAL | MD-006-events.sql | sp_led_* | packages/events | — |
| **Integration** | MD-KERNEL-014 | — | — | MAP-001 | — | sp_integration_* | packages/workflow | — |
| **HIS/Healthcare** | — | BR-003 | — | MAP-001 | — | sp_master_atendimento, sp_ffa_*, sp_triagem_* | modules/atendimento | apps/portal |
| **Farmácia** | — | — | — | — | — | sp_farm_*, sp_farmacia_* | modules/farmacia | apps/portal |
| **Estoque** | — | — | — | — | — | sp_estoque_* | modules/estoque | apps/portal |
| **Faturamento** | — | BR-004 | — | — | — | sp_faturamento_* | modules/faturamento | apps/portal |
| **Portal/Display** | — | — | ADR-002 | — | — | sp_painel_*, sp_totem_* | modules/painel | apps/portal |

---

## 4. Governança

### 4.1 Regras

```text
1. Todo conceito deve ter pelo menos um MD.
2. Todo MD deve ter pelo menos uma BR ou ADR.
3. Todo conceito materializado deve ter SQL + SP + Backend + Frontend.
4. Nenhum documento é criado sem classificação (CANON, REF, AUDIT, DRAFT).
5. Todo documento órfão deve ser classificado ou removido.
```

### 4.2 Ciclo de Vida

```text
DRAFT → CANON → REF → OBSOL → REMOVIDO
   ↓      ↓      ↓       ↓
 Revisão Aprovação Uso    Arquivamento
```

### 4.3 Responsabilidades

| Papel | Responsabilidade |
|-------|-----------------|
| Arquiteto | Aprovar MDs, ADRs, MAPs |
| Engenheiro Backend | Implementar SPs, validar SQL |
| Engenheiro Frontend | Implementar contratos React |
| Product Owner | Validar BRs |
| Auditor | Validar AUDITs, GATEs |

---

## 5. Metadados dos Documentos

### 5.1 Formato Padrão

Todo documento canônico deve conter:

```markdown
## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
[Descrição]
```

---

## Classificação

```text
Tipo: [MD/BR/ADR/MAP/GATE/AUDIT/DOSSIER/FRONT/SQL/SP/API]
Camada: [Plataforma/Kernel/Core/Domínio/Infraestrutura]
Prioridade: [Crítica/Alta/Média/Baixa]
Obrigatoriedade: [Global/Domínio/Opcional]
```

---

## 1. Propósito

[Descrição do propósito]

---

## 2. Referências

- [Lista de documentos referenciados]
```

---

## 6. Ferramentas

### 6.1 Navegação

- **Índice Canônico**: `INDICE-DOCUMENTOS-CANONICOS.md`
- **Mapa de Documentos**: `MD-CANONICAL-DOCUMENT-MAP.md`
- **Este documento**: `KNOWLEDGE-INDEX.md` (índice unificado)

### 6.2 Busca

```bash
# Buscar por prefixo
Get-ChildItem -Recurse -Filter "MD-*.md"

# Buscar por conteúdo
Select-String -Pattern "conceito" -Path "*.md" -Recurse

# Contar por tipo
Get-ChildItem -Recurse -Filter "MD-*.md" | Measure-Object
```

---

## 7. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Manter KNOWLEDGE-INDEX atualizado | Atualizar a cada novo documento |
| Alta | Criar SP-INDEX | Índice de SPs por tipo |
| Alta | Criar TABLE-INDEX | Índice de tabelas |
| Média | Criar DOMAIN-COVERAGE | Cobertura por domínio |
| Média | Criar MATERIALIZATION-TRACKER | Rastreador de materialização |
| Baixa | Automatizar inventário | Script para gerar DOCUMENT-INVENTORY |

---

## 8. Referências

- MD-CANONICAL-DOCUMENT-MAP
- INDICE-DOCUMENTOS-CANONICOS
- MAP-001-Enterprise-Domain-Architecture
- CATALOGO-DA-PLATAFORMA
- AUDIT-MODEL-PHYSICAL-VS-BANCO
- AUDIT-SP-CATALOG
- AUDIT-VIEW-CATALOG
- DEPENDENCY-CATALOG
- DATABASE-COVERAGE

---

## 9. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Índice mestre do conhecimento |

---

Documento Canônico — KNOWLEDGE-INDEX

**Este é o índice mestre de todo o conhecimento da plataforma New Wave Enterprise.**
