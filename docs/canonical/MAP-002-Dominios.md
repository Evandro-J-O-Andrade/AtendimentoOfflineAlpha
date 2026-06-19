# MAP-002 — Domínios

## Status

Documento Canônico De Mapeamento.
Fonte: dump + tabelas confirmadas.

---

## Domínios Identificados

| Domínio | Sinais no sistema | Status |
|---------|-------------------|--------|
| AUTH | authRoutes + usuario/perfil/permissao/sessao + sp_auth_* | CANONICO |
| PLATAFORMA | sistema/unidade/local/tenant_registry + kernel_* | CANONICO |
| PORTAL | portal_* + portalRoutes + apps/portal + documento_* | CANONICO |
| OPERACIONAL | operacionalRoutes + apps/assistencial + senha/fila/triagem/atendimento | CANONICO |
| HIS/PRONTUARIO | atendimento_*/paciente_*/ffa_*/prescricao_* no dump | CANONICO |
| FARMACIA | farmaciaRoutes + apps/farmacia + farm_* + dispensacao_medicacao | CANONICO |
| ESTOQUE | apps/estoque + estoque_* + produto + movimentacao | CANONICO |
| FATURAMENTO | faturamento_* + gpat_* + faturamento_evento + sigtap/sigtap | CANONICO |
| FINANCEIRO | financeiro_* + forma_pagamento + repasse | CANONICO |
| PDV | pdv_*/venda_*/caixa_* + apps/financeiro (caixa) | CANONICO |
| CRM | apps/crm + cliente/fornecedor/contrato | CANONICO |
| SAC | apps/suporte + chamado_* | CANONICO |
| LABORATORIO | lab_* + exame_* | CANONICO |
| INTERNACAO | internacao_* + leito_* | CANONICO |
| CAT | cat_* + sinan_* | CANONICO |
| ESOCIAL | rh_* + funcionario_* + escala_* | CANONICO |
| WORKFLOW | fluxo_* + workflow_* + eventos_fluxo | CANONICO |
| RUNTIME | runtime_* + sync_* + fila_local | CANONICO |
| AUDITORIA | auditoria_* + log_* + kernel_ledger | CANONICO |
| MASTERDATA | md_* + codigo_* + cid10/cnes/sigtap | CANONICO |
| SEGURANCA | hardening_* + guardiao_* + auth_audit | CANONICO |
| BI | apps/bi + painel_* + tv_rotativo_* + analytics | CANONICO |
