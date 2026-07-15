# DOCUMENT-INVENTORY

## Status

```text
GOVERNAÇA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Inventário completo de todos os documentos da plataforma.
```

---

## 1. Propósito

Este documento é o **inventário completo de todos os documentos** da plataforma New Wave Enterprise.

Ele serve para:
- Contar documentos por tipo, categoria e status
- Identificar documentos órfãos (sem referências)
- Identificar documentos duplicados
- Controlar obsolescência
- Servir como fonte de governança da documentação

**Total de documentos**: 2.856 arquivos `.md` (excluindo node_modules/.kilo).

---

## 2. Distribuição Global

| Tipo | Count | % do Total |
|------|-------|------------|
| **MD-*** | **1,133** | **39.7%** |
| FRONT-* | 106 | 3.7% |
| MAP-* | 51 | 1.8% |
| BR-* | 35 | 1.2% |
| GATE-* | 10 | 0.3% |
| ADR-* | 8 | 0.3% |
| AUDIT-* | 4 | 0.1% |
| DOSSIER-* | 2 | 0.1% |
| SP-* | 2 | 0.1% |
| API-* | 1 | 0.0% |
| SQL-* | 1 | 0.0% |
| TABLE-* | 1 | 0.0% |
| OUTROS | 1,502 | 52.6% |
| **TOTAL** | **2,856** | **100%** |

---

## 3. Documentos por Diretório

| Diretório | Arquivos | Tipo Predominante |
|-----------|----------|-------------------|
| docs/database/ | 1,953 | MD-* (tables, procedures) |
| docs/canonical/ | 471 | CANON (MD, BR, ADR, MAP, FRONT) |
| engineering/ | 1,144 | MD-* (canonical/md, md-columns) |
| modules/ | 1,104 | TypeScript (código) + docs |
| apps/ | 98 | TypeScript (código) |
| packages/ | 84 | TypeScript (código) |
| docs/new-wave-ia/ | 33 | IA docs |
| docs/architecture/ | 13 | Arquitetura |
| docs/auditoria/ | 14 | Auditoria |
| backend/ | — | TypeScript (código) |

---

## 4. Categorias Canônicas

| Categoria | Sigla | Count | Descrição |
|-----------|-------|-------|-----------|
| Constituição | CONSTIT | 2 | Documentos supremos |
| Canônico | CANON | 200+ | Leis, MDs, MAPs, ADRs aprovados |
| Referência | REF | 500+ | Documentos de apoio técnico |
| Auditoria | AUDIT | 50+ | Dossiês, GATEs, relatórios |
| Rascunho | DRAFT | 1,000+ | Documentos em evolução |
| Gerado | GEN | 1,000+ | Artefatos derivados de banco/código |
| Histórico | HIST | 100+ | Documentos de versões anteriores |
| Obsoleto | OBSOL | — | Documentos substituídos |

---

## 5. Inventário por Tipo

### 5.1 MD-*.md (1,133 documentos)

| Local | Count | Descrição |
|-------|-------|-----------|
| engineering/canonical/md/ | 488 | Entity-level MDs (tabelas) |
| engineering/canonical/md-columns/ | 478 | Column-level MDs |
| docs/database/tables/ | 480 | Table definition MDs |
| docs/canonical/ | 60+ | Architecture MDs (MD-001 a MD-143) |
| engineering/kilo/md/ | 6 | Migration SQL+MD files |
| docs/database/procedures/ | 229 | SP documentation MDs |
| Outros | 292 | Scattered MDs |

**Classificação**:
- CANON: ~200 (MDs canônicos aprovados)
- REF: ~300 (documentos de referência)
- DRAFT: ~400 (em evolução)
- GEN: ~233 (gerados de banco/código)

---

### 5.2 FRONT-*.md (106 documentos)

| Local | Count | Descrição |
|-------|-------|-----------|
| docs/canonical/FRONT/ | 12 | Frontend experience specs |
| docs/canonical/ | 83 | FRONT-001 a FRONT-083 |
| engineering/canonical/front/ | 5 | Front engineering docs |
| Outros | 6 | Scattered front docs |

**Classificação**:
- CANON: ~20 (aprovados)
- DRAFT: ~80 (em evolução)
- REF: ~6 (referência)

---

### 5.3 MAP-*.md (51 documentos)

| Local | Count | Descrição |
|-------|-------|-----------|
| docs/canonical/ | 51 | Architecture maps |

**Classificação**:
- CANON: ~30 (aprovados)
- DRAFT: ~20 (em evolução)
- REF: ~1 (referência)

---

### 5.4 BR-*.md (35 documentos)

| Local | Count | Descrição |
|-------|-------|-----------|
| docs/canonical/ | 10 | Business rules catalog + 9 BRs |
| engineering/canonical/br/ | 25 | SP-specific BRs |

**Classificação**:
- CANON: ~10 (aprovados)
- REF: ~25 (referência)

---

### 5.5 ADR-*.md (8 documentos)

| Local | Count | Descrição |
|-------|-------|-----------|
| docs/canonical/ | 8 | Architecture Decision Records |

**Classificação**:
- CANON: 8 (todos aprovados)

---

### 5.6 GATE-*.md (10 documentos)

| Local | Count | Descrição |
|-------|-------|-----------|
| docs/canonical/ | 9 | Gateway/adaptation plans |
| docs/engineering/ | 1 | GATE-FRONT-001 |

**Classificação**:
- CANON: ~5 (aprovados)
- AUDIT: ~5 (em revisão)

---

### 5.7 AUDIT-*.md (4 documentos)

| Local | Count | Descrição |
|-------|-------|-----------|
| docs/canonical/ | 4 | Audit catalogs |

**Classificação**:
- AUDIT: 4 (todos aprovados)

---

### 5.8 Outros Documentos (1,502)

| Tipo | Count | Descrição |
|------|-------|-----------|
| README.md | ~50 | Project READMEs |
| CHANGELOG.md | ~20 | Change logs |
| LICENSE | ~10 | Licenses |
| .gitignore | ~20 | Git ignores |
| Config files | ~100 | JSON, YAML, XML configs |
| Código/documentação | ~1,300 | TypeScript, JavaScript, etc. |

---

## 6. Documentos Órfãos

### 6.1 Definição

Documento órfão = documento que não é referenciado por nenhum outro documento canônico.

### 6.2 Metodologia de Detecção

```bash
# Listar todos os documentos canônicos
Get-ChildItem -Recurse -Filter "MD-*.md" | Select-Object -ExpandProperty Name

# Buscar referências em documentos principais
Select-String -Pattern "MD-001" -Path "*.md" -Recurse
```

### 6.3 Documentos Potencialmente Órfãos

| Documento | Motivo | Ação |
|-----------|--------|------|
| MDs em engineering/canonical/md/ | Não referenciados em docs/canonical/ | Adicionar referência ou arquivar |
| FRONT-* em docs/canonical/FRONT/ | Alguns não referenciados | Adicionar referência ou arquivar |
| MAPs antigos | Substituídos por MAP-001 | Marcar como OBSOL |

---

## 7. Documentos Duplicados

### 7.1 Duplicações Identificadas

| Documento A | Documento B | Similaridade | Ação |
|-------------|-------------|--------------|------|
| MODEL-PHYSICAL-KERNEL.md | docs/database/tables/*.md | Alta | Consolidar em MODEL-PHYSICAL-KERNEL |
| SP-KERNEL-CATALOG.md | AUDIT-SP-CATALOG.md | Alta | Manter ambos (catálogo vs audit) |
| GATE-MODEL-PHYSICAL.md | AUDIT-MODEL-PHYSICAL-VS-BANCO.md | Alta | Manter ambos (gate vs audit) |
| MAP-001-Enterprise-Domain-Architecture.md | MAP-002-Dominios.md | Média | Consolidar |
| docs/canonical/INDICE-DOCUMENTOS-CANONICOS.md | KNOWLEDGE-INDEX.md | Alta | Manter ambos (índice simples vs completo) |

### 7.2 Duplicações em Banco

| Tabela A | Tabela B | Similaridade | Ação |
|----------|----------|--------------|------|
| usuario_contexto | contexto | Alta | ADAPT: renomear |
| sessao_usuario | sessao | Alta | REUSE: manter sessao_usuario |
| saas_entidade | tenant | Alta | ADAPT: renomear |
| kernel_ledger | evento_geral + eventos_fluxo | Alta | MERGE: consolidar em kernel_ledger |

---

## 8. Documentos por Status

| Status | Count | Ação |
|--------|-------|------|
| CANÔNICO (aprovado) | ~200 | Manter |
| REFERÊNCIA | ~300 | Manter |
| RASCUNHO | ~400 | Revisar/atualizar |
| GERADO | ~233 | Regenerar quando necessário |
| AUDITORIA | ~50 | Manter histórico |
| HISTÓRICO | ~100 | Arquivar |
| OBSOLETO | — | Remover |

---

## 9. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Classificar todos os MDs | Aplicar categorias CONSTIT/CANON/REF/DRAFT/GEN |
| Alta | Identificar documentos órfãos | Script de detecção de órfãos |
| Alta | Resolver duplicações | Consolidar documentos duplicados |
| Média | Arquivar históricos | Mover documentos obsoletos para archive/ |
| Média | Atualizar KNOWLEDGE-INDEX | Manter índice atualizado |
| Baixa | Automatizar inventário | Script para gerar este documento |

---

## 10. Ferramentas

### 10.1 Scripts Úteis

```bash
# Contar MDs por diretório
Get-ChildItem -Recurse -Filter "MD-*.md" | Group-Object Directory | Sort-Object Count -Descending

# Buscar referências a um MD
Select-String -Pattern "MD-KERNEL-001" -Path "*.md" -Recurse

# Listar documentos sem referências
# (requer script customizado)

# Contar por tipo
Get-ChildItem -Recurse -Include "MD-*.md","BR-*.md","ADR-*.md","MAP-*.md" | Group-Object Extension | Sort-Object Count -Descending
```

---

## 11. Referências

- MD-CANONICAL-DOCUMENT-MAP
- INDICE-DOCUMENTOS-CANONICOS
- KNOWLEDGE-INDEX
- CATALOGO-DA-PLATAFORMA
- AUDIT-MODEL-PHYSICAL-VS-BANCO

---

## 12. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Inventário de documentos |

---

Documento Canônico — DOCUMENT-INVENTORY

**Este é o inventário oficial de documentos da plataforma New Wave Enterprise.**
