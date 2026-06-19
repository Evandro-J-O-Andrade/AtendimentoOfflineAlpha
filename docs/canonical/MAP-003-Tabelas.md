# MAP-003 — Tabelas Canônicas

## Status

Documento Canônico De Mapeamento.
Fonte: Dump20260606.sql.
Nota: lista completa consolidada do dump como verdade oficial.

---

## Tabelas Canônicas (MD-001)

| Tabela | Entidade Canônica |
|--------|-------------------|
| pessoa | Pessoa |
| usuario | Usuário |
| sessao_usuario | Sessão |
| perfil | Perfil |
| permissao | Permissão |
| perfil_permissao | Perfil-Permissão |
| sistema | Sistema |
| unidade | Unidade |
| local_operacional | Local |

## Visão Consolidada Por Domínio

| Domínio | Tabelas |
|---------|---------|
| AUTH | auth_*, usuario_*, perfil_*, permissao_*, sessao_* |
| PLATAFORMA | sistema, tenant_registry, saas_*, config_*, md_*, codigo_* |
| PORTAL | portal_*, documento_*, assinatura_*, agenda_* |
| OPERACIONAL | senha_*, fila_*, atendimento_*, triagem_*, contexto_*, painel_*, local_* |
| HIS | atendimento_*, paciente_*, ffa_*, prescricao_*, exame_*, evolucao_* |
| FARMACIA | farm_*, farmacia_*, dispensacao_medicacao, gpat_* |
| ESTOQUE | estoque_*, produto_*, almoxarifado_*, lote_*, saldo_* |
| FATURAMENTO | faturamento_*, gpat_*, nota_fiscal_*, sigtap_* |
| FINANCEIRO | financeiro_*, repasse_*, forma_pagamento |
| PDV | pdv_*, venda_*, caixa_* |
| CRM | cliente, fornecedor, contrato |
| SAC | chamado_*, alerta_*, manutencao_* |
| LABORATORIO | lab_*, laboratorio_* |
| INTERNACAO | internacao_*, leito_*, config_leitos_* |
| CAT | cat_*, sinan_*, notificacao_* |
| ESOCIAL | rh_*, funcionario_*, escala_* |
| WORKFLOW | fluxo_*, workflow_*, eventos_fluxo |
| RUNTIME | runtime_*, sync_*, ledger_* de sincronizacao, guardiao_* |
| AUDITORIA | auditoria_*, log_*, erro_*, kernel_ledger |
| MASTERDATA | md_*, codigo_*, cid10_*, cnes_*, competencia_*, sigtap_*, sigpat_* |
| SEGURANCA | hardening_sp_excecao, guardiao_*, assistencial_*_circuit_breaker/checkpoint |

## Referência De Dados

- Dump completo: `legacy/backend_antigo/sql/Dump20260606.sql`
- Schemas parciais: `database/stages/Stage100.sql`, `Stage200.sql`
