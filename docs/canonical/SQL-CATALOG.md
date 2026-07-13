# SQL-CATALOG

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Catálogo de scripts SQL do Kernel.
```

---

## 1. Propósito

Este documento é o **catálogo oficial de scripts SQL** do Kernel Enterprise.

Ele serve para:
- Listar todos os scripts SQL do Kernel
- Definir ordem de execução
- Definir dependências entre scripts
- Servir como referência para materialização

SQL não é criação de tabela isolada.
SQL é **materialização ordenada do modelo físico**.

---

## 2. Princípio Fundamental

```text
Nenhum SQL sem GATE aprovado.
Nenhuma tabela sem classificação REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
Nenhuma SP sem tipo definido.
Nenhuma escrita sem SP.
```

---

## 3. Ordem de Execução

### 3.1 Fases

```text
FASE 1: REUSE (objetos existentes)
  ↓
FASE 2: ADAPT (objetos adaptados)
  ↓
FASE 3: EXTEND (objetos estendidos)
  ↓
FASE 4: MERGE (objetos consolidados)
  ↓
FASE 5: PROPOSE (novos objetos)
```

### 3.2 Ordem dentro de cada fase

```text
1. Tabelas (sem FKs)
2. FKs
3. Índices
4. Views
5. Functions
6. SPs
7. Dados iniciais
```

---

## 4. Catálogo de Scripts

### 4.1 FASE 1: REUSE

| Arquivo | Objetivo | Objetos |
|---------|----------|---------|
| 001_reuse_tables.sql | Criar tabelas existentes | pessoa, usuario, tenant, sessao, contexto |
| 002_reuse_fks.sql | Criar FKs existentes | fk_usuario_pessoa, fk_sessao_usuario, etc. |
| 003_reuse_indexes.sql | Criar índices existentes | idx_usuario_pessoa, idx_sessao_usuario, etc. |
| 004_reuse_views.sql | Criar views existentes | vw_usuario_summary, vw_sessao_ativa, vw_contexto_ativo |
| 005_reuse_sps.sql | Criar SPs existentes | sp_master_login, sp_auth_contexto_get, etc. |

### 4.2 FASE 2: ADAPT

| Arquivo | Objetivo | Objetos |
|---------|----------|---------|
| 006_adapt_tables.sql | Alterar tabelas existentes | usuario, sessao, contexto, tenant |
| 007_adapt_fks.sql | Alterar FKs | Novas FKs para contexto |
| 008_adapt_indexes.sql | Criar índices adicionais | idx_sessao_estado, idx_sessao_expira_em |
| 009_adapt_views.sql | Alterar views | vw_contexto_ativo |
| 010_adapt_sps.sql | Alterar SPs | sp_auth_contexto_set, sp_sessao_contexto_set |

### 4.3 FASE 3: EXTEND

| Arquivo | Objetivo | Objetos |
|---------|----------|---------|
| 011_extend_tables.sql | Adicionar colunas | Novo id_tenant, campos de histórico |
| 012_extend_fks.sql | Adicionar FKs | Novas FKs para unidades, locais, perfis |
| 013_extend_indexes.sql | Adicionar índices | idx_tenant_status, idx_contexto_estado |

### 4.4 FASE 4: MERGE

| Arquivo | Objetivo | Objetos |
|---------|----------|---------|
| 014_merge_event_ledger.sql | Consolidar event_stream e kernel_ledger | kernel_ledger unificado |

### 4.5 FASE 5: PROPOSE

| Arquivo | Objetivo | Objetos |
|---------|----------|---------|
| 015_propose_tables_foundation.sql | Criar tabelas Foundation | identidade_tecnica, pessoa_tenant |
| 016_propose_tables_governance.sql | Criar tabelas Governance | auth_policy, auth_role, auth_permission, auth_decision |
| 017_propose_tables_runtime.sql | Criar tabelas Runtime | registry_module, registry_capability, runtime_execution |
| 018_propose_tables_integration.sql | Criar tabelas Integration | workflow_process, workflow_state, integration_registry |
| 019_propose_fks.sql | Criar FKs novas | FKs para novas tabelas |
| 020_propose_indexes.sql | Criar índices novos | Índices para novas tabelas |
| 021_propose_views.sql | Criar views novas | vw_tenant_summary, vw_auth_decision, etc. |
| 022_propose_functions.sql | Criar functions | Funções de cálculo |
| 023_propose_sps_foundation.sql | Criar SPs Foundation | sp_pessoa_get, sp_usuario_create, sp_contexto_resolve |
| 024_propose_sps_governance.sql | Criar SPs Governance | sp_auth_evaluate, sp_event_publish, sp_ledger_append |
| 025_propose_sps_runtime.sql | Criar SPs Runtime | sp_registry_capability_create, sp_runtime_execute |
| 026_propose_sps_integration.sql | Criar SPs Integration | sp_workflow_start, sp_integration_execute |
| 027_propose_data.sql | Inserir dados iniciais | Seeds |

---

## 5. Estrutura de Diretórios

```
sql/
  ├── kernel/
  │   ├── 001_reuse_tables.sql
  │   ├── 002_reuse_fks.sql
  │   ├── 003_reuse_indexes.sql
  │   ├── 004_reuse_views.sql
  │   ├── 005_reuse_sps.sql
  │   ├── 006_adapt_tables.sql
  │   ├── 007_adapt_fks.sql
  │   ├── 008_adapt_indexes.sql
  │   ├── 009_adapt_views.sql
  │   ├── 010_adapt_sps.sql
  │   ├── 011_extend_tables.sql
  │   ├── 012_extend_fks.sql
  │   ├── 013_extend_indexes.sql
  │   ├── 014_merge_event_ledger.sql
  │   ├── 015_propose_tables_foundation.sql
  │   ├── 016_propose_tables_governance.sql
  │   ├── 017_propose_tables_runtime.sql
  │   ├── 018_propose_tables_integration.sql
  │   ├── 019_propose_fks.sql
  │   ├── 020_propose_indexes.sql
  │   ├── 021_propose_views.sql
  │   ├── 022_propose_functions.sql
  │   ├── 023_propose_sps_foundation.sql
  │   ├── 024_propose_sps_governance.sql
  │   ├── 025_propose_sps_runtime.sql
  │   ├── 026_propose_sps_integration.sql
  │   └── 027_propose_data.sql
  ├── migrations/
  │   └── [migrations versionadas]
  └── README.md
```

---

## 6. Padrões de SQL

### 6.1 Tabelas

```sql
CREATE TABLE IF NOT EXISTS {tabela} (
  {colunas}
);

ALTER TABLE {tabela}
  ADD COLUMN IF NOT EXISTS {coluna} {tipo};
```

### 6.2 FKs

```sql
ALTER TABLE {tabela}
  ADD CONSTRAINT {fk_nome}
  FOREIGN KEY ({coluna})
  REFERENCES {tabela_pai}({coluna_pai})
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
```

### 6.3 Índices

```sql
CREATE INDEX idx_{tabela}_{coluna}
  ON {tabela}({coluna});
```

### 6.4 Views

```sql
CREATE OR REPLACE VIEW {view} AS
{query};
```

### 6.5 SPs

```sql
DELIMITER $$

CREATE PROCEDURE sp_{tipo}_{acao}_{entidade}(
  IN p_id_tenant BIGINT,
  IN p_id_usuario BIGINT,
  ...
)
BEGIN
  -- Validações
  -- Lógica
  -- Retorno
END$$

DELIMITER ;
```

---

## 7. Regras de Governança

### 7.1 Criação de script

```text
Novo script SQL:
1. Verificar fase correta (REUSE/ADAPT/EXTEND/MERGE/PROPOSE)
2. Verificar ordem correta (tabelas → FKs → índices → views → SPs)
3. Documentar no SQL-CATALOG.md
4. Aprovar
5. Executar
```

### 7.2 Execução

```text
Executar SQL:
1. Ordem: FASE 1 → FASE 2 → FASE 3 → FASE 4 → FASE 5
2. Dentro de cada fase: ordem numérica
3. Verificar dependências antes de executar
4. Testar em homologação antes de produção
5. Backup antes de executar em produção
```

### 7.3 Rollback

```text
Cada script deve ter:
- Script de rollback correspondente
- Ordem de rollback inversa
- Validação pós-rollback
```

---

## 8. Integração com GATEs

### 8.1 GATE-MODEL-PHYSICAL

```text
GATE-MODEL-PHYSICAL aprova:
- Tabelas REUSE/ADAPT/EXTEND/MERGE/PROPOSE
- SPs REUSE/ADAPT/EXTEND/MERGE/PROPOSE
- Views REUSE/ADAPT/EXTEND/MERGE/PROPOSE

Somente após aprovação:
- Gerar SQL
- Executar SQL
```

### 8.2 GATE-SQL

```text
GATE-SQL aprova:
- Scripts SQL gerados
- Ordem de execução
- Rollback planejado

Somente após aprovação:
- Executar em homologação
- Executar em produção
```

---

## 9. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | API-CATALOG.md | Catálogo de APIs |
| Média | GATE-SQL.md | GATE de aprovação de SQL |
| Baixa | SQL-MIGRATIONS.md | Estratégia de migrations |

---

## 10. Referências

- MODEL-PHYSICAL-KERNEL
- MODEL-LOGICAL-KERNEL
- MAP-DATA-CANONICAL
- SP-KERNEL-CATALOG
- GATE-MODEL-PHYSICAL
- ADR-CATALOG
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- 000-CONSTITUICAO-IA.md

---

## 11. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do catálogo de SQL |

---

Documento Canônico — SQL-CATALOG

**Este é o catálogo oficial de scripts SQL do Kernel da plataforma New Wave Enterprise.**
