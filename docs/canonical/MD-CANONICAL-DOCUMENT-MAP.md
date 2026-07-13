# MD-CANONICAL-DOCUMENT-MAP

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Artefato de transição para materialização.
```

---

## 1. Propósito

Este documento é o **índice oficial de todos os documentos canônicos** da plataforma New Wave Enterprise.

Ele serve para:
- Identificar rapidamente o que é canônico
- Separar referência de histórico
- Evitar duplicação
- Orientar materialização
- Controlar obsolescência

Com **2.823 arquivos MDs** no projeto, este mapa é o instrumento de governança que impede que documentação infinita atrase a execução.

---

## 2. Classificação de Documentos

### 2.1 Categorias canônicas

| Categoria | Sigla | Descrição | Ação |
|-----------|-------|-----------|------|
| Constituição | CONSTIT | Documentos supremos da plataforma | Consulta obrigatória |
| Canônico | CANON | Leis, MDs, MAPs, ADRs aprovados | Referência obrigatória |
| Referência | REF | Documentos de apoio técnico | Consulta quando necessário |
| Auditoria | AUDIT | Dossiês, GATEs, relatórios | Consulta histórica |
| Rascunho | DRAFT | Documentos em evolução | Não é referência |
| Gerado | GEN | Artefatos derivados de banco/código | Regenerável |
| Histórico | HIST | Documentos de versões anteriores | Consulta retrospectiva |
| Obsoleto | OBSOL | Documentos substituídos | Não consultar |

### 2.2 Regra de classificação

```text
Todo documento deve ter uma categoria definida.
Nenhum documento fica sem classificação.
Documentos sem categoria não são referência.
```

---

## 3. Mapa de Documentos Canônicos

### 3.1 Constituição da Plataforma

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| 000-CONSTITUICAO-PLATAFORMA.md | CONSTIT | CANÔNICO | Constituição suprema da plataforma |
| 000-CONSTITUICAO-IA.md | CONSTIT | CANÔNICO | Guia operacional das IAs |

### 3.2 Leis Canônicas

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/canonical/MD-110-Canonical-Laws.md | CANON | CANÔNICO | Leis supremas da plataforma |
| docs/canonical/MD-100-Unified-Enterprise-Operating-System.md | CANON | CANÔNICO | Arquitetura unificada |
| docs/canonical/MD-CANONICO-IA-001-Lei-Evolucao-Documental.md | CANON | CANÔNICO | Lei de evolução documental |
| docs/canonical/MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md | CANON | CANÔNICO | Lei de governança arquitetural |
| docs/canonical/MD-CANONICO-IA-003-Lei-Evolucao-Core.md | CANON | CANÔNICO | Lei da evolução do Core |
| docs/canonical/MD-CANONICO-IA-004-Matriz-Evolucao-Projeto.md | CANON | CANÔNICO | Matriz de evolução |
| docs/canonical/MD-CANONICO-IA-005-Lei-Engenharia-Materializacao.md | CANON | CANÔNICO | Lei de engenharia e materialização |
| docs/canonical/MD-CANONICO-IA-007-Lei-Banco-Fonte-Verdade-Knowledge-Graph.md | CANON | CANÔNICO | Lei do banco como fonte da verdade |

### 3.3 Kernel Enterprise

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/canonical/kernel/MD-KERNEL-000.md | CANON | CANÔNICO | Arquitetura conceitual do Kernel |
| docs/canonical/kernel/MD-KERNEL-001-Identity.md | CANON | CANÔNICO | Domínio: Identity |
| docs/canonical/kernel/MD-KERNEL-002-Tenant.md | CANON | CANÔNICO | Domínio: Tenant |
| docs/canonical/kernel/MD-KERNEL-003-Session.md | CANON | CANÔNICO | Domínio: Session |
| docs/canonical/kernel/MD-KERNEL-004-Context.md | CANON | CANÔNICO | Domínio: Context |
| docs/canonical/kernel/MD-KERNEL-005-Authorization.md | CANON | CANÔNICO | Domínio: Authorization |
| docs/canonical/kernel/MD-KERNEL-006-Discovery.md | CANON | CANÔNICO | Domínio: Discovery |
| docs/canonical/kernel/MD-KERNEL-007-Registry.md | CANON | CANÔNICO | Domínio: Registry |
| docs/canonical/kernel/MD-KERNEL-008-Capability.md | CANON | CANÔNICO | Domínio: Capability |
| docs/canonical/kernel/MD-KERNEL-009-Runtime.md | CANON | CANÔNICO | Domínio: Runtime |
| docs/canonical/kernel/MD-KERNEL-010-Navigation.md | CANON | CANÔNICO | Domínio: Navigation |
| docs/canonical/kernel/MD-KERNEL-011-Workflow.md | CANON | CANÔNICO | Domínio: Workflow |
| docs/canonical/kernel/MD-KERNEL-012-Event.md | CANON | CANÔNICO | Domínio: Event |
| docs/canonical/kernel/MD-KERNEL-013-Ledger.md | CANON | CANÔNICO | Domínio: Ledger |
| docs/canonical/kernel/MD-KERNEL-014-Integration.md | CANON | CANÔNICO | Domínio: Integration |
| docs/canonical/kernel/MAPA-DO-KERNEL.md | CANON | CANÔNICO | Mapa estrutural do Kernel |
| docs/canonical/kernel/MD-KERNEL-DEPENDENCY-MAP.md | CANON | CANÔNICO | Matriz de dependências |

### 3.4 Mapas de Arquitetura

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/canonical/MAP-001-Enterprise-Domain-Architecture.md | CANON | CANÔNICO | Mapa de domínios enterprise |
| docs/canonical/MAP-001-Apps.md | CANON | CANÔNICO | Mapa de aplicações |

### 3.5 ADRs

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/canonical/ADAPT-AUTHSERVICE.md | CANON | CANÔNICO | ADR: Adaptação do serviço de autenticação |
| docs/canonical/ADR-CORE-005-PERMISSION-EVALUATE.md | CANON | CANÔNICO | ADR: Avaliação de permissões |
| docs/canonical/GATE-CORE-005.md | CANON | CANÔNICO | GATE: Core 005 |
| docs/canonical/GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION.md | CANON | CANÔNICO | GATE: Decision |
| docs/canonical/GATE-RUNTIME-CHAIN.md | CANON | CANÔNICO | GATE: Runtime Chain |
| docs/canonical/DOSSIER-DISCOVERY-REGISTRY-RUNTIME.md | CANON | CANÔNICO | Dossiê: Discovery/Registry/Runtime |
| docs/canonical/AUDIT-DISCOVERY-REGISTRY-RUNTIME.md | CANON | CANÔNICO | Auditoria: Discovery/Registry/Runtime |
| docs/canonical/AUDITORIA-CORE-005-MIGRATION.md | CANON | CANÔNICO | Auditoria: Core 005 Migration |

### 3.6 Documentos de Engenharia

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/engineering/runtime-map.md | REF | CANÔNICO | Mapa de runtime |
| docs/engineering/GATE-FRONT-001-discovery.md | REF | CANÔNICO | GATE Front 001 |
| engineering/canonical/md/MD-contexto.md | REF | CANÔNICO | Contexto operacional (legado) |
| engineering/canonical/md/MD-usuario_contexto.md | REF | HIST | Contexto de usuário (legado) |
| engineering/canonical/md/MD-sessao_contexto_historico.md | REF | HIST | Histórico de contexto (legado) |
| engineering/canonical/md/MD-runtime_contexto.md | REF | HIST | Contexto de runtime (legado) |
| engineering/canonical/md/MD-contexto_atendimento.md | REF | HIST | Contexto de atendimento (legado) |
| engineering/canonical/md/MD-auditoria_contexto.md | REF | HIST | Auditoria de contexto (legado) |

### 3.7 Documentos de Projeto

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/PROJECT_BRAIN.md | REF | CANÔNICO | Cérebro do projeto |
| docs/IMPLEMENTATION_STATUS.md | REF | CANÔNICO | Status de implementação |
| docs/DEVELOPMENT.md | REF | CANÔNICO | Guia de desenvolvimento |
| docs/DATABASE_BRAIN.md | REF | CANÔNICO | Cérebro do banco de dados |
| docs/CHANGELOG_BRAIN.md | REF | HIST | Changelog histórico |

### 3.8 Documentos de Database

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/database/DATABASE-MAP.md | REF | CANÔNICO | Mapa do banco de dados |
| docs/database/MAPA_ESCRITA.md | REF | CANÔNICO | Mapa de escrita |
| docs/database/MAPA_DEPENDENCIAS_ERD.md | REF | CANÔNICO | Mapa de dependências ERD |
| docs/database/MAPA_CONSUMO_MODULOS.md | REF | CANÔNICO | Mapa de consumo por módulos |
| docs/database/INVENTORY.md | REF | CANÔNICO | Inventário |
| docs/database/INVENTARIO_PROCEDURES.md | REF | CANÔNICO | Inventário de procedures |
| docs/database/FRONT-SP-MAP.md | REF | CANÔNICO | Mapa Front-SP |
| docs/database/BACKEND-SP-MAP.md | REF | CANÔNICO | Mapa Backend-SP |
| docs/database/ESTADO_DOCUMENTACAO.md | REF | CANÔNICO | Estado da documentação |
| docs/database/DECISION-LOG.md | REF | CANÔNICO | Log de decisões |
| docs/database/DECISION-ENGINE.md | REF | CANÔNICO | Engine de decisão |
| docs/database/CHANGELOG.md | REF | HIST | Changelog |
| docs/database/CATALOGO_ENTIDADES_CORE.md | REF | CANÔNICO | Catálogo de entidades core |
| docs/database/ARCHITECTURE-TESTS.md | REF | CANÔNICO | Testes de arquitetura |
| docs/database/AUDIT-RESULTADO.md | REF | HIST | Resultado de auditoria |
| docs/database/DUPLICATION-MAP.md | REF | CANÔNICO | Mapa de duplicações |
| docs/database/DUMP-001-audit.md | GEN | CANÔNICO | Dump de auditoria |

### 3.9 Documentos de Frontend

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| FRONT-000 | CANON | CANÔNICO | Constituição Frontend |
| FRONT-001 | CANON | CANÔNICO | Login |
| FRONT-002 | CANON | CANÔNICO | Seleção de Contexto |
| FRONT-003 | CANON | CANÔNICO | Portal Enterprise |
| FRONT-004 | CANON | CANÔNICO | Design System |
| FRONT-005 | CANON | CANÔNICO | App Shell |

### 3.10 Documentos de Business Rules

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| BR-KERNEL-001 | CANON | RASCUNHO | Regras de plataforma (a criar) |
| BR-SECURITY-001 | CANON | RASCUNHO | Regras de segurança (a criar) |
| BR-RUNTIME-001 | CANON | RASCUNHO | Regras de runtime (a criar) |
| BR-DATA-001 | CANON | RASCUNHO | Regras de dados (a criar) |
| BR-INTEGRATION-001 | CANON | RASCUNHO | Regras de integração (a criar) |
| BR-AUDIT-001 | CANON | RASCUNHO | Regras de auditoria (a criar) |

### 3.11 Documentos de Database - Tabelas

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/database/tables/*.md | REF | GERADO | Tabelas do banco (regeneráveis) |

### 3.12 Documentos de Database - Procedures

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/database/procedures/*.md | REF | GERADO | Procedures do banco (regeneráveis) |

### 3.13 Documentos New Wave IA

| Documento | Categoria | Status | Descrição |
|-----------|-----------|--------|-----------|
| docs/new-wave-ia/MASTER-*.md | REF | CANÔNICO | Documentos estratégicos New Wave |
| docs/new-wave-ia/FASE-2-AGENTE-*.md | REF | CANÔNICO | Agentes Fase 2 |

---

## 4. Regras de Governança

### 4.1 Criação

```text
Todo novo documento deve:
1. Verificar se já existe documento equivalente
2. Se existir: atualizar
3. Se não existir: criar com categoria definida
4. Nunca criar sem categoria
```

### 4.2 Atualização

```text
Todo documento canônico:
1. Mantém categoria CANON
2. Recebe número de versão
3. Recebe data de atualização
4. Recebe autor
```

### 4.3 Obsolescência

```text
Documento obsoleto:
1. Recebe categoria OBSOL
2. Recebe data de obsolescência
3. Recebe documento substituto
4. Nunca é deletado
```

### 4.4 Regeneração

```text
Documentos GERADOS:
1. Podem ser recriados a partir da fonte
2. Fonte: banco, código, schema
3. Não são referência arquitetônica
4. São referência técnica
```

---

## 5. Próximos Artefatos

Baseado neste mapa, os próximos documentos a criar são:

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | REVIEW-KERNEL-TRANSVERSAL.md | Validação dos produtos contra Kernel |
| Alta | MAP-KERNEL-COVERAGE.md | Mapa de cobertura de domínios |
| Alta | BR-KERNEL-001.md | Regras de plataforma |
| Média | MAP-RUNTIME-FLOW.md | Mapa de fluxo de runtime |
| Média | MAP-DATA-CANONICAL.md | Mapa de dados canônicos |
| Média | MODEL-LOGICAL-KERNEL.md | Modelo lógico do Kernel |
| Média | MODEL-PHYSICAL-KERNEL.md | Modelo físico do Kernel |
| Média | SP-KERNEL-CATALOG.md | Catálogo de procedures |
| Baixa | FRONT-KERNEL-MAP.md | Mapa front-kernel |

---

## 6. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-DEPENDENCY-MAP
- MAPA DO KERNEL ENTERPRISE
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 7. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do mapa de documentos canônicos |

---

Documento Canônico — MD-CANONICAL-DOCUMENT-MAP

**Este é o índice oficial de todos os documentos canônicos da plataforma New Wave Enterprise.**
