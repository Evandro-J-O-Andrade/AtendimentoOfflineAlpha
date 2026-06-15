# MAPA SP CANÔNICO - NEW WAVE ENTERPRISE

## Padrão Canônico

```
sp_executor_<dominio>_<acao>(IN p_id_sessao, IN p_acao, IN p_id_referencia, IN p_payload JSON)
```

## SPs Existentes no Dump (451 procedures)

### MASTER DISPATCHER
- `sp_master_dispatcher` → Orquestrador universal
- `sp_master_routes` → Roteamento de sistema

### ASSERT
- `sp_assert_true` → Validação booleana
- `sp_assert_not_null` → Validação not-null

### CONTEXTO
- `sp_auth_contexto_set` → Define contexto unidade/local
- `sp_auth_contexto_get` → Busca contexto
- `sp_contexto_assert_permissao` → Valida permissão
- `sp_contexto_assert_transicao` → Valida transição

### AUTENTICAÇÃO
- `sp_auth_menu_get` → Menu por permissão
- `sp_acl_registrar_evento` → ACL eventos

### ASSISTENCIAL (HIS/PA)
#### Executores
- `sp_executor_assistencial_atendimento_iniciar`
- `sp_executor_assistencial_atendimento_finalizar`
- `sp_executor_assistencial_evolucao_salvar`
- `sp_executor_assistencial_triagem_iniciar`
- `sp_executor_assistencial_triagem_finalizar`
- `sp_executor_assistencial_triagem_salvar`
- `sp_executor_assistencial_runtime`

#### Runtime
- `sp_executor_fila_runtime` → Runtime da fila
- `sp_executor_estoque_runtime` → Runtime do estoque
- `sp_executor_faturamento_runtime` → Runtime do faturamento

### ESTOQUE
- `sp_estoque_movimentar` → Movimentação
- `sp_estoque_produto_criar_com_codigo` → Cria produto
- `sp_estoque_movimento_criar` → Cria movimento

### FILA/SENHAS
- `sp_criar_senha`
- `sp_chamar_senha`
- `sp_complementar_senha`
- `sp_fila_emitir_senha` → Via dispatcher

### LABORATÓRIO
- `sp_lab_protocolo_criar_ou_mapear`
- `sp_laboratorio_protocolo_evento_add`

### CÓDIGO
- `sp_codigo_emitir_interno` → Gera código interno
- `sp_codigo_mapear_externo` → Mapeia código externo

### LEDGER/AUDITORIA
- `sp_ledger_registrar_evento`
- `sp_auditoria_evento_registrar`

---

## SPs Portal (A CRIAR - Stage 200)

```sql
sp_executor_portal_noticia_criar(IN p_id_sessao, IN p_acao, IN p_id_referencia, IN p_payload JSON)
sp_executor_portal_comunicado_criar(...)
sp_executor_portal_enquete_criar(...)
sp_executor_portal_evento_criar(...)  -- OPCIONAL (usar agendamento + evento_geral)
```

## SPs Social (A CRIAR - Stage 202)

```sql
sp_executor_social_postagem_criar(...)
sp_executor_social_comentario_adicionar(...)
sp_executor_social_reacao_adicionar(...)
```

## SPs Wiki (A CRIAR - Stage 205)

```sql
sp_executor_wiki_artigo_criar(...)
sp_executor_wiki_artigo_salvar(...)
```

## SPs Chat (A CRIAR - Stage 204)

```sql
sp_executor_chat_mensagem_enviar(...)
sp_executor_chat_conversa_criar(...)
```

---

## Regra de Ouro

**Portal NÃO acessa tabelas diretamente**
- Toda operação Portal → `sp_master_dispatcher` → `sp_executor_portal_*`
- Toda operação Social → `sp_master_dispatcher` → `sp_executor_social_*`
- Tudo registrado em `evento_geral` com `dominio='PORTAL'` ou `'SOCIAL'`