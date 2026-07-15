# TABLE-INDEX

## Status

```text
GOVERNAÇA (ENGENHARIA)
CICLO 2 — Kernel Enterprise
Índice mestre de tabelas do banco de dados.
```

---

## 1. Propósito

Este documento é o **índice mestre de tabelas** da plataforma New Wave Enterprise.

Ele serve para:
- Localizar rapidamente qualquer tabela
- Entender owner, categoria e domínio
- Rastrear materialização (MD, SQL, SP, Backend, Frontend)
- Visualizar relacionamentos (PK, FK)
- Controlar cobertura

Fonte: Dump20260618.sql (479 tabelas) + CATALOGO_ENTIDADES_CORE.md + AUDIT-MODEL-PHYSICAL-VS-BANCO.md.

---

## 2. Estrutura do Índice

```text
Tabela
├── Categoria
├── Owner
├── PK
├── FKs (entrada/saída)
├── Índices
├── UNIQUE
├── Materializada (MD/SQL/SP/Backend/Frontend)
├── BRs
└── Status
```

---

## 3. Tabelas por Categoria

### 3.1 Foundation Layer

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| pessoa | Foundation | Kernel | id_pessoa | 0 | 15 | MD+SQL+SP | REUSE |
| usuario | Foundation | Kernel | id_usuario | 1 (pessoa) | 99 | MD+SQL+SP | REUSE |
| identidade_tecnica | Foundation | Kernel | id_identidade | 1 (pessoa) | 0 | MD+SQL+SP | PROPOSE |
| saas_entidade | Foundation | Kernel | id_entidade | 0 | 80 | MD+SQL+SP | ADAPT→tenant |
| tenant_registry | Foundation | Kernel | id_tenant | 0 | 0 | MD+SQL+SP | REUSE |
| saas_contrato | Foundation | Kernel | id_contrato | 1 (saas_entidade) | 0 | MD+SQL+SP | REUSE |
| pessoa_tenant | Foundation | Kernel | id_pessoa_tenant | 2 (pessoa, tenant) | 0 | MD+SQL+SP | PROPOSE |
| sessao_usuario | Foundation | Kernel | id_sessao_usuario | 2 (usuario, tenant) | 13 | MD+SQL+SP | REUSE |
| usuario_contexto | Foundation | Kernel | id_contexto | 4 (usuario, tenant, sessao) | 0 | MD+SQL+SP | ADAPT→contexto |
| login_tentativa | Foundation | Kernel | id_tentativa | 1 (usuario) | 0 | MD+SQL+SP | REUSE |

### 3.2 Governance Layer

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| kernel_authz_policy | Governance | Kernel | id_policy | 0 | 0 | MD+SQL+SP | ADAPT→auth_policy |
| auth_role | Governance | Kernel | id_role | 1 (auth_policy) | 0 | MD+SQL+SP | PROPOSE |
| auth_permission | Governance | Kernel | id_permission | 1 (auth_role) | 0 | MD+SQL+SP | ADAPT (de permissao) |
| auth_decision | Governance | Kernel | id_decision | 4 (identity, tenant, session, contexto) | 0 | MD+SQL+SP | PROPOSE |
| kernel_ledger | Governance | Kernel | id_ledger | 0 | 0 | MD+SQL+SP | REUSE |
| evento_geral | Governance | Kernel | id_evento | 0 | 0 | MD+SQL+SP | MERGE→kernel_ledger |
| eventos_fluxo | Governance | Kernel | id_evento | 0 | 0 | MD+SQL+SP | MERGE→kernel_ledger |

### 3.3 Runtime Layer

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| registry_module | Runtime | Kernel | id_module | 0 | 1 (capability) | MD+SQL+SP | PROPOSE |
| registry_capability | Runtime | Kernel | id_capability | 1 (module) | 1 (execution) | MD+SQL+SP | PROPOSE |
| runtime_execution_queue | Runtime | Kernel | id_queue | 0 | 0 | MD+SQL+SP | EXTEND→runtime_execution |
| runtime_sync_queue | Runtime | Kernel | id_sync | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_sync_log | Runtime | Kernel | id_log | 1 (sync) | 0 | MD+SQL+SP | REUSE |
| runtime_concurrency_guard | Runtime | Kernel | id_guard | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_lock_semantico | Runtime | Kernel | id_lock | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_kernel_locks | Runtime | Kernel | id_lock | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_snapshot_governanca | Runtime | Kernel | id_snapshot | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_snapshot_metadata | Runtime | Kernel | id_snapshot | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_estado_sobrevivencia | Runtime | Kernel | id_estado | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_evento_provisional | Runtime | Kernel | id_evento | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_invariant_log | Runtime | Kernel | id_log | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_edge_evento | Runtime | Kernel | id_evento | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_api_session_token | Runtime | Kernel | id_token | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_contexto | Runtime | Kernel | id_contexto | 0 | 0 | MD+SQL+SP | REUSE |
| runtime_dispositivo | Runtime | Kernel | id_dispositivo | 0 | 0 | MD+SQL+SP | REUSE |
| kernel_runtime_evento | Runtime | Kernel | id_evento | 0 | 0 | MD+SQL+SP | REUSE |
| kernel_runtime_heartbeat | Runtime | Kernel | id_heartbeat | 0 | 0 | MD+SQL+SP | REUSE |
| kernel_runtime_single_writer_lock | Runtime | Kernel | id_lock | 0 | 0 | MD+SQL+SP | REUSE |
| kernel_single_writer_lock | Runtime | Kernel | id_lock | 0 | 0 | MD+SQL+SP | REUSE |
| kernel_identity_trust_chain | Runtime | Kernel | id_chain | 0 | 0 | MD+SQL+SP | REUSE |

### 3.4 Integration Layer

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| workflow_process | Integration | Kernel | id_process | 1 (workflow_state) | 0 | MD+SQL+SP | PROPOSE |
| workflow_state | Integration | Kernel | id_state | 0 | 2 (transitions) | MD+SQL+SP | PROPOSE |
| workflow_transition | Integration | Kernel | id_transition | 2 (state_origem, state_destino) | 0 | MD+SQL+SP | ADAPT (de fluxo_transicao) |
| integration_registry | Integration | Kernel | id_integration | 0 | 1 (adapter) | MD+SQL+SP | ADAPT (de integracao) |
| integration_adapter | Integration | Kernel | id_adapter | 1 (integration) | 1 (contract) | MD+SQL+SP | PROPOSE |
| integration_contract | Integration | Kernel | id_contract | 1 (adapter) | 0 | MD+SQL+SP | PROPOSE |
| integracao | Integration | Kernel | id_integracao | 0 | 0 | MD+SQL+SP | ADAPT→integration_registry |
| fluxo_transicao | Integration | Kernel | id_transicao | 2 (state) | 0 | MD+SQL+SP | ADAPT→workflow_transition |
| fluxo_transicao_matriz | Integration | Kernel | id_matriz | 0 | 0 | MD+SQL+SP | ADAPT→workflow_transition |

### 3.5 Portal / Display

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| painel | Portal | Display | id_painel | 0 | 9 | MD+SQL+SP | REUSE |
| painel_config | Portal | Display | id_config | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| painel_config_def | Portal | Display | id_def | 0 | 0 | MD+SQL+SP | REUSE |
| painel_evento_stream | Portal | Display | id_evento | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| painel_fila_tipo | Portal | Display | id_tipo | 0 | 0 | MD+SQL+SP | REUSE |
| painel_grupo | Portal | Display | id_grupo | 0 | 0 | MD+SQL+SP | REUSE |
| painel_grupo_local | Portal | Display | id_grupo_local | 2 (grupo, local) | 0 | MD+SQL+SP | REUSE |
| painel_lane | Portal | Display | id_lane | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| painel_local | Portal | Display | id_local | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| painel_mensagem | Portal | Display | id_mensagem | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| painel_mensagem_consumo | Portal | Display | id_consumo | 1 (mensagem) | 0 | MD+SQL+SP | REUSE |
| painel_alertas_tempo | Portal | Display | id_alerta | 0 | 0 | MD+SQL+SP | REUSE |
| painel_consumo_evento | Portal | Display | id_consumo | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| painel_monitoramento_especialidade | Portal | Display | id_monitoramento | 0 | 0 | MD+SQL+SP | REUSE |
| totem | Portal | Display | id_totem | 1 (unidade) | 0 | MD+SQL+SP | REUSE |
| totem_evento | Portal | Display | id_evento | 1 (totem) | 0 | MD+SQL+SP | REUSE |
| totem_feedback | Portal | Display | id_feedback | 0 | 0 | MD+SQL+SP | REUSE |
| totem_senha_opcao | Portal | Display | id_opcao | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| tv_rotativo | Portal | Display | id_tv | 1 (painel) | 0 | MD+SQL+SP | REUSE |
| tv_rotativo_tela | Portal | Display | id_tela | 1 (tv) | 0 | MD+SQL+SP | REUSE |
| portal_categoria | Portal | Portal | id_categoria | 0 | 0 | MD+SQL+SP | REUSE |
| portal_noticia | Portal | Portal | id_noticia | 1 (categoria) | 0 | MD+SQL+SP | PROPOSE |

### 3.6 Healthcare / HIS

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| paciente | HIS | Paciente | id_paciente | 0 | 0 | MD+SQL+SP | REUSE |
| paciente_canonico | HIS | Paciente | id_paciente | 1 (paciente) | 0 | MD+SQL+SP | REUSE |
| paciente_cns | HIS | Paciente | id_cns | 1 (paciente) | 0 | MD+SQL+SP | REUSE |
| paciente_cns_evento | HIS | Paciente | id_evento | 0 | 0 | MD+SQL+SP | REUSE |
| paciente_alertas | HIS | Paciente | id_alerta | 1 (paciente) | 0 | MD+SQL+SP | REUSE |
| ffa | HIS | Atendimento | id_ffa | 0 | 59 | MD+SQL+SP | REUSE |
| ffa_estado | HIS | Atendimento | id_estado | 1 (ffa) | 0 | MD+SQL+SP | REUSE |
| ffa_historico_status | HIS | Atendimento | id_historico | 1 (ffa) | 0 | MD+SQL+SP | REUSE |
| ffa_item | HIS | Atendimento | id_item | 1 (ffa) | 0 | MD+SQL+SP | REUSE |
| atendimento | HIS | Atendimento | id_atendimento | 0 | 59 | MD+SQL+SP | REUSE |
| triagem | HIS | Atendimento | id_triagem | 1 (atendimento) | 0 | MD+SQL+SP | REUSE |
| internacao | HIS | Internação | id_internacao | 1 (atendimento) | 13 | MD+SQL+SP | REUSE |
| prescricao | HIS | Farmácia | id_prescricao | 0 | 0 | MD+SQL+SP | REUSE |
| prescricao_item | HIS | Farmácia | id_item | 1 (prescricao) | 0 | MD+SQL+SP | REUSE |
| administracao_medicacao | HIS | Enfermagem | id_admin | 2 (prescricao, usuario) | 0 | MD+SQL+SP | REUSE |
| lab_pedido | HIS | Laboratório | id_pedido | 1 (paciente) | 0 | MD+SQL+SP | REUSE |
| lab_amostra | HIS | Laboratório | id_amostra | 1 (pedido) | 0 | MD+SQL+SP | REUSE |
| lab_resultado | HIS | Laboratório | id_resultado | 1 (amostra) | 0 | MD+SQL+SP | REUSE |

### 3.7 Farmácia

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| farm_dispensacao | Farmácia | Farmácia | id_dispensacao | 0 | 0 | MD+SQL+SP | REUSE |
| farm_dispensacao_item | Farmácia | Farmácia | id_item | 1 (dispensacao) | 0 | MD+SQL+SP | REUSE |
| farm_operacao | Farmácia | Farmácia | id_operacao | 0 | 0 | MD+SQL+SP | REUSE |
| farm_convenio_autorizacao | Farmácia | Farmácia | id_autorizacao | 0 | 0 | MD+SQL+SP | REUSE |
| farm_receita_controlada | Farmácia | Farmácia | id_receita | 0 | 0 | MD+SQL+SP | REUSE |
| farmacia_dispensacao_log | Farmácia | Farmácia | id_log | 0 | 0 | MD+SQL+SP | REUSE |

### 3.8 Estoque / Logística

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| estoque_produto | Estoque | Estoque | id_produto | 0 | 0 | MD+SQL+SP | REUSE |
| estoque_item | Estoque | Estoque | id_item | 1 (produto) | 0 | MD+SQL+SP | REUSE |
| estoque_local | Estoque | Estoque | id_local | 0 | 0 | MD+SQL+SP | REUSE |
| estoque_lote | Estoque | Estoque | id_lote | 0 | 0 | MD+SQL+SP | REUSE |
| estoque_saldo | Estoque | Estoque | id_saldo | 3 (unidade, local, item) | 0 | MD+SQL+SP | REUSE |
| estoque_movimentacao | Estoque | Estoque | id_movimentacao | 0 | 0 | MD+SQL+SP | REUSE |
| estoque_movimento | Estoque | Estoque | id_movimento | 0 | 0 | MD+SQL+SP | REUSE |
| estoque_inventario | Estoque | Estoque | id_inventario | 0 | 0 | MD+SQL+SP | REUSE |
| estoque_reserva | Estoque | Estoque | id_reserva | 0 | 0 | MD+SQL+SP | REUSE |
| estoque_alerta | Estoque | Estoque | id_alerta | 0 | 0 | MD+SQL+SP | REUSE |

### 3.9 Faturamento / Financeiro

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| faturamento_conta | Financeiro | Faturamento | id_conta | 0 | 0 | MD+SQL+SP | REUSE |
| faturamento_conta_item | Financeiro | Faturamento | id_item | 1 (conta) | 0 | MD+SQL+SP | REUSE |
| faturamento_convenio | Financeiro | Faturamento | id_convenio | 0 | 0 | MD+SQL+SP | REUSE |
| faturamento_producao | Financeiro | Faturamento | id_producao | 0 | 0 | MD+SQL+SP | REUSE |
| caixa | Financeiro | Financeiro | id_caixa | 0 | 0 | MD+SQL+SP | REUSE |
| venda | Financeiro | Financeiro | id_venda | 0 | 0 | MD+SQL+SP | REUSE |
| venda_item | Financeiro | Financeiro | id_item | 1 (venda) | 0 | MD+SQL+SP | REUSE |
| forma_pagamento | Financeiro | Financeiro | id_forma | 0 | 0 | MD+SQL+SP | REUSE |

### 3.10 Auditoria / Event Store

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| auditoria_evento | Auditoria | Auditoria | id_auditoria | 0 | 0 | MD+SQL+SP | REUSE |
| auditoria_acesso | Auditoria | Auditoria | id_acesso | 1 (usuario) | 0 | MD+SQL+SP | REUSE |
| auditoria_ffa | Auditoria | Auditoria | id_auditoria | 1 (ffa) | 0 | MD+SQL+SP | REUSE |
| auditoria_fila | Auditoria | Auditoria | id_auditoria | 1 (fila) | 0 | MD+SQL+SP | REUSE |
| auditoria_estoque | Auditoria | Auditoria | id_auditoria | 0 | 0 | MD+SQL+SP | REUSE |
| log_auditoria | Auditoria | Auditoria | id_log | 0 | 0 | MD+SQL+SP | REUSE |
| log_acesso_prontuario | Auditoria | Auditoria | id_log | 1 (usuario) | 0 | MD+SQL+SP | REUSE |
| atendimento_evento | Auditoria | Atendimento | id_evento | 1 (atendimento) | 0 | MD+SQL+SP | REUSE |
| ffa_evento | Auditoria | Atendimento | id_evento | 1 (ffa) | 0 | MD+SQL+SP | REUSE |
| eventos_fluxo | Auditoria | Kernel | id_evento | 0 | 0 | MD+SQL+SP | MERGE→kernel_ledger |

### 3.11 Integração

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| integracao | Integração | Integração | id_integracao | 0 | 0 | MD+SQL+SP | ADAPT→integration_registry |
| integracao_credencial | Integração | Integração | id_credencial | 1 (integracao) | 0 | MD+SQL+SP | REUSE |
| webhook_entrada | Integração | Integração | id_webhook | 0 | 0 | MD+SQL+SP | REUSE |
| webhook_saida | Integração | Integração | id_webhook | 0 | 0 | MD+SQL+SP | REUSE |
| integracao_mensageria_externa | Integração | Integração | id_mensageria | 0 | 0 | MD+SQL+SP | REUSE |

### 3.12 RH / Administrativo

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| funcionario | RH | RH | id_funcionario | 1 (pessoa) | 7 | MD+SQL+SP | REUSE |
| funcionario_unidade | RH | RH | id_unidade | 2 (funcionario, unidade) | 0 | MD+SQL+SP | REUSE |
| funcionario_especialidade | RH | RH | id_especialidade | 2 (funcionario, especialidade) | 0 | MD+SQL+SP | REUSE |
| funcionario_conselho_profissional | RH | RH | id_conselho | 1 (funcionario) | 0 | MD+SQL+SP | REUSE |
| escala_medica | RH | RH | id_escala | 0 | 0 | MD+SQL+SP | REUSE |
| escala_plantao | RH | RH | id_escala | 0 | 0 | MD+SQL+SP | REUSE |
| escala_plantao_atual | RH | RH | id_escala_atual | 0 | 0 | MD+SQL+SP | REUSE |
| escala_profissional | RH | RH | id_profissional | 2 (funcionario, escala) | 0 | MD+SQL+SP | REUSE |
| plantao | RH | RH | id_plantao | 0 | 0 | MD+SQL+SP | REUSE |
| plantao_escala | RH | RH | id_escala | 0 | 0 | MD+SQL+SP | REUSE |
| plantao_modelo | RH | RH | id_modelo | 0 | 0 | MD+SQL+SP | REUSE |
| chamado | RH | RH | id_chamado | 0 | 0 | MD+SQL+SP | REUSE |
| chamado_evento | RH | RH | id_evento | 1 (chamado) | 0 | MD+SQL+SP | REUSE |
| chamado_manutencao | RH | RH | id_manutencao | 1 (chamado) | 0 | MD+SQL+SP | REUSE |
| manutencao_execucao | RH | RH | id_execucao | 1 (manutencao) | 0 | MD+SQL+SP | REUSE |

### 3.13 CRM / SAC

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| cliente | CRM | CRM | id_cliente | 0 | 0 | MD+SQL+SP | REUSE |
| contrato | CRM | CRM | id_contrato | 1 (cliente) | 0 | MD+SQL+SP | REUSE |
| cat_evento | CRM | CRM | id_evento | 0 | 0 | MD+SQL+SP | REUSE |
| cat_notificacao | CRM | CRM | id_notificacao | 0 | 0 | MD+SQL+SP | REUSE |
| cat_regra_item | CRM | CRM | id_regra | 0 | 0 | MD+SQL+SP | REUSE |
| cat_acidente_trabalho | CRM | CRM | id_acidente | 0 | 0 | MD+SQL+SP | REUSE |
| cat_acidente_trabalho_evento | CRM | CRM | id_evento | 1 (acidente) | 0 | MD+SQL+SP | REUSE |

### 3.14 Dados Mestre / MD

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| md_cid10 | MD | Mestrado | id_cid10 | 0 | 0 | MD+SQL+SP | REUSE |
| md_cnes_estabelecimento | MD | Mestrado | id_cnes | 0 | 0 | MD+SQL+SP | REUSE |
| md_competencia | MD | Mestrado | id_competencia | 0 | 0 | MD+SQL+SP | REUSE |
| md_sigpat_medicamento | MD | Mestrado | id_medicamento | 0 | 0 | MD+SQL+SP | REUSE |
| md_sigtap_procedimento | MD | Mestrado | id_procedimento | 0 | 0 | MD+SQL+SP | REUSE |
| md_arquivo_fonte | MD | Mestrado | id_arquivo | 0 | 0 | MD+SQL+SP | REUSE |
| tabela_tuss | MD | Mestrado | id_tuss | 0 | 0 | MD+SQL+SP | REUSE |
| codigo_universal | MD | Mestrado | id_codigo | 0 | 0 | MD+SQL+SP | REUSE |
| especialidade | MD | Mestrado | id_especialidade | 0 | 0 | MD+SQL+SP | REUSE |
| conselho_profissional | MD | Mestrado | id_conselho | 0 | 0 | MD+SQL+SP | REUSE |
| exame | MD | Mestrado | id_exame | 0 | 0 | MD+SQL+SP | REUSE |

### 3.15 Configuração

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| config_sistema | Config | Config | id_config | 0 | 0 | MD+SQL+SP | REUSE |
| configuracao | Config | Config | id_config | 0 | 0 | MD+SQL+SP | REUSE |
| config_locais | Config | Config | id_config | 1 (local) | 0 | MD+SQL+SP | REUSE |
| config_leitos | Config | Config | id_config | 1 (leito) | 0 | MD+SQL+SP | REUSE |

### 3.16 Logística / Transporte

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| viatura | Logística | Logística | id_viatura | 1 (unidade) | 0 | MD+SQL+SP | REUSE |
| remocao | Logística | Logística | id_remocao | 1 (viatura) | 0 | MD+SQL+SP | REUSE |
| remocao_evento | Logística | Logística | id_evento | 1 (remocao) | 0 | MD+SQL+SP | REUSE |
| remocao_logistica | Logística | Logística | id_logistica | 1 (remocao) | 0 | MD+SQL+SP | REUSE |
| gaso_solicitacao | Logística | Logística | id_solicitacao | 0 | 0 | MD+SQL+SP | REUSE |
| gaso_evento | Logística | Logística | id_evento | 1 (solicitacao) | 0 | MD+SQL+SP | REUSE |
| gasoterapia_consumo | Logística | Logística | id_consumo | 0 | 0 | MD+SQL+SP | REUSE |
| gasoterapia_consumo_evento | Logística | Logística | id_evento | 1 (consumo) | 0 | MD+SQL+SP | REUSE |

### 3.17 Documentos

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| documento_arquivo | Documentos | Documentos | id_arquivo | 0 | 0 | MD+SQL+SP | REUSE |
| documento_emissao | Documentos | Documentos | id_emissao | 1 (arquivo) | 0 | MD+SQL+SP | REUSE |
| documento_emissao_evento | Documentos | Documentos | id_evento | 1 (emissao) | 0 | MD+SQL+SP | REUSE |
| documento_tipo_config | Documentos | Documentos | id_config | 0 | 0 | MD+SQL+SP | REUSE |
| assinatura_digital_documentos | Documentos | Documentos | id_assinatura | 1 (documento) | 0 | MD+SQL+SP | REUSE |
| assinatura_digital_prontuario | Documentos | Documentos | id_assinatura | 1 (paciente) | 0 | MD+SQL+SP | REUSE |
| reg_anexo | Documentos | Documentos | id_anexo | 0 | 0 | MD+SQL+SP | REUSE |
| reg_export_arquivo | Documentos | Documentos | id_arquivo | 0 | 0 | MD+SQL+SP | REUSE |
| reg_export_item | Documentos | Documentos | id_item | 1 (arquivo) | 0 | MD+SQL+SP | REUSE |
| reg_export_lote | Documentos | Documentos | id_lote | 0 | 0 | MD+SQL+SP | REUSE |
| reg_export_erro_validacao | Documentos | Documentos | id_erro | 1 (lote) | 0 | MD+SQL+SP | REUSE |
| reg_formulario_snapshot | Documentos | Documentos | id_snapshot | 0 | 0 | MD+SQL+SP | REUSE |
| pep_registro | Documentos | Documentos | id_pep | 0 | 0 | MD+SQL+SP | REUSE |
| pep_assinatura_digital | Documentos | Documentos | id_assinatura | 1 (pep) | 0 | MD+SQL+SP | REUSE |

### 3.18 Agendamento

| Tabela | Categoria | Owner | PK | FKs Entrada | FKs Saída | Materializada | Status |
|--------|-----------|-------|----|-------------|-----------|---------------|--------|
| agendamento | Agendamento | Agendamento | id_agendamento | 4 (sistema, profissional, paciente, servico) | 0 | MD+SQL+SP | REUSE |
| agenda_disponibilidade | Agendamento | Agendamento | id_disponibilidade | 2 (sistema, profissional) | 0 | MD+SQL+SP | REUSE |
| agendamentos_eventos | Agendamento | Agendamento | id_evento | 1 (agendamento) | 0 | MD+SQL+SP | REUSE |
| servico_agendamento | Agendamento | Agendamento | id_servico | 0 | 0 | MD+SQL+SP | REUSE |

---

## 4. Estatísticas

| Categoria | Total | REUSE | ADAPT | EXTEND | MERGE | PROPOSE |
|-----------|-------|-------|-------|--------|-------|---------|
| Foundation | 10 | 6 | 2 | 0 | 0 | 2 |
| Governance | 7 | 1 | 2 | 0 | 1 | 3 |
| Runtime | 22 | 20 | 0 | 1 | 0 | 1 |
| Integration | 9 | 3 | 2 | 0 | 0 | 4 |
| Portal/Display | 21 | 20 | 0 | 0 | 0 | 1 |
| HIS/Healthcare | 200+ | 200+ | 0 | 0 | 0 | 0 |
| Farmácia | 6 | 6 | 0 | 0 | 0 | 0 |
| Estoque | 10+ | 10+ | 0 | 0 | 0 | 0 |
| Financeiro | 8 | 8 | 0 | 0 | 0 | 0 |
| Auditoria | 10+ | 10+ | 0 | 0 | 1 | 0 |
| Integração | 5 | 5 | 1 | 0 | 0 | 0 |
| RH/Admin | 14 | 14 | 0 | 0 | 0 | 0 |
| CRM/SAC | 7 | 7 | 0 | 0 | 0 | 0 |
| MD/Mestrado | 11 | 11 | 0 | 0 | 0 | 0 |
| Configuração | 4 | 4 | 0 | 0 | 0 | 0 |
| Logística | 8 | 8 | 0 | 0 | 0 | 0 |
| Documentos | 14 | 14 | 0 | 0 | 0 | 0 |
| Agendamento | 4 | 4 | 0 | 0 | 0 | 0 |
| **Total** | **479** | **~450** | **~6** | **~1** | **~2** | **~20** |

---

## 5. Tabelas por Owner (Domínio)

| Owner | Qtd Tabelas | Descrição |
|-------|-------------|-----------|
| Kernel | 40+ | Foundation, Governance, Runtime, Integration |
| HIS/Atendimento | 200+ | Domínio assistencial completo |
| Farmácia | 6 | Farmácia e dispensação |
| Estoque | 10+ | Estoque e movimentação |
| Financeiro | 8 | Faturamento, PDV, caixa |
| Portal/Display | 21 | Painéis, totens, TVs |
| Auditoria | 10+ | Event store, logs, ledger |
| Integração | 5 | Integrações externas |
| RH | 14 | Funcionários, escalas, plantões |
| CRM | 7 | Clientes, contratos |
| MD | 11 | Dados mestres |
| Config | 4 | Configurações |
| Logística | 8 | Viaturas, remoções |
| Documentos | 14 | Arquivos, anexos, assinaturas |
| Agendamento | 4 | Agendamentos |

---

## 6. Próximos Passos

| Prioridade | Ação | Descrição |
|------------|------|-----------|
| Alta | Manter TABLE-INDEX atualizado | Atualizar a cada nova tabela |
| Alta | Validar FKs | Garantir que todas as FKs são válidas |
| Média | Criar MDs para tabelas PROPOSE | Documentar 20 tabelas novas |
| Baixa | Automatizar | Script para gerar índice do dump |

---

## 7. Referências

- CATALOGO_ENTIDADES_CORE
- MAPA_DEPENDENCIAS_ERD
- AUDIT-MODEL-PHYSICAL-VS-BANCO
- MODEL-PHYSICAL-KERNEL
- MODEL-LOGICAL-KERNEL
- Dump20260618.sql
- docs/database/tables/
- docs/database/tables_completas/
- docs/database/tables_raw/

---

## 8. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-14 | Kilo | Índice mestre de tabelas |

---

Documento Canônico — TABLE-INDEX

**Este é o índice oficial de tabelas da plataforma New Wave Enterprise.**
