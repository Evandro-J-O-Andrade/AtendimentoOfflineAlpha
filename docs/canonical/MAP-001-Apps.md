# MAP-001 — Aplicações da Plataforma

## Status

Documento Canônico De Mapeamento.
Fonte: dump + estrutura legada.
Revisão: pendente de validação do legado full quando desejado.

---

## Aplicações Confirmadas (com evidência)

| Aplicação | Evidência | Status |
|-----------|-----------|--------|
| AUTH | authRoutes, authMiddleware, sp_auth_*, tabelas usuario/sessao/perfil/permissao | CANONICA |
| OPERACIONAL | operacionalRoutes + apps/ operacional + tabelas atendimento/triagem/senha/ffa | CANONICA |
| FARMACIA | farmaciaRoutes + apps/farmacia + tabelas farm_*/dispensacao | CANONICA |
| FATURAMENTO | tabelas faturamento_*/gpat_* + procedimentos SUS + sps faturamento | CANONICA |
| ESTOQUE | apps/estoque + tabelas estoque_*/produto + sps estoque | CANONICA |
| PDV | apps/financeiro/caixa + tabelas pdv_*/venda_*/caixa | CANONICA |
| FINANCEIRO | apps/financeiro + tabelas financeiro_*/repasse_*/forma_pagamento | CANONICA |
| CRM | apps/crm + tabelas cliente/fornecedor/contrato | CANONICA |
| SAC | apps/suporte + tabelas chamado_* + backend sem rotas explícitas | CANONICA |
| PORTAL | apps/portal + portalRoutes + portal_* | CANONICA |
| BI | apps/bi + tables sem prefixo claro + componentes painel / tv_rotativo | CANONICA |
| RH | apps/rh + tabelas rh_*/escala_* | CANONICA |

## Aplicações Inferidas (ainda por validar)

| Aplicação | Motivo | Status |
|-----------|--------|--------|
| CAT | cat_* existe no dump | ANALISAR |
| LABORATORIO | exame/lab_* existe no dump | ANALISAR |
| INTERNACAO | internacao_* / leito existe | ANALISAR |
| ADMIN | config_sistema / schema_patch no dump | ANALISAR |
| ESG/SOCIAL | sem evidência forte no legado atual | ANALISAR |

## Aplicações Inativas/Parciais

| Aplicação | Sinais | Status |
|-----------|--------|--------|
| OUVIDORIA | sem código/rotas claras | PARCIAL |
| AVA | sem código claro | PARCIAL |
| TI | apps/ti com estrutura mínima | PARCIAL |
| COMPLIANCE | apps/compliance com estrutura mínima | PARCIAL |
