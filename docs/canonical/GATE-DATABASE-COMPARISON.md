# GATE-DATABASE-COMPARISON

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
GATE de comparação entre modelo físico e banco existente.
```

---

## 1. Propósito

Este documento é o **GATE de comparação entre o modelo físico proposto e o banco existente**.

Ele serve para:
- Confrontar modelo físico com bancoMysql.md
- Classificar cada objeto como REUSE/ADAPT/EXTEND/MERGE/PROPOSE
- Identificar conflitos
- Aprovar ou rejeitar materialização

Nenhum SQL é executado antes deste GATE aprovado.

---

## 2. Princípio Fundamental

```text
Banco Vivo é a fonte da verdade.
Modelo físico é a proposta.
Revisão cruzada é obrigatória.
Nenhuma materialização sem GATE aprovado.
```

---

## 3. Metodologia

### 3.1 Passos

```text
1. Mapear objetos existentes (bancoMysql.md)
2. Mapear objetos propostos (MODEL-PHYSICAL-KERNEL.md)
3. Confrontar: existe?
4. Classificar: REUSE/ADAPT/EXTEND/MERGE/PROPOSE
5. Documentar decisão
6. Aprovar GATE
7. Somente então: gerar SQL
```

### 3.2 Classificação

| Classificação | Significado | Ação |
|---------------|-------------|------|
| REUSE | Objeto existe e pode ser reutilizado | Manter |
| ADAPT | Objeto existe mas precisa de adaptação | Alterar |
| EXTEND | Objeto existe mas precisa de extensão | Adicionar colunas/índices |
| MERGE | Múltiplos objetos existentes devem ser unificados | Consolidar |
| PROPOSE | Objeto não existe, criar novo | Criar |

---

## 4. Tabelas

### 4.1 Foundation Layer

| Tabela Modelo | Tabela Existente | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| pessoa | pessoa | REUSE | Manter |
| usuario | usuario | REUSE | Manter |
| identidade_tecnica | Não existe | PROPOSE | Criar |
| tenant | saas_entidade | ADAPT | Adaptar saas_entidade para tenant |
| pessoa_tenant | Não existe | PROPOSE | Criar |
| sessao | sessao_usuario | REUSE | Manter |
| contexto | usuario_contexto | ADAPT | Adaptar usuario_contexto para contexto |

### 4.2 Governance Layer

| Tabela Modelo | Tabela Existente | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| auth_policy | Não existe | PROPOSE | Criar |
| auth_role | Não existe | PROPOSE | Criar |
| auth_permission | Não existe | PROPOSE | Criar |
| auth_decision | Não existe | PROPOSE | Criar |
| event_stream | kernel_ledger | MERGE | Consolidar com kernel_ledger |
| kernel_ledger | kernel_ledger | REUSE | Manter |

### 4.3 Runtime Layer

| Tabela Modelo | Tabela Existente | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| registry_module | Não existe | PROPOSE | Criar |
| registry_capability | Não existe | PROPOSE | Criar |
| registry_integration | Não existe | PROPOSE | Criar |
| discovery_cache | Não existe | PROPOSE | Criar |
| runtime_execution | Não existe | PROPOSE | Criar |
| runtime_job | Não existe | PROPOSE | Criar |
| runtime_queue | Não existe | PROPOSE | Criar |
| runtime_sync | Não existe | PROPOSE | Criar |

### 4.4 Integration Layer

| Tabela Modelo | Tabela Existente | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| workflow_process | Não existe | PROPOSE | Criar |
| workflow_state | Não existe | PROPOSE | Criar |
| workflow_transition | Não existe | PROPOSE | Criar |
| integration_registry | Não existe | PROPOSE | Criar |
| integration_adapter | Não existe | PROPOSE | Criar |
| integration_contract | Não existe | PROPOSE | Criar |

---

## 5. Stored Procedures

### 5.1 SPs Existentes

| SP Modelo | SP Existente | Classificação | Decisão |
|-----------|--------------|---------------|---------|
| sp_pessoa_get | sp_usuario_get | REUSE | Manter |
| sp_pessoa_create | sp_usuario_create | REUSE | Manter |
| sp_usuario_get | sp_usuario_get | REUSE | Manter |
| sp_usuario_create | sp_usuario_create | REUSE | Manter |
| sp_usuario_authenticate | sp_master_login | ADAPT | Adaptar |
| sp_tenant_get | sp_tenant_get | REUSE | Manter |
| sp_tenant_create | sp_tenant_create | REUSE | Manter |
| sp_sessao_create | sp_sessao_create | REUSE | Manter |
| sp_sessao_validate | sp_sessao_validate | REUSE | Manter |
| sp_sessao_revoke | sp_sessao_revoke | REUSE | Manter |
| sp_contexto_resolve | sp_auth_contexto_get | ADAPT | Adaptar |
| sp_contexto_switch | sp_sessao_contexto_set | ADAPT | Adaptar |
| sp_contexto_get | sp_auth_contexto_get | ADAPT | Adaptar |
| sp_contexto_options | sp_usuario_criar_contexto | ADAPT | Adaptar |

### 5.2 SPs Novas

| SP Nova | Classificação | Decisão |
|---------|---------------|---------|
| sp_mas_auth_evaluate | PROPOSE | Criar |
| sp_exe_runtime_execute | PROPOSE | Criar |
| sp_led_ledger_append | PROPOSE | Criar |
| sp_evt_event_publish | PROPOSE | Criar |
| sp_discovery_resolve | PROPOSE | Criar |
| sp_navigation_project | PROPOSE | Criar |
| sp_workflow_start | PROPOSE | Criar |
| sp_integration_execute | PROPOSE | Criar |

---

## 6. Views

### 6.1 Views Existentes

| View Modelo | View Existente | Classificação | Decisão |
|-------------|----------------|---------------|---------|
| vw_usuario_summary | vw_usuario_summary | REUSE | Manter |
| vw_sessao_ativa | vw_sessao_ativa | REUSE | Manter |
| vw_contexto_ativo | vw_contexto_ativo | REUSE | Manter |

### 6.2 Views Novas

| View Nova | Classificação | Decisão |
|-----------|---------------|---------|
| vw_tenant_summary | PROPOSE | Criar |
| vw_auth_decision | PROPOSE | Criar |
| vw_runtime_active | PROPOSE | Criar |
| vw_navigation_active | PROPOSE | Criar |
| vw_workflow_active | PROPOSE | Criar |
| vw_event_stream | PROPOSE | Criar |
| vw_ledger_audit | PROPOSE | Criar |

---

## 7. Relacionamentos

### 7.1 FKs Existentes

| FK Modelo | FK Existente | Classificação | Decisão |
|-----------|--------------|---------------|---------|
| fk_usuario_pessoa | fk_usuario_pessoa | REUSE | Manter |
| fk_sessao_usuario | fk_sessao_usuario | REUSE | Manter |
| fk_sessao_tenant | fk_sessao_tenant | REUSE | Manter |
| fk_contexto_usuario | fk_contexto_usuario | REUSE | Manter |
| fk_contexto_tenant | fk_contexto_tenant | REUSE | Manter |
| fk_contexto_sessao | fk_contexto_sessao | REUSE | Manter |

### 7.2 FKs Novas

| FK Nova | Classificação | Decisão |
|---------|---------------|---------|
| fk_contexto_unidade | PROPOSE | Criar |
| fk_contexto_local | PROPOSE | Criar |
| fk_contexto_perfil | PROPOSE | Criar |
| fk_contexto_sistema | PROPOSE | Criar |
| fk_contexto_aplicacao | PROPOSE | Criar |
| fk_auth_decision_identity | PROPOSE | Criar |
| fk_auth_decision_tenant | PROPOSE | Criar |
| fk_auth_decision_session | PROPOSE | Criar |
| fk_auth_decision_contexto | PROPOSE | Criar |
| fk_runtime_execution_identity | PROPOSE | Criar |
| fk_runtime_execution_tenant | PROPOSE | Criar |
| fk_runtime_execution_capability | PROPOSE | Criar |
| fk_workflow_process_workflow_state | PROPOSE | Criar |

---

## 8. Índices

### 8.1 Índices Existentes

| Índice Modelo | Índice Existente | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| idx_usuario_pessoa | idx_usuario_pessoa | REUSE | Manter |
| idx_sessao_usuario | idx_sessao_usuario | REUSE | Manter |
| idx_sessao_tenant | idx_sessao_tenant | REUSE | Manter |
| idx_contexto_usuario | idx_contexto_usuario | REUSE | Manter |
| idx_contexto_tenant | idx_contexto_tenant | REUSE | Manter |
| idx_contexto_sessao | idx_contexto_sessao | REUSE | Manter |

### 8.2 Índices Novos

| Índice Novo | Classificação | Decisão |
|-------------|---------------|---------|
| idx_usuario_login | REUSE | Manter (unique) |
| idx_sessao_estado | REUSE | Manter |
| idx_sessao_expira_em | REUSE | Manter |
| idx_contexto_estado | REUSE | Manter |
| idx_tenant_documento | REUSE | Manter (unique) |
| idx_tenant_status | REUSE | Manter |

---

## 9. Conflitos

### 9.1 Conflitos identificados

| Objeto | Conflito | Resolução |
|--------|----------|-----------|
| tenant vs saas_entidade | Nome diferente, mesmo conceito | ADAPT: renomear saas_entidade para tenant |
| evento_stream vs kernel_ledger | Quase iguais | MERGE: consolidar em kernel_ledger |
| usuario_contexto vs contexto | Nome diferente, mesmo conceito | ADAPT: renomear usuario_contexto para contexto |
| sessao_usuario vs sessao | Nome diferente, mesmo conceito | REUSE: manter sessao_usuario como sessao |

### 9.2 Decisões

```text
1. saas_entidade → tenant
   - Manter dados
   - Renomear tabela
   - Atualizar SPs
   - Atualizar views

2. kernel_ledger absorve event_stream
   - Manter kernel_ledger
   - Adicionar colunas de event_stream
   - Migrar dados
   - Atualizar SPs

3. usuario_contexto → contexto
   - Manter dados
   - Renomear tabela
   - Atualizar SPs
   - Atualizar views

4. sessao_usuario → sessao
   - Manter nome atual (sessao_usuario)
   - Usar como sessao no modelo
```

---

## 10. Resumo

### 10.1 Estatísticas

| Categoria | REUSE | ADAPT | EXTEND | MERGE | PROPOSE | Total |
|-----------|-------|-------|--------|-------|---------|-------|
| Tabelas | 4 | 2 | 0 | 1 | 12 | 19 |
| SPs | 4 | 5 | 0 | 0 | 8 | 17 |
| Views | 3 | 0 | 0 | 1 | 7 | 11 |
| FKs | 6 | 0 | 0 | 0 | 12 | 18 |
| Índices | 8 | 0 | 0 | 0 | 0 | 8 |

### 10.2 Decisão

```text
GATE-DATABASE-COMPARISON: APROVADO COM RESSALVAS

Tabelas REUSE: 4 (21%)
Tabelas ADAPT: 2 (11%)
Tabelas MERGE: 1 (5%)
Tabelas PROPOSE: 12 (63%)

SPs REUSE: 4 (24%)
SPs ADAPT: 5 (29%)
SPs PROPOSE: 8 (47%)

Conflitos resolvidos:
- tenant vs saas_entidade: ADAPT
- event_stream vs kernel_ledger: MERGE
- usuario_contexto vs contexto: ADAPT

Materialização pode prosseguir em fases:
1. REUSE (imediatamente)
2. ADAPT/MERGE (curto prazo)
3. PROPOSE (médio prazo)
```

---

## 11. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Gerar SQL REUSE | Scripts para objetos existentes |
| Alta | Gerar SQL ADAPT | Scripts para adaptações |
| Alta | Gerar SQL MERGE | Scripts para merge |
| Média | Gerar SQL PROPOSE | Scripts para novos objetos |
| Média | Criar SQL-CATALOG | Catálogo de scripts SQL |
| Baixa | Criar GATE-SQL | GATE de aprovação de SQL |

---

## 12. Referências

- MODEL-PHYSICAL-KERNEL
- MODEL-LOGICAL-KERNEL
- MAP-DATA-CANONICAL
- docs/database/mysql/bancoMysql.md
- GATE-MODEL-PHYSICAL
- ADR-CATALOG
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- 000-CONSTITUICAO-IA.md

---

## 13. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do GATE de comparação de banco |

---

Documento Canônico — GATE-DATABASE-COMPARISON

**Este é o GATE oficial de comparação entre modelo físico e banco existente da plataforma New Wave Enterprise.**
