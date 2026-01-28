
/*
HIS/PA - REBUILD V2 (DROP + CREATE) - 2026-01-26
Fonte de verdade: BANCO (VW/SP/FN/TRG). Frontend apenas consome.
NÚCLEO IMUTÁVEL:
- Senha/ticket nasce antes e é auditável; não é paciente
- Paciente + FFA só nasce na recepção na complementação (vincula a senha internamente)
- Chamadas e decisões sempre manuais e auditáveis
- Painéis somente leitura (consomem views e eventos); voz apenas para evento CHAMADA
- usuario_sistema é a fonte da verdade (usuario_perfil é legado e NÃO será criado aqui)
- Toda ação relevante exige sessão/contexto operacional (sessao_usuario)

IMPORTANTE:
- Script cria um banco limpo, sem tabelas legadas.
- Inclui SEED mínimo para teste (usuário ADMIN) no final.
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS pronto_atendimento;
CREATE DATABASE pronto_atendimento CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE pronto_atendimento;

/* ==========================================================
   0) BASE: SISTEMA / UNIDADE / PERFIL / USUÁRIO / PERMISSÃO
   ========================================================== */

CREATE TABLE sistema (
  id_sistema BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(50) NOT NULL,
  nome VARCHAR(150) NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_sistema_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE unidade (
  id_unidade BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(50) NOT NULL,
  nome VARCHAR(150) NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_unidade_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE perfil (
  id_perfil INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(50) NOT NULL,
  nome VARCHAR(150) NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_perfil_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE usuario (
  id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  login VARCHAR(80) NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_usuario_login (login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Fonte da verdade de perfil (usuário x sistema x perfil)
CREATE TABLE usuario_sistema (
  id_usuario BIGINT NOT NULL,
  id_sistema BIGINT NOT NULL,
  id_perfil INT NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_sistema, id_perfil),
  KEY idx_us_usuario (id_usuario),
  KEY idx_us_sistema (id_sistema),
  CONSTRAINT fk_us_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_us_sistema FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema),
  CONSTRAINT fk_us_perfil FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE permissao (
  id_permissao BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(80) NOT NULL,
  descricao VARCHAR(255) NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_perm_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE perfil_permissao (
  id_perfil INT NOT NULL,
  id_permissao BIGINT NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_perfil, id_permissao),
  CONSTRAINT fk_pp_perfil FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil),
  CONSTRAINT fk_pp_perm FOREIGN KEY (id_permissao) REFERENCES permissao(id_permissao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   1) CONTEXTO OPERACIONAL / LOCAIS / SESSÃO
   ========================================================== */

CREATE TABLE local_operacional (
  id_local_operacional BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_sistema BIGINT NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  nome VARCHAR(150) NOT NULL,
  tipo ENUM(
    'RECEPCAO','TRIAGEM','MEDICO_CLINICO','MEDICO_PEDIATRICO',
    'MEDICACAO','RX','LABORATORIO','ECG','OBSERVACAO','INTERNACAO',
    'FARMACIA','TI','MANUTENCAO','ENG_CLINICA','GASOTERAPIA','ASSIST_SOCIAL',
    'SALA_NOTIFICACAO','ADMIN','OUTRO'
  ) NOT NULL DEFAULT 'OUTRO',
  sala VARCHAR(50) NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_localop (id_unidade, id_sistema, codigo),
  KEY idx_localop_unidade (id_unidade),
  KEY idx_localop_sistema (id_sistema),
  CONSTRAINT fk_localop_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_localop_sistema FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE usuario_local_operacional (
  id_usuario BIGINT NOT NULL,
  id_local_operacional BIGINT NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_local_operacional),
  KEY idx_ulo_local (id_local_operacional),
  CONSTRAINT fk_ulo_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_ulo_localop FOREIGN KEY (id_local_operacional) REFERENCES local_operacional(id_local_operacional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE sessao_usuario (
  id_sessao_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_usuario BIGINT NOT NULL,
  id_sistema BIGINT NOT NULL,
  id_unidade BIGINT NOT NULL,
  id_local_operacional BIGINT NOT NULL,
  ip VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  iniciado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  encerrado_em DATETIME NULL,
  ativo TINYINT(1) DEFAULT 1,
  KEY idx_su_usuario (id_usuario),
  KEY idx_su_contexto (id_sistema, id_unidade, id_local_operacional),
  CONSTRAINT fk_su_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_su_sistema FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema),
  CONSTRAINT fk_su_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_su_localop FOREIGN KEY (id_local_operacional) REFERENCES local_operacional(id_local_operacional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   2) PESSOA / PACIENTE (mínimo)
   ========================================================== */

CREATE TABLE pessoa (
  id_pessoa BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome_completo VARCHAR(150) NOT NULL,
  nome_social VARCHAR(150) NULL,
  data_nascimento DATE NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE paciente (
  id_paciente BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_pessoa BIGINT NOT NULL,
  prontuario VARCHAR(30) NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_paciente_pessoa (id_pessoa),
  CONSTRAINT fk_paciente_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   3) SENHA (ticket) + FILA DA RECEPÇÃO (entidade primária operacional)
   ========================================================== */

CREATE TABLE senhas (
  id_senha BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  codigo VARCHAR(12) NOT NULL,     -- ex: C0001, P0002...
  numero INT NOT NULL,
  prefixo VARCHAR(5) NOT NULL,
  lane ENUM('CLINICO','PEDIATRICO','PRIORITARIO') NOT NULL DEFAULT 'CLINICO',
  origem ENUM('TOTEM','RECEPCAO','ADMIN','SAMU') NOT NULL DEFAULT 'RECEPCAO',
  prioridade_declarada TINYINT(1) NOT NULL DEFAULT 0,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_senha_codigo (id_unidade, codigo),
  KEY idx_senha_unidade (id_unidade, criado_em),
  CONSTRAINT fk_senha_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fila_senha (
  id_fila_senha BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_senha BIGINT NOT NULL,
  id_paciente BIGINT NULL,  -- REGRA: pode ser NULL até complementação
  status ENUM('AGUARDANDO','CHAMANDO','EM_COMPLEMENTACAO','ENCAMINHADO','NAO_ATENDIDO','FINALIZADO','CANCELADO')
    NOT NULL DEFAULT 'AGUARDANDO',
  lane_confirmada ENUM('CLINICO','PEDIATRICO','PRIORITARIO') NOT NULL DEFAULT 'CLINICO',
  prioridade_confirmada ENUM('NAO','IDOSO','GESTANTE','ESPECIAL','AUTISTA','OUTRA') NOT NULL DEFAULT 'NAO',
  local_chamada VARCHAR(50) NULL,
  id_usuario_chamada BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  chamado_em DATETIME NULL,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_fs_status (status, criado_em),
  KEY idx_fs_lane (lane_confirmada, criado_em),
  KEY idx_fs_senha (id_senha),
  KEY idx_fs_paciente (id_paciente),
  CONSTRAINT fk_fs_senha FOREIGN KEY (id_senha) REFERENCES senhas(id_senha),
  CONSTRAINT fk_fs_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_fs_user_chamada FOREIGN KEY (id_usuario_chamada) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   4) FFA (episódio) + FILA OPERACIONAL SETORIAL
   ========================================================== */

CREATE TABLE ffa (
  id_ffa BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_paciente BIGINT NOT NULL,
  id_fila_senha BIGINT NOT NULL,
  gpat VARCHAR(30) NULL,
  status ENUM(
    'ABERTO','EM_TRIAGEM','AGUARDANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO',
    'MEDICACAO','RX','EXAMES','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','RETORNO'
  ) NOT NULL DEFAULT 'ABERTO',
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_ffa_paciente (id_paciente, criado_em),
  KEY idx_ffa_status (status, atualizado_em),
  CONSTRAINT fk_ffa_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_ffa_fila FOREIGN KEY (id_fila_senha) REFERENCES fila_senha(id_fila_senha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fila_operacional (
  id_fila_operacional BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_ffa BIGINT NOT NULL,
  id_local_destino BIGINT NOT NULL,
  id_profissional_alocado BIGINT NULL,
  status ENUM('AGUARDANDO','CHAMANDO','EM_EXECUCAO','FINALIZADO','NAO_ATENDIDO','RETORNO') NOT NULL DEFAULT 'AGUARDANDO',
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  chamado_em DATETIME NULL,
  iniciado_em DATETIME NULL,
  finalizado_em DATETIME NULL,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_fo_destino_status (id_local_destino, status, criado_em),
  KEY idx_fo_prof (id_profissional_alocado, status, criado_em),
  CONSTRAINT fk_fo_ffa FOREIGN KEY (id_ffa) REFERENCES ffa(id_ffa),
  CONSTRAINT fk_fo_local FOREIGN KEY (id_local_destino) REFERENCES local_operacional(id_local_operacional),
  CONSTRAINT fk_fo_prof FOREIGN KEY (id_profissional_alocado) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   5) AUDITORIA/EVENTOS + CHAMADAS DE PAINEL + IMPRESSÃO
   ========================================================== */

CREATE TABLE auditoria_evento (
  id_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_sessao_usuario BIGINT NULL,
  entity_type ENUM('SENHA','FILA_SENHA','FFA','FILA_OPERACIONAL','IMPRESSAO','CHAMADO','REMOVER','OUTRO') NOT NULL,
  entity_id BIGINT NULL,
  acao VARCHAR(80) NOT NULL,
  de_local BIGINT NULL,
  para_local BIGINT NULL,
  de_status VARCHAR(50) NULL,
  para_status VARCHAR(50) NULL,
  motivo VARCHAR(255) NULL,
  detalhe_json JSON NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_evt_sessao (id_sessao_usuario),
  KEY idx_evt_ent (entity_type, entity_id, criado_em),
  CONSTRAINT fk_evt_sessao FOREIGN KEY (id_sessao_usuario) REFERENCES sessao_usuario(id_sessao_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Registro de "chamada" para painéis (última chamada + voz)
CREATE TABLE chamada_painel (
  id_chamada BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_local_operacional BIGINT NOT NULL,
  texto VARCHAR(120) NOT NULL, -- ex: "Senha C0001 - Guichê 01"
  id_fila_senha BIGINT NULL,
  id_fila_operacional BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_cp_local (id_unidade, id_local_operacional, criado_em),
  CONSTRAINT fk_cp_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_cp_local FOREIGN KEY (id_local_operacional) REFERENCES local_operacional(id_local_operacional),
  CONSTRAINT fk_cp_fs FOREIGN KEY (id_fila_senha) REFERENCES fila_senha(id_fila_senha),
  CONSTRAINT fk_cp_fo FOREIGN KEY (id_fila_operacional) REFERENCES fila_operacional(id_fila_operacional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE print_job (
  id_print_job BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_sessao_usuario BIGINT NULL,
  id_unidade BIGINT NOT NULL,
  id_local_operacional BIGINT NOT NULL,
  entity_type ENUM('FILA_SENHA','FFA','OUTRO') NOT NULL,
  entity_id BIGINT NOT NULL,
  template_code VARCHAR(80) NOT NULL,
  status ENUM('PENDENTE','ENVIADO','IMPRESSO','ERRO') NOT NULL DEFAULT 'PENDENTE',
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_pj_status (status, criado_em),
  CONSTRAINT fk_pj_sessao FOREIGN KEY (id_sessao_usuario) REFERENCES sessao_usuario(id_sessao_usuario),
  CONSTRAINT fk_pj_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_pj_local FOREIGN KEY (id_local_operacional) REFERENCES local_operacional(id_local_operacional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   6) MÓDULOS CONGELADOS (MODELADOS NO BANCO)
   (Chamados/GLPI, Totem, Plantão/Escala, Gasoterapia, Assist. Social, Notificação,
    Viatura/Remoção/SAMU)
   ========================================================== */

-- Chamados / GLPI
CREATE TABLE chamado (
  id_chamado BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_sistema BIGINT NOT NULL,
  area_responsavel ENUM('TI','MANUTENCAO','ENG_CLINICA','GASOTERAPIA','OUTRA') NOT NULL,
  prioridade ENUM('BAIXA','MEDIA','ALTA','CRITICA') NOT NULL DEFAULT 'MEDIA',
  status ENUM('ABERTO','ENVIADO_GLPI','EM_ATENDIMENTO','AGUARDANDO','RESOLVIDO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  titulo VARCHAR(150) NOT NULL,
  descricao TEXT NULL,
  id_usuario_abertura BIGINT NOT NULL,
  id_usuario_atribuido BIGINT NULL,
  glpi_ticket_id BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_ch_area_status (area_responsavel, status),
  KEY idx_ch_glpi (glpi_ticket_id),
  CONSTRAINT fk_ch_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_ch_sistema FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema),
  CONSTRAINT fk_ch_user_abertura FOREIGN KEY (id_usuario_abertura) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_ch_user_atr FOREIGN KEY (id_usuario_atribuido) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE chamado_evento (
  id_chamado_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_chamado BIGINT NOT NULL,
  evento VARCHAR(80) NOT NULL,
  detalhe TEXT NULL,
  id_usuario BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_chev_chamado (id_chamado),
  CONSTRAINT fk_chev_chamado FOREIGN KEY (id_chamado) REFERENCES chamado(id_chamado),
  CONSTRAINT fk_chev_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Totem
CREATE TABLE totem (
  id_totem BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  codigo VARCHAR(50) NOT NULL,
  descricao VARCHAR(150) NULL,
  ip VARCHAR(45) NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_totem (id_unidade, codigo),
  CONSTRAINT fk_totem_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE totem_evento (
  id_totem_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_totem BIGINT NOT NULL,
  evento ENUM('ONLINE','OFFLINE','EMITIU_SENHA','ERRO') NOT NULL,
  detalhe TEXT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_te_totem (id_totem),
  CONSTRAINT fk_te_totem FOREIGN KEY (id_totem) REFERENCES totem(id_totem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Plantão / Escala (banner do totem)
CREATE TABLE plantao_modelo (
  id_plantao_modelo BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  inicio TIME NOT NULL,
  fim TIME NOT NULL,
  atravessa_dia TINYINT(1) DEFAULT 0,
  horas_previstas DECIMAL(5,2) NULL,
  ativo TINYINT(1) DEFAULT 1,
  UNIQUE KEY uk_pm_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE escala_plantao (
  id_escala BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_sistema BIGINT NOT NULL,
  data DATE NOT NULL,
  id_plantao_modelo BIGINT NOT NULL,
  observacao VARCHAR(255) NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_escala_data (id_unidade, data),
  CONSTRAINT fk_esc_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_esc_sistema FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema),
  CONSTRAINT fk_esc_pm FOREIGN KEY (id_plantao_modelo) REFERENCES plantao_modelo(id_plantao_modelo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE escala_profissional (
  id_escala BIGINT NOT NULL,
  id_usuario BIGINT NOT NULL,
  funcao ENUM('MEDICO','ENFERMEIRO','TECNICO','RECEPCAO','TI','OUTRA') NOT NULL,
  inicio_real DATETIME NULL,
  fim_real DATETIME NULL,
  ativo TINYINT(1) DEFAULT 1,
  PRIMARY KEY (id_escala, id_usuario),
  CONSTRAINT fk_ep_escala FOREIGN KEY (id_escala) REFERENCES escala_plantao(id_escala),
  CONSTRAINT fk_ep_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Gasoterapia (mínimo)
CREATE TABLE gaso_solicitacao (
  id_solicitacao BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_ffa BIGINT NULL,
  id_paciente BIGINT NULL,
  status ENUM('ABERTA','EM_ATENDIMENTO','FINALIZADA','CANCELADA') NOT NULL DEFAULT 'ABERTA',
  descricao TEXT NULL,
  id_usuario_abertura BIGINT NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_gaso_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_gaso_ffa FOREIGN KEY (id_ffa) REFERENCES ffa(id_ffa),
  CONSTRAINT fk_gaso_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_gaso_user FOREIGN KEY (id_usuario_abertura) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE gaso_evento (
  id_gaso_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_solicitacao BIGINT NOT NULL,
  evento VARCHAR(80) NOT NULL,
  detalhe TEXT NULL,
  id_usuario BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ge_solic FOREIGN KEY (id_solicitacao) REFERENCES gaso_solicitacao(id_solicitacao),
  CONSTRAINT fk_ge_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Assistência social / Sala de notificação
CREATE TABLE prioridade_social (
  id_prioridade BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(50) NOT NULL,
  descricao VARCHAR(150) NULL,
  ativo TINYINT(1) DEFAULT 1,
  UNIQUE KEY uk_prs_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE assistencia_social_atendimento (
  id_atendimento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_ffa BIGINT NULL,
  id_paciente BIGINT NULL,
  id_prioridade BIGINT NULL,
  descricao TEXT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_asa_ffa FOREIGN KEY (id_ffa) REFERENCES ffa(id_ffa),
  CONSTRAINT fk_asa_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente),
  CONSTRAINT fk_asa_prs FOREIGN KEY (id_prioridade) REFERENCES prioridade_social(id_prioridade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE sala_notificacao (
  id_notificacao BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_ffa BIGINT NULL,
  id_paciente BIGINT NULL,
  tipo VARCHAR(80) NOT NULL,
  descricao TEXT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sn_ffa FOREIGN KEY (id_ffa) REFERENCES ffa(id_ffa),
  CONSTRAINT fk_sn_paciente FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Viatura / Remoção (SAMU como origem de senha; remoção vinculável à senha/FFA)
CREATE TABLE viatura (
  id_viatura BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(30) NOT NULL,
  placa VARCHAR(15) NULL,
  tipo ENUM('AMBULANCIA','CARRO','MOTO','OUTRO') NOT NULL DEFAULT 'AMBULANCIA',
  ativo TINYINT(1) DEFAULT 1,
  UNIQUE KEY uk_viatura_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE remocao (
  id_remocao BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_viatura BIGINT NULL,
  id_senha BIGINT NULL,
  id_ffa BIGINT NULL,
  destino VARCHAR(150) NULL,
  condutor_interno BIGINT NULL,
  condutor_externo VARCHAR(150) NULL,
  status ENUM('ABERTA','EM_ANDAMENTO','FINALIZADA','CANCELADA') NOT NULL DEFAULT 'ABERTA',
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_rem_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_rem_viatura FOREIGN KEY (id_viatura) REFERENCES viatura(id_viatura),
  CONSTRAINT fk_rem_senha FOREIGN KEY (id_senha) REFERENCES senhas(id_senha),
  CONSTRAINT fk_rem_ffa FOREIGN KEY (id_ffa) REFERENCES ffa(id_ffa),
  CONSTRAINT fk_rem_condutor_int FOREIGN KEY (condutor_interno) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE remocao_evento (
  id_remocao_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_remocao BIGINT NOT NULL,
  evento VARCHAR(80) NOT NULL,
  detalhe TEXT NULL,
  id_usuario BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_re_remocao FOREIGN KEY (id_remocao) REFERENCES remocao(id_remocao),
  CONSTRAINT fk_re_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   7) VIEWS V2 (fonte da verdade)
   ========================================================== */

CREATE OR REPLACE VIEW vw_usuario_perfis_v2 AS
SELECT
  u.id_usuario,
  u.nome,
  u.login,
  us.id_sistema,
  s.codigo AS sistema_codigo,
  us.id_perfil,
  p.codigo AS perfil_codigo,
  p.nome   AS perfil_nome
FROM usuario u
JOIN usuario_sistema us ON us.id_usuario = u.id_usuario AND us.ativo = 1
JOIN sistema s ON s.id_sistema = us.id_sistema
JOIN perfil  p ON p.id_perfil  = us.id_perfil
WHERE u.ativo = 1;

CREATE OR REPLACE VIEW vw_usuario_permissoes_v2 AS
SELECT
  u.id_usuario,
  us.id_sistema,
  perm.codigo AS permissao
FROM usuario u
JOIN usuario_sistema us ON us.id_usuario = u.id_usuario AND us.ativo = 1
JOIN perfil_permissao pp ON pp.id_perfil = us.id_perfil AND pp.ativo = 1
JOIN permissao perm ON perm.id_permissao = pp.id_permissao AND perm.ativo = 1
WHERE u.ativo = 1;

CREATE OR REPLACE VIEW vw_usuario_contextos_v2 AS
SELECT
  u.id_usuario,
  lo.id_local_operacional,
  lo.id_unidade,
  lo.id_sistema,
  lo.codigo AS local_codigo,
  lo.nome   AS local_nome,
  lo.tipo   AS local_tipo
FROM usuario u
JOIN usuario_local_operacional ulo ON ulo.id_usuario = u.id_usuario AND ulo.ativo = 1
JOIN local_operacional lo ON lo.id_local_operacional = ulo.id_local_operacional AND lo.ativo = 1
WHERE u.ativo = 1;

/* ==========================================================
   8) FUNCTIONS + SPs NÚCLEO (mínimo para operar e demonstrar)
   ========================================================== */

DELIMITER $$

CREATE FUNCTION fn_idade_meses(p_data_nasc DATE)
RETURNS INT
DETERMINISTIC
BEGIN
  IF p_data_nasc IS NULL THEN RETURN NULL; END IF;
  RETURN TIMESTAMPDIFF(MONTH, p_data_nasc, CURDATE());
END$$

CREATE PROCEDURE sp_sessao_abrir(
  IN p_id_usuario BIGINT,
  IN p_id_sistema BIGINT,
  IN p_id_unidade BIGINT,
  IN p_id_local_operacional BIGINT,
  IN p_ip VARCHAR(45),
  IN p_user_agent VARCHAR(255)
)
BEGIN
  INSERT INTO sessao_usuario(id_usuario,id_sistema,id_unidade,id_local_operacional,ip,user_agent)
  VALUES(p_id_usuario,p_id_sistema,p_id_unidade,p_id_local_operacional,p_ip,p_user_agent);

  SELECT LAST_INSERT_ID() AS id_sessao_usuario;
END$$

CREATE PROCEDURE sp_sessao_encerrar(IN p_id_sessao_usuario BIGINT)
BEGIN
  UPDATE sessao_usuario
     SET encerrado_em = NOW(),
         ativo = 0
   WHERE id_sessao_usuario = p_id_sessao_usuario AND ativo = 1;
  SELECT ROW_COUNT() AS rows_updated;
END$$

-- Emissão de senha (TOTEM/RECEPCAO/ADMIN/SAMU) + cria entrada em fila_senha
CREATE PROCEDURE sp_emitir_senha(
  IN p_id_unidade BIGINT,
  IN p_lane ENUM('CLINICO','PEDIATRICO','PRIORITARIO'),
  IN p_origem ENUM('TOTEM','RECEPCAO','ADMIN','SAMU'),
  IN p_prioridade_declarada TINYINT
)
BEGIN
  DECLARE v_prefixo VARCHAR(5);
  DECLARE v_num INT;
  DECLARE v_codigo VARCHAR(12);

  SET v_prefixo = CASE p_lane
    WHEN 'CLINICO' THEN 'C'
    WHEN 'PEDIATRICO' THEN 'P'
    WHEN 'PRIORITARIO' THEN 'R'
    ELSE 'C'
  END;

  -- Sequência simples por unidade+prefixo (para demo). Em produção, trocar por tabela sequenciador por dia.
  SELECT IFNULL(MAX(numero),0) + 1 INTO v_num
    FROM senhas
   WHERE id_unidade = p_id_unidade AND prefixo = v_prefixo;

  SET v_codigo = CONCAT(v_prefixo, LPAD(v_num, 4, '0'));

  INSERT INTO senhas(id_unidade,codigo,numero,prefixo,lane,origem,prioridade_declarada)
  VALUES(p_id_unidade,v_codigo,v_num,v_prefixo,p_lane,p_origem,IFNULL(p_prioridade_declarada,0));

  INSERT INTO fila_senha(id_senha, lane_confirmada, status)
  VALUES(LAST_INSERT_ID(), p_lane, 'AGUARDANDO');

  SELECT
    (SELECT id_senha FROM senhas WHERE codigo=v_codigo AND id_unidade=p_id_unidade ORDER BY id_senha DESC LIMIT 1) AS id_senha,
    v_codigo AS senha;
END$$

-- Recepção: CHAMAR
CREATE PROCEDURE sp_recepcao_chamar(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_fila_senha BIGINT,
  IN p_local_chamada VARCHAR(50)
)
BEGIN
  DECLARE v_user BIGINT;
  DECLARE v_unidade BIGINT;
  DECLARE v_localop BIGINT;
  DECLARE v_old VARCHAR(50);

  SELECT id_usuario, id_unidade, id_local_operacional INTO v_user, v_unidade, v_localop
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao_usuario AND ativo=1;

  SELECT status INTO v_old FROM fila_senha WHERE id_fila_senha = p_id_fila_senha;

  UPDATE fila_senha
     SET status='CHAMANDO',
         local_chamada = p_local_chamada,
         id_usuario_chamada = v_user,
         chamado_em = NOW()
   WHERE id_fila_senha = p_id_fila_senha;

  INSERT INTO auditoria_evento(id_sessao_usuario,entity_type,entity_id,acao,de_local,para_local,de_status,para_status)
  VALUES(p_id_sessao_usuario,'FILA_SENHA',p_id_fila_senha,'CHAMAR',v_localop,v_localop,v_old,'CHAMANDO');

  -- Painel/voz (texto básico)
  INSERT INTO chamada_painel(id_unidade,id_local_operacional,texto,id_fila_senha)
  SELECT v_unidade, v_localop,
         CONCAT('Senha ', s.codigo, ' - ', IFNULL(p_local_chamada,'LOCAL')) AS texto,
         p_id_fila_senha
    FROM fila_senha fs
    JOIN senhas s ON s.id_senha = fs.id_senha
   WHERE fs.id_fila_senha = p_id_fila_senha;

  SELECT 1 AS ok;
END$$

-- Recepção: INICIAR COMPLEMENTAÇÃO
CREATE PROCEDURE sp_recepcao_iniciar_complementacao(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_fila_senha BIGINT
)
BEGIN
  DECLARE v_localop BIGINT;
  DECLARE v_old VARCHAR(50);

  SELECT id_local_operacional INTO v_localop
    FROM sessao_usuario WHERE id_sessao_usuario=p_id_sessao_usuario AND ativo=1;

  SELECT status INTO v_old FROM fila_senha WHERE id_fila_senha=p_id_fila_senha;

  UPDATE fila_senha SET status='EM_COMPLEMENTACAO' WHERE id_fila_senha=p_id_fila_senha;

  INSERT INTO auditoria_evento(id_sessao_usuario,entity_type,entity_id,acao,de_local,para_local,de_status,para_status)
  VALUES(p_id_sessao_usuario,'FILA_SENHA',p_id_fila_senha,'INICIAR_COMPLEMENTACAO',v_localop,v_localop,v_old,'EM_COMPLEMENTACAO');

  SELECT 1 AS ok;
END$$

-- Recepção: SALVAR COMPLEMENTAÇÃO (cria pessoa/paciente se necessário; abre FFA; cria print_job)
CREATE PROCEDURE sp_recepcao_salvar_complementacao(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_fila_senha BIGINT,
  IN p_nome VARCHAR(150),
  IN p_data_nascimento DATE,
  IN p_lane_confirmada ENUM('CLINICO','PEDIATRICO','PRIORITARIO'),
  IN p_prioridade_confirmada ENUM('NAO','IDOSO','GESTANTE','ESPECIAL','AUTISTA','OUTRA')
)
BEGIN
  DECLARE v_meses INT;
  DECLARE v_user BIGINT;
  DECLARE v_unidade BIGINT;
  DECLARE v_localop BIGINT;
  DECLARE v_id_pessoa BIGINT;
  DECLARE v_id_paciente BIGINT;
  DECLARE v_id_ffa BIGINT;

  SELECT id_usuario,id_unidade,id_local_operacional INTO v_user,v_unidade,v_localop
    FROM sessao_usuario WHERE id_sessao_usuario=p_id_sessao_usuario AND ativo=1;

  -- valida pediátrico por idade: pedi se < 12 anos (144 meses). Ajustável depois por configuração.
  SET v_meses = fn_idade_meses(p_data_nascimento);
  IF p_lane_confirmada = 'PEDIATRICO' AND v_meses IS NOT NULL AND v_meses >= 144 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Inconsistência: lane PEDIÁTRICO, mas idade indica ADULTO. Corrija antes de salvar.';
  END IF;
  IF p_lane_confirmada <> 'PEDIATRICO' AND v_meses IS NOT NULL AND v_meses < 144 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Inconsistência: lane ADULTO/PRIORITÁRIO, mas idade indica PEDIÁTRICO. Corrija antes de salvar.';
  END IF;

  INSERT INTO pessoa(nome_completo,data_nascimento) VALUES(p_nome,p_data_nascimento);
  SET v_id_pessoa = LAST_INSERT_ID();

  INSERT INTO paciente(id_pessoa, prontuario) VALUES(v_id_pessoa, NULL);
  SET v_id_paciente = LAST_INSERT_ID();

  UPDATE fila_senha
     SET id_paciente = v_id_paciente,
         lane_confirmada = p_lane_confirmada,
         prioridade_confirmada = p_prioridade_confirmada,
         status = 'ENCAMINHADO'
   WHERE id_fila_senha = p_id_fila_senha;

  INSERT INTO ffa(id_paciente,id_fila_senha,status)
  VALUES(v_id_paciente,p_id_fila_senha,'ABERTO');
  SET v_id_ffa = LAST_INSERT_ID();

  INSERT INTO auditoria_evento(id_sessao_usuario,entity_type,entity_id,acao,de_local,para_local,para_status,detalhe_json)
  VALUES(p_id_sessao_usuario,'FFA',v_id_ffa,'ABRIR_FFA',v_localop,v_localop,'ABERTO',
         JSON_OBJECT('id_fila_senha',p_id_fila_senha,'id_paciente',v_id_paciente,'lane',p_lane_confirmada,'prioridade',p_prioridade_confirmada));

  -- impressão automática pós-salvar (base; templates você configura depois)
  INSERT INTO print_job(id_sessao_usuario,id_unidade,id_local_operacional,entity_type,entity_id,template_code)
  VALUES(p_id_sessao_usuario,v_unidade,v_localop,'FFA',v_id_ffa,'RECEPCAO_COMPLEMENTACAO');

  INSERT INTO auditoria_evento(id_sessao_usuario,entity_type,entity_id,acao,de_local,para_local,detalhe_json)
  VALUES(p_id_sessao_usuario,'IMPRESSAO',NULL,'CRIAR_PRINT_JOB',v_localop,v_localop,
         JSON_OBJECT('entity_type','FFA','entity_id',v_id_ffa,'template','RECEPCAO_COMPLEMENTACAO'));

  SELECT v_id_paciente AS id_paciente, v_id_ffa AS id_ffa;
END$$

DELIMITER ;

/* ==========================================================
   9) SEED de teste (ADMIN + contexto mínimo)
   ========================================================== */

-- Sistemas básicos
INSERT INTO sistema(codigo,nome) VALUES
('PA','Pronto Atendimento'),
('TI','Tecnologia da Informação'),
('MANUTENCAO','Manutenção'),
('FARMACIA_PA','Farmácia PA');

-- Unidade
INSERT INTO unidade(codigo,nome) VALUES ('ALPHA','Instituto Alpha');

-- Perfis básicos
INSERT INTO perfil(codigo,nome) VALUES
('ADMIN_MASTER','Administrador Master'),
('RECEPCAO','Recepção'),
('TRIAGEM','Triagem'),
('MEDICO','Médico'),
('FARMACEUTICO','Farmacêutico');

-- Permissões mínimas (exemplo; ampliar depois)
INSERT INTO permissao(codigo,descricao) VALUES
('LOGIN','Pode autenticar'),
('ABRIR_SESSAO','Abrir sessão operacional'),
('CHAMAR_SENHA','Chamar senha'),
('COMPLEMENTAR','Complementar atendimento'),
('ENCAMINHAR','Encaminhar'),
('REABRIR_FFA','Reabrir FFA');

-- Vincular permissões ao ADMIN_MASTER
INSERT INTO perfil_permissao(id_perfil,id_permissao)
SELECT p.id_perfil, perm.id_permissao
  FROM perfil p
 CROSS JOIN permissao perm
 WHERE p.codigo='ADMIN_MASTER';

-- Usuário admin de teste
-- Senha padrão: admin123 (HASH PLACEHOLDER). Trocar para hash real no backend (bcrypt).
INSERT INTO usuario(nome,login,senha_hash) VALUES ('Admin','admin','admin123');

-- Vínculo admin ao sistema PA
INSERT INTO usuario_sistema(id_usuario,id_sistema,id_perfil)
SELECT u.id_usuario, s.id_sistema, p.id_perfil
  FROM usuario u, sistema s, perfil p
 WHERE u.login='admin' AND s.codigo='PA' AND p.codigo='ADMIN_MASTER';

-- Locais operacionais mínimos (PA)
INSERT INTO local_operacional(id_unidade,id_sistema,codigo,nome,tipo,sala) VALUES
((SELECT id_unidade FROM unidade WHERE codigo='ALPHA'),
 (SELECT id_sistema FROM sistema WHERE codigo='PA'),
 'RECEP','Recepção','RECEPCAO','Guichê'),
((SELECT id_unidade FROM unidade WHERE codigo='ALPHA'),
 (SELECT id_sistema FROM sistema WHERE codigo='PA'),
 'TRIAG','Triagem','TRIAGEM','Sala 1'),
((SELECT id_unidade FROM unidade WHERE codigo='ALPHA'),
 (SELECT id_sistema FROM sistema WHERE codigo='PA'),
 'MEDC','Médico Clínico','MEDICO_CLINICO','Consultório 1'),
((SELECT id_unidade FROM unidade WHERE codigo='ALPHA'),
 (SELECT id_sistema FROM sistema WHERE codigo='PA'),
 'MEDP','Médico Pediátrico','MEDICO_PEDIATRICO','Consultório 2');

-- Admin tem acesso aos locais
INSERT INTO usuario_local_operacional(id_usuario,id_local_operacional)
SELECT (SELECT id_usuario FROM usuario WHERE login='admin'), lo.id_local_operacional
  FROM local_operacional lo;

SET FOREIGN_KEY_CHECKS = 1;
