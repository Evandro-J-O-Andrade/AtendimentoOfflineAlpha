/*
HIS/PA - Extensões (núcleo + módulos essenciais)
Data: 2026-01-21

Princípios (já alinhados no projeto):
- "Senha" (fila_senha) é entidade primária do PA; paciente/FFA vem depois.
- Painéis são somente leitura; chamadas são sempre manuais (eventos).
- Banco (VW/SP/FN/TRG) é a fonte da verdade; front apenas reflete.
- Tabela `setor` permanece ASSISTENCIAL (leitos/obs/internação/UTI).
- `sistema` representa CONTEXTO OPERACIONAL (PA, UBS, FARMACIA..., TI, MANUTENCAO...).
- `usuario_sistema` é a fonte da verdade de perfis.

Este script é aditivo: usa IF NOT EXISTS e não remove estruturas legadas.
*/

SET NAMES utf8mb4;

/* ==========================================================
   1) CONTEXTO OPERACIONAL POR SESSÃO (fonte p/ auditoria)
   ========================================================== */

CREATE TABLE IF NOT EXISTS local_operacional (
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
  KEY idx_localop_sistema (id_sistema)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vínculo de usuário a locais operacionais (opcional; pode coexistir com usuario_alocacao legado)
CREATE TABLE IF NOT EXISTS usuario_local_operacional (
  id_usuario BIGINT NOT NULL,
  id_local_operacional BIGINT NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_local_operacional),
  KEY idx_ulo_local (id_local_operacional),
  CONSTRAINT fk_ulo_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_ulo_localop FOREIGN KEY (id_local_operacional) REFERENCES local_operacional(id_local_operacional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sessão operacional (substitui/convive com sessao legado; ideal para auditoria/relatórios)
CREATE TABLE IF NOT EXISTS sessao_usuario (
  id_sessao_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_usuario BIGINT NOT NULL,
  id_sistema BIGINT NOT NULL,
  id_unidade BIGINT NOT NULL,
  id_local_operacional BIGINT NOT NULL,
  sid_refresh BIGINT NULL COMMENT 'Opcional: correlaciona com usuario_refresh.id_refresh',
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
   2) PERMISSÕES (perfil -> permissao) e auditoria base
   ========================================================== */

CREATE TABLE IF NOT EXISTS permissao (
  id_permissao BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(80) NOT NULL,
  descricao VARCHAR(255) NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_perm_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS perfil_permissao (
  id_perfil INT NOT NULL,
  id_permissao BIGINT NOT NULL,
  ativo TINYINT(1) DEFAULT 1,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_perfil, id_permissao),
  CONSTRAINT fk_pp_perfil FOREIGN KEY (id_perfil) REFERENCES perfil(id_perfil),
  CONSTRAINT fk_pp_perm FOREIGN KEY (id_permissao) REFERENCES permissao(id_permissao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Auditoria genérica orientada a sessão (imutável, alta cardinalidade)
CREATE TABLE IF NOT EXISTS auditoria_evento (
  id_auditoria BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_sessao_usuario BIGINT NULL,
  entidade VARCHAR(80) NOT NULL,
  id_entidade BIGINT NULL,
  acao VARCHAR(80) NOT NULL,
  detalhe TEXT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_aud_sessao (id_sessao_usuario),
  KEY idx_aud_entidade (entidade, id_entidade),
  CONSTRAINT fk_aud_sessao FOREIGN KEY (id_sessao_usuario) REFERENCES sessao_usuario(id_sessao_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   3) CHAMADOS (TI / Manutenção / Eng. Clínica / Gasoterapia) + integração GLPI
   ========================================================== */

CREATE TABLE IF NOT EXISTS chamado (
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

CREATE TABLE IF NOT EXISTS chamado_evento (
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

/* ==========================================================
   4) TOTEM (dispositivo + emissão de senha + auditoria)
   ========================================================== */

CREATE TABLE IF NOT EXISTS totem (
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

CREATE TABLE IF NOT EXISTS totem_evento (
  id_totem_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_totem BIGINT NOT NULL,
  evento ENUM('ONLINE','OFFLINE','EMITIU_SENHA','ERRO') NOT NULL,
  detalhe TEXT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_te_totem (id_totem),
  CONSTRAINT fk_te_totem FOREIGN KEY (id_totem) REFERENCES totem(id_totem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   5) PLANTÃO / ESCALA (base para "gestão" e PA)
   ========================================================== */

CREATE TABLE IF NOT EXISTS plantao_modelo (
  id_plantao_modelo BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  inicio TIME NOT NULL,
  fim TIME NOT NULL,
  atravessa_dia TINYINT(1) DEFAULT 0,
  horas_previstas DECIMAL(5,2) NULL,
  ativo TINYINT(1) DEFAULT 1,
  UNIQUE KEY uk_pm_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS escala_plantao (
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

CREATE TABLE IF NOT EXISTS escala_profissional (
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

/* ==========================================================
   6) GASOTERAPIA (base para solicitações e rastreio)
   ========================================================== */

CREATE TABLE IF NOT EXISTS gaso_solicitacao (
  id_gaso BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_senha BIGINT NULL,
  id_ffa BIGINT NULL,
  tipo ENUM('CILINDRO','REDE','MANUTENCAO','OUTRO') NOT NULL DEFAULT 'OUTRO',
  status ENUM('ABERTO','EM_ATENDIMENTO','ENTREGUE','CANCELADO','FINALIZADO') NOT NULL DEFAULT 'ABERTO',
  local_destino VARCHAR(150) NULL,
  observacao TEXT NULL,
  id_usuario_abertura BIGINT NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_gaso_status (status),
  CONSTRAINT fk_gaso_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_gaso_user FOREIGN KEY (id_usuario_abertura) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS gaso_evento (
  id_gaso_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_gaso BIGINT NOT NULL,
  evento VARCHAR(80) NOT NULL,
  detalhe TEXT NULL,
  id_usuario BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ge_gaso (id_gaso),
  CONSTRAINT fk_ge_gaso FOREIGN KEY (id_gaso) REFERENCES gaso_solicitacao(id_gaso),
  CONSTRAINT fk_ge_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   7) SAMU / REMOÇÃO (senha especial rastreável)
   ========================================================== */

CREATE TABLE IF NOT EXISTS viatura (
  id_viatura BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  prefixo VARCHAR(30) NOT NULL,
  tipo ENUM('AMBULANCIA_BASICA','AMBULANCIA_AVANCADA','OUTRO') NOT NULL DEFAULT 'OUTRO',
  ativo TINYINT(1) DEFAULT 1,
  UNIQUE KEY uk_viatura (id_unidade, prefixo),
  CONSTRAINT fk_viatura_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS remocao (
  id_remocao BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_senha BIGINT NULL,
  id_ffa BIGINT NULL,
  origem VARCHAR(150) NULL,
  destino VARCHAR(150) NULL,
  motivo VARCHAR(255) NULL,
  status ENUM('SOLICITADA','AUTORIZADA','EM_TRANSITO','CONCLUIDA','CANCELADA') NOT NULL DEFAULT 'SOLICITADA',
  id_viatura BIGINT NULL,
  condutor_interno VARCHAR(150) NULL,
  condutor_externo VARCHAR(150) NULL,
  protocolo_cross VARCHAR(50) NULL,
  id_usuario_solicitante BIGINT NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_rem_status (status),
  CONSTRAINT fk_rem_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_rem_viatura FOREIGN KEY (id_viatura) REFERENCES viatura(id_viatura),
  CONSTRAINT fk_rem_user FOREIGN KEY (id_usuario_solicitante) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS remocao_evento (
  id_remocao_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_remocao BIGINT NOT NULL,
  evento VARCHAR(80) NOT NULL,
  detalhe TEXT NULL,
  id_usuario BIGINT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_re_remocao (id_remocao),
  CONSTRAINT fk_re_remocao FOREIGN KEY (id_remocao) REFERENCES remocao(id_remocao),
  CONSTRAINT fk_re_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   8) ASSISTÊNCIA SOCIAL / SALA DE NOTIFICAÇÃO (base)
   ========================================================== */

CREATE TABLE IF NOT EXISTS assistencia_social_atendimento (
  id_as BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_senha BIGINT NULL,
  id_ffa BIGINT NULL,
  status ENUM('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  motivo VARCHAR(255) NULL,
  relato TEXT NULL,
  id_usuario_abertura BIGINT NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_as_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_as_user FOREIGN KEY (id_usuario_abertura) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sala_notificacao (
  id_notificacao BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_senha BIGINT NULL,
  id_ffa BIGINT NULL,
  tipo ENUM('VIOLENCIA','AGRAVO','OUTRO') NOT NULL DEFAULT 'OUTRO',
  status ENUM('ABERTO','EM_ATENDIMENTO','FINALIZADO','CANCELADO') NOT NULL DEFAULT 'ABERTO',
  detalhes TEXT NULL,
  id_usuario_abertura BIGINT NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_sn_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_sn_user FOREIGN KEY (id_usuario_abertura) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/* ==========================================================
   9) PRODUTIVIDADE MÉDICA (tempo real via eventos)
   ========================================================== */

-- Tabela de eventos de produtividade (alimentada por SP/TRG nos pontos-chave)
CREATE TABLE IF NOT EXISTS produtividade_evento (
  id_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
  id_unidade BIGINT NOT NULL,
  id_usuario BIGINT NOT NULL,
  tipo ENUM('INICIO_ATENDIMENTO','FIM_ATENDIMENTO','EVOLUCAO','PRESCRICAO','ENCAMINHAMENTO','OUTRO') NOT NULL,
  id_ffa BIGINT NULL,
  id_senha BIGINT NULL,
  ocorrido_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  detalhe VARCHAR(255) NULL,
  KEY idx_pe_user_time (id_usuario, ocorrido_em),
  KEY idx_pe_tipo_time (tipo, ocorrido_em),
  CONSTRAINT fk_pe_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_pe_user FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- View simples de produtividade diária (ajuste conforme seu modelo de eventos real)
CREATE OR REPLACE VIEW vw_produtividade_medica_diaria AS
SELECT
  pe.id_unidade,
  pe.id_usuario,
  DATE(pe.ocorrido_em) AS dia,
  SUM(CASE WHEN pe.tipo = 'INICIO_ATENDIMENTO' THEN 1 ELSE 0 END) AS atendimentos_iniciados,
  SUM(CASE WHEN pe.tipo = 'FIM_ATENDIMENTO' THEN 1 ELSE 0 END) AS atendimentos_finalizados,
  SUM(CASE WHEN pe.tipo = 'EVOLUCAO' THEN 1 ELSE 0 END) AS evolucoes,
  SUM(CASE WHEN pe.tipo = 'PRESCRICAO' THEN 1 ELSE 0 END) AS prescricoes
FROM produtividade_evento pe
GROUP BY pe.id_unidade, pe.id_usuario, DATE(pe.ocorrido_em);

/* ==========================================================
   10) NOTAS DE MIGRAÇÃO (não executável)
   ========================================================== */
-- 1) Popular `local_operacional` usando seus `local_atendimento` atuais (por unidade + sistema).
-- 2) Alterar o fluxo do front: após login, selecionar (sistema, unidade, local_operacional) -> criar `sessao_usuario`.
-- 3) Amarrar inserções relevantes em `auditoria_evento` e `produtividade_evento` (via SP).
-- 4) Manter `sessao` legado apenas para compatibilidade; o novo núcleo deve usar `sessao_usuario`.
