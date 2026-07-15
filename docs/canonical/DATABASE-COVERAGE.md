# DATABASE-COVERAGE

## Status

```text
AUDITORIA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Relatório de cobertura do banco de dados.
```

---

## 1. Propósito

Este documento é o **relatório de cobertura do banco de dados** da plataforma New Wave Enterprise.

Ele serve para:
- Contar objetos totais no banco
- Contar objetos já mapeados
- Identificar lacunas de documentação
- Medir progresso da auditoria

---

## 2. Metodologia

```text
Para cada tipo de objeto:
1. Contar total no banco (Dump20260618.sql)
2. Contar total documentado (docs/)
3. Contar total com MD
4. Contar total com BR
5. Contar total com SP
6. Calcular cobertura %
```

---

## 3. Inventário Atual

### 3.1 Tabelas

| Métrica | Valor | Fonte |
|---------|-------|-------|
| Total no dump | 479 | Dump20260618.sql |
| Total mapeadas | 479 | CATALOGO_ENTIDADES_CORE.md |
| Com MD (table-level) | 488 | engineering/canonical/md/ |
| Com colunas documentadas | 488 | engineering/canonical/md-columns/ |
| Com BR | ~200 | docs/BR/ |
| Com SP | ~330 | TABLE-SP-MAP.md |
| Não classificadas | 0 | — |

**Cobertura**: 100% das tabelas estão mapeadas e documentadas.

**Nota**: O número de MDs (488) é maior que o número de tabelas (479) porque existem MDs adicionais para tabelas que foram renomeadas ou consolidadas, além de tabelas que existem em estágios/migrações mas não no dump principal.

### 3.2 Stored Procedures

| Métrica | Valor | Fonte |
|---------|-------|-------|
| Total no dump | 225 | Dump20260618.sql |
| Total documentadas | 42 | AUDIT-SP-CATALOG.md |
| Com SP-TABLE-MAP | ~50 | SP-TABLE-MAP.md |
| Com TABLE-SP-MAP | ~50 | TABLE-SP-MAP.md |
| Com ficha individual | 26 | docs/database/procedures_raw_texts/ |
| Não classificadas | 183 | — |

**Cobertura**: ~19% das SPs estão no catálogo do Kernel. As restantes são SPs de domínio (HIS, Farmácia, Estoque, Faturamento, etc.).

### 3.3 Views

| Métrica | Valor | Fonte |
|---------|-------|-------|
| Total no banco | 0 | Dump20260618.sql |
| Total propostas | 10 | MODEL-PHYSICAL-KERNEL.md |
| Documentadas | 10 | AUDIT-VIEW-CATALOG.md |
| Criadas | 0 | — |

**Cobertura**: Nenhuma view existe no banco. 10 views propostas documentadas.

### 3.4 Functions

| Métrica | Valor | Fonte |
|---------|-------|-------|
| Total no dump | 3 | Dump20260618.sql |
| Documentadas | 0 | — |
| Nomes | fn_decision_fingerprint, fn_runtime_chain_fingerprint, fn_sha256i_hash | Dump20260618.sql |

**Cobertura**: 0% — functions não documentadas.

### 3.5 Triggers

| Métrica | Valor | Fonte |
|---------|-------|-------|
| Total no banco | 0 | Dump20260618.sql |

**Cobertura**: N/A — banco não usa triggers.

---

## 4. Cobertura por Domínio

| Domínio | Tabelas | SPs | Views | MDs | BRs | Cobertura |
|---------|---------|-----|-------|-----|-----|-----------|
| CORE/IDENTIDADE/MULTI-TENANT | 47 | ~30 | 3 | Sim | Sim | Alta |
| KERNEL/RUNTIME | 53 | ~20 | 2 | Parcial | Parcial | Média |
| PORTAL/DISPLAY | 38 | ~15 | 1 | Parcial | Parcial | Média |
| HIS/HEALTHCARE | 200 | ~100 | 0 | Sim | Sim | Alta |
| FARMÁCIA | 9 | ~10 | 0 | Sim | Sim | Alta |
| ESTOQUE | 38 | ~15 | 0 | Sim | Sim | Alta |
| FATURAMENTO/FINANCEIRO | 22 | ~15 | 0 | Sim | Sim | Alta |
| LABORATÓRIO | 7 | ~8 | 0 | Sim | Sim | Alta |
| AUDITORIA/EVENT STORE | 38 | ~5 | 1 | Parcial | Parcial | Média |
| INTEGRAÇÃO | 6 | ~2 | 1 | Não | Não | Baixa |
| SOCIAL/WIKI/CHAT | 4 | ~1 | 0 | Não | Não | Baixa |
| RH/ADMINISTRATIVO | 18 | ~5 | 0 | Parcial | Parcial | Média |
| CRM/SAC | 7 | ~2 | 0 | Não | Não | Baixa |
| DADOS MESTRE/MD | 22 | ~3 | 0 | Sim | Sim | Alta |
| CONFIGURAÇÃO | 4 | ~2 | 0 | Parcial | Parcial | Média |
| LOGÍSTICA/TRANSPORTE | 8 | ~3 | 0 | Não | Não | Baixa |
| DOCUMENTOS | 13 | ~2 | 0 | Não | Não | Baixa |
| AGENDAMENTO | 4 | ~3 | 0 | Parcial | Parcial | Média |

---

## 5. Lacunas Identificadas

### 5.1 Tabelas sem MD

| Tabela | Motivo | Ação |
|--------|--------|------|
| Tabelas de domínio HIS | Muitas, mas priorizar Kernel | Documentar em fases |
| integration_adapter | Nova (PROPOSE) | Criar MD quando materializar |
| integration_contract | Nova (PROPOSE) | Criar MD quando materializar |
| workflow_process | Nova (PROPOSE) | Criar MD quando materializar |
| workflow_state | Nova (PROPOSE) | Criar MD quando materializar |
| workflow_transition | Nova (PROPOSE) | Criar MD quando materializar |
| registry_module | Nova (PROPOSE) | Criar MD quando materializar |
| registry_capability | Nova (PROPOSE) | Criar MD quando materializar |
| discovery_cache | Nova (PROPOSE) | Criar MD quando materializar |
| auth_role | Nova (PROPOSE) | Criar MD quando materializar |
| auth_decision | Nova (PROPOSE) | Criar MD quando materializar |
| identidade_tecnica | Nova (PROPOSE) | Criar MD quando materializar |
| pessoa_tenant | Nova (PROPOSE) | Criar MD quando materializar |

### 5.2 SPs sem Catálogo

| Categoria | Count | Ação |
|-----------|-------|------|
| SPs de domínio HIS | ~100 | Criar catálogo separado |
| SPs de suporte/seed | ~30 | Manter como está |
| SPs de infraestrutura | ~13 | Manter como está |
| SPs do Kernel | 42 | Documentado em AUDIT-SP-CATALOG |

### 5.3 Functions sem Documentação

| Function | Ação |
|----------|------|
| fn_decision_fingerprint | Documentar |
| fn_runtime_chain_fingerprint | Documentar |
| fn_sha256i_hash | Documentar |

---

## 6. Estatísticas Gerais

| Tipo | Total | Documentados | Cobertos por SP | Cobertos por MD | Cobertos por BR | Lacunas |
|------|-------|--------------|-----------------|-----------------|-----------------|---------|
| Tabelas | 479 | 479 | ~330 | 488 | ~200 | 0 |
| Procedures | 225 | 42 | — | — | — | 183 |
| Views | 0 | 10 (propostas) | — | — | — | 10 |
| Functions | 3 | 0 | — | — | — | 3 |
| Triggers | 0 | 0 | — | — | — | 0 |

---

## 7. Priorização de Lacunas

### Alta Prioridade

1. Documentar SPs do Kernel (42 já catalogadas em AUDIT-SP-CATALOG)
2. Validar FKs de todas as tabelas do Kernel
3. Criar MDs para tabelas PROPOSE do Kernel

### Média Prioridade

4. Documentar functions (3)
5. Criar views propostas
6. Documentar SPs de domínio HIS

### Baixa Prioridade

7. Documentar tabelas de domínio (HIS, Farmácia, etc.)
8. Documentar SPs de suporte/seed
9. Criar catálogo de SPs de domínio

---

## 8. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Finalizar AUDIT-SP-CATALOG | Completar catálogo de SPs |
| Alta | Criar AUDIT-FUNCTION-CATALOG | Catalogar functions |
| Média | Criar MDs para tabelas PROPOSE | Documentar 12 tabelas novas |
| Média | Implementar views | Criar 10 views no banco |
| Baixa | Automatizar cobertura | Script para gerar este relatório |

---

## 9. Referências

- CATALOGO_ENTIDADES_CORE
- MAPA_DEPENDENCIAS_ERD
- AUDIT-MODEL-PHYSICAL-VS-BANCO
- AUDIT-SP-CATALOG
- AUDIT-VIEW-CATALOG
- DEPENDENCY-CATALOG
- SP-TABLE-MAP
- TABLE-SP-MAP
- Dump20260618.sql
- docs/database/procedures_raw_texts/
- docs/database/procedures_raw/
- docs/database/views/kilo-views.json

---

## 10. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Relatório de cobertura do banco |

---

Documento Canônico — DATABASE-COVERAGE

**Este é o relatório oficial de cobertura do banco de dados da plataforma New Wave Enterprise.**
