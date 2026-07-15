# DOMAIN-COVERAGE

## Status

```text
GOVERNAÇA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Cobertura por domínio/produto da plataforma.
```

---

## 1. Propósito

Este documento é o **relatório de cobertura por domínio** da plataforma New Wave Enterprise.

Ele serve para:
- Medir maturidade de cada produto (HIS, ERP, CRM, Portal, BI, etc.)
- Identificar domínios com documentação incompleta
- Priorizar esforços de materialização
- Controlar evolução da plataforma

---

## 2. Metodologia

```text
Para cada domínio:
1. Contar tabelas no banco
2. Contar MDs (docs/canonical/ + engineering/canonical/md/)
3. Contar BRs (docs/canonical/BR-*)
4. Contar ADRs relevantes
5. Contar SPs
6. Contar módulos runtime (modules/)
7. Contar apps (apps/)
8. Calcular % de cobertura
```

---

## 3. Cobertura por Domínio

### 3.1 Kernel Enterprise

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 40+ | Alta |
| MDs | 15 (MD-KERNEL-000 a 014) | Alta |
| BRs | 2 (BR-REGISTRY-001/002) | Média |
| ADRs | 2 (ADR-010, ADR-CORE-005) | Alta |
| SPs | 42 catalogadas | Alta |
| Módulos runtime | modules/kernel/ (66 arquivos) | Alta |
| Apps | apps/portal/ | Alta |

**Maturidade**: 85% — Kernel está bem documentado e parcialmente implementado.

**Pendente**: 
- Materializar tabelas PROPOSE (registry_module, registry_capability, auth_decision, etc.)
- Implementar SPs PROPOSE (sp_discovery_resolve, sp_navigation_project, etc.)
- Conectar Backend ao Kernel

---

### 3.2 Core / Foundation

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 10 | Alta |
| MDs | 10+ | Alta |
| BRs | 1 (BR-001) | Alta |
| ADRs | 1 (ADR-001) | Alta |
| SPs | 30+ | Alta |
| Módulos runtime | modules/identity/ (23), modules/pessoa/ (38) | Alta |

**Maturidade**: 90% — Foundation está implementado e funcionando.

**Pendente**: 
- Adaptar saas_entidade → tenant
- Adaptar usuario_contexto → contexto

---

### 3.3 HIS / Healthcare

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 200+ | Alta |
| MDs | Parcial | Média |
| BRs | 1 (BR-003-HIS-Clinical-Rules) | Alta |
| ADRs | 0 | Baixa |
| SPs | ~100 | Alta |
| Módulos runtime | modules/atendimento/ (99), modules/ffa/ (37), modules/triagem/ (25), modules/enfermagem/ (29), modules/medico/ (27), modules/internacao/ (37), modules/laboratorio/ (39) | Alta |
| Apps | apps/portal/ (usa HIS) | Alta |

**Maturidade**: 80% — HIS está implementado e funcionando, mas falta documentação canônica MD/ADR.

**Pendente**: 
- Criar MDs canônicos para HIS
- Criar ADRs específicas de HIS
- Documentar fluxos clínicos em MAPs

---

### 3.4 Portal / Display

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 21 | Alta |
| MDs | Parcial | Média |
| BRs | 0 | Baixa |
| ADRs | 1 (ADR-002-Portal-Entry-Point) | Alta |
| SPs | ~15 | Alta |
| Módulos runtime | modules/painel/ (38), modules/display/ (32) | Alta |
| Apps | apps/portal/, apps/displays/ | Alta |

**Maturidade**: 75% — Portal está implementado, mas falta documentação de experiência frontend.

**Pendente**: 
- Completar FRONT-001 a FRONT-083
- Documentar design system
- Criar runtime de dashboards dinâmicos

---

### 3.5 Farmácia

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 6 | Alta |
| MDs | Parcial | Média |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~10 | Alta |
| Módulos runtime | modules/farmacia/ (48) | Alta |

**Maturidade**: 70% — Implementado, mas falta documentação canônica.

**Pendente**: 
- Criar MDs canônicos para Farmácia
- Criar BRs específicas

---

### 3.6 Estoque / Logística

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 10+ | Alta |
| MDs | Parcial | Média |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~15 | Alta |
| Módulos runtime | modules/estoque/ (53) | Alta |

**Maturidade**: 70% — Implementado, mas falta documentação canônica.

**Pendente**: 
- Criar MDs canônicos para Estoque
- Criar BRs específicas

---

### 3.7 Faturamento / Financeiro

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 8 | Alta |
| MDs | Parcial | Média |
| BRs | 1 (BR-004-CRM-Rules) | Média |
| ADRs | 0 | Baixa |
| SPs | ~15 | Alta |
| Módulos runtime | modules/faturamento/ (39), modules/financeiro/ (38) | Alta |

**Maturidade**: 70% — Implementado, mas falta documentação canônica.

**Pendente**: 
- Criar MDs canônicos para Financeiro
- Criar BRs específicas

---

### 3.8 Auditoria / Event Store

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 10+ | Alta |
| MDs | Parcial | Média |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~5 | Média |
| Módulos runtime | modules/auditoria/ (48) | Alta |

**Maturidade**: 75% — Implementado, mas SPs e documentação canônica incompletas.

**Pendente**: 
- Consolidar event_stream em kernel_ledger
- Criar MDs canônicos para Auditoria

---

### 3.9 Integração

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 5 | Média |
| MDs | 0 | Baixa |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~2 | Baixa |
| Módulos runtime | modules/governanca/ (24) | Média |

**Maturidade**: 30% — Estrutura básica existe, mas falta materialização do Kernel de integração.

**Pendente**: 
- Criar MDs canônicos para Integration
- Implementar workflow_process, workflow_state, workflow_transition
- Implementar integration_adapter, integration_contract

---

### 3.10 RH / Administrativo

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 14 | Alta |
| MDs | Parcial | Média |
| BRs | 1 (BR-005-RH-Rules) | Alta |
| ADRs | 0 | Baixa |
| SPs | ~5 | Média |
| Módulos runtime | Nenhum módulo específico | Baixa |

**Maturidade**: 60% — Tabelas e SPs existem, mas falta módulo runtime dedicado.

**Pendente**: 
- Criar módulo RH runtime
- Criar MDs canônicos

---

### 3.11 CRM / SAC

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 7 | Alta |
| MDs | 0 | Baixa |
| BRs | 1 (BR-004-CRM-Rules) | Média |
| ADRs | 0 | Baixa |
| SPs | ~2 | Baixa |
| Módulos runtime | Nenhum módulo específico | Baixa |

**Maturidade**: 40% — Tabelas existem, mas falta módulo runtime e documentação canônica.

**Pendente**: 
- Criar módulo CRM runtime
- Criar MDs canônicos

---

### 3.12 Dados Mestre / MD

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 11 | Alta |
| MDs | Parcial | Média |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~3 | Média |

**Maturidade**: 60% — Tabelas existem, mas falta documentação canônica.

**Pendente**: 
- Criar MDs canônicos para MD
- Criar módulo MD runtime

---

### 3.13 Configuração

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 4 | Alta |
| MDs | Parcial | Média |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~2 | Média |

**Maturidade**: 50% — Básico implementado.

---

### 3.14 Logística / Transporte

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 8 | Alta |
| MDs | 0 | Baixa |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~3 | Baixa |
| Módulos runtime | Nenhum módulo específico | Baixa |

**Maturidade**: 40% — Tabelas existem, mas falta módulo runtime e documentação.

---

### 3.15 Documentos

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 14 | Alta |
| MDs | 0 | Baixa |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~2 | Baixa |
| Módulos runtime | Nenhum módulo específico | Baixa |

**Maturidade**: 40% — Estrutura básica existe, mas falta módulo runtime.

---

### 3.16 Agendamento

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 4 | Alta |
| MDs | Parcial | Média |
| BRs | 0 | Baixa |
| ADRs | 0 | Baixa |
| SPs | ~3 | Média |

**Maturidade**: 50% — Básico implementado.

---

### 3.17 ERP (não implementado)

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 0 | N/A |
| MDs | 0 | N/A |
| BRs | 0 | N/A |
| ADRs | 0 | N/A |
| SPs | 0 | N/A |
| Módulos runtime | Nenhum | N/A |

**Maturidade**: 0% — Conceitual apenas.

**Pendente**: 
- Definir domínios ERP
- Criar MDs canônicos
- Implementar tabelas e SPs

---

### 3.18 CRM (não implementado)

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 0 | N/A |
| MDs | 0 | N/A |
| BRs | 0 | N/A |
| ADRs | 0 | N/A |
| SPs | 0 | N/A |
| Módulos runtime | Nenhum | N/A |

**Maturidade**: 0% — Conceitual apenas.

**Pendente**: 
- Definir domínios CRM
- Criar MDs canônicos
- Implementar tabelas e SPs

---

### 3.19 Marketplace (não implementado)

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 0 | N/A |
| MDs | 0 | N/A |
| BRs | 0 | N/A |
| ADRs | 0 | N/A |
| SPs | 0 | N/A |
| Módulos runtime | Nenhum | N/A |

**Maturidade**: 0% — Conceitual apenas.

---

### 3.20 BI / Analytics

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Tabelas | 0 | N/A |
| MDs | 0 | N/A |
| BRs | 0 | N/A |
| ADRs | 0 | N/A |
| SPs | 0 | N/A |
| Módulos runtime | Nenhum | N/A |

**Maturidade**: 0% — Conceitual apenas.

---

### 3.21 Mobile

| Métrica | Valor | Cobertura |
|---------|-------|-----------|
| Apps | apps/mobile/ (não analisado) | — |

**Maturidade**: Não avaliado — requer análise específica.

---

## 4. Resumo de Maturidade

| Domínio | Maturidade | Status |
|---------|------------|--------|
| Kernel Enterprise | 85% | 🟢 Em materialização |
| Core / Foundation | 90% | 🟢 Implementado |
| HIS / Healthcare | 80% | 🟢 Implementado |
| Portal / Display | 75% | 🟡 Em desenvolvimento |
| Farmácia | 70% | 🟡 Implementado |
| Estoque | 70% | 🟡 Implementado |
| Faturamento | 70% | 🟡 Implementado |
| Auditoria / Event Store | 75% | 🟡 Implementado |
| Integração | 30% | 🔴 Em planejamento |
| RH | 60% | 🟡 Parcial |
| CRM | 40% | 🔴 Em planejamento |
| Dados Mestre | 60% | 🟡 Parcial |
| Configuração | 50% | 🟡 Parcial |
| Logística | 40% | 🔴 Em planejamento |
| Documentos | 40% | 🔴 Em planejamento |
| Agendamento | 50% | 🟡 Parcial |
| ERP | 0% | ⚪ Conceitual |
| CRM (produto) | 0% | ⚪ Conceitual |
| Marketplace | 0% | ⚪ Conceitual |
| BI / Analytics | 0% | ⚪ Conceitual |
| Mobile | — | ⚪ Não avaliado |

---

## 5. Priorização de Domínios

### Alta Prioridade (Materializar)

1. **Kernel Enterprise** — 85% → 100% (finalizar materialização)
2. **Portal/Display** — 75% → 90% (completar frontend)
3. **Integração** — 30% → 60% (implementar workflow e adapters)

### Média Prioridade (Documentar)

4. **HIS/Healthcare** — 80% → 90% (documentar MDs/ADRs)
5. **Farmácia** — 70% → 85% (documentar)
6. **Estoque** — 70% → 85% (documentar)
7. **Faturamento** — 70% → 85% (documentar)

### Baixa Prioridade (Planejar)

8. **ERP** — 0% → 10% (definir escopo)
9. **CRM** — 0% → 10% (definir escopo)
10. **Marketplace** — 0% → 10% (definir escopo)
11. **BI** — 0% → 10% (definir escopo)

---

## 6. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Finalizar Kernel | Materializar tabelas e SPs PROPOSE |
| Alta | Completar Portal | Implementar FRONT-001 a FRONT-083 |
| Alta | Implementar Integração | Workflow, adapters, contracts |
| Média | Documentar HIS | MDs e ADRs canônicos |
| Média | Documentar domínios | MDs para Farmácia, Estoque, Faturamento |
| Baixa | Planejar ERP/CRM | Definir escopo e MDs |

---

## 7. Referências

- MAP-001-Enterprise-Domain-Architecture
- CATALOGO_ENTIDADES_CORE
- AUDIT-MODEL-PHYSICAL-VS-BANCO
- AUDIT-SP-CATALOG
- MATERIALIZATION-TRACKER
- Dump20260618.sql

---

## 8. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Relatório de cobertura por domínio |

---

Documento Canônico — DOMAIN-COVERAGE

**Este é o relatório oficial de cobertura por domínio da plataforma New Wave Enterprise.**
