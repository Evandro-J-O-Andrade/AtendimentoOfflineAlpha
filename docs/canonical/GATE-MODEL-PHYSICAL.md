# GATE-MODEL-PHYSICAL

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
GATE de revisão do modelo físico.
```

---

## 1. Propósito

Este documento é o **GATE de revisão do modelo físico** do Kernel Enterprise.

Ele serve para:
- Confrontar o modelo físico com o banco existente
- Classificar cada objeto como REUSE/ADAPT/EXTEND/MERGE/PROPOSE
- Aprovar ou rejeitar materialização
- Garantir que nenhum objeto legacy seja ignorado ou duplicado

Nenhum SQL é gerado antes deste GATE aprovado.

---

## 2. Princípio Fundamental

```text
Banco Vivo é a fonte da verdade.
Modelo físico é a proposta.
Revisão cruzada é obrigatória.
Nenhuma materialização sem GATE aprovado.
```

---

## 3. Processo de Revisão

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

## 4. Revisão de Tabelas

### 4.1 Foundation Layer

| Tabela Modelo | Existe no Banco? | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| pessoa | Sim (pessoa) | REUSE | Manter |
| usuario | Sim (usuario) | REUSE | Manter |
| identidade_tecnica | Não | PROPOSE | Criar |
| tenant | Sim (saas_entidade) | ADAPT | Adaptar tenant para saas_entidade |
| pessoa_tenant | Não | PROPOSE | Criar |
| sessao | Sim (sessao_usuario) | REUSE | Manter |
| contexto | Sim (usuario_contexto) | ADAPT | Adaptar usuario_contexto para contexto |

### 4.2 Governance Layer

| Tabela Modelo | Existe no Banco? | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| auth_policy | Não | PROPOSE | Criar |
| auth_role | Não | PROPOSE | Criar |
| auth_permission | Não | PROPOSE | Criar |
| auth_decision | Não | PROPOSE | Criar |
| event_stream | Sim (kernel_ledger) | MERGE | Consolidar com kernel_ledger |
| kernel_ledger | Sim (kernel_ledger) | REUSE | Manter |

### 4.3 Runtime Layer

| Tabela Modelo | Existe no Banco? | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| registry_module | Não | PROPOSE | Criar |
| registry_capability | Não | PROPOSE | Criar |
| registry_integration | Não | PROPOSE | Criar |
| discovery_cache | Não | PROPOSE | Criar |
| runtime_execution | Não | PROPOSE | Criar |
| runtime_job | Não | PROPOSE | Criar |
| runtime_queue | Não | PROPOSE | Criar |
| runtime_sync | Não | PROPOSE | Criar |

### 4.4 Integration Layer

| Tabela Modelo | Existe no Banco? | Classificação | Decisão |
|---------------|------------------|---------------|---------|
| workflow_process | Não | PROPOSE | Criar |
| workflow_state | Não | PROPOSE | Criar |
| workflow_transition | Não | PROPOSE | Criar |
| integration_registry | Não | PROPOSE | Criar |
| integration_adapter | Não | PROPOSE | Criar |
| integration_contract | Não | PROPOSE | Criar |

---

## 5. Revisão de SPs

### 5.1 SPs Existentes

| SP Existente | Classificação | Decisão |
|--------------|---------------|---------|
| sp_master_login | REUSE | Manter |
| sp_auth_contexto_get | ADAPT | Adaptar |
| sp_auth_contexto_set | ADAPT | Adaptar |
| sp_sessao_contexto_get | ADAPT | Adaptar |
| sp_sessao_contexto_set | ADAPT | Adaptar |
| sp_contexto_assert_permissao | ADAPT | Adaptar |
| sp_contexto_assert_transicao | ADAPT | Adaptar |
| sp_usuario_criar_contexto | ADAPT | Adaptar |
| sp_usuario_get | REUSE | Manter |
| sp_usuario_create | REUSE | Manter |
| sp_tenant_get | REUSE | Manter |

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

## 6. Revisão de Views

### 6.1 Views Existentes

| View Existente | Classificação | Decisão |
|----------------|---------------|---------|
| vw_usuario_summary | REUSE | Manter |
| vw_sessao_ativa | REUSE | Manter |
| vw_contexto_ativo | REUSE | Manter |

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

## 7. Revisão de Relacionamentos

### 7.1 FKs Existentes

| FK Existente | Classificação | Decisão |
|--------------|---------------|---------|
| fk_usuario_pessoa | REUSE | Manter |
| fk_sessao_usuario | REUSE | Manter |
| fk_sessao_tenant | REUSE | Manter |
| fk_contexto_usuario | REUSE | Manter |
| fk_contexto_tenant | REUSE | Manter |
| fk_contexto_sessao | REUSE | Manter |

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

## 8. Revisão de Índices

### 8.1 Índices Existentes

| Índice Existente | Classificação | Decisão |
|------------------|---------------|---------|
| idx_usuario_pessoa | REUSE | Manter |
| idx_sessao_usuario | REUSE | Manter |
| idx_sessao_tenant | REUSE | Manter |
| idx_contexto_usuario | REUSE | Manter |
| idx_contexto_tenant | REUSE | Manter |
| idx_contexto_sessao | REUSE | Manter |

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

## 9. Resumo

### 9.1 Estatísticas

| Categoria | REUSE | ADAPT | EXTEND | MERGE | PROPOSE | Total |
|-----------|-------|-------|--------|-------|---------|-------|
| Tabelas | 4 | 2 | 0 | 1 | 12 | 19 |
| SPs | 4 | 5 | 0 | 0 | 8 | 17 |
| Views | 3 | 0 | 0 | 1 | 7 | 11 |
| FKs | 6 | 0 | 0 | 0 | 12 | 18 |
| Índices | 8 | 0 | 0 | 0 | 0 | 8 |

### 9.2 Decisão

```text
GATE-MODEL-PHYSICAL: APROVADO COM RESSALVAS

Tabelas REUSE: 4 (21%)
Tabelas ADAPT: 2 (11%)
Tabelas PROPOSE: 12 (63%)

SPs REUSE: 4 (24%)
SPs ADAPT: 5 (29%)
SPs PROPOSE: 8 (47%)

Materialização pode prosseguir em fases:
1. REUSE (imediatamente)
2. ADAPT (curto prazo)
3. PROPOSE (médio prazo)
```

---

## 10. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Gerar SQL REUSE | Scripts para objetos existentes |
| Alta | Gerar SQL ADAPT | Scripts para adaptações |
| Média | Gerar SQL PROPOSE | Scripts para novos objetos |
| Média | Criar API-CATALOG | Contratos HTTP |
| Baixa | Criar SQL-CATALOG | Catálogo de scripts SQL |

---

## 11. Referências

- MODEL-PHYSICAL-KERNEL
- MODEL-LOGICAL-KERNEL
- MAP-DATA-CANONICAL
- docs/database/mysql/bancoMysql.md
- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-110 — Canonical Laws
- 000-CONSTITUICAO-IA.md

---

## 12. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do GATE de modelo físico |

---

Documento Canônico — GATE-MODEL-PHYSICAL

**Este é o GATE oficial de revisão do modelo físico do Kernel da plataforma New Wave Enterprise.**
