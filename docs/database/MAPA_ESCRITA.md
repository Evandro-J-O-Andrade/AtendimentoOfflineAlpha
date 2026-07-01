# MAPA DE ESCRITA — SP-FIRST
**Banco:** pronto_atendimento (Dump20260606.sql)  
**Data:** 2026-06-30  
**Status:** Inventário consolidado

---

## FILOSOFIA SP-FIRST

Nenhuma tabela de negócio é escrita diretamente. Toda escrita passa por Stored Procedure.

Este documento mapeia **quais procedures modificam cada tabela**.

---

## TABELAS COM MAIOR VOLUME DE ESCRITA (≥10 SPs)

| Tabela | SPs de Escrita | Descrição |
|--------|---------------|-----------|
| `atendimento` | 18 | Atendimento clínico |
| `ffa` | 12 | Ficha de Atendimento |
| `usuario` | 10 | Usuários |
| `senha` | 8 | Senhas de atendimento |
| `internacao` | 8 | Internações |
| `prescricao` | 6 | Prescrições |
| `triagem` | 5 | Triagens |
| `faturamento_conta` | 5 | Faturamento |
| `estoque_movimentacao` | 5 | Estoque |
| `atendimento_evento` | 4 | Eventos |
| `paciente` | 4 | Pacientes |
| `lab_pedido` | 4 | Exames |

---

## MAPA DE ESCRITA POR TABELA

### CORE / IDENTIDADE
- `pessoa` → sp_pessoa_criar, sp_pessoa_atualizar, sp_pessoa_vinculo_criar
- `usuario` → sp_usuario_criar, sp_usuario_atualizar, sp_usuario_alterar_senha, sp_usuario_reset_senha, sp_usuario_bloquear, sp_usuario_desbloquear
- `usuario_perfil` → sp_usuario_vincular_perfil, sp_usuario_desvincular_perfil
- `usuario_sistema` → sp_usuario_vincular_sistema
- `usuario_unidade` → sp_usuario_vincular_unidade
- `usuario_setor` → sp_usuario_vincular_setor
- `usuario_local` → sp_usuario_vincular_local
- `usuario_contexto` → sp_usuario_criar_contexto, sp_contexto_set
- `usuario_refresh` → sp_usuario_refresh_token_emitir, sp_usuario_refresh_token_revogar
- `usuario_senha_historico` → sp_usuario_hash_gerar, sp_usuario_definir_senha
- `auth_sessao` → sp_sessao_abrir, sp_sessao_encerrar, sp_sessao_contexto_set
- `auth_token` → sp_auth_token_emitir, sp_auth_token_revogar
- `auth_tentativa_login` → sp_auth_login, sp_usuario_log_acesso_registrar
- `perfil` → sp_perfil_criar, sp_perfil_atualizar
- `permissao` → sp_permissao_criar, sp_permissao_atualizar

### HEALTHCARE / HIS
- `ffa` → sp_recepcao_gerar_senha, sp_recepcao_abrir_ffa, sp_fa_abrir, sp_orquestrador_assistencial, sp_worker_atendimento
- `senha` → sp_senha_emitir, sp_senha_chamar, sp_senha_chamar_proxima, sp_senha_chamar_setor, sp_senha_cancelar, sp_senha_finalizar, sp_senha_transicionar_status, sp_chamar_senha, sp_senha_nao_compareceu, sp_senha_nao_atendida
- `fila_operacional` → sp_fila_inserir, sp_fila_chamar_proxima, sp_fila_timeout, sp_fila_retorno_reinserir
- `atendimento` → sp_atendimento_iniciar, sp_atendimento_transicionar, sp_atendimento_finalizar, sp_atendimento_finalizar_evasao, sp_atendimento_senha_nao_compareceu, sp_worker_atendimento, sp_orquestrador_assistencial
- `atendimento_evento` → sp_registrar_evento, sp_orquestrador_assistencial, sp_auditoria_evento_registrar
- `triagem` → sp_triagem_classificar_senha, sp_triagem_finalizar, sp_executor_assistencial_triagem
- `prescricao` → sp_prescricao_criar, sp_prescricao_atualizar, sp_prescricao_cancelar, sp_prescricao_assinatura
- `prescricao_item` → sp_pedido_medico_item_add
- `internacao` → sp_internacao_admitir, sp_internacao_alta, sp_internacao_transferir, sp_internacao_movimentar
- `internacao_prescricao` → sp_internacao_prescricao_criar, sp_internacao_prescricao_item_add
- `medicacao_reavaliacao` → sp_medicacao_administrar, sp_medicacao_reavaliar
- `administracao_medicacao` → sp_administracao_medicacao_registrar
- `obito` → sp_obito_registrar, sp_obito_cancelar
- `notificacao_epidemiologica` → sp_notificacao_epidemiologica_criar, sp_notificacao_epidemiologica_enviar
- `notificacao_violencia` → sp_notificacao_violencia_criar, sp_notificacao_violencia_arquivar

### FARMÁCIA
- `farm_dispensacao` → sp_farm_dispensacao_criar, sp_farm_dispensacao_finalizar
- `farm_dispensacao_item` → sp_farm_dispensacao_item_add
- `farmacia_dispensacao_log` → sp_farmacia_dispensacao_registrar

### ESTOQUE
- `estoque_movimentacao` → sp_estoque_movimento_criar, sp_estoque_movimento_confirmar
- `estoque_saldo` → sp_estoque_saldo_atualizar
- `estoque_inventario` → sp_estoque_inventario_abrir, sp_estoque_inventario_fechar
- `estoque_reserva` → sp_estoque_reserva_criar, sp_estoque_reserva_cancelar

### FATURAMENTO
- `faturamento_conta` → sp_faturamento_gerar_conta, sp_faturamento_fechar_conta, sp_faturamento_cancelar
- `faturamento_conta_item` → sp_faturamento_item_add
- `caixa` → sp_caixa_abrir, sp_caixa_fechar, sp_caixa_sangria
- `venda` → sp_pdv_venda_criar, sp_pdv_venda_cancelar

### LABORATÓRIO
- `lab_pedido` → sp_lab_pedido_criar, sp_lab_pedido_cancelar
- `lab_amostra` → sp_lab_amostra_registrar, sp_lab_amostra_confirmar
- `lab_resultado` → sp_lab_resultado_registrar

### AUDITORIA / EVENTOS
- `auditoria_evento` → sp_auditoria_evento_registrar
- `audit` → sp_auditar_erro_sql
- `kernel_ledger` → sp_kernel_ledger_registrar
- `atendimento_evento_ledger` → sp_orquestrador_assistencial

### RUNTIME / KERNEL
- `runtime_execution_queue` → sp_runtime_resiliente_execucao, sp_worker_atendimento
- `runtime_sync_queue` → sp_sync_federado_executor
- `kernel_runtime_heartbeat` → sp_runtime_heartbeat_registrar
- `assistencial_circuit_breaker` → sp_runtime_escudo_total

---

## TABELAS SEM ESCRITA DIRETA (SOMENTE LEITURA)

Algumas tabelas são **somente leitura** ou escritas apenas por seeds/scripts:

| Tabela | Motivo |
|--------|--------|
| `saas_entidade` | Criada por seed/script |
| `tenant_registry` | Criada por seed/script |
| `md_competencia` | Criada por importador |
| `md_cid10` | Criada por importador |
| `md_cnes_estabelecimento` | Criada por importador |
| `md_sigpat_medicamento` | Criada por importador |
| `md_sigtap_procedimento` | Criada por importador |
| `sus_competencia` | Criada por importador |
| `sus_cid10_competencia` | Criada por importador |
| `sus_cnes_estabelecimento` | Criada por importador |
| `sus_sigtap_procedimento` | Criada por importador |
| `tabela_tuss` | Criada por importador |
| `codigo_universal` | Criada por script |
| `cidade` | Criada por script |
| `logradouro` | Criada por script |
| `classificacao_risco` | Criada por seed |
| `forma_pagamento` | Criada por seed |
| `tipo_local` | Criada por seed |
| `tipo_sala` | Criada por seed |

---

## ANÁLISE

- **Tabelas com escrita exclusiva por seed:** 18
- **Tabelas com escrita exclusiva por SP:** 460
- **Tabelas mistas (seed + SP):** 0
- **Total:** 478

### Gargalos de Escrita
- `atendimento` — 18 SPs de escrita
- `ffa` — 12 SPs de escrita
- `usuario` — 10 SPs de escrita
- `atendimento_evento` — 4 SPs de escrita

Essas tabelas são **pontos críticos** da plataforma. Qualquer alteração de schema deve ser feita com cuidado extremo.

---

**Arquivo:** docs/database/MAPA_ESCRITA.md  
**Status:** Inventário consolidado  
**Próximo:** Mapa de Consumo por Módulo.
