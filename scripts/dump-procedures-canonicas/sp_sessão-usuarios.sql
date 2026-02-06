SET NAMES utf8mb4;

-- ==========================================================
-- 1) Persistir ÚLTIMO CONTEXTO escolhido (para o front já entrar certo)
--    (não substitui sessao_usuario; complementa)
-- ==========================================================
CREATE TABLE IF NOT EXISTS usuario_contexto (
  id_usuario BIGINT NOT NULL,
  id_sistema BIGINT NOT NULL,
  id_unidade BIGINT NOT NULL,
  id_local_operacional BIGINT NOT NULL,
  id_perfil INT NULL,
  atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_sistema),
  KEY idx_uc_unidade_local (id_unidade, id_local_operacional),
  KEY idx_uc_perfil (id_perfil),
  CONSTRAINT fk_uc_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_uc_sistema FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema),
  CONSTRAINT fk_uc_unidade FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  CONSTRAINT fk_uc_localop FOREIGN KEY (id_local_operacional) REFERENCES local_operacional(id_local_operacional)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================================
-- 2) Views v2 mínimas (sem depender de colunas "codigo/nome" que variam)
-- ==========================================================
CREATE OR REPLACE VIEW vw_usuario_perfis_v2 AS
SELECT
  us.id_usuario,
  us.id_sistema,
  us.id_perfil
FROM usuario_sistema us;

CREATE OR REPLACE VIEW vw_perfil_permissoes_v2 AS
SELECT
  pp.id_perfil,
  p.id_permissao,
  p.codigo AS permissao_codigo
FROM perfil_permissao pp
JOIN permissao p ON p.id_permissao = pp.id_permissao;

-- ==========================================================
-- 3) Functions v2 (fonte da verdade = usuario_sistema)
-- ==========================================================
DROP FUNCTION IF EXISTS fn_usuario_tem_perfil_id_v2;
DELIMITER $$
CREATE FUNCTION fn_usuario_tem_perfil_id_v2(
  p_id_usuario BIGINT,
  p_id_sistema BIGINT,
  p_id_perfil  INT
) RETURNS TINYINT
DETERMINISTIC
BEGIN
  DECLARE v_qtd INT DEFAULT 0;

  SELECT COUNT(*)
    INTO v_qtd
    FROM usuario_sistema us
   WHERE us.id_usuario = p_id_usuario
     AND us.id_sistema = p_id_sistema
     AND us.id_perfil  = p_id_perfil;

  RETURN IF(v_qtd > 0, 1, 0);
END$$
DELIMITER ;

DROP FUNCTION IF EXISTS fn_usuario_tem_permissao_v2;
DELIMITER $$
CREATE FUNCTION fn_usuario_tem_permissao_v2(
  p_id_usuario BIGINT,
  p_id_sistema BIGINT,
  p_codigo_permissao VARCHAR(80)
) RETURNS TINYINT
DETERMINISTIC
BEGIN
  DECLARE v_qtd INT DEFAULT 0;

  SELECT COUNT(*)
    INTO v_qtd
    FROM usuario_sistema us
    JOIN perfil_permissao pp ON pp.id_perfil = us.id_perfil
    JOIN permissao p         ON p.id_permissao = pp.id_permissao
   WHERE us.id_usuario = p_id_usuario
     AND us.id_sistema = p_id_sistema
     AND p.codigo      = p_codigo_permissao;

  RETURN IF(v_qtd > 0, 1, 0);
END$$
DELIMITER ;

-- ==========================================================
-- 4) Procedures v2 (sessão + auditoria)
-- ==========================================================
DROP PROCEDURE IF EXISTS sp_sessao_usuario_abrir_v2;
DELIMITER $$
CREATE PROCEDURE sp_sessao_usuario_abrir_v2(
  IN  p_id_usuario BIGINT,
  IN  p_id_sistema BIGINT,
  IN  p_id_unidade BIGINT,
  IN  p_id_local_operacional BIGINT,
  IN  p_sid_refresh BIGINT,
  IN  p_ip VARCHAR(45),
  IN  p_user_agent VARCHAR(255),
  IN  p_id_perfil INT,
  OUT p_id_sessao_usuario BIGINT
)
BEGIN
  -- encerra sessões ativas antigas (mesmo usuário + mesmo contexto) para não duplicar
  UPDATE sessao_usuario
     SET encerrado_em = NOW(),
         ativo = 0
   WHERE id_usuario = p_id_usuario
     AND id_sistema = p_id_sistema
     AND id_unidade = p_id_unidade
     AND id_local_operacional = p_id_local_operacional
     AND ativo = 1
     AND encerrado_em IS NULL;

  INSERT INTO sessao_usuario (
    id_usuario, id_sistema, id_unidade, id_local_operacional,
    sid_refresh, ip, user_agent, iniciado_em, ativo
  ) VALUES (
    p_id_usuario, p_id_sistema, p_id_unidade, p_id_local_operacional,
    p_sid_refresh, p_ip, p_user_agent, NOW(), 1
  );

  SET p_id_sessao_usuario = LAST_INSERT_ID();

  -- salva "último contexto" (para o front reabrir direto)
  INSERT INTO usuario_contexto (
    id_usuario, id_sistema, id_unidade, id_local_operacional, id_perfil, atualizado_em
  ) VALUES (
    p_id_usuario, p_id_sistema, p_id_unidade, p_id_local_operacional, p_id_perfil, NOW()
  )
  ON DUPLICATE KEY UPDATE
    id_unidade = VALUES(id_unidade),
    id_local_operacional = VALUES(id_local_operacional),
    id_perfil = VALUES(id_perfil),
    atualizado_em = NOW();

  -- auditoria
  INSERT INTO auditoria_evento (
    id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em
  ) VALUES (
    p_id_sessao_usuario, 'SESSAO', p_id_sessao_usuario, 'ABRIR',
    CONCAT('Sessão aberta. sistema=',p_id_sistema,' unidade=',p_id_unidade,' local=',p_id_local_operacional),
    NOW()
  );
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_sessao_usuario_encerrar_v2;
DELIMITER $$
CREATE PROCEDURE sp_sessao_usuario_encerrar_v2(
  IN p_id_sessao_usuario BIGINT,
  IN p_id_usuario BIGINT,
  IN p_motivo VARCHAR(120)
)
BEGIN
  UPDATE sessao_usuario
     SET encerrado_em = NOW(),
         ativo = 0
   WHERE id_sessao_usuario = p_id_sessao_usuario
     AND id_usuario = p_id_usuario
     AND ativo = 1
     AND encerrado_em IS NULL;

  INSERT INTO auditoria_evento (
    id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em
  ) VALUES (
    p_id_sessao_usuario, 'SESSAO', p_id_sessao_usuario, 'ENCERRAR',
    IFNULL(p_motivo,'Encerramento manual'),
    NOW()
  );
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_auditoria_evento_registrar_v2;
DELIMITER $$
CREATE PROCEDURE sp_auditoria_evento_registrar_v2(
  IN p_id_sessao_usuario BIGINT,
  IN p_entidade VARCHAR(80),
  IN p_id_entidade BIGINT,
  IN p_acao VARCHAR(80),
  IN p_detalhe TEXT
)
BEGIN
  INSERT INTO auditoria_evento (
    id_sessao_usuario, entidade, id_entidade, acao, detalhe, criado_em
  ) VALUES (
    p_id_sessao_usuario, p_entidade, p_id_entidade, p_acao, p_detalhe, NOW()
  );
END$$
DELIMITER ;
