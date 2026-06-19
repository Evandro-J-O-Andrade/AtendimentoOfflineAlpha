# MD-022 — Legacy Action Mapping

## Status

Documento Canônico De Mapeamento E Transição Arquitetural.

---

## Objetivo

Construir o catálogo executável oficial que conecta ações do Portal Core ao sistema legado, permitindo transição controlada, rastreabilidade total e migração progressiva sem parada.

---

## Princípio Fundamental

```text
Portal nunca conhece SP.
Portal conhece Ação.
Adapter traduz Ação → SP.
```

---

## Formato Canônico

Cada entrada do mapa segue:

```json
{
  "acao": "FILA.CHAMAR",
  "sp": "sp_chamar_senha",
  "dominio": "OPERACIONAL",
  "evento": "SENHA_CHAMADA",
  "status": "ACTIVE | LEGACY | OBSOLETE",
  "rotas_legadas": ["/api/fila/chamar"],
  "frontend_calls": ["/api/fila/chamar"]
}
```

---

## Mapeamento Por Domínio

### AUTH

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| AUTH.LOGIN | sp_master_login | LOGIN | ACTIVE |
| AUTH.LOGOUT | sp_auth_sessao_invalidar | LOGOUT | ACTIVE |
| AUTH.CONTEXTO.GET | sp_auth_contexto_get | CONTEXTO_CARREGADO | ACTIVE |
| AUTH.CONTEXTO.SET | sp_auth_contexto_set | CONTEXTO_ALTERADO | ACTIVE |
| AUTH.MENU.GET | sp_auth_menu_get | MENU_CARREGADO | ACTIVE |
| AUTH.SESSAO.REVOGAR | sp_admin_sessao_revogar | SESSAO_REVOGADA | ACTIVE |
| AUTH.PERMISSAO.VERIFICAR | sp_contexto_assert_permissao | PERMISSAO_VERIFICADA | ACTIVE |

---

### OPERACIONAL

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| FILA.CHAMAR | sp_chamar_senha | SENHA_CHAMADA | ACTIVE |
| FILA.COMPLEMENTAR | sp_complementar_senha | SENHA_COMPLEMENTADA | ACTIVE |
| TRIAGEM.INICIAR | sp_triagem_registrar (inferida) | TRIAGEM_INICIADA | ACTIVE |
| ATENDIMENTO.TRANSICIONAR | sp_atendimento_transicionar | ATENDIMENTO_TRANSICIONADO | ACTIVE |
| ATENDIMENTO.FINALIZAR_EVASAO | sp_atendimento_finalizar_evasao | ATENDIMENTO_FINALIZADO | ACTIVE |
| ATENDIMENTO.SENHA_NAO_COMPARECEU | sp_atendimento_senha_nao_compareceu | SENHA_NAO_COMPARECEU | ACTIVE |

---

### HISP/PRONTUARIO

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| FFA.INICIAR | sp_ffa_* (inferida) | FFA_CRIADA | ACTIVE |
| PRESCRICAO.CRIAR | sp_medico_prescrever (inferida) | PRESCRICAO_CRIADA | ACTIVE |
| EVOLUCAO.REGISTRAR | sp_atendimento_evolucao_* | EVOLUCAO_REGISTRADA | ACTIVE |
| EXAME.PEDIR | sp_exame_pedido_* | EXAME_PEDIDO | ACTIVE |

---

### FARMACIA

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| FARMACIA.DISPENSAR | sp_farmacia_dispensar (inferida) | MEDICAMENTO_DISPENSADO | ACTIVE |
| FARMACIA.RECEITA_CONTROLADA | sp_farmacia_receita_controlada (inferida) | RECEITA_CONTROLADA | ACTIVE |

---

### FATURAMENTO

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| FATURAMENTO.CONTA.GERAR | sp_faturamento_conta_* (inferida) | CONTA_GERADA | ACTIVE |
| FATURAMENTO.GPAT.REGISTRAR | sp_gpat_* (inferida) | GPAT_REGISTRADO | ACTIVE |

---

### ESTOQUE

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| ESTOQUE.MOVIMENTAR | sp_estoque_movimentar (inferida) | MOVIMENTACAO_ESTOQUE | ACTIVE |

---

### PORTAL

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| PORTAL.NOTICIA.PUBLICAR | (sem SP direta) | NOTICIA_PUBLICADA | LEGACY |
| PORTAL.DOCUMENTO.EMITIR | (via SPs de documento) | DOCUMENTO_EMITIDO | LEGACY |

---

### DISPATCHER / CORE

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| DISPATCHER.EXECUTAR | sp_master_dispatcher | DISPATCH_EXECUTADO | CANONICO |
| CHECKPOINT.VALIDAR | sp_checkpoint_global_validar | CHECKPOINT_VALIDADO | CANONICO |
| CODIGO.EMITIR | sp_codigo_emitir_interno | CODIGO_EMITIDO | CANONICO |

---

### AUDITORIA

| Ação | SP | Evento | Status |
|------|-----|--------|--------|
| AUDITORIA.REGISTRAR | sp_auditoria_evento_registrar | AUDITORIA_REGISTRADA | CANONICO |
| AUDITORIA.ERRO.REGISTRAR | sp_auditar_erro_sql | ERRO_AUDITADO | CANONICO |
| ACL.REGISTRAR | sp_acl_registrar_evento | ACL_REGISTRADA | CANONICO |

---

## Rotas Express Legadas Mapeadas

### Confirmadas no legado

| Rota Legada | Ação Portal | Domínio | Status |
|-------------|-------------|---------|--------|
| POST /api/fila/chamar | FILA.CHAMAR | OPERACIONAL | ACTIVE |
| POST /api/triagem/iniciar | TRIAGEM.INICIAR | OPERACIONAL | ACTIVE |
| POST /api/farmacia/dispensar | FARMACIA.DISPENSAR | FARMACIA | ACTIVE |
| POST /api/auth/login | AUTH.LOGIN | AUTH | ACTIVE |
| POST /api/auth/logout | AUTH.LOGOUT | AUTH | ACTIVE |
| POST /api/contexto/selecionar | CONTEXTO.SELECIONAR | PLATAFORMA | ACTIVE |

---

## Frontend Calls Mapeadas

### Confirmadas no legado

| Endpoint Frontend | Ação Portal | Domínio | Status |
|-------------------|-------------|---------|--------|
| /api/fila/chamar | FILA.CHAMAR | OPERACIONAL | ACTIVE |
| /api/auth/login | AUTH.LOGIN | AUTH | ACTIVE |
| /api/contexto/selecionar | CONTEXTO.SELECIONAR | PLATAFORMA | ACTIVE |

---

## Regras De Mapeamento

1. Toda SP do legado deve ter uma ação Portal correspondente.
2. Toda ação Portal deve gerar evento canônico.
3. Nenhuma ação sem mapeamento explícito é executada.
4. Rotas legadas são wrappers; ações são a abstração real.
5. Domínio é obrigatório para classificação e permissão.

---

## Integração Com Outros MDs

- **MD-004 (Dispatcher)**: ação é a entrada única.
- **MD-005 (Event Store)**: evento é obrigatório por ação.
- **MD-021 (Adapter)**: executa a tradução ação → SP.
- **MD-010/019 (App Registry)**: ação pertence a uma app registrada.

---

## Próximo Documento

- **MD-023 — Migration Runbook**: passo a passo da transição usando este mapa.

---

## Evidência Fonte

```text
legacy/backend_antigo/sql/Dump20260606.sql — 225 SPs
legacy/backend_antigo/src/routes/*Routes.js — rotas Express
legacy/backend_antigo/src/services/*Service.js — chamadas SP
legacy/root_antigo/*.ts/*.tsx — calls de API
```
