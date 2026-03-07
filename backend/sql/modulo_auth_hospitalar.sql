-- ================================================================
-- MÓDULO AUTH HOSPITALAR COMPLETO
-- 12 Tabelas + 10 Stored Procedures
-- Sistema de Autenticação e Autorização Nível Hospitalar
-- ================================================================

USE `pronto_atendimento`;

-- ================================================================
-- PARTE 1: TABELAS (12 tabelas)
-- ================================================================

-- ------------------------------------------------------------
-- 1. auth_token - Tokens de autenticação
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_token`;

CREATE TABLE `auth_token` (
  `id_token` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `tipo_token` enum('ACCESS','REFRESH','RECOVERY','VERIFICATION') NOT NULL,
  `token_hash` varchar(255) NOT NULL,
  `ip_origem` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `expira_em` datetime NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `utilizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_token`),
  KEY `idx_token_usuario` (`id_usuario`),
  KEY `idx_token_hash` (`token_hash`),
  KEY `idx_token_expira` (`expira_em`),
  CONSTRAINT `fk_token_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 2. auth_sessao - Sessões ativas
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_sessao`;

CREATE TABLE `auth_sessao` (
  `id_sessao` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_unidade` bigint DEFAULT NULL,
  `id_local_operacional` bigint DEFAULT NULL,
  `id_perfil` bigint DEFAULT NULL,
  `token_sessao` varchar(255) NOT NULL,
  `ip_origem` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `dispositivo` varchar(100) DEFAULT NULL,
  `geo_localizacao` varchar(200) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `expira_em` datetime NOT NULL,
  `ultima_atividade` datetime DEFAULT CURRENT_TIMESTAMP,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sessao`),
  KEY `idx_sessao_usuario` (`id_usuario`),
  KEY `idx_sessao_token` (`token_sessao`),
  KEY `idx_sessao_expira` (`expira_em`),
  CONSTRAINT `fk_sessao_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 3. auth_log - Log de autenticação
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_log`;

CREATE TABLE `auth_log` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint DEFAULT NULL,
  `tipo_evento` enum('LOGIN_SUCESSO','LOGIN_FALHA','LOGOUT','SENHA_TROCA','SENHA_RESET','TOKEN_REFRESH','BLOQUEIO','DESBLOQUEIO','SESSAO_EXPIRADA') NOT NULL,
  `ip_origem` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `dispositivo` varchar(100) DEFAULT NULL,
  `localizacao` varchar(200) DEFAULT NULL,
  `mensagem` text DEFAULT NULL,
  `dados_extras` json DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`),
  KEY `idx_log_usuario` (`id_usuario`),
  KEY `idx_log_tipo` (`tipo_evento`),
  KEY `idx_log_data` (`criado_em`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 4. auth_tentativa_login - Tentativas de login
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_tentativa_login`;

CREATE TABLE `auth_tentativa_login` (
  `id_tentativa` bigint NOT NULL AUTO_INCREMENT,
  `login` varchar(80) NOT NULL,
  `ip_origem` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `sucesso` tinyint(1) NOT NULL DEFAULT '0',
  `motivo_falha` varchar(100) DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tentativa`),
  KEY `idx_tentativa_login` (`login`),
  KEY `idx_tentativa_ip` (`ip_origem`),
  KEY `idx_tentativa_data` (`criado_em`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 5. auth_bloqueio - Bloqueios de conta
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_bloqueio`;

CREATE TABLE `auth_bloqueio` (
  `id_bloqueio` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `tipo_bloqueio` enum('SENHA_EXPIRADA','TENTATIVAS_EXCEDIDAS','ADMINISTRATIVO','INATIVIDADE','FRAUDE') NOT NULL,
  `motivo` text NOT NULL,
  `bloqueado_por` bigint DEFAULT NULL,
  `expira_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `desbloqueado_por` bigint DEFAULT NULL,
  `desbloqueado_em` datetime DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_bloqueio`),
  KEY `idx_bloqueio_usuario` (`id_usuario`),
  KEY `idx_bloqueio_expira` (`expira_em`),
  CONSTRAINT `fk_bloqueio_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 6. auth_sessao_dispositivo - Dispositivos confiáveis
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_sessao_dispositivo`;

CREATE TABLE `auth_sessao_dispositivo` (
  `id_dispositivo_confiavel` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `dispositivo_hash` varchar(255) NOT NULL,
  `nome_dispositivo` varchar(100) DEFAULT NULL,
  `sistema_operacional` varchar(50) DEFAULT NULL,
  `navegador` varchar(50) DEFAULT NULL,
  `ultimo_ip` varchar(45) DEFAULT NULL,
  `ultimo_acesso` datetime DEFAULT CURRENT_TIMESTAMP,
  `primeiro_acesso` datetime DEFAULT CURRENT_TIMESTAMP,
  `confiavel` tinyint(1) DEFAULT '0',
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_dispositivo_confiavel`),
  KEY `idx_dispositivo_usuario` (`id_usuario`),
  KEY `idx_dispositivo_hash` (`dispositivo_hash`),
  CONSTRAINT `fk_dispositivo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 7. auth_grupo - Grupos de usuários
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_grupo`;

CREATE TABLE `auth_grupo` (
  `id_grupo` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `tipo_grupo` enum('SETOR','EQUIPE','PROJETO','REGIONAL') DEFAULT 'SETOR',
  `id_unidade` bigint DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_por` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo`),
  KEY `idx_grupo_unidade` (`id_unidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 8. auth_grupo_usuario - Associação usuário-grupo
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_grupo_usuario`;

CREATE TABLE `auth_grupo_usuario` (
  `id_grupo_usuario` bigint NOT NULL AUTO_INCREMENT,
  `id_grupo` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `papel` enum('MEMBRO','COORDENADOR','SUBCOORDENADOR') DEFAULT 'MEMBRO',
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo_usuario`),
  UNIQUE KEY `uk_grupo_usuario` (`id_grupo`, `id_usuario`),
  KEY `idx_grupo_usuario_usuario` (`id_usuario`),
  CONSTRAINT `fk_gu_grupo` FOREIGN KEY (`id_grupo`) REFERENCES `auth_grupo` (`id_grupo`) ON DELETE CASCADE,
  CONSTRAINT `fk_gu_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 9. auth_grupo_permissao - Permissões de grupo
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_grupo_permissao`;

CREATE TABLE `auth_grupo_permissao` (
  `id_grupo_permissao` bigint NOT NULL AUTO_INCREMENT,
  `id_grupo` bigint NOT NULL,
  `recurso` varchar(100) NOT NULL,
  `acao` varchar(50) NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_grupo_permissao`),
  UNIQUE KEY `uk_grupo_recurso` (`id_grupo`, `recurso`, `acao`),
  CONSTRAINT `fk_gp_grupo` FOREIGN KEY (`id_grupo`) REFERENCES `auth_grupo` (`id_grupo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 10. auth_parametro - Parâmetros de autenticação
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_parametro`;

CREATE TABLE `auth_parametro` (
  `id_parametro` bigint NOT NULL AUTO_INCREMENT,
  `chave` varchar(100) NOT NULL,
  `valor` text NOT NULL,
  `descricao` text DEFAULT NULL,
  `tipo_parametro` enum('SENHA','SESSAO','TOKEN','BLOQUEIO','GERAL') DEFAULT 'GERAL',
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_parametro`),
  UNIQUE KEY `uk_parametro_chave` (`chave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserir parâmetros padrão
INSERT INTO auth_parametro (chave, valor, descricao, tipo_parametro) VALUES
('senha_tamanho_minimo', '6', 'Tamanho mínimo da senha', 'SENHA'),
('senha_tamanho_maximo', '20', 'Tamanho máximo da senha', 'SENHA'),
('senha_exige_maiuscula', '1', 'Exige letra maiúscula na senha', 'SENHA'),
('senha_exige_minuscula', '1', 'Exige letra minúscula na senha', 'SENHA'),
('senha_exige_numero', '1', 'Exige número na senha', 'SENHA'),
('senha_exige_especial', '0', 'Exige caractere especial na senha', 'SENHA'),
('senha_dias_expiracao', '90', 'Dias até expiração da senha', 'SENHA'),
('senha_historico_tamanho', '5', 'Quantidade de senhas no histórico', 'SENHA'),
('login_tentativas_maximas', '5', 'Máximo de tentativas de login', 'BLOQUEIO'),
('login_bloqueio_minutos', '30', 'Minutos de bloqueio após tentativas', 'BLOQUEIO'),
('sessao_duracao_horas', '8', 'Duração máxima da sessão em horas', 'SESSAO'),
('token_refresh_dias', '30', 'Dias de validade do token de refresh', 'TOKEN'),
('token_recovery_minutos', '15', 'Minutos de validade do token de recuperação', 'TOKEN');

-- ------------------------------------------------------------
-- 11. auth_audit - Auditoria de segurança
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_audit`;

CREATE TABLE `auth_audit` (
  `id_audit` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint DEFAULT NULL,
  `id_sessao` bigint DEFAULT NULL,
  `acao` varchar(100) NOT NULL,
  `recurso` varchar(100) DEFAULT NULL,
  `detalhes` json DEFAULT NULL,
  `ip_origem` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `sucesso` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_audit`),
  KEY `idx_audit_usuario` (`id_usuario`),
  KEY `idx_audit_sessao` (`id_sessao`),
  KEY `idx_audit_acao` (`acao`),
  KEY `idx_audit_data` (`criado_em`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 12. auth_notificacao - Notificações de segurança
-- ------------------------------------------------------------
DROP TABLE IF EXISTS `auth_notificacao`;

CREATE TABLE `auth_notificacao` (
  `id_notificacao` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `tipo_notificacao` enum('LOGIN_NOVO_DISPOSITIVO','LOGIN_SUSPEITO','SENHA_EXPIRANDO','BLOQUUEIO_CONTA','SEGURANCA_ALERTA') NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `mensagem` text NOT NULL,
  `lido` tinyint(1) DEFAULT '0',
  `lido_em` datetime DEFAULT NULL,
  `dados_extras` json DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_notificacao`),
  KEY `idx_notif_usuario` (`id_usuario`),
  KEY `idx_notif_lido` (`lido`),
  KEY `idx_notif_data` (`criado_em`),
  CONSTRAINT `fk_notif_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ================================================================
-- PARTE 2: STORED PROCEDURES (10 procedures)
-- ================================================================

DELIMITER ;;

-- ------------------------------------------------------------
-- SP 1: sp_auth_login - Realiza login
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_login;;
CREATE PROCEDURE sp_auth_login(
    IN p_login VARCHAR(80),
    IN p_senha VARCHAR(255),
    IN p_ip_origem VARCHAR(45),
    IN p_user_agent TEXT,
    OUT p_id_usuario BIGINT,
    OUT p_id_sessao BIGINT,
    OUT p_token_sessao VARCHAR(255),
    OUT p_resultado INT,
    OUT p_mensagem VARCHAR(255)
)
BEGIN
    DECLARE v_id_usuario BIGINT DEFAULT NULL;
    DECLARE v_senha_hash VARCHAR(255);
    DECLARE v_ativo TINYINT;
    DECLARE v_tentativas INT DEFAULT 0;
    DECLARE v_bloqueado_ate DATETIME;
    DECLARE v_id_sessao BIGINT;
    DECLARE v_token_sessao VARCHAR(255);
    DECLARE v_expira_em DATETIME;
    DECLARE v_param_tentativas INT DEFAULT 5;
    DECLARE v_param_bloqueio INT DEFAULT 30;
    
    SET p_resultado = 0;
    SET p_mensagem = '';
    
    -- Buscar parâmetros
    SELECT CAST(valor AS UNSIGNED) INTO v_param_tentativas FROM auth_parametro WHERE chave = 'login_tentativas_maximas' AND ativo = 1;
    SELECT CAST(valor AS UNSIGNED) INTO v_param_bloqueio FROM auth_parametro WHERE chave = 'login_bloqueio_minutos' AND ativo = 1;
    
    -- Buscar usuário
    SELECT id_usuario, senha_hash, ativo, tentativas_login, bloqueado_ate
    INTO v_id_usuario, v_senha_hash, v_ativo, v_tentativas, v_bloqueado_ate
    FROM usuario WHERE login = p_login;
    
    IF v_id_usuario IS NULL THEN
        SET p_resultado = 1;
        SET p_mensagem = 'Usuário não encontrado';
        
        -- Logar tentativa falha
        INSERT INTO auth_tentativa_login (login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'USUARIO_NAO_ENCONTRADO');
        INSERT INTO auth_log (tipo_evento, ip_origem, user_agent, mensagem)
        VALUES ('LOGIN_FALHA', p_ip_origem, p_user_agent, CONCAT('Tentativa de login falhou: usuário não encontrado - ', p_login));
        LEAVE;
    END IF;
    
    -- Verificar se usuário está ativo
    IF v_ativo = 0 THEN
        SET p_resultado = 2;
        SET p_mensagem = 'Usuário inativo';
        
        INSERT INTO auth_tentativa_login (login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'USUARIO_INATIVO');
        INSERT INTO auth_log (id_usuario, tipo_evento, ip_origem, user_agent, mensagem)
        VALUES (v_id_usuario, 'LOGIN_FALHA', p_ip_origem, p_user_agent, 'Tentativa de login: usuário inativo');
        LEAVE;
    END IF;
    
    -- Verificar bloqueio
    IF v_bloqueado_ate IS NOT NULL AND v_bloqueado_ate > NOW() THEN
        SET p_resultado = 3;
        SET p_mensagem = CONCAT('Usuário bloqueado até ', v_bloqueado_ate);
        
        INSERT INTO auth_tentativa_login (login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'USUARIO_BLOQUEADO');
        LEAVE;
    END IF;
    
    -- Verificar tentativas
    IF v_tentativas >= v_param_tentativas THEN
        SET v_bloqueado_ate = DATE_ADD(NOW(), INTERVAL v_param_bloqueio MINUTE);
        UPDATE usuario SET bloqueado_ate = v_bloqueado_ate WHERE id_usuario = v_id_usuario;
        
        INSERT INTO auth_bloqueio (id_usuario, tipo_bloqueio, motivo, expira_em)
        VALUES (v_id_usuario, 'TENTATIVAS_EXCEDIDAS', CONCAT('Bloqueado após ', v_tentativas, ' tentativas'), v_bloqueado_ate);
        
        SET p_resultado = 3;
        SET p_mensagem = 'Usuário bloqueado por excesso de tentativas';
        
        INSERT INTO auth_tentativa_login (login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'BLOQUEADO_TENTATIVAS');
        LEAVE;
    END IF;
    
    -- Validar senha (simplificado - usar bcrypt em produção)
    IF v_senha_hash != p_senha THEN
        UPDATE usuario SET tentativas_login = tentativas_login + 1 WHERE id_usuario = v_id_usuario;
        
        SET p_resultado = 4;
        SET p_mensagem = 'Senha incorreta';
        
        INSERT INTO auth_tentativa_login (login, ip_origem, user_agent, sucesso, motivo_falha)
        VALUES (p_login, p_ip_origem, p_user_agent, 0, 'SENHA_INCORRETA');
        INSERT INTO auth_log (id_usuario, tipo_evento, ip_origem, user_agent, mensagem)
        VALUES (v_id_usuario, 'LOGIN_FALHA', p_ip_origem, p_user_agent, 'Tentativa de login: senha incorreta');
        LEAVE;
    END IF;
    
    -- Login bem-sucedido
    UPDATE usuario SET tentativas_login = 0, ultimo_login = NOW(), ultimo_ip = p_ip_origem WHERE id_usuario = v_id_usuario;
    
    -- Gerar token de sessão
    SET v_token_sessao = MD5(CONCAT(NOW(), RAND(), v_id_usuario));
    SET v_expira_em = DATE_ADD(NOW(), INTERVAL 8 HOUR);
    
    INSERT INTO auth_sessao (id_usuario, token_sessao, ip_origem, user_agent, expira_em)
    VALUES (v_id_usuario, v_token_sessao, p_ip_origem, p_user_agent, v_expira_em);
    
    SET v_id_sessao = LAST_INSERT_ID();
    
    SET p_id_usuario = v_id_usuario;
    SET p_id_sessao = v_id_sessao;
    SET p_token_sessao = v_token_sessao;
    SET p_resultado = 0;
    SET p_mensagem = 'Login realizado com sucesso';
    
    -- Logar sucesso
    INSERT INTO auth_tentativa_login (login, ip_origem, user_agent, sucesso)
    VALUES (p_login, p_ip_origem, p_user_agent, 1);
    INSERT INTO auth_log (id_usuario, id_sessao, tipo_evento, ip_origem, user_agent, mensagem)
    VALUES (v_id_usuario, v_id_sessao, 'LOGIN_SUCESSO', p_ip_origem, p_user_agent, 'Login realizado com sucesso');
END;;

-- ------------------------------------------------------------
-- SP 2: sp_auth_logout - Realiza logout
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_logout;;
CREATE PROCEDURE sp_auth_logout(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_ip_origem VARCHAR(45)
)
BEGIN
    UPDATE auth_sessao SET ativo = 0 WHERE id_sessao = p_id_sessao;
    
    INSERT INTO auth_log (id_usuario, id_sessao, tipo_evento, ip_origem, mensagem)
    VALUES (p_id_usuario, p_id_sessao, 'LOGOUT', p_ip_origem, 'Logout realizado');
    
    SELECT 'Logout realizado com sucesso' AS mensagem;
END;;

-- ------------------------------------------------------------
-- SP 3: sp_auth_renovar_token - Renova token de sessão
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_renovar_token;;
CREATE PROCEDURE sp_auth_renovar_token(
    IN p_token_sessao VARCHAR(255),
    OUT p_novo_token VARCHAR(255),
    OUT p_resultado INT
)
BEGIN
    DECLARE v_id_sessao BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_expira_em DATETIME;
    
    SELECT id_sessao, id_usuario, expira_em INTO v_id_sessao, v_id_usuario, v_expira_em
    FROM auth_sessao WHERE token_sessao = p_token_sessao AND ativo = 1;
    
    IF v_id_sessao IS NULL THEN
        SET p_resultado = 1;
        SET p_novo_token = NULL;
        LEAVE;
    END IF;
    
    IF v_expira_em < NOW() THEN
        UPDATE auth_sessao SET ativo = 0 WHERE id_sessao = v_id_sessao;
        INSERT INTO auth_log (id_usuario, id_sessao, tipo_evento, mensagem)
        VALUES (v_id_usuario, v_id_sessao, 'SESSAO_EXPIRADA', 'Sessão expirada durante renovação');
        SET p_resultado = 2;
        SET p_novo_token = NULL;
        LEAVE;
    END IF;
    
    SET p_novo_token = MD5(CONCAT(NOW(), RAND(), v_id_usuario));
    SET v_expira_em = DATE_ADD(NOW(), INTERVAL 8 HOUR);
    
    UPDATE auth_sessao SET token_sessao = p_novo_token, expira_em = v_expira_em, ultima_atividade = NOW()
    WHERE id_sessao = v_id_sessao;
    
    INSERT INTO auth_log (id_usuario, id_sessao, tipo_evento, mensagem)
    VALUES (v_id_usuario, v_id_sessao, 'TOKEN_REFRESH', 'Token de sessão renovado');
    
    SET p_resultado = 0;
END;;

-- ------------------------------------------------------------
-- SP 4: sp_auth_bloquear - Bloqueia usuário
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_bloquear;;
CREATE PROCEDURE sp_auth_bloquear(
    IN p_id_usuario BIGINT,
    IN p_id_bloqueio_por BIGINT,
    IN p_tipo_bloqueio ENUM('SENHA_EXPIRADA','TENTATIVAS_EXCEDIDAS','ADMINISTRATIVO','INATIVIDADE','FRAUDE'),
    IN p_motivo TEXT,
    IN p_dias_bloqueio INT,
    OUT p_resultado INT
)
BEGIN
    DECLARE v_expira_em DATETIME DEFAULT NULL;
    
    IF p_dias_bloqueio > 0 THEN
        SET v_expira_em = DATE_ADD(NOW(), INTERVAL p_dias_bloqueio DAY);
    END IF;
    
    UPDATE usuario SET ativo = 0, bloqueado_ate = v_expira_em WHERE id_usuario = p_id_usuario;
    
    INSERT INTO auth_bloqueio (id_usuario, tipo_bloqueio, motivo, bloqueado_por, expira_em)
    VALUES (p_id_usuario, p_tipo_bloqueio, p_motivo, p_id_bloqueio_por, v_expira_em);
    
    -- Encerrar sessões ativas
    UPDATE auth_sessao SET ativo = 0 WHERE id_usuario = p_id_usuario AND ativo = 1;
    
    INSERT INTO auth_log (id_usuario, tipo_evento, mensagem)
    VALUES (p_id_usuario, 'BLOQUEIO', CONCAT('Usuário bloqueado: ', p_motivo));
    
    SET p_resultado = 0;
END;;

-- ------------------------------------------------------------
-- SP 5: sp_auth_desbloquear - Desbloqueia usuário
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_desbloquear;;
CREATE PROCEDURE sp_auth_desbloquear(
    IN p_id_usuario BIGINT,
    IN p_id_desbloqueio_por BIGINT,
    OUT p_resultado INT
)
BEGIN
    UPDATE usuario SET ativo = 1, bloqueado_ate = NULL WHERE id_usuario = p_id_usuario;
    
    UPDATE auth_bloqueio SET ativo = 0, desbloqueado_por = p_id_desbloqueio_por, desbloqueado_em = NOW()
    WHERE id_usuario = p_id_usuario AND ativo = 1;
    
    INSERT INTO auth_log (id_usuario, tipo_evento, mensagem)
    VALUES (p_id_usuario, 'DESBLOQUEIO', 'Usuário desbloqueado');
    
    SET p_resultado = 0;
END;;

-- ------------------------------------------------------------
-- SP 6: sp_auth_criar_token - Cria token de recuperação
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_criar_token;;
CREATE PROCEDURE sp_auth_criar_token(
    IN p_id_usuario BIGINT,
    IN p_tipo_token ENUM('ACCESS','REFRESH','RECOVERY','VERIFICATION'),
    IN p_ip_origem VARCHAR(45),
    IN p_user_agent TEXT,
    OUT p_token_hash VARCHAR(255),
    OUT p_expira_em DATETIME,
    OUT p_resultado INT
)
BEGIN
    DECLARE v_minutos INT DEFAULT 15;
    
    SELECT CAST(valor AS UNSIGNED) INTO v_minutos FROM auth_parametro 
    WHERE chave = 'token_recovery_minutos' AND ativo = 1;
    
    SET p_token_hash = MD5(CONCAT(NOW(), RAND(), p_id_usuario));
    SET p_expira_em = DATE_ADD(NOW(), INTERVAL v_minutos MINUTE);
    
    INSERT INTO auth_token (id_usuario, tipo_token, token_hash, ip_origem, user_agent, expira_em)
    VALUES (p_id_usuario, p_tipo_token, p_token_hash, p_ip_origem, p_user_agent, p_expira_em);
    
    SET p_resultado = 0;
END;;

-- ------------------------------------------------------------
-- SP 7: sp_auth_validar_token - Valida token
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_validar_token;;
CREATE PROCEDURE sp_auth_validar_token(
    IN p_token_hash VARCHAR(255),
    IN p_tipo_token ENUM('ACCESS','REFRESH','RECOVERY','VERIFICATION'),
    OUT p_id_usuario BIGINT,
    OUT p_resultado INT,
    OUT p_mensagem VARCHAR(255)
)
BEGIN
    DECLARE v_id_token BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_expira_em DATETIME;
    
    SELECT id_token, id_usuario, expira_em INTO v_id_token, v_id_usuario, v_expira_em
    FROM auth_token 
    WHERE token_hash = p_token_hash AND tipo_token = p_tipo_token AND ativo = 1;
    
    IF v_id_token IS NULL THEN
        SET p_resultado = 1;
        SET p_mensagem = 'Token inválido';
        SET p_id_usuario = NULL;
        LEAVE;
    END IF;
    
    IF v_expira_em < NOW() THEN
        UPDATE auth_token SET ativo = 0 WHERE id_token = v_id_token;
        SET p_resultado = 2;
        SET p_mensagem = 'Token expirado';
        SET p_id_usuario = NULL;
        LEAVE;
    END IF;
    
    UPDATE auth_token SET ativo = 0, utilizado_em = NOW() WHERE id_token = v_id_token;
    
    SET p_id_usuario = v_id_usuario;
    SET p_resultado = 0;
    SET p_mensagem = 'Token válido';
END;;

-- ------------------------------------------------------------
-- SP 8: sp_auth_gerenciar_grupo - Gerencia grupos de usuários
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_gerenciar_grupo;;
CREATE PROCEDURE sp_auth_gerenciar_grupo(
    IN p_acao VARCHAR(20),
    IN p_id_grupo BIGINT,
    IN p_nome VARCHAR(100),
    IN p_descricao TEXT,
    IN p_id_unidade BIGINT,
    IN p_id_usuario_cria BIGINT,
    OUT p_id_grupo_saida BIGINT,
    OUT p_resultado INT
)
BEGIN
    IF p_acao = 'CRIAR' THEN
        INSERT INTO auth_grupo (nome, descricao, id_unidade, criado_por)
        VALUES (p_nome, p_descricao, p_id_unidade, p_id_usuario_cria);
        SET p_id_grupo_saida = LAST_INSERT_ID();
        SET p_resultado = 0;
    ELSEIF p_acao = 'ATUALIZAR' THEN
        UPDATE auth_grupo SET nome = p_nome, descricao = p_descricao, id_unidade = p_id_unidade
        WHERE id_grupo = p_id_grupo;
        SET p_id_grupo_saida = p_id_grupo;
        SET p_resultado = 0;
    ELSEIF p_acao = 'ATIVAR' THEN
        UPDATE auth_grupo SET ativo = 1 WHERE id_grupo = p_id_grupo;
        SET p_id_grupo_saida = p_id_grupo;
        SET p_resultado = 0;
    ELSEIF p_acao = 'INATIVAR' THEN
        UPDATE auth_grupo SET ativo = 0 WHERE id_grupo = p_id_grupo;
        SET p_id_grupo_saida = p_id_grupo;
        SET p_resultado = 0;
    ELSE
        SET p_resultado = 1;
    END IF;
END;;

-- ------------------------------------------------------------
-- SP 9: sp_auth_adicionar_usuario_grupo - Adiciona usuário a grupo
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_adicionar_usuario_grupo;;
CREATE PROCEDURE sp_auth_adicionar_usuario_grupo(
    IN p_id_grupo BIGINT,
    IN p_id_usuario BIGINT,
    IN p_papel ENUM('MEMBRO','COORDENADOR','SUBCOORDENADOR'),
    OUT p_resultado INT
)
BEGIN
    INSERT INTO auth_grupo_usuario (id_grupo, id_usuario, papel)
    VALUES (p_id_grupo, p_id_usuario, p_papel)
    ON DUPLICATE KEY UPDATE papel = p_papel, ativo = 1;
    
    SET p_resultado = 0;
END;;

-- ------------------------------------------------------------
-- SP 10: sp_auth_gerar_relatorio - Relatório de autenticação
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS sp_auth_gerar_relatorio;;
CREATE PROCEDURE sp_auth_gerar_relatorio(
    IN p_data_inicio DATETIME,
    IN p_data_fim DATETIME,
    IN p_id_usuario BIGINT
)
BEGIN
    SELECT 
        DATE_FORMAT(al.criado_em, '%Y-%m-%d') AS data,
        al.tipo_evento,
        COUNT(*) AS total,
        al.ip_origem
    FROM auth_log al
    WHERE al.criado_em BETWEEN p_data_inicio AND p_data_fim
    AND (p_id_usuario IS NULL OR al.id_usuario = p_id_usuario)
    GROUP BY DATE_FORMAT(al.criado_em, '%Y-%m-%d'), al.tipo_evento, al.ip_origem
    ORDER BY data DESC;
    
    -- Total de logins por dia
    SELECT 
        DATE_FORMAT(criado_em, '%Y-%m-%d') AS data,
        COUNT(*) AS total_logins
    FROM auth_log
    WHERE tipo_evento = 'LOGIN_SUCESSO'
    AND criado_em BETWEEN p_data_inicio AND p_data_fim
    GROUP BY DATE_FORMAT(criado_em, '%Y-%m-%d')
    ORDER BY data DESC;
    
    -- Usuários mais ativos
    SELECT 
        u.login,
        COUNT(*) AS total_operacoes
    FROM auth_log al
    JOIN usuario u ON u.id_usuario = al.id_usuario
    WHERE al.criado_em BETWEEN p_data_inicio AND p_data_fim
    GROUP BY u.login
    ORDER BY total_operacoes DESC
    LIMIT 10;
END;;

DELIMITER ;

SELECT 'Módulo AUTH Hospitalar criado com sucesso!' AS resultado;
SELECT '12 tabelas criadas' AS tabelas;
SELECT '10 procedures criadas' AS procedures;
