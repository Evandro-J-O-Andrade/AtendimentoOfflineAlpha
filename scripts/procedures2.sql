

DELIMITER $$

CREATE PROCEDURE sp_gerar_senha (
    IN p_origem ENUM('TOTEM','RECEPCAO','ADMIN'),
    IN p_tipo_atendimento ENUM('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME'),
    IN p_prioridade TINYINT,
    IN p_id_paciente BIGINT,      -- pode ser NULL (totem sem cadastro)
    IN p_id_usuario BIGINT         -- NULL se totem
)
BEGIN
    DECLARE v_numero INT;
    DECLARE v_prefixo VARCHAR(5);
    DECLARE v_id_senha BIGINT;

    -- Prefixo por tipo
    SET v_prefixo = CASE p_tipo_atendimento
        WHEN 'CLINICO' THEN 'C'
        WHEN 'PEDIATRICO' THEN 'P'
        WHEN 'PRIORITARIO' THEN 'PR'
        WHEN 'EMERGENCIA' THEN 'E'
        WHEN 'EXAME' THEN 'X'
        ELSE 'G'
    END;

    -- Próximo número da senha (por tipo/dia)
    SELECT COALESCE(MAX(numero),0) + 1
      INTO v_numero
      FROM senhas
     WHERE DATE(criada_em) = CURDATE()
       AND tipo_atendimento = p_tipo_atendimento;

    -- Cria a senha
    INSERT INTO senhas (
        numero,
        prefixo,
        tipo_atendimento,
        status,
        origem,
        prioridade,
        criada_em
    ) VALUES (
        v_numero,
        v_prefixo,
        p_tipo_atendimento,
        'GERADA',
        p_origem,
        p_prioridade,
        NOW()
    );

    SET v_id_senha = LAST_INSERT_ID();

    -- Coloca na fila
    INSERT INTO fila_senha (
        senha,
        id_paciente,
        prioridade_recepcao,
        criado_em
    ) VALUES (
        v_id_senha,
        p_id_paciente,
        CASE
            WHEN p_prioridade = 1 THEN 'IDOSO'
            ELSE 'PADRAO'
        END,
        NOW()
    );

    -- Atualiza status para EM_FILA
    UPDATE senhas
       SET status = 'EM_FILA'
     WHERE id = v_id_senha;

    -- Auditoria de fila (se existir a tabela)
    /*
    INSERT INTO auditoria_fila (
        id_senha,
        acao,
        id_usuario,
        data_hora
    ) VALUES (
        v_id_senha,
        'GERACAO_SENHA',
        p_id_usuario,
        NOW()
    );
    */

    -- Retorno
    SELECT
        v_id_senha     AS id_senha,
        CONCAT(v_prefixo, v_numero) AS senha_formatada,
        p_tipo_atendimento AS tipo,
        p_origem AS origem,
        p_prioridade AS prioridade,
        NOW() AS criada_em;

END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_chamar_senha $$

CREATE PROCEDURE sp_chamar_senha (
    IN p_id_guiche INT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_fila BIGINT;
    DECLARE v_id_senha BIGINT;

    /*
      Seleciona a próxima senha válida:
      - ainda sem FFA
      - não finalizada
      - sem retorno futuro ativo
      - respeita prioridade e horário
    */
    SELECT fs.id, fs.senha
      INTO v_id_fila, v_id_senha
      FROM fila_senha fs
      LEFT JOIN fila_retorno fr 
             ON fr.id_fila = fs.id 
            AND fr.ativo = 1
            AND fr.retorno_em > NOW()
     WHERE fs.id_ffa IS NULL
       AND fs.status IN ('EM_FILA','GERADA')
       AND fr.id IS NULL
     ORDER BY
        CASE fs.prioridade_recepcao
            WHEN 'IDOSO' THEN 3
            WHEN 'CRIANCA' THEN 2
            WHEN 'ESPECIAL' THEN 1
            ELSE 0
        END DESC,
        fs.criado_em ASC
     LIMIT 1;

    -- Se não achou senha, encerra
    IF v_id_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nenhuma senha disponível para chamada';
    END IF;

    -- Marca a fila como chamada
    UPDATE fila_senha
       SET status        = 'CHAMADA',
           chamado_em    = NOW(),
           id_guiche     = p_id_guiche,
           id_usuario_chamada = p_id_usuario
     WHERE id = v_id_fila;

    -- Atualiza status da senha
    UPDATE senhas
       SET status = 'CHAMADA'
     WHERE id = v_id_senha;

    -- Auditoria (se existir)
    /*
    INSERT INTO auditoria_fila (
        id_senha,
        acao,
        id_usuario,
        data_hora,
        detalhe
    ) VALUES (
        v_id_senha,
        'CHAMADA_SENHA',
        p_id_usuario,
        NOW(),
        CONCAT('Guichê ', p_id_guiche)
    );
    */

    -- Retorno
    SELECT
        v_id_senha AS id_senha,
        p_id_guiche AS guiche,
        NOW() AS chamado_em;

END$$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_abrir_ffa $$

CREATE PROCEDURE sp_abrir_ffa (
    IN p_id_fila BIGINT,
    IN p_id_pessoa BIGINT,
    IN p_layout VARCHAR(50),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_gpat VARCHAR(30);
    DECLARE v_status_fila VARCHAR(20);

    /* 1. Valida a fila */
    SELECT status
      INTO v_status_fila
      FROM fila_senha
     WHERE id = p_id_fila
       AND id_ffa IS NULL
     FOR UPDATE;

    IF v_status_fila IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha inválida ou já vinculada a FFA';
    END IF;

    IF v_status_fila NOT IN ('CHAMADA') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Senha não está em estado válido para abertura de FFA';
    END IF;

    /* 2. Gera GPAT */
    SET v_gpat = fn_gera_protocolo();

    /* 3. Cria a FFA */
    INSERT INTO ffa (
        gpat,
        id_pessoa,
        status,
        layout,
        criado_em
    ) VALUES (
        v_gpat,
        p_id_pessoa,
        'ABERTO',
        p_layout,
        NOW()
    );

    SET v_id_ffa = LAST_INSERT_ID();

    /* 4. Vincula fila à FFA */
    UPDATE fila_senha
       SET id_ffa   = v_id_ffa,
           status   = 'EM_ATENDIMENTO',
           atualizado_em = NOW()
     WHERE id = p_id_fila;

    /* 5. Auditoria assistencial */
    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        id_usuario,
        criado_em,
        detalhe
    ) VALUES (
        'FFA',
        v_id_ffa,
        'ABERTURA_FFA',
        p_id_usuario,
        NOW(),
        CONCAT('FFA aberta a partir da senha ', p_id_fila)
    );

    /* 6. Retorno */
    SELECT
        v_id_ffa AS id_ffa,
        v_gpat   AS gpat,
        'FFA_ABERTA' AS status;

END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_inicio_triagem;
DELIMITER $$

CREATE PROCEDURE sp_inicio_triagem (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    SELECT status
    INTO v_status_atual
    FROM ffa
    WHERE id = p_id_ffa;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA não encontrada';
    END IF;

    IF v_status_atual NOT IN ('ABERTO','AGUARDANDO_TRIAGEM') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA não está apta para iniciar triagem';
    END IF;

    UPDATE ffa
    SET status = 'EM_TRIAGEM',
        inicio_triagem_em = NOW()
    WHERE id = p_id_ffa;

    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        'FFA',
        p_id_ffa,
        'INICIO_TRIAGEM',
        'Triagem iniciada',
        p_id_usuario,
        NOW()
    );
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_classificar_manchester;
DELIMITER $$

CREATE PROCEDURE sp_classificar_manchester (
    IN p_id_ffa BIGINT,
    IN p_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_senha BIGINT;

    SELECT id_senha
    INTO v_id_senha
    FROM ffa
    WHERE id = p_id_ffa;

    IF v_id_senha IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA sem senha associada';
    END IF;

    UPDATE ffa
    SET classificacao_manchester = p_classificacao
    WHERE id = p_id_ffa;

    UPDATE senha
    SET prioridade = CASE p_classificacao
        WHEN 'VERMELHO' THEN 5
        WHEN 'LARANJA'  THEN 4
        WHEN 'AMARELO'  THEN 3
        WHEN 'VERDE'    THEN 2
        WHEN 'AZUL'     THEN 1
    END
    WHERE id = v_id_senha;

    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        'FFA',
        p_id_ffa,
        'CLASSIFICACAO_MANCHESTER',
        CONCAT('Classificação: ', p_classificacao),
        p_id_usuario,
        NOW()
    );
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_finalizar_triagem;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_triagem (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    SELECT status
    INTO v_status_atual
    FROM ffa
    WHERE id = p_id_ffa;

    IF v_status_atual <> 'EM_TRIAGEM' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FFA não está em triagem';
    END IF;

    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',
        fim_triagem_em = NOW()
    WHERE id = p_id_ffa;

    INSERT INTO auditoria_eventos (
        entidade,
        id_entidade,
        evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        'FFA',
        p_id_ffa,
        'FIM_TRIAGEM',
        'Triagem finalizada',
        p_id_usuario,
        NOW()
    );
END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_chamar_paciente_medico (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_local VARCHAR(50)
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida status atual da FFA
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual <> 'AGUARDANDO_CHAMADA_MEDICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está aguardando chamada médica';
    END IF;

    -- Atualiza status da FFA
    UPDATE ffa
       SET status = 'CHAMANDO_MEDICO',
           layout = 'MEDICO'
     WHERE id = p_id_ffa;

    -- Atualiza a senha vinculada (chamada em painel)
    UPDATE fila_senha
       SET status = 'CHAMADA',
           id_usuario_chamada = p_id_usuario,
           guiche_chamada = p_local,
           chamada_em = NOW()
     WHERE id_ffa = p_id_ffa
       AND status IN ('EM_FILA','EM_TRIAGEM');

    -- Registra evento
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CHAMADA_MEDICA',
        CONCAT('Paciente chamado para atendimento médico no local ', p_local),
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_inicio_atendimento_medico;

DELIMITER $$

CREATE PROCEDURE sp_inicio_atendimento_medico (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida status atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual <> 'CHAMANDO_MEDICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em estado de chamada médica';
    END IF;

    -- Atualiza FFA para atendimento médico
    UPDATE ffa
       SET status = 'EM_ATENDIMENTO_MEDICO',
           layout = 'MEDICO',
           atendimento_medico_inicio = NOW()
     WHERE id = p_id_ffa;

    -- Atualiza senha (controle de auditoria)
    UPDATE fila_senha
       SET status = 'EM_ATENDIMENTO'
     WHERE id_ffa = p_id_ffa
       AND status = 'CHAMADA';

    -- Evento assistencial
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'INICIO_ATENDIMENTO_MEDICO',
        'Atendimento médico iniciado',
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_finalizar_atendimento_medico;


DELIMITER $$

CREATE PROCEDURE sp_finalizar_atendimento_medico (
    IN p_id_ffa BIGINT,
    IN p_destino VARCHAR(30), -- ALTA | OBSERVACAO | MEDICACAO | RX | INTERNACAO | RETORNO
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida estado atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual <> 'EM_ATENDIMENTO_MEDICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em atendimento médico';
    END IF;

    -- Atualiza FFA conforme destino
    UPDATE ffa
       SET status = 
           CASE p_destino
               WHEN 'ALTA'        THEN 'ALTA'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'MEDICACAO'   THEN 'AGUARDANDO_MEDICACAO'
               WHEN 'RX'          THEN 'AGUARDANDO_RX'
               WHEN 'INTERNACAO'  THEN 'INTERNACAO'
               WHEN 'RETORNO'     THEN 'AGUARDANDO_RETORNO'
               ELSE status
           END,
           layout =
           CASE p_destino
               WHEN 'ALTA'        THEN 'FINAL'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'MEDICACAO'   THEN 'PROCEDIMENTOS'
               WHEN 'RX'          THEN 'PROCEDIMENTOS'
               WHEN 'INTERNACAO'  THEN 'INTERNACAO'
               WHEN 'RETORNO'     THEN 'RETORNO'
               ELSE layout
           END,
           atendimento_medico_fim = NOW(),
           id_usuario_alteracao = p_id_usuario
     WHERE id = p_id_ffa;

    -- Observação clínica (opcional)
    IF p_observacao IS NOT NULL AND LENGTH(TRIM(p_observacao)) > 0 THEN
        INSERT INTO observacoes_eventos (
            entidade,
            id_entidade,
            tipo,
            contexto,
            texto,
            id_usuario,
            criado_em
        ) VALUES (
            'FFA',
            p_id_ffa,
            'CLINICA',
            'ENCERRAMENTO_ATENDIMENTO_MEDICO',
            p_observacao,
            p_id_usuario,
            NOW()
        );
    END IF;

    -- Evento de fluxo
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FIM_ATENDIMENTO_MEDICO',
        CONCAT('Destino definido: ', p_destino),
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_finalizar_atendimento_medico (
    IN p_id_ffa BIGINT,
    IN p_destino VARCHAR(30), -- ALTA | OBSERVACAO | MEDICACAO | RX | INTERNACAO | RETORNO
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida estado atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual <> 'EM_ATENDIMENTO_MEDICO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em atendimento médico';
    END IF;

    -- Atualiza FFA conforme destino
    UPDATE ffa
       SET status = 
           CASE p_destino
               WHEN 'ALTA'        THEN 'ALTA'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'MEDICACAO'   THEN 'AGUARDANDO_MEDICACAO'
               WHEN 'RX'          THEN 'AGUARDANDO_RX'
               WHEN 'INTERNACAO'  THEN 'INTERNACAO'
               WHEN 'RETORNO'     THEN 'AGUARDANDO_RETORNO'
               ELSE status
           END,
           layout =
           CASE p_destino
               WHEN 'ALTA'        THEN 'FINAL'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'MEDICACAO'   THEN 'PROCEDIMENTOS'
               WHEN 'RX'          THEN 'PROCEDIMENTOS'
               WHEN 'INTERNACAO'  THEN 'INTERNACAO'
               WHEN 'RETORNO'     THEN 'RETORNO'
               ELSE layout
           END,
           atendimento_medico_fim = NOW(),
           id_usuario_alteracao = p_id_usuario
     WHERE id = p_id_ffa;

    -- Observação clínica (opcional)
    IF p_observacao IS NOT NULL AND LENGTH(TRIM(p_observacao)) > 0 THEN
        INSERT INTO observacoes_eventos (
            entidade,
            id_entidade,
            tipo,
            contexto,
            texto,
            id_usuario,
            criado_em
        ) VALUES (
            'FFA',
            p_id_ffa,
            'CLINICA',
            'ENCERRAMENTO_ATENDIMENTO_MEDICO',
            p_observacao,
            p_id_usuario,
            NOW()
        );
    END IF;

    -- Evento de fluxo
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FIM_ATENDIMENTO_MEDICO',
        CONCAT('Destino definido: ', p_destino),
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_chamar_procedimento;

DELIMITER $$

CREATE PROCEDURE sp_chamar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo_procedimento VARCHAR(30), -- MEDICACAO | RX | COLETA | ECG
    IN p_id_local INT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_novo_status VARCHAR(50);

    -- Determina status conforme procedimento
    SET v_novo_status =
        CASE p_tipo_procedimento
            WHEN 'MEDICACAO' THEN 'EM_MEDICACAO'
            WHEN 'RX'        THEN 'EM_RX'
            WHEN 'COLETA'    THEN 'EM_COLETA'
            WHEN 'ECG'       THEN 'EM_ECG'
            ELSE NULL
        END;

    IF v_novo_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Tipo de procedimento inválido';
    END IF;

    -- Valida estado atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual NOT LIKE 'AGUARDANDO_%' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está aguardando procedimento';
    END IF;

    -- Atualiza FFA
    UPDATE ffa
       SET status = v_novo_status,
           layout = 'PROCEDIMENTOS',
           id_local_atendimento = p_id_local,
           id_usuario_alteracao = p_id_usuario,
           atualizado_em = NOW()
     WHERE id = p_id_ffa;

    -- Evento
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CHAMADA_PROCEDIMENTO',
        CONCAT('Chamado para ', p_tipo_procedimento),
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_finalizar_procedimento;

DELIMITER $$

CREATE PROCEDURE sp_finalizar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_destino VARCHAR(30), -- MEDICO | OBSERVACAO | ALTA
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    -- Valida estado atual
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id = p_id_ffa
     FOR UPDATE;

    IF v_status_atual NOT IN ('EM_MEDICACAO','EM_RX','EM_COLETA','EM_ECG') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não está em procedimento';
    END IF;

    -- Define próximo status
    UPDATE ffa
       SET status =
           CASE p_destino
               WHEN 'MEDICO'      THEN 'AGUARDANDO_CHAMADA_MEDICO'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'ALTA'        THEN 'ALTA'
               ELSE status
           END,
           layout =
           CASE p_destino
               WHEN 'MEDICO'      THEN 'ATENDIMENTO_MEDICO'
               WHEN 'OBSERVACAO'  THEN 'OBSERVACAO'
               WHEN 'ALTA'        THEN 'FINAL'
               ELSE layout
           END,
           id_usuario_alteracao = p_id_usuario,
           atualizado_em = NOW()
     WHERE id = p_id_ffa;

    -- Observação técnica (opcional)
    IF p_observacao IS NOT NULL AND LENGTH(TRIM(p_observacao)) > 0 THEN
        INSERT INTO observacoes_eventos (
            entidade,
            id_entidade,
            tipo,
            contexto,
            texto,
            id_usuario,
            criado_em
        ) VALUES (
            'FFA',
            p_id_ffa,
            'TECNICA',
            'FINALIZACAO_PROCEDIMENTO',
            p_observacao,
            p_id_usuario,
            NOW()
        );
    END IF;

    -- Evento
    INSERT INTO eventos_ffa (
        id_ffa,
        tipo_evento,
        descricao,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FIM_PROCEDIMENTO',
        CONCAT('Destino pós-procedimento: ', p_destino),
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_prescrever_medicacao (
    IN p_id_ffa BIGINT,
    IN p_id_medico BIGINT,
    IN p_descricao TEXT,
    IN p_controlada TINYINT
)
BEGIN
    DECLARE v_id_prescricao BIGINT;

    INSERT INTO prescricao_medicacao (
        id_ffa, id_medico, descricao, controlada
    ) VALUES (
        p_id_ffa, p_id_medico, p_descricao, p_controlada
    );

    SET v_id_prescricao = LAST_INSERT_ID();

    INSERT INTO ffa_substatus (
        id_ffa, categoria, status, id_usuario
    ) VALUES (
        p_id_ffa, 'MEDICACAO', 'PRESCRITA', p_id_medico
    );

    IF p_controlada = 1 THEN
        INSERT INTO ffa_substatus (
            id_ffa, categoria, status
        ) VALUES (
            p_id_ffa, 'FARMACIA', 'AGUARDANDO_ANALISE'
        );
    ELSE
        INSERT INTO ffa_substatus (
            id_ffa, categoria, status
        ) VALUES (
            p_id_ffa, 'MEDICACAO', 'AGUARDANDO_MEDICACAO'
        );
    END IF;

    -- Garante que a FFA esteja no macro correto
    UPDATE ffa
       SET status = 'EM_PROCEDIMENTO'
     WHERE id = p_id_ffa
       AND status NOT IN ('EM_OBSERVACAO','INTERNADO','ALTA','FINALIZADO');
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_iniciar_medicacao (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    -- Segurança: só inicia se liberada
    IF NOT EXISTS (
        SELECT 1
          FROM ffa_substatus
         WHERE id_ffa = p_id_ffa
           AND categoria = 'FARMACIA'
           AND status IN ('LIBERADA','LIBERACAO_EXCEPCIONAL')
           AND ativo = 1
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medicação não liberada pela farmácia';
    END IF;

    INSERT INTO ffa_substatus (
        id_ffa, categoria, status, id_usuario
    ) VALUES (
        p_id_ffa, 'MEDICACAO', 'EM_MEDICACAO', p_id_usuario
    );
END$$

DELIMITER ;
DROP PROCEDURE IF EXISTS sp_solicitar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('RX','ECG','EXAME_LAB','OUTROS'),
    IN p_descricao TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO ffa_procedimento (
        id_ffa, tipo, descricao, solicitado_por
    ) VALUES (
        p_id_ffa, p_tipo, p_descricao, p_id_usuario
    );

    INSERT INTO ffa_substatus (
        id_ffa, categoria, status, id_usuario
    ) VALUES (
        p_id_ffa, 'PROCEDIMENTO', 'SOLICITADO', p_id_usuario
    );

    UPDATE ffa
       SET status = 'EM_PROCEDIMENTO'
     WHERE id = p_id_ffa;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_iniciar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_procedimento (
    IN p_id_procedimento BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_substatus
       SET ativo = 0,
           finalizado_em = NOW()
     WHERE id_ffa = (
         SELECT id_ffa FROM ffa_procedimento WHERE id_procedimento = p_id_procedimento
     )
       AND categoria = 'PROCEDIMENTO'
       AND ativo = 1;

    INSERT INTO ffa_substatus (
        id_ffa, categoria, status, id_usuario
    )
    SELECT id_ffa, 'PROCEDIMENTO', 'EM_EXECUCAO', p_id_usuario
      FROM ffa_procedimento
     WHERE id_procedimento = p_id_procedimento;
END$$

DELIMITER ;



CREATE OR REPLACE VIEW vw_procedimentos_pendentes AS
SELECT
    p.id_procedimento,
    p.tipo,
    p.descricao,
    p.criado_em,
    f.id AS id_ffa,
    f.status
FROM ffa_procedimento p
JOIN ffa f ON f.id = p.id_ffa
WHERE p.ativo = 1;


DROP PROCEDURE IF EXISTS sp_solicitar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(20),
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO fila_operacional (
        id_ffa,
        tipo,
        solicitado_por
    )
    VALUES (
        p_id_ffa,
        p_tipo,
        p_id_usuario
    );

    UPDATE ffa
    SET status = 'AGUARDANDO_' || p_tipo,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_iniciar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_procedimento (
    IN p_id_fila BIGINT
)
BEGIN
    UPDATE fila_operacional
    SET status = 'EM_EXECUCAO',
        iniciado_em = NOW()
    WHERE id = p_id_fila
      AND status = 'AGUARDANDO';

    UPDATE ffa f
    JOIN fila_operacional fo ON fo.id_ffa = f.id
    SET f.status = CONCAT('EM_', fo.tipo),
        f.atualizado_em = NOW()
    WHERE fo.id = p_id_fila;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_iniciar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_procedimento (
    IN p_id_fila BIGINT
)
BEGIN
    UPDATE fila_operacional
    SET status = 'EM_EXECUCAO',
        iniciado_em = NOW()
    WHERE id = p_id_fila
      AND status = 'AGUARDANDO';

    UPDATE ffa f
    JOIN fila_operacional fo ON fo.id_ffa = f.id
    SET f.status = CONCAT('EM_', fo.tipo),
        f.atualizado_em = NOW()
    WHERE fo.id = p_id_fila;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_retorno_procedimento_normal;
DELIMITER $$

CREATE PROCEDURE sp_retorno_procedimento_normal (
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_retorno_procedimento_critico;
DELIMITER $$

CREATE PROCEDURE sp_retorno_procedimento_critico (
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
    SET status = 'EMERGENCIA',
        classificacao_manchester = 'VERMELHO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_inserir_fila(
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO'),
    IN p_prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_local INT,
    IN p_observacao TEXT
)
BEGIN
    INSERT INTO fila_operacional (id_ffa, tipo, prioridade, substatus, id_local, observacao)
    VALUES (p_id_ffa, p_tipo, p_prioridade, 'AGUARDANDO', p_id_local, p_observacao);
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_atualizar_fila(
    IN p_id_fila BIGINT,
    IN p_substatus ENUM('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','FINALIZADO','CRITICO'),
    IN p_id_responsavel BIGINT,
    IN p_observacao TEXT
)
BEGIN
    UPDATE fila_operacional
    SET substatus = p_substatus,
        id_responsavel = p_id_responsavel,
        observacao = p_observacao,
        data_inicio = IF(p_substatus='EM_EXECUCAO', NOW(), data_inicio),
        data_fim = IF(p_substatus='FINALIZADO', NOW(), data_fim)
    WHERE id_fila = p_id_fila;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_retorno_medico(
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1), -- 1 = crítico, vai direto
    IN p_id_local INT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL');
    
    IF p_critico = 1 THEN
        SET v_prioridade = 'VERMELHO';
    ELSE
        SET v_prioridade = 'AZUL';
    END IF;
    
    CALL sp_inserir_fila(p_id_ffa, 'MEDICO', v_prioridade, p_id_local, p_observacao);
END$$
DELIMITER ;


DROP VIEW IF EXISTS vw_fila_operacional_atual;

CREATE VIEW vw_fila_operacional_atual AS
SELECT 
    f.id_fila,
    f.id_ffa,
    f.tipo,
    f.substatus,
    f.prioridade,
    f.data_entrada,
    f.data_inicio,
    f.data_fim,
    f.id_responsavel,
    u.login AS responsavel_login,
    f.id_local,
    l.nome AS local_nome,
    f.observacao
FROM fila_operacional f
LEFT JOIN usuario u ON u.id_usuario = f.id_responsavel
LEFT JOIN local_atendimento l ON l.id_local = f.id_local
WHERE f.substatus != 'FINALIZADO';


DELIMITER $$
CREATE PROCEDURE sp_listar_fila_operacional(
    IN p_tipo ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO'),
    IN p_prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL')
)
BEGIN
    SELECT *
    FROM vw_fila_operacional_atual
    WHERE tipo = p_tipo
      AND (prioridade = p_prioridade OR p_prioridade IS NULL)
    ORDER BY 
        FIELD(prioridade,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
        data_entrada;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_historico_fila_ffa(
    IN p_id_ffa BIGINT
)
BEGIN
    SELECT *
    FROM vw_historico_fila_operacional
    WHERE id_ffa = p_id_ffa
    ORDER BY data_entrada, data_inicio;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE sp_update_substatus_operacional(
    IN p_id_fila BIGINT,
    IN p_substatus ENUM('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','FINALIZADO','CRITICO'),
    IN p_id_responsavel BIGINT,
    IN p_observacao TEXT
)
BEGIN
    -- Evita quebrar fila: não permite retroceder substatus já finalizado
    IF (SELECT substatus FROM fila_operacional WHERE id_fila = p_id_fila) != 'FINALIZADO' THEN
        CALL sp_atualizar_fila(p_id_fila, p_substatus, p_id_responsavel, p_observacao);
    END IF;
END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_retorno_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo_retorno ENUM('NORMAL','EMERGENCIA'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_substatus VARCHAR(50);

    -- 1. Busca o status atual do paciente
    SELECT status, substatus
    INTO v_status_atual, v_substatus
    FROM ffa
    WHERE id = p_id_ffa
    LIMIT 1;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA não encontrada';
    END IF;

    -- 2. Define próximo status e substatus baseado no tipo de retorno
    IF p_tipo_retorno = 'EMERGENCIA' THEN
        SET v_status_atual = 'CHAMANDO_MEDICO';
        SET v_substatus = 'EMERGENCIA';
    ELSE
        SET v_status_atual = 'AGUARDANDO_CHAMADA_MEDICO';
        SET v_substatus = 'NORMAL';
    END IF;

    -- 3. Atualiza FFA com novo status e substatus
    UPDATE ffa
    SET status = v_status_atual,
        substatus = v_substatus,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- 4. Insere na fila_operacional
    INSERT INTO fila_operacional (
        id_ffa,
        tipo_evento,
        prioridade,
        criado_em
    ) VALUES (
        p_id_ffa,
        'RETORNO_PROCEDIMENTO',
        IF(p_tipo_retorno='EMERGENCIA', 1, 5), -- prioridade: 1 máxima, 5 normal
        NOW()
    );

    -- 5. Registra auditoria
    INSERT INTO auditoria_ffa (
        id_ffa,
        acao,
        descricao,
        id_usuario,
        data_hora
    ) VALUES (
        p_id_ffa,
        'RETORNO_PROCEDIMENTO',
        CONCAT('Tipo: ', p_tipo_retorno, '; Substatus atualizado: ', v_substatus),
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_execucao_medicacao (
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('MEDICACAO','OBSERVACAO'),
    IN p_id_usuario BIGINT,
    IN p_acao ENUM('AGUARDANDO','EM_EXECUCAO','CONCLUIDO')
)
BEGIN
    DECLARE v_substatus VARCHAR(50);

    -- Define substatus
    SET v_substatus = CONCAT(p_tipo,'_',p_acao);

    -- Atualiza FFA com substatus
    UPDATE ffa
    SET substatus = v_substatus,
        atualizado_em = NOW()
    WHERE id = p_id_ffa;

    -- Insere na fila operacional para controle
    INSERT INTO fila_operacional (
        id_ffa,
        tipo_evento,
        prioridade,
        criado_em
    ) VALUES (
        p_id_ffa,
        CONCAT('EXECUCAO_',p_tipo),
        CASE WHEN p_acao='CONCLUIDO' THEN 10 ELSE 5 END,
        NOW()
    );

    -- Auditoria
    INSERT INTO auditoria_ffa (
        id_ffa,
        acao,
        descricao,
        id_usuario,
        data_hora
    ) VALUES (
        p_id_ffa,
        CONCAT('EXECUCAO_',p_tipo),
        CONCAT('Substatus atualizado: ', v_substatus),
        p_id_usuario,
        NOW()
    );

END$$

DELIMITER ;


DELIMITER $$


CREATE PROCEDURE sp_finalizar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo_retorno ENUM('NORMAL','EMERGENCIA'),
    IN p_classificacao ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_now DATETIME DEFAULT NOW();

    -- 1. Finaliza procedimento
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           data_fim = v_now
     WHERE id_ffa = p_id_ffa
       AND status = 'EM_EXECUCAO';

    -- 2. Evento auditável
    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    VALUES (
        p_id_ffa,
        CONCAT('RETORNO_PROCEDIMENTO_', p_tipo_retorno),
        v_now,
        p_id_usuario
    );

    -- 3. Fluxo
    IF p_tipo_retorno = 'EMERGENCIA' THEN

        UPDATE ffa
           SET status = 'EM_EMERGENCIA'
         WHERE id = p_id_ffa;

        INSERT INTO fila_operacional (
            id_ffa, prioridade, data_entrada, origem
        ) VALUES (
            p_id_ffa, 'VERMELHO', v_now, 'PROCEDIMENTO'
        );

    ELSE

        UPDATE ffa
           SET status = 'AGUARDANDO_MEDICO'
         WHERE id = p_id_ffa;

        INSERT INTO fila_retorno (
            id_ffa, data_retorno, origem
        ) VALUES (
            p_id_ffa, v_now, 'PROCEDIMENTO'
        );

    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_iniciar_execucao_assistencial (
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('MEDICACAO','OBSERVACAO'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_substatus VARCHAR(50);
    DECLARE v_now DATETIME DEFAULT NOW();

    IF p_tipo = 'MEDICACAO' THEN
        SET v_substatus = 'EM_MEDICACAO';
    ELSE
        SET v_substatus = 'EM_OBSERVACAO';
    END IF;

    -- Atualiza substatus
    UPDATE ffa_substatus
       SET status = v_substatus,
           data_inicio = v_now
     WHERE id_ffa = p_id_ffa
       AND ativo = 1;

    -- Evento
    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    VALUES (
        p_id_ffa,
        CONCAT('INICIO_', v_substatus),
        v_now,
        p_id_usuario
    );
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_finalizar_execucao_assistencial (
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('MEDICACAO','OBSERVACAO'),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_substatus VARCHAR(50);
    DECLARE v_now DATETIME DEFAULT NOW();

    IF p_tipo = 'MEDICACAO' THEN
        SET v_substatus = 'MEDICACAO_FINALIZADA';
    ELSE
        SET v_substatus = 'OBSERVACAO_CONCLUIDA';
    END IF;

    UPDATE ffa_substatus
       SET status = v_substatus,
           data_fim = v_now,
           ativo = 0
     WHERE id_ffa = p_id_ffa
       AND ativo = 1;

    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    VALUES (
        p_id_ffa,
        CONCAT('FIM_', v_substatus),
        v_now,
        p_id_usuario
    );

    -- Retorna automaticamente ao médico
    UPDATE ffa
       SET status = 'AGUARDANDO_MEDICO'
     WHERE id = p_id_ffa;

END$$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE sp_iniciar_procedimento (
    IN p_id_procedimento BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           inicio_execucao = NOW()
     WHERE id = p_id_procedimento;

    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    SELECT id_ffa, 'INICIO_PROCEDIMENTO', NOW(), p_id_usuario
      FROM ffa_procedimento
     WHERE id = p_id_procedimento;
END$$

DELIMITER ;



drop procedure sp_solicitar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('RX','ECG','LAB','PROCEDIMENTO'),
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO ffa_procedimento (
        id_ffa, tipo, status, criado_em
    ) VALUES (
        p_id_ffa, p_tipo, 'AGUARDANDO', NOW()
    );

    UPDATE ffa
       SET status = 'AGUARDANDO_PROCEDIMENTO'
     WHERE id = p_id_ffa;

    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    VALUES (
        p_id_ffa,
        CONCAT('SOLICITADO_', p_tipo),
        NOW(),
        p_id_usuario
    );
END$$

DELIMITER ;

drop procedure sp_finalizar_procedimento;

DELIMITER $$

CREATE PROCEDURE sp_finalizar_procedimento (
    IN p_id_procedimento BIGINT,
    IN p_critico TINYINT(1),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa INTO v_id_ffa
      FROM ffa_procedimento
     WHERE id = p_id_procedimento;

    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           fim_execucao = NOW()
     WHERE id = p_id_procedimento;

    IF p_critico = 1 THEN
        UPDATE ffa SET status = 'RETORNO_EMERGENCIA' WHERE id = v_id_ffa;
    ELSE
        UPDATE ffa SET status = 'RETORNO_MEDICO' WHERE id = v_id_ffa;
    END IF;

    INSERT INTO evento_ffa (id_ffa, evento, data_evento, id_usuario)
    VALUES (
        v_id_ffa,
        IF(p_critico=1,'RETORNO_CRITICO','RETORNO_NORMAL'),
        NOW(),
        p_id_usuario
    );
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_internar_paciente;
DELIMITER $$

CREATE PROCEDURE sp_internar_paciente (
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('OBSERVACAO','INTERNACAO'),
    IN p_id_leito INT,
    IN p_id_usuario BIGINT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM internacao
         WHERE id_ffa = p_id_ffa
           AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Já existe internação ativa para esta FFA';
    END IF;

    INSERT INTO internacao (
        id_ffa, id_leito, tipo, data_entrada
    ) VALUES (
        p_id_ffa, p_id_leito, p_tipo, NOW()
    );

    UPDATE ffa
       SET status = 'INTERNADO'
     WHERE id = p_id_ffa;

    INSERT INTO internacao_historico
        (id_internacao, evento, data_evento, id_usuario)
    VALUES
        (LAST_INSERT_ID(), 'ENTRADA', NOW(), p_id_usuario);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_alta_internacao;
DELIMITER $$

CREATE PROCEDURE sp_alta_internacao (
    IN p_id_ffa BIGINT,
    IN p_motivo VARCHAR(255),
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_internacao BIGINT;

    SELECT id_internacao
      INTO v_id_internacao
      FROM internacao
     WHERE id_ffa = p_id_ffa
       AND status = 'ATIVA'
     LIMIT 1;

    IF v_id_internacao IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhuma internação ativa encontrada';
    END IF;

    UPDATE internacao
       SET status = 'ENCERRADA',
           data_saida = NOW(),
           motivo_alta = p_motivo,
           encerrado_em = NOW()
     WHERE id_internacao = v_id_internacao;

    UPDATE ffa
       SET status = 'ALTA'
     WHERE id = p_id_ffa;

    INSERT INTO internacao_historico
        (id_internacao, evento, data_evento, id_usuario)
    VALUES
        (v_id_internacao, 'ALTA', NOW(), p_id_usuario);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_finalizar_atendimento;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_atendimento (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM internacao
        WHERE id_ffa = p_id_ffa
          AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Internação ativa. Use alta de internação.';
    END IF;

    UPDATE ffa
       SET status = 'FINALIZADO',
           encerrado_em = NOW()
     WHERE id = p_id_ffa;

    INSERT INTO auditoria_ffa
        (id_ffa, evento, data_evento, id_usuario)
    VALUES
        (p_id_ffa, 'FINALIZACAO', NOW(), p_id_usuario);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_finalizar_atendimento;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_atendimento (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM internacao
        WHERE id_ffa = p_id_ffa
          AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Internação ativa. Use alta de internação.';
    END IF;

    UPDATE ffa
       SET status = 'FINALIZADO',
           encerrado_em = NOW()
     WHERE id = p_id_ffa;

    INSERT INTO auditoria_ffa
        (id_ffa, evento, data_evento, id_usuario)
    VALUES
        (p_id_ffa, 'FINALIZACAO', NOW(), p_id_usuario);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_nao_atendido;
DELIMITER $$

CREATE PROCEDURE sp_nao_atendido (
    IN p_id_ffa BIGINT,
    IN p_motivo VARCHAR(255),
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa
       SET status = 'NAO_ATENDIDO',
           encerrado_em = NOW()
     WHERE id = p_id_ffa;

    INSERT INTO auditoria_ffa
        (id_ffa, evento, observacao, data_evento, id_usuario)
    VALUES
        (p_id_ffa, 'NAO_ATENDIDO', p_motivo, NOW(), p_id_usuario);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_timeout_ffa;
DELIMITER $$

CREATE PROCEDURE sp_timeout_ffa ()
BEGIN
    UPDATE ffa
       SET status = 'TIMEOUT',
           encerrado_em = NOW()
     WHERE status NOT IN ('FINALIZADO','NAO_ATENDIDO','ALTA')
       AND TIMESTAMPDIFF(HOUR, criado_em, NOW()) >= 14;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_timeout_ffa;
DELIMITER $$

CREATE PROCEDURE sp_timeout_ffa ()
BEGIN
    UPDATE ffa
       SET status = 'TIMEOUT',
           encerrado_em = NOW()
     WHERE status NOT IN ('FINALIZADO','NAO_ATENDIDO','ALTA')
       AND TIMESTAMPDIFF(HOUR, criado_em, NOW()) >= 14;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_solicitar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(20),
    IN p_prioridade VARCHAR(20),
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO ffa_procedimento
        (id_ffa, tipo, prioridade, id_usuario_solicitante)
    VALUES
        (p_id_ffa, p_tipo, p_prioridade, p_id_usuario);

    UPDATE ffa
       SET status = CONCAT('AGUARDANDO_', p_tipo)
     WHERE id = p_id_ffa;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_iniciar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_procedimento (
    IN p_id_procedimento BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW(),
           id_usuario_execucao = p_id_usuario
     WHERE id_procedimento = p_id_procedimento;
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS sp_finalizar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_procedimento (
    IN p_id_procedimento BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa INTO v_id_ffa
      FROM ffa_procedimento
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa_procedimento
       SET status = 'CONCLUIDO',
           finalizado_em = NOW()
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa
       SET status = 'AGUARDANDO_RETORNO'
     WHERE id = v_id_ffa;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_procedimento_critico;
DELIMITER $$

CREATE PROCEDURE sp_procedimento_critico (
    IN p_id_procedimento BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa INTO v_id_ffa
      FROM ffa_procedimento
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa_procedimento
       SET status = 'CRITICO',
           observacao = p_observacao,
           finalizado_em = NOW()
     WHERE id_procedimento = p_id_procedimento;

    UPDATE ffa
       SET status = 'EMERGENCIA'
     WHERE id = v_id_ffa;
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_retorno_medico;
DELIMITER $$

CREATE PROCEDURE sp_retorno_medico (
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE fila_operacional
       SET status = 'AGUARDANDO_MEDICO'
     WHERE id_ffa = p_id_ffa;

    UPDATE ffa
       SET status = 'AGUARDANDO_CHAMADA_MEDICO'
     WHERE id = p_id_ffa;
END$$
DELIMITER ;

DROP VIEW IF EXISTS vw_procedimentos_pendentes;

CREATE VIEW vw_procedimentos_pendentes AS
SELECT
    p.id_procedimento,
    p.id_ffa,
    p.tipo,
    p.status,
    p.prioridade,
    p.criado_em
FROM ffa_procedimento p
WHERE p.status IN ('SOLICITADO','EM_FILA','EM_EXECUCAO');


DROP PROCEDURE IF EXISTS sp_internar_paciente;
DELIMITER $$

CREATE PROCEDURE sp_internar_paciente (
    IN p_id_ffa BIGINT,
    IN p_id_leito INT,
    IN p_tipo VARCHAR(20),
    IN p_motivo TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_atendimento BIGINT;

    SELECT id_atendimento INTO v_id_atendimento
      FROM atendimento
     WHERE id_senha = (SELECT id_senha FROM ffa WHERE id = p_id_ffa)
     ORDER BY data_abertura DESC
     LIMIT 1;

    INSERT INTO internacao
        (id_atendimento, id_leito, tipo, motivo, data_entrada, id_usuario_entrada)
    VALUES
        (v_id_atendimento, p_id_leito, p_tipo, p_motivo, NOW(), p_id_usuario);

    UPDATE leito
       SET status = 'OCUPADO'
     WHERE id_leito = p_id_leito;

    UPDATE ffa
       SET status = 'INTERNACAO'
     WHERE id = p_id_ffa;

    INSERT INTO internacao_historico
        (id_internacao, evento, descricao, id_usuario)
    VALUES
        (LAST_INSERT_ID(), 'ENTRADA', p_motivo, p_id_usuario);
END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_alta_internacao;
DELIMITER $$

CREATE PROCEDURE sp_alta_internacao (
    IN p_id_internacao BIGINT,
    IN p_observacao TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_leito INT;
    DECLARE v_id_atendimento BIGINT;

    SELECT id_leito, id_atendimento
      INTO v_id_leito, v_id_atendimento
      FROM internacao
     WHERE id_internacao = p_id_internacao;

    UPDATE internacao
       SET status = 'ENCERRADA',
           data_saida = NOW(),
           id_usuario_saida = p_id_usuario
     WHERE id_internacao = p_id_internacao;

    UPDATE leito
       SET status = 'LIVRE'
     WHERE id_leito = v_id_leito;

    UPDATE atendimento
       SET status_atendimento = 'FINALIZADO',
           data_fechamento = NOW()
     WHERE id_atendimento = v_id_atendimento;

    INSERT INTO internacao_historico
        (id_internacao, evento, descricao, id_usuario)
    VALUES
        (p_id_internacao, 'ALTA', p_observacao, p_id_usuario);
END$$


DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_solicitar_exame_rx $$
CREATE PROCEDURE sp_solicitar_exame_rx (
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);

    /* 1️⃣ Validação básica */
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id_ffa = p_id_ffa
       AND ativo = 1
     LIMIT 1;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA inválida ou encerrada';
    END IF;

    /* 2️⃣ Registra o procedimento RX */
    INSERT INTO ffa_procedimento (
        id_ffa,
        tipo_procedimento,
        status,
        solicitado_em,
        id_usuario_solicitante,
        observacao
    ) VALUES (
        p_id_ffa,
        'RX',
        'SOLICITADO',
        NOW(),
        p_id_usuario,
        p_observacao
    );

    /* 3️⃣ Atualiza status assistencial */
    UPDATE ffa
       SET status = 'EM_PROCEDIMENTO'
     WHERE id_ffa = p_id_ffa;

    /* 4️⃣ Substatus humano */
    INSERT INTO ffa_substatus (
        id_ffa,
        substatus,
        criado_em
    ) VALUES (
        p_id_ffa,
        'AGUARDANDO_RX',
        NOW()
    );

    /* 5️⃣ Insere na fila paralela (RX) */
    INSERT INTO fila_operacional (
        id_ffa,
        contexto,
        prioridade,
        status,
        criado_em
    )
    SELECT
        p_id_ffa,
        'RX',
        prioridade,
        'AGUARDANDO',
        NOW()
    FROM fila_operacional
    WHERE id_ffa = p_id_ffa
      AND contexto = 'MEDICO'
    LIMIT 1;

    /* 6️⃣ Evento de auditoria de fluxo */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'SOLICITACAO_RX',
        'RX',
        p_id_usuario,
        NOW()
    );

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_iniciar_execucao_procedimento_rx $$
CREATE PROCEDURE sp_iniciar_execucao_procedimento_rx (
    IN p_id_ffa      BIGINT,
    IN p_id_usuario  BIGINT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1️⃣ Busca procedimento RX pendente */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'SOLICITADO'
     ORDER BY solicitado_em ASC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum procedimento RX pendente para execução';
    END IF;

    /* 2️⃣ Atualiza procedimento */
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW(),
           id_usuario_executor = p_id_usuario
     WHERE id_procedimento = v_id_proc;

    /* 3️⃣ Atualiza fila RX */
    UPDATE fila_operacional
       SET status = 'EM_EXECUCAO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX'
       AND status = 'AGUARDANDO';

    /* 4️⃣ Substatus humano */
    INSERT INTO ffa_substatus (
        id_ffa,
        substatus,
        criado_em
    ) VALUES (
        p_id_ffa,
        'EM_EXECUCAO_RX',
        NOW()
    );

    /* 5️⃣ Evento de auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'INICIO_EXECUCAO_RX',
        'RX',
        p_id_usuario,
        NOW()
    );

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finalizar_procedimento_rx $$
CREATE PROCEDURE sp_finalizar_procedimento_rx (
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* Busca RX em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX em execucao para finalizar';
    END IF;

    /* Finaliza RX */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_observacao
     WHERE id_procedimento = v_id_proc;

    /* Remove da fila RX */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* Retorno */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_RX_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_RX_NORMAL', NOW());

    END IF;

    /* Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_RX',
        'RX',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finalizar_procedimento_ecg $$
CREATE PROCEDURE sp_finalizar_procedimento_ecg (
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* Busca ECG em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'ECG'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum ECG em execucao para finalizar';
    END IF;

    /* Finaliza ECG */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_observacao
     WHERE id_procedimento = v_id_proc;

    /* Remove da fila ECG */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'ECG';

    /* Retorno ao fluxo */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_ECG_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_ECG_NORMAL', NOW());

    END IF;

    /* Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_ECG',
        'ECG',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finalizar_procedimento_laboratorio $$
CREATE PROCEDURE sp_finalizar_procedimento_laboratorio (
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_resultado     TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca LAB em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'LAB'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum exame de laboratorio em execucao';
    END IF;

    /* 2. Finaliza LAB */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_resultado
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila LAB */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'LAB';

    /* 4. Retorno ao fluxo */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_LAB_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_LAB_NORMAL', NOW());

    END IF;

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_LAB',
        'LAB',
        p_id_usuario,
        p_resultado,
        NOW()
    );

END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finalizar_procedimento_geral $$
CREATE PROCEDURE sp_finalizar_procedimento_geral (
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_critico       TINYINT(1),
    IN p_observacao    TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca procedimento geral em execucao */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'GERAL'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum procedimento geral em execucao';
    END IF;

    /* 2. Finaliza procedimento */
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_observacao
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila */
    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'GERAL';

    /* 4. Retorno */
    IF p_critico = 1 THEN

        CALL sp_retorno_procedimento_critico(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_GERAL_CRITICO', NOW());

    ELSE

        CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

        INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
        VALUES (p_id_ffa, 'RETORNO_GERAL_NORMAL', NOW());

    END IF;

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FINALIZACAO_GERAL',
        'GERAL',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_iniciar_procedimento_rx $$
CREATE PROCEDURE sp_iniciar_procedimento_rx (
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca RX solicitado */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'SOLICITADO'
     ORDER BY criado_em ASC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX solicitado para iniciar';
    END IF;

    /* 2. Inicia execução */
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW()
     WHERE id_procedimento = v_id_proc;

    /* 3. Atualiza fila RX */
    UPDATE fila_operacional
       SET status = 'EM_ATENDIMENTO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* 4. Substatus assistencial */
    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (p_id_ffa, 'EM_RX', NOW());

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'INICIO_RX',
        'RX',
        p_id_usuario,
        NOW()
    );

END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_cancelar_procedimento_rx $$
CREATE PROCEDURE sp_cancelar_procedimento_rx (
    IN p_id_ffa        BIGINT,
    IN p_id_usuario    BIGINT,
    IN p_motivo        TEXT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. Busca RX ativo */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status IN ('SOLICITADO','EM_EXECUCAO')
     ORDER BY criado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX ativo para cancelamento';
    END IF;

    /* 2. Cancela procedimento */
    UPDATE ffa_procedimento
       SET status = 'CANCELADO',
           finalizado_em = NOW(),
           resultado = p_motivo
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila RX */
    UPDATE fila_operacional
       SET status = 'CANCELADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* 4. Substatus */
    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (p_id_ffa, 'RX_CANCELADO', NOW());

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CANCELAMENTO_RX',
        'RX',
        p_id_usuario,
        p_motivo,
        NOW()
    );

END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_timeout_procedimento_rx $$
CREATE PROCEDURE sp_timeout_procedimento_rx (
    IN p_id_ffa      BIGINT,
    IN p_id_usuario  BIGINT
)
BEGIN
    DECLARE v_id_proc BIGINT;

    /* 1. RX em execução */
    SELECT id_procedimento
      INTO v_id_proc
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = 'RX'
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    IF v_id_proc IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nenhum RX em execução para timeout';
    END IF;

    /* 2. Marca timeout */
    UPDATE ffa_procedimento
       SET status = 'TIMEOUT',
           finalizado_em = NOW(),
           resultado = 'Timeout de RX'
     WHERE id_procedimento = v_id_proc;

    /* 3. Remove da fila RX */
    UPDATE fila_operacional
       SET status = 'TIMEOUT'
     WHERE id_ffa = p_id_ffa
       AND contexto = 'RX';

    /* 4. Retorno normal */
    CALL sp_retorno_procedimento_normal(p_id_ffa, p_id_usuario);

    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (p_id_ffa, 'RX_TIMEOUT', NOW());

    /* 5. Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'TIMEOUT_RX',
        'RX',
        p_id_usuario,
        'RX não atendido dentro do tempo',
        NOW()
    );

END $$

DELIMITER ;


SET FOREIGN_KEY_CHECKS = 0;

DROP PROCEDURE IF EXISTS sp_solicitar_exame_generico;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_exame_generico (
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    INSERT INTO ffa_procedimento
        (id_ffa, tipo_procedimento, status, solicitado_em)
    VALUES
        (p_id_ffa, p_tipo, 'AGUARDANDO', NOW());

    INSERT INTO fila_operacional
        (id_ffa, contexto, status, criado_em)
    VALUES
        (p_id_ffa, p_tipo, 'AGUARDANDO', NOW());

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, 'SOLICITACAO', p_tipo, p_id_usuario, p_observacao, NOW());
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_iniciar_execucao_exame;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_execucao_exame (
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW()
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = p_tipo
       AND status = 'AGUARDANDO'
     ORDER BY solicitado_em
     LIMIT 1;

    UPDATE fila_operacional
       SET status = 'EM_EXECUCAO'
     WHERE id_ffa = p_id_ffa
       AND contexto = p_tipo;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_finalizar_exame_generico;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_exame_generico (
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'FINALIZADO',
           finalizado_em = NOW(),
           resultado = p_resultado
     WHERE id_ffa = p_id_ffa
       AND tipo_procedimento = p_tipo
       AND status = 'EM_EXECUCAO'
     ORDER BY iniciado_em DESC
     LIMIT 1;

    UPDATE fila_operacional
       SET status = 'FINALIZADO'
     WHERE id_ffa = p_id_ffa
       AND contexto = p_tipo;

    INSERT INTO ffa_substatus (id_ffa, substatus, criado_em)
    VALUES (
        p_id_ffa,
        IF(p_critico = 1,
           CONCAT('RETORNO_', p_tipo, '_CRITICO'),
           CONCAT('RETORNO_', p_tipo, '_NORMAL')),
        NOW()
    );

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, 'FINALIZACAO', p_tipo, p_id_usuario, p_resultado, NOW());
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_reabrir_fluxo_manual;
DELIMITER $$

CREATE PROCEDURE sp_reabrir_fluxo_manual (
    IN p_id_ffa BIGINT,
    IN p_motivo TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa
       SET status = 'EM_ATENDIMENTO'
     WHERE id_ffa = p_id_ffa;

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, 'REABERTURA_MANUAL', 'SISTEMA', p_id_usuario, p_motivo, NOW());
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_rechamar_procedimento;
DELIMITER $$

CREATE PROCEDURE sp_rechamar_procedimento (
    IN p_id_ffa BIGINT,
    IN p_tipo VARCHAR(10),
    IN p_id_usuario BIGINT
)
BEGIN
    INSERT INTO fila_operacional
        (id_ffa, contexto, status, criado_em)
    VALUES
        (p_id_ffa, p_tipo, 'AGUARDANDO', NOW());

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, criado_em)
    VALUES
        (p_id_ffa, 'RECHAMADA_MANUAL', p_tipo, p_id_usuario, NOW());
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_decisao_pos_timeout;
DELIMITER $$

CREATE PROCEDURE sp_decisao_pos_timeout (
    IN p_id_ffa BIGINT,
    IN p_acao VARCHAR(20),
    IN p_id_usuario BIGINT,
    IN p_obs TEXT
)
BEGIN
    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (p_id_ffa, CONCAT('DECISAO_TIMEOUT_', p_acao),
         'SISTEMA', p_id_usuario, p_obs, NOW());
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_definir_decisao_medica_final;
DELIMITER $$

CREATE PROCEDURE sp_definir_decisao_medica_final (
    IN p_id_ffa BIGINT,
    IN p_decisao VARCHAR(20),
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa
       SET decisao_final = p_decisao,
           decisao_em = NOW()
     WHERE id_ffa = p_id_ffa;

    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, criado_em)
    VALUES
        (p_id_ffa, CONCAT('DECISAO_MEDICA_', p_decisao),
         'MEDICO', p_id_usuario, NOW());
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_verificar_pendencias_assistenciais;
DELIMITER $$

CREATE PROCEDURE sp_verificar_pendencias_assistenciais (
    IN p_id_ffa BIGINT,
    OUT p_pendencias INT
)
BEGIN
    SELECT COUNT(*)
      INTO p_pendencias
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND status IN ('AGUARDANDO','EM_EXECUCAO');
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_liberar_estado_pos_execucao;
DELIMITER $$

CREATE PROCEDURE sp_liberar_estado_pos_execucao (
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
       SET status = 'PRONTO_PARA_DECISAO'
     WHERE id_ffa = p_id_ffa
       AND decisao_final IS NOT NULL;
END$$

DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;


DROP PROCEDURE IF EXISTS sp_solicitar_laboratorio;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_laboratorio (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'LAB', p_id_usuario, p_observacao);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_solicitar_ecg;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_ecg (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'ECG', p_id_usuario, p_observacao);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_solicitar_usg;
DELIMITER $$

CREATE PROCEDURE sp_solicitar_usg (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'USG', p_id_usuario, p_observacao);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_iniciar_lab;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_lab (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'LAB', p_id_usuario);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_iniciar_ecg;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_ecg (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'ECG', p_id_usuario);
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_iniciar_usg;
DELIMITER $$

CREATE PROCEDURE sp_iniciar_usg (
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'USG', p_id_usuario);
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_finalizar_lab;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_lab (
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'LAB', p_critico, p_resultado, p_id_usuario);
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_finalizar_ecg;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_ecg (
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'ECG', p_critico, p_resultado, p_id_usuario);
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS sp_finalizar_usg;
DELIMITER $$

CREATE PROCEDURE sp_finalizar_usg (
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'USG', p_critico, p_resultado, p_id_usuario);
END$$

DELIMITER ;
