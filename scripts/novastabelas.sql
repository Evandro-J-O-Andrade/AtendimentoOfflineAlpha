CREATE TABLE IF NOT EXISTS sistema (
    id_sistema BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao VARCHAR(255) NULL,
    ativo TINYINT(1) DEFAULT 1,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cidade (
    id_cidade BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    uf CHAR(2) NOT NULL,
    codigo_ibge VARCHAR(10) NULL,
    ativo TINYINT(1) DEFAULT 1
);

CREATE TABLE IF NOT EXISTS unidade (
    id_unidade BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_sistema BIGINT NULL,
    id_cidade BIGINT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    tipo ENUM('UPA','HOSPITAL','PA','CLINICA') NOT NULL,
    ativo TINYINT(1) DEFAULT 1,

    FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),
    FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema)
);


ALTER TABLE local_atendimento
ADD COLUMN id_unidade BIGINT NULL,
ADD CONSTRAINT fk_local_unidade
FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade);


CREATE TABLE IF NOT EXISTS sigpat_procedimento (
    id_sigpat BIGINT AUTO_INCREMENT PRIMARY KEY,

    codigo VARCHAR(20) NOT NULL,        -- código SIGPAT
    descricao VARCHAR(255) NOT NULL,    -- nome do procedimento
    tipo ENUM('EXAME','PROCEDIMENTO','CONSULTA','OUTRO') NOT NULL,

    grupo VARCHAR(100) NULL,
    subgrupo VARCHAR(100) NULL,

    ativo TINYINT(1) DEFAULT 1,

    UNIQUE KEY uk_sigpat_codigo (codigo)
);

ALTER TABLE solicitacao_exame
ADD COLUMN id_sigpat BIGINT NULL AFTER id_exame;


ALTER TABLE solicitacao_exame
MODIFY status ENUM(
  'SOLICITADO',
  'COLETADO',
  'EM_ANALISE',
  'RESULTADO',
  'CANCELADO'
) NOT NULL;

ALTER TABLE solicitacao_exame
CHANGE data_hora solicitado_em DATETIME NOT NULL;


ALTER TABLE solicitacao_exame
ADD COLUMN solicitado_em DATETIME NULL AFTER data_hora;

UPDATE solicitacao_exame
SET solicitado_em = data_hora
WHERE solicitado_em IS NULL;

SHOW COLUMNS FROM solicitacao_exame;


DELIMITER $$

CREATE PROCEDURE sp_marcar_nao_compareceu (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_motivo VARCHAR(255)
)
BEGIN
    DECLARE v_id_fila BIGINT;

    -- Busca fila ativa da FFA
    SELECT id_fila
    INTO v_id_fila
    FROM fila_operacional
    WHERE id_ffa = p_id_ffa
      AND status IN ('AGUARDANDO','CHAMANDO')
    ORDER BY criado_em DESC
    LIMIT 1;

    -- Registra evento de exceção
    INSERT INTO auditoria_excecoes (
        entidade,
        id_entidade,
        tipo,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        'FFA',
        p_id_ffa,
        'NAO_COMPARECEU',
        p_motivo,
        p_id_usuario,
        NOW()
    );

    -- Atualiza fila
    IF v_id_fila IS NOT NULL THEN
        UPDATE fila_operacional
        SET status = 'NAO_COMPARECEU',
            finalizado_em = NOW()
        WHERE id_fila = v_id_fila;
    END IF;

    -- Atualiza FFA
    UPDATE ffa
    SET status = 'NAO_COMPARECEU',
        atualizado_em = NOW()
    WHERE id_ffa = p_id_ffa;

END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_rechamar_painel (
    IN p_id_ffa BIGINT,
    IN p_id_local BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_fila BIGINT;

    -- Busca última fila válida
    SELECT id_fila
    INTO v_id_fila
    FROM fila_operacional
    WHERE id_ffa = p_id_ffa
      AND status = 'CHAMANDO'
    ORDER BY criado_em DESC
    LIMIT 1;

    -- Registra evento de chamada no painel
    INSERT INTO chamada_painel (
        id_ffa,
        id_local,
        tipo,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_id_local,
        'RECHAMADA',
        NOW()
    );

    -- Auditoria
    INSERT INTO auditoria_fila (
        id_fila,
        acao,
        id_usuario,
        criado_em
    ) VALUES (
        v_id_fila,
        'RECHAMADA_PAINEL',
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_solicitar_exame (
    IN p_id_atendimento BIGINT,
    IN p_id_sigpat BIGINT,
    IN p_id_medico BIGINT
)
BEGIN
    INSERT INTO solicitacao_exame (
        id_atendimento,
        id_sigpat,
        status,
        id_medico,
        solicitado_em
    ) VALUES (
        p_id_atendimento,
        p_id_sigpat,
        'SOLICITADO',
        p_id_medico,
        NOW()
    );
END$$

DELIMITER ;


ALTER TABLE sigpat_procedimento
ADD COLUMN setor_execucao ENUM(
    'RX',
    'LABORATORIO',
    'ECG',
    'MEDICACAO',
    'AMBULATORIO',
    'OUTRO'
) NOT NULL DEFAULT 'OUTRO',

ADD COLUMN gera_faturamento TINYINT(1) DEFAULT 1,

ADD COLUMN exige_coleta TINYINT(1) DEFAULT 0,

ADD COLUMN criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP;

CREATE OR REPLACE VIEW vw_solicitacoes_exame_pendentes AS
SELECT
    se.id_solicitacao,
    se.status,
    se.solicitado_em,

    sp.codigo        AS codigo_sigpat,
    sp.descricao,
    sp.setor_execucao,

    f.id             AS id_ffa,
    pe.nome_completo AS paciente

FROM solicitacao_exame se
JOIN sigpat_procedimento sp
    ON sp.id_sigpat = se.id_sigpat
JOIN ffa f
    ON f.id = se.id_atendimento
JOIN paciente pa
    ON pa.id = f.id_paciente
JOIN pessoa pe
    ON pe.id_pessoa = pa.id_pessoa

WHERE se.status IN ('SOLICITADO','EM_ANALISE');



DROP PROCEDURE IF EXISTS sp_marcar_nao_compareceu;
DELIMITER $$

CREATE PROCEDURE sp_marcar_nao_compareceu (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_motivo VARCHAR(255)
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Status atual da FFA
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    -- Validação
    IF v_status_atual NOT IN ('CHAMANDO_MEDICO','AGUARDANDO_CHAMADA_MEDICO') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em estado válido para não compareceu';
    END IF;

    -- Atualiza FFA
    UPDATE ffa
       SET status = 'AGUARDANDO_RETORNO',
           atualizado_em = NOW(),
           id_usuario_alteracao = p_id_usuario
     WHERE id = p_id_ffa;

    -- Evento de fila / auditoria
    INSERT INTO fila_evento (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'NAO_COMPARECEU',
        COALESCE(p_motivo, 'Paciente não compareceu à chamada'),
        p_id_usuario,
        NOW()
    );

END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_marcar_nao_compareceu;
DELIMITER $$

CREATE PROCEDURE sp_marcar_nao_compareceu (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_local BIGINT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_id_fila BIGINT;

    -- buscar fila (senha) vinculada à FFA
    SELECT id_senha, status
      INTO v_id_fila, v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não possui senha vinculada';
    END IF;

    IF v_status_atual NOT IN ('CHAMANDO_MEDICO','AGUARDANDO_CHAMADA_MEDICO') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em estado válido para NAO_COMPARECEU';
    END IF;

    -- atualiza status da FFA
    UPDATE ffa
       SET status = 'AGUARDANDO_RETORNO',
           atualizado_em = NOW(),
           id_usuario_alteracao = p_id_usuario
     WHERE id = p_id_ffa;

    -- evento correto de fila
    INSERT INTO fila_evento (
        id_fila,
        evento,
        id_usuario,
        id_local,
        detalhe,
        criado_em
    ) VALUES (
        v_id_fila,
        'NAO_ATENDIDO',
        p_id_usuario,
        p_id_local,
        COALESCE(p_motivo, 'Paciente não compareceu à chamada'),
        NOW()
    );

END$$
DELIMITER ;


CALL sp_marcar_nao_compareceu(
    123,  -- id_ffa (que TEM id_senha válido)
    10,   -- usuário
    2,    -- local
    'Paciente ausente na chamada médica'
);


SELECT id_senha, status
INTO v_id_fila, v_status_atual
FROM ffa
WHERE id = p_id_ffa;


SELECT id, id_senha, status
FROM ffa
ORDER BY id DESC
LIMIT 10;

INSERT INTO fila_senha (senha, id_paciente, prioridade_recepcao, criado_em)
VALUES (1001, 1, 'PADRAO', NOW());




DELIMITER $$

CREATE PROCEDURE sp_gerar_senha (
    IN p_id_paciente BIGINT,
    IN p_prioridade ENUM('PADRAO','IDOSO','CRONICO'),
    OUT p_id_senha BIGINT
)
BEGIN
    INSERT INTO fila_senha (
        senha,
        id_paciente,
        prioridade_recepcao,
        criado_em
    )
    VALUES (
        (SELECT IFNULL(MAX(senha), 0) + 1 FROM fila_senha),
        p_id_paciente,
        p_prioridade,
        NOW()
    );

    SET p_id_senha = LAST_INSERT_ID();
END$$

DELIMITER ;


CALL sp_gerar_senha(null);

CALL sp_abrir_ffa_por_senha();

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_abrir_ffa_por_senha` $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_ffa_por_senha`(
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_layout VARCHAR(50)
)
BEGIN
    DECLARE v_id_fila BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    /* ===============================
       1. Valida senha
       =============================== */
    IF NOT EXISTS (SELECT 1 FROM senhas WHERE id = p_id_senha) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha inexistente';
    END IF;

    /* ===============================
       2. Garante que ainda não existe FFA
       =============================== */
    IF EXISTS (SELECT 1 FROM ffa WHERE id_senha = p_id_senha) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Já existe FFA para esta senha';
    END IF;

    /* ===============================
       3. Busca fila e paciente
       =============================== */
    SELECT fs.id, fs.id_paciente
      INTO v_id_fila, v_id_paciente
      FROM fila_senha fs
     WHERE fs.id = p_id_senha
     LIMIT 1;

    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha não está na fila';
    END IF;

    /* ===============================
       4. Cria FFA principal
       =============================== */
    INSERT INTO ffa (
        id_paciente,
        status,
        layout,
        id_usuario_criacao,
        criado_em,
        atualizado_em,
        id_senha
    ) VALUES (
        v_id_paciente,
        'ABERTO',
        p_layout,
        p_id_usuario,
        NOW(),
        NOW(),
        p_id_senha
    );

    SET v_id_ffa = LAST_INSERT_ID();

    /* ===============================
       5. Evento de abertura da FFA
       =============================== */
    INSERT INTO evento_ffa (
        id_ffa,
        evento,
        id_usuario,
        criado_em
    ) VALUES (
        v_id_ffa,
        'ABERTURA_FFA',
        p_id_usuario,
        NOW()
    );

    /* ===============================
       6. Atualiza status da senha
       =============================== */
    UPDATE senhas
       SET status = 'EM_ATENDIMENTO'
     WHERE id = p_id_senha;

    /* ===============================
       7. Cria FFAs adicionais para procedimentos/exames
       =============================== */
    INSERT INTO ffa (
        id_paciente,
        status,
        layout,
        id_usuario_criacao,
        criado_em,
        atualizado_em,
        id_senha
    )
    SELECT
        v_id_paciente,
        'ABERTO',
        CONCAT(p_layout, '_PROC'),
        p_id_usuario,
        NOW(),
        NOW(),
        p_id_senha
    FROM pedidos_exames pe
    WHERE pe.id_senha = p_id_senha
      AND NOT EXISTS (
          SELECT 1 FROM ffa f
           WHERE f.id_senha = p_id_senha
             AND f.id_paciente = pe.id_paciente
             AND f.layout = CONCAT(p_layout, '_PROC')
      );

    /* ===============================
       8. Retorna todas as FFAs criadas
       =============================== */
    SELECT
        f.id         AS id_ffa,
        f.id_paciente,
        f.status,
        f.layout,
        f.criado_em
    FROM ffa f
    WHERE f.id_senha = p_id_senha
    ORDER BY f.id;

END $$

DELIMITER ;
INSERT INTO senhas (
    numero, prefixo, tipo_atendimento, status, origem, prioridade, criada_em
) VALUES (
    9999, 'TST', 'CLINICO', 'GERADA', 'ADMIN', 1, NOW()
);
SELECT ROUTINE_NAME, ROUTINE_TYPE, CREATED, LAST_ALTERED
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'pronto_atendimento'
AND ROUTINE_TYPE = 'PROCEDURE';
DROP PROCEDURE IF EXISTS sp_abrir_ffa_por_senha;

DELIMITER $$

CREATE DEFINER=`root`@`localhost`
PROCEDURE sp_abrir_ffa_por_senha (
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_layout VARCHAR(50)
)
BEGIN
    DECLARE v_id_fila BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    /* ===============================
       1. Valida senha
       =============================== */
    IF NOT EXISTS (
        SELECT 1 FROM senhas WHERE id = p_id_senha
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha inexistente';
    END IF;

    /* ===============================
       2. Garante que ainda não existe FFA
       =============================== */
    IF EXISTS (
        SELECT 1 FROM ffa WHERE id_senha = p_id_senha
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Já existe FFA para esta senha';
    END IF;

    /* ===============================
       3. Busca fila e paciente
       =============================== */
    SELECT id, id_paciente
      INTO v_id_fila, v_id_paciente
      FROM fila_senha
     WHERE senha = p_id_senha
     LIMIT 1;

    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha não está na fila';
    END IF;

    /* ===============================
       4. Cria FFA
       =============================== */
    INSERT INTO ffa (
        id_paciente,
        status,
        layout,
        id_usuario_criacao,
        criado_em,
        atualizado_em,
        id_senha
    ) VALUES (
        v_id_paciente,
        'ABERTO',
        p_layout,
        p_id_usuario,
        NOW(),
        NOW(),
        p_id_senha
    );

    SET v_id_ffa = LAST_INSERT_ID();

    /* ===============================
       5. Evento de abertura da FFA
       =============================== */
    INSERT INTO evento_ffa (
        id_ffa,
        evento,
        id_usuario,
        criado_em
    ) VALUES (
        v_id_ffa,
        'ABERTURA_FFA',
        p_id_usuario,
        NOW()
    );

    /* ===============================
       6. Atualiza status da senha
       =============================== */
    UPDATE senhas
       SET status = 'EM_ATENDIMENTO'
     WHERE id = p_id_senha;

    /* ===============================
       7. Retorno
       =============================== */
    SELECT
        v_id_ffa   AS id_ffa,
        p_id_senha AS id_senha,
        'ABERTO'   AS status,
        p_layout   AS layout,
        NOW()      AS criado_em;

END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_abrir_ffa_com_exames;

DELIMITER $$

CREATE DEFINER=`root`@`localhost`
PROCEDURE sp_abrir_ffa_com_exames (
    IN p_id_senha BIGINT,
    IN p_id_usuario BIGINT,
    IN p_layout VARCHAR(50)
)
BEGIN
    DECLARE v_id_fila BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    -- ======================================
    -- 1. Valida senha
    -- ======================================
    IF NOT EXISTS (SELECT 1 FROM senhas WHERE id = p_id_senha) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha inexistente';
    END IF;

    -- ======================================
    -- 2. Garante que ainda não existe FFA
    -- ======================================
    IF EXISTS (SELECT 1 FROM ffa WHERE id_senha = p_id_senha) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Já existe FFA para esta senha';
    END IF;

    -- ======================================
    -- 3. Busca fila e paciente
    -- ======================================
    SELECT id, id_paciente
      INTO v_id_fila, v_id_paciente
      FROM fila_senha
     WHERE senha = p_id_senha
     LIMIT 1;

    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha não está na fila';
    END IF;

    -- ======================================
    -- 4. Cria FFA
    -- ======================================
    INSERT INTO ffa (
        id_paciente,
        status,
        layout,
        id_usuario_criacao,
        criado_em,
        atualizado_em,
        id_senha
    ) VALUES (
        v_id_paciente,
        'ABERTO',
        p_layout,
        p_id_usuario,
        NOW(),
        NOW(),
        p_id_senha
    );

    SET v_id_ffa = LAST_INSERT_ID();

    -- ======================================
    -- 5. Evento de abertura da FFA
    -- ======================================
    INSERT INTO evento_ffa (
        id_ffa,
        evento,
        id_usuario,
        criado_em
    ) VALUES (
        v_id_ffa,
        'ABERTURA_FFA',
        p_id_usuario,
        NOW()
    );

    -- ======================================
    -- 6. Atualiza status da senha
    -- ======================================
    UPDATE senhas
       SET status = 'EM_ATENDIMENTO'
     WHERE id = p_id_senha;

    -- ======================================
    -- 7. Adiciona exames/procedimentos de teste
    -- ======================================
    INSERT INTO ffa_procedimento (
        id_ffa,
        tipo_procedimento,   -- Ex: 'EXAME', 'PROCEDIMENTO'
        descricao,
        status,
        criado_em
    )
    SELECT v_id_ffa, tipo_procedimento, descricao, 'PENDENTE', NOW()
      FROM solicitacao_exame
     WHERE id_senha = p_id_senha;

    -- ======================================
    -- 8. Retorno
    -- ======================================
    SELECT
        v_id_ffa AS id_ffa,
        p_id_senha AS id_senha,
        'ABERTO' AS status,
        p_layout AS layout,
        NOW() AS criado_em;

END$$

DELIMITER ;

show tables;

-- 1️⃣ Procedure para criar usuário
DELIMITER $$
CREATE PROCEDURE sp_criar_usuario(
    IN p_nome VARCHAR(150),
    IN p_login VARCHAR(50),
    IN p_senha VARCHAR(255),
    IN p_id_perfil BIGINT,
    IN p_id_local BIGINT,
    OUT p_id_usuario BIGINT
)
BEGIN
    START TRANSACTION;

    -- Inserir usuário
    INSERT INTO usuario (nome, login, senha, criado_em)
    VALUES (p_nome, p_login, p_senha, NOW());
    SET p_id_usuario = LAST_INSERT_ID();

    -- Vincular perfil
    INSERT INTO usuario_perfil (id_usuario, id_perfil)
    VALUES (p_id_usuario, p_id_perfil);

    -- Alocação em local
    INSERT INTO usuario_alocacao (id_usuario, id_local)
    VALUES (p_id_usuario, p_id_local);

    -- Log de auditoria
    INSERT INTO log_auditoria (id_usuario, tabela, acao, detalhe, criado_em)
    VALUES (p_id_usuario, 'usuario', 'INSERT', CONCAT('Usuário criado: ', p_nome), NOW());

    COMMIT;
END$$
DELIMITER ;

-- 2️⃣ Procedure para reset de senha de usuário
DELIMITER $$
CREATE PROCEDURE sp_reset_senha_usuario(
    IN p_id_usuario BIGINT,
    IN p_nova_senha VARCHAR(255),
    IN p_id_admin BIGINT
)
BEGIN
    START TRANSACTION;

    UPDATE usuario
    SET senha = p_nova_senha, atualizado_em = NOW()
    WHERE id = p_id_usuario;

    -- Registrar auditoria
    INSERT INTO log_auditoria (id_usuario, tabela, acao, detalhe, criado_em)
    VALUES (p_id_admin, 'usuario', 'UPDATE', CONCAT('Reset de senha do usuário ', p_id_usuario), NOW());

    COMMIT;
END$$
DELIMITER ;

-- 3️⃣ Procedure para atualizar dados do paciente
DELIMITER $$
CREATE PROCEDURE sp_update_paciente(
    IN p_id_paciente BIGINT,
    IN p_nome VARCHAR(150),
    IN p_nascimento DATE,
    IN p_cns VARCHAR(20),
    IN p_telefone VARCHAR(50),
    IN p_endereco TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    START TRANSACTION;

    UPDATE paciente
    SET nome = p_nome,
        nascimento = p_nascimento,
        cns = p_cns,
        telefone = p_telefone,
        endereco = p_endereco,
        atualizado_em = NOW()
    WHERE id = p_id_paciente;

    -- Log de auditoria
    INSERT INTO log_auditoria (id_usuario, tabela, acao, detalhe, criado_em)
    VALUES (p_id_usuario, 'paciente', 'UPDATE', CONCAT('Atualização de paciente ', p_id_paciente), NOW());

    COMMIT;
END$$
DELIMITER ;

-- 4️⃣ Procedure para atualizar dados de usuário
DELIMITER $$
CREATE PROCEDURE sp_update_usuario(
    IN p_id_usuario BIGINT,
    IN p_nome VARCHAR(150),
    IN p_login VARCHAR(50),
    IN p_id_perfil BIGINT,
    IN p_id_local BIGINT,
    IN p_id_admin BIGINT
)
BEGIN
    START TRANSACTION;

    -- Atualizar dados básicos
    UPDATE usuario
    SET nome = p_nome,
        login = p_login,
        atualizado_em = NOW()
    WHERE id = p_id_usuario;

    -- Atualizar perfil
    UPDATE usuario_perfil
    SET id_perfil = p_id_perfil
    WHERE id_usuario = p_id_usuario;

    -- Atualizar alocação
    UPDATE usuario_alocacao
    SET id_local = p_id_local
    WHERE id_usuario = p_id_usuario;

    -- Auditoria
    INSERT INTO log_auditoria (id_usuario, tabela, acao, detalhe, criado_em)
    VALUES (p_id_admin, 'usuario', 'UPDATE', CONCAT('Atualização de usuário ', p_id_usuario), NOW());

    COMMIT;
END$$
DELIMITER ;
