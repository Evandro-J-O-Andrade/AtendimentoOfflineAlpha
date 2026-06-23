# MAP-001 — Mapa de Aplicações da Plataforma

## Status

Documento Canônico De Mapeamento.
Fonte: dump + estrutura legada + MDs canônicos.
Versão: 1.0

---

## Princípio

```text
Toda capacidade da plataforma é uma App registrada.
Nenhuma app existe sem entrada no Registry.
Nenhuma app executa sem contexto validado.
```

---

## Aplicações Confirmadas

| Aplicação | Domínio | Evidência | Status |
|-----------|---------|-----------|--------|
| AUTH | Plataforma | authRoutes, authMiddleware, sp_auth_*, tabelas usuario/sessao/perfil/permissao | CANONICA |
| PORTAL | Plataforma | apps/portal + portalRoutes + portal_* | CANONICA |
| OPERACIONAL | Saúde | operacionalRoutes + apps/operacional + senha/fila/ffa/atendimento/triagem | CANONICA |
| FARMACIA | Saúde | apps/farmacia + farm_*/farmacia_* + dispensacao_medicacao + gpat_* + sp_farmacia_* | CANONICA |
| ESTOQUE | Saúde | apps/estoque + estoque_*/produto_*/lote_*/saldo_* + sps estoque | CANONICA |
| FATURAMENTO | Saúde | faturamento_*/gpat_* + sigtap + procedimentos SUS | CANONICA |
| LABORATORIO | Saúde | lab_* + exame_* + laboratorio_* | CANONICA |
| INTERNACAO | Saúde | internacao_* + leito_* | CANONICA |
| CAT | Saúde | cat_* + sinan_* + sp_cat_* | CANONICA |
| PDV | Comercial | apps/financeiro/caixa + pdv_*/venda_*/caixa_* | CANONICA |
| FINANCEIRO | Comercial | apps/financeiro + financeiro_*/repasse_*/forma_pagamento | CANONICA |
| CRM | Comercial | apps/crm + cliente/fornecedor/contrato | CANONICA |
| SAC | Comercial | apps/suporte + chamado_* + backend sem rotas explícitas | CANONICA |
| BI | Analytics | apps/bi + painel_* + tv_rotativo_* + analytics | CANONICA |
| RH | RH | apps/rh + rh_*/escala_* + funcionario_* | CANONICA |
| ADMIN | Plataforma | config_sistema / schema_patch | CANONICA |

---

## Aplicações Planejadas (MDs canônicos)

| Aplicação | Domínio | MD Fonte | Status |
|-----------|---------|----------|--------|
| DOCUMENTOS | Plataforma | MD-006, MD-042A | PLANEJADA |
| WIKI | Plataforma | MD-006 | PLANEJADA |
| OUVIDORIA | Saúde | MD-006 | PLANEJADA |
| AVA | Educação | MD-006, MD-042A | PLANEJADA |
| INTRANET | Workplace | MD-042A | PLANEJADA |
| SOCIAL | Workplace | MD-028, MD-042A | PLANEJADA |
| CHAT | Workplace | MD-029, MD-042A | PLANEJADA |
| CALENDARIO | Workplace | MD-029 | PLANEJADA |
| MARKETPLACE | Ecossistema | MD-031, MD-075 | PLANEJADA |
| IA_COPILOT | Cognitivo | MD-081 | PLANEJADA |
| AGENT_MARKETPLACE | Cognitivo | MD-082 | PLANEJADA |
| WORKFLOW | Automação | MD-056, MD-089 | PLANEJADA |
| N8N | Automação | MD-089 | PLANEJADA |
| NOTIFICACOES | Plataforma | MD-088 | PLANEJADA |
| SEARCH | Plataforma | MD-053, MD-087 | PLANEJADA |

---

## Aplicações Inativas/Parciais

| Aplicação | Sinais | Status |
|-----------|--------|--------|
| OUVIDORIA | sem código/rotas claras | PARCIAL |
| AVA | sem código claro | PARCIAL |
| TI | apps/ti com estrutura mínima | PARCIAL |
| COMPLIANCE | apps/compliance com estrutura mínima | PARCIAL |

---

## Ordem de Implementação

1. AUTH (já canônica)
2. PORTAL (já canônica)
3. OPERACIONAL (base assistencial)
4. FARMACIA, ESTOQUE, FATURAMENTO (encadeadas)
5. PDV, FINANCEIRO, CRM, SAC (comerciais)
6. BI (analytics)
7. RH, LABORATORIO, INTERNACAO, CAT (complementares)
8. Apps planejadas conforme roadmap MD-100

---

## Critério de Aceite

- Toda app tem tabelas, SPs, eventos e frontend mapeados.
- App sem Registry não existe.
- App sem IAM não abre.
- App opera dentro do Shell.
