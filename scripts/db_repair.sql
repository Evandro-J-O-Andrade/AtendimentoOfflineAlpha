-- scripts/db_repair.sql
-- Limpa triggers, procedures, functions e views que podem ter sido criadas parcialmente
-- Executar ANTES de reexecutar o arquivo antendimento.sql

USE pronto_atendimento;

-- Triggers
DROP TRIGGER IF EXISTS trg_auditoria_atendimento_update;
DROP TRIGGER IF EXISTS trg_movimentacao_atendimento;
DROP TRIGGER IF EXISTS trg_bloqueia_atendimento_finalizado;
DROP TRIGGER IF EXISTS trg_unica_internacao_ativa;
DROP TRIGGER IF EXISTS trg_prescricao_atendimento_fechado;
DROP TRIGGER IF EXISTS trg_bloqueia_update_prescricao;
DROP TRIGGER IF EXISTS trg_leito_ocupado;
DROP TRIGGER IF EXISTS trg_finalizacao_com_internacao;
DROP TRIGGER IF EXISTS trg_admin_medicacao_duplicada;
DROP TRIGGER IF EXISTS trg_auditoria_prescricao;
DROP TRIGGER IF EXISTS trg_ocupa_leito;
DROP TRIGGER IF EXISTS trg_libera_leito;
DROP TRIGGER IF EXISTS trg_encerrar_internacao;
DROP TRIGGER IF EXISTS trg_alta_internacao;
DROP TRIGGER IF EXISTS trg_bloqueia_anamnese_finalizado;
DROP TRIGGER IF EXISTS trg_bloqueia_prescricao;
DROP TRIGGER IF EXISTS trg_uma_internacao_ativa;
DROP TRIGGER IF EXISTS trg_nao_atendido;
DROP TRIGGER IF EXISTS trg_audit_prescricao_insert;
DROP TRIGGER IF EXISTS trg_reabertura_status;

-- Procedures (com variantes que aparecem no script)
DROP PROCEDURE IF EXISTS sp_abrir_atendimento;
DROP PROCEDURE IF EXISTS sp_abrir_atendimento_segura;
DROP PROCEDURE IF EXISTS sp_abre_atendimento;
DROP PROCEDURE IF EXISTS sp_mover_atendimento;
DROP PROCEDURE IF EXISTS sp_finalizar_atendimento;
DROP PROCEDURE IF EXISTS sp_gerar_senha;
DROP PROCEDURE IF EXISTS sp_registrar_recepcao;
DROP PROCEDURE IF EXISTS sp_registrar_triagem;
DROP PROCEDURE IF EXISTS sp_chamar_paciente;
DROP PROCEDURE IF EXISTS sp_entrar_observacao;
DROP PROCEDURE IF EXISTS sp_internar_paciente;
DROP PROCEDURE IF EXISTS sp_alta_internacao;
DROP PROCEDURE IF EXISTS sp_reabrir_atendimento;
DROP PROCEDURE IF EXISTS sp_abertura_recepcao;
DROP PROCEDURE IF EXISTS sp_buscar_ou_criar_pessoa;
DROP PROCEDURE IF EXISTS sp_abrir_atendimento_segura;

-- Functions
DROP FUNCTION IF EXISTS fn_gera_protocolo;

-- Views (principais mencionadas no esquema)
DROP VIEW IF EXISTS vw_fila_atendimento;
DROP VIEW IF EXISTS vw_historico_paciente;
DROP VIEW IF EXISTS vw_mapa_leitos;
DROP VIEW IF EXISTS vw_fila_atual;
DROP VIEW IF EXISTS vw_tempo_medio_atendimento;
DROP VIEW IF EXISTS vw_produtividade_medico;
DROP VIEW IF EXISTS vw_produtividade_enfermagem;
DROP VIEW IF EXISTS vw_tempo_atendimento;
DROP VIEW IF EXISTS vw_origem_pacientes;
DROP VIEW IF EXISTS vw_tipo_atendimento;
DROP VIEW IF EXISTS vw_classificacao_risco;
DROP VIEW IF EXISTS vw_base_faturamento;
DROP VIEW IF EXISTS vw_auditoria_status;
DROP VIEW IF EXISTS vw_atendimentos_diarios;
DROP VIEW IF EXISTS vw_nao_atendidos;
DROP VIEW IF EXISTS vw_paciente_observacao;
DROP VIEW IF EXISTS vw_fila_triagem;
DROP VIEW IF EXISTS vw_pacientes_internados;
DROP VIEW IF EXISTS vw_receitas_controladas;
DROP VIEW IF EXISTS vw_auditoria;

-- Outros objetos que podem travar a execução
DROP TABLE IF EXISTS chamada_painel;
DROP TABLE IF EXISTS totem_feedback;

-- Mensagem opcional (para execução em clientes que mostram comentários)
SELECT 'DROP commands executed (verificar mensagens de erro se houver)';
