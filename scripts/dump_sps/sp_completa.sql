CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_atendimento`(
    IN p_id_pessoa BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_local INT,
    IN p_id_especialidade INT
)
BEGIN
    INSERT INTO atendimento (
        protocolo,
        id_pessoa,
        id_senha,
        status_atendimento,
        id_local_atual,
        id_especialidade
    )
    VALUES (
        fn_gera_protocolo(),
        p_id_pessoa,
        p_id_senha,
        'ABERTO',
        p_id_local,
        p_id_especialidade
    );
END;


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_ffa`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_abrir_ffa_com_exames`(
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

END;

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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_internacao`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atualizar_estoque`(
    IN p_id_produto BIGINT,
    IN p_id_local INT,
    IN p_quantidade INT,
    IN p_id_usuario BIGINT
)
BEGIN
    -- Atualiza estoque
    UPDATE estoque_local SET quantidade_atual = quantidade_atual + p_quantidade
    WHERE id_produto = p_id_produto AND id_local = p_id_local;
    
    -- Auditoria
    INSERT INTO auditoria_estoque (id_produto, id_local, acao, quantidade, id_usuario)
    VALUES (p_id_produto, p_id_local, 'ENTRADA', p_quantidade, p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atualizar_fila`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atualizar_status_internacao`(
    IN p_id_internacao BIGINT,
    IN p_novo_status ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA'),
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    UPDATE internacao
    SET status = p_novo_status,
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, p_novo_status, p_id_usuario, p_comentario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cancelar_procedimento_rx`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_paciente_medico`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_painel`(
    IN p_id_atendimento BIGINT,
    IN p_id_sala        INT
)
BEGIN
    INSERT INTO chamada_painel (
        id_atendimento,
        id_sala,
        status,
        data_hora
    ) VALUES (
        p_id_atendimento,
        p_id_sala,
        'CHAMANDO',
        NOW()
    );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_procedimento`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_chamar_senha`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_classificar_manchester`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_consolidar_faturamento_ffa`(
    IN p_id_ffa BIGINT
)
BEGIN
    SELECT
        origem,
        descricao,
        SUM(quantidade) AS total_quantidade
    FROM faturamento_item
    WHERE id_ffa = p_id_ffa
    GROUP BY origem, descricao;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_criar_agendamento`(
    IN p_id_pessoa BIGINT,
    IN p_id_especialidade INT,
    IN p_data_agendada DATETIME,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    INSERT INTO agendamentos (id_pessoa, id_especialidade, data_agendada, id_usuario, observacao)
    VALUES (p_id_pessoa, p_id_especialidade, p_data_agendada, p_id_usuario, p_observacao);
    
    -- Evento inicial
    INSERT INTO agendamentos_eventos (id_agendamento, tipo_evento, descricao, id_usuario)
    VALUES (LAST_INSERT_ID(), 'CRIACAO', 'Agendamento criado', p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_criar_usuario`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_decisao_pos_timeout`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_definir_decisao_medica_final`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_encerrar_ordem_assistencial`(
    IN p_id_ordem   BIGINT,
    IN p_resultado  TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND status IN ('ATIVA','SUSPENSA');

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordem inválida para encerramento';
    END IF;

    UPDATE ordem_assistencial
       SET status = 'ENCERRADA',
           encerrado_em = NOW()
     WHERE id = p_id_ordem;

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        v_id_ffa,
        'ENCERRAMENTO_ORDEM_ASSISTENCIAL',
        'ORDEM',
        p_id_usuario,
        p_resultado,
        NOW()
    );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_execucao_medicacao`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmacia_saida_estoque`(
    IN p_id_lote BIGINT,
    IN p_quantidade INT,
    IN p_id_usuario BIGINT,
    IN p_id_local BIGINT
)
BEGIN
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);
    DECLARE v_estoque INT;

    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
      FROM lote
     WHERE id_lote = p_id_lote;

    SET v_dias = fn_dias_para_vencimento(v_validade);

    SET v_risco = CASE
        WHEN v_dias < 0 THEN 'VENCIDO'
        WHEN v_dias <= 30 THEN 'CRITICO'
        ELSE 'OK'
    END;

    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saída bloqueada: medicamento vencido';
    END IF;

    SELECT quantidade_atual
      INTO v_estoque
      FROM estoque_local
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_estoque IS NULL OR v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    INSERT INTO auditoria_estoque_sanitario
        (id_farmaco, id_lote, id_local, quantidade, nivel_risco, criado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, p_quantidade, v_risco, p_id_usuario);

    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade, 'FARMACIA', p_id_usuario);

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_entrada`(
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local BIGINT,
    IN p_quantidade INT,
    IN p_origem ENUM('COMPRA','TRANSFERENCIA','AJUSTE'),
    IN p_usuario BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;

    -- 1️⃣ Validação de lote
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_usuario,
             'Tentativa de entrada com lote inválido');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote inválido. Entrada bloqueada.';
    END IF;

    -- 2️⃣ Verifica estoque existente
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    -- 3️⃣ Atualiza ou insere estoque
    IF v_saldo_atual IS NULL THEN
        INSERT INTO estoque_local
            (id_farmaco, id_local, quantidade_atual)
        VALUES
            (p_id_farmaco, p_id_local, p_quantidade);
    ELSE
        UPDATE estoque_local
           SET quantidade_atual = quantidade_atual + p_quantidade
         WHERE id_farmaco = p_id_farmaco
           AND id_local = p_id_local;
    END IF;

    -- 4️⃣ Registra movimentação
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'ENTRADA', p_quantidade, p_origem, p_usuario);

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_saida_paciente`(
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local BIGINT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_cliente BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;
    DECLARE v_posologia INT DEFAULT 1;
    DECLARE v_dias INT DEFAULT 1;
    DECLARE v_total_permitido INT;

    -- 1️⃣ Bloqueio sanitário
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_id_usuario,
             'Tentativa de saída com lote vencido');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote vencido. Saída bloqueada.';
    END IF;

    -- 2️⃣ Verifica saldo
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_saldo_atual IS NULL OR v_saldo_atual < p_quantidade THEN
        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_id_usuario,
             'Tentativa de saída sem saldo suficiente');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente.';
    END IF;

    -- 3️⃣ Verifica prescrição / posologia
    SELECT posologia, dias
      INTO v_posologia, v_dias
      FROM ffa_medicacao
     WHERE id_ffa = p_id_ffa
       AND id_farmaco = p_id_farmaco;

    SET v_total_permitido = v_posologia * v_dias;

    IF p_quantidade > v_total_permitido THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantidade acima da prescrição permitida.';
    END IF;

    -- 4️⃣ Debita estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local;

    -- 5️⃣ Registra movimentação
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por, id_cliente)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade,
         'PACIENTE', p_id_ffa, p_id_usuario, p_id_cliente);

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmaco_set_cota_minima`(
    IN p_id_farmaco BIGINT,
    IN p_id_cidade BIGINT,
    IN p_cota_minima INT,
    IN p_usuario BIGINT
)
BEGIN
    INSERT INTO farmaco_unidade (id_farmaco, id_cidade, cota_minima, atualizado_por)
    VALUES (p_id_farmaco, p_id_cidade, p_cota_minima, p_usuario)
    ON DUPLICATE KEY UPDATE
        cota_minima = p_cota_minima,
        atualizado_por = p_usuario,
        atualizado_em = NOW();
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_consolidar`(
    IN p_id_conta   BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE faturamento_item
       SET status = 'CONSOLIDADO'
     WHERE status = 'ABERTO'
       AND (
            id_ffa IN (SELECT id_ffa FROM faturamento_conta WHERE id_conta = p_id_conta)
         OR id_internacao IN (SELECT id_internacao FROM faturamento_conta WHERE id_conta = p_id_conta)
       );

    UPDATE faturamento_conta
       SET status = 'EM_REVISAO'
     WHERE id_conta = p_id_conta
       AND status = 'ABERTA';
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_consolidar_conta`(
  IN p_tipo ENUM('FFA','INTERNACAO'),
  IN p_id BIGINT,
  IN p_usuario BIGINT
)
BEGIN
  DECLARE v_id_conta BIGINT;

  INSERT INTO faturamento_conta (tipo_conta, id_ffa, id_internacao)
  VALUES (
    p_tipo,
    IF(p_tipo = 'FFA', p_id, NULL),
    IF(p_tipo = 'INTERNACAO', p_id, NULL)
  );

  SET v_id_conta = LAST_INSERT_ID();

  INSERT INTO faturamento_conta_item (id_conta, id_item)
  SELECT v_id_conta, id_item
  FROM faturamento_item
  WHERE status = 'ABERTO'
    AND (
      (p_tipo = 'FFA' AND id_ffa = p_id)
      OR
      (p_tipo = 'INTERNACAO' AND id_internacao = p_id)
    );

  UPDATE faturamento_item
  SET status = 'CONSOLIDADO'
  WHERE id_item IN (
    SELECT id_item FROM faturamento_conta_item
    WHERE id_conta = v_id_conta
  );

  UPDATE faturamento_conta
  SET valor_total = (
    SELECT SUM(valor_total)
    FROM faturamento_item fi
    JOIN faturamento_conta_item fci ON fci.id_item = fi.id_item
    WHERE fci.id_conta = v_id_conta
  );

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_fechar_conta`(
    IN p_id_conta   BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    IF EXISTS (
        SELECT 1
          FROM faturamento_item
         WHERE status = 'ABERTO'
           AND (
                id_ffa IN (SELECT id_ffa FROM faturamento_conta WHERE id_conta = p_id_conta)
             OR id_internacao IN (SELECT id_internacao FROM faturamento_conta WHERE id_conta = p_id_conta)
           )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Existem itens de faturamento ainda abertos';
    END IF;

    UPDATE faturamento_conta
       SET status      = 'FECHADA',
           fechada_em  = NOW(),
           fechado_por = p_id_usuario
     WHERE id_conta = p_id_conta;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_gerar_item`(
    IN p_origem          ENUM('PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO'),
    IN p_id_origem       BIGINT,
    IN p_descricao       VARCHAR(255),
    IN p_quantidade      DECIMAL(10,2),
    IN p_valor_unitario  DECIMAL(10,2),
    IN p_id_ffa          BIGINT,
    IN p_id_internacao   BIGINT,
    IN p_id_usuario      BIGINT
)
BEGIN
    DECLARE v_id_conta BIGINT;
    DECLARE v_valor_total DECIMAL(10,2);

    SET v_valor_total = p_quantidade * p_valor_unitario;

    CALL sp_faturamento_obter_conta(
        IF(p_id_internacao IS NULL, 'FFA', 'INTERNACAO'),
        p_id_ffa,
        p_id_internacao,
        p_id_usuario,
        v_id_conta
    );

    INSERT INTO faturamento_item (
        origem,
        id_origem,
        descricao,
        quantidade,
        valor_unitario,
        valor_total,
        id_ffa,
        id_internacao,
        criado_por,
        status
    ) VALUES (
        p_origem,
        p_id_origem,
        p_descricao,
        p_quantidade,
        p_valor_unitario,
        v_valor_total,
        p_id_ffa,
        p_id_internacao,
        p_id_usuario,
        'ABERTO'
    );

    UPDATE faturamento_conta
       SET valor_total = valor_total + v_valor_total
     WHERE id_conta = v_id_conta;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_obter_conta`(
    IN  p_tipo_conta     ENUM('FFA','INTERNACAO'),
    IN  p_id_ffa         BIGINT,
    IN  p_id_internacao  BIGINT,
    IN  p_id_usuario     BIGINT,
    OUT p_id_conta       BIGINT
)
BEGIN
    SELECT id_conta
      INTO p_id_conta
      FROM faturamento_conta
     WHERE status = 'ABERTA'
       AND (
            (p_tipo_conta = 'FFA'        AND id_ffa        = p_id_ffa)
         OR (p_tipo_conta = 'INTERNACAO' AND id_internacao = p_id_internacao)
       )
     LIMIT 1;

    IF p_id_conta IS NULL THEN
        INSERT INTO faturamento_conta (
            tipo_conta,
            id_ffa,
            id_internacao,
            status,
            valor_total,
            aberta_em,
            fechado_por
        ) VALUES (
            p_tipo_conta,
            p_id_ffa,
            p_id_internacao,
            'ABERTA',
            0,
            NOW(),
            p_id_usuario
        );

        SET p_id_conta = LAST_INSERT_ID();
    END IF;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_faturamento_registrar_item`(
  IN p_origem ENUM(
      'PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO'
  ),
  IN p_id_origem BIGINT,
  IN p_descricao VARCHAR(255),
  IN p_quantidade DECIMAL(10,2),
  IN p_valor_unitario DECIMAL(10,2),
  IN p_id_ffa BIGINT,
  IN p_id_internacao BIGINT,
  IN p_usuario BIGINT
)
BEGIN
  INSERT INTO faturamento_item (
    origem, id_origem, descricao,
    quantidade, valor_unitario, valor_total,
    id_ffa, id_internacao, criado_por
  ) VALUES (
    p_origem, p_id_origem, p_descricao,
    p_quantidade, p_valor_unitario,
    p_quantidade * p_valor_unitario,
    p_id_ffa, p_id_internacao, p_usuario
  );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fecha_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_id_senha BIGINT;

    /* ===============================
       1️⃣ Valida FFA existente
       =============================== */
    SELECT status, id_senha
      INTO v_status_atual, v_id_senha
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'FFA inexistente';
    END IF;

    IF v_status_atual = 'FINALIZADO' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'FFA já está finalizada';
    END IF;

    /* ===============================
       2️⃣ Fecha todos os itens em andamento
       =============================== */
    -- Itens de faturamento
    CALL sp_fechar_conta_ffa(p_id_ffa, p_id_usuario);

    -- Libera estados de execução em aberto (exames, procedimentos)
    CALL sp_liberar_estado_pos_execucao(p_id_ffa);

    /* ===============================
       3️⃣ Atualiza status da FFA
       =============================== */
    UPDATE ffa
       SET status = 'FINALIZADO',
           atualizado_em = NOW()
     WHERE id_ffa = p_id_ffa;

    /* ===============================
       4️⃣ Registra evento de fechamento
       =============================== */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FECHAMENTO_FFA',
        'SISTEMA',
        p_id_usuario,
        IFNULL(p_motivo, 'Fechamento automático'),
        NOW()
    );

    /* ===============================
       5️⃣ Atualiza status da senha associada
       =============================== */
    UPDATE senhas
       SET status = 'FINALIZADA'
     WHERE id = v_id_senha;

    /* ===============================
       6️⃣ Atualiza fila de senha (painel / guichê)
       =============================== */
    UPDATE fila_senha
       SET status = 'FINALIZADA'
     WHERE id_senha = v_id_senha;

    /* ===============================
       7️⃣ Auditoria final
       =============================== */
    INSERT INTO auditoria_ffa (
        id_ffa,
        id_usuario,
        acao,
        motivo,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_id_usuario,
        'FECHAMENTO_FFA',
        IFNULL(p_motivo, 'Fechamento automático'),
        NOW()
    );

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechamento_ffa_completo`(
    IN p_horas_limite INT
)
BEGIN
    -- 1️⃣ Declara todas as variáveis e cursores primeiro
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo INT;
    DECLARE v_paciente_internado INT;

    DECLARE cur CURSOR FOR
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO','EM_ATENDIMENTO','EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= p_horas_limite;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- 2️⃣ Define 24h como padrão se parâmetro não informado
    IF p_horas_limite IS NULL OR p_horas_limite = 0 THEN
        SET p_horas_limite = 24;
    END IF;

    -- 3️⃣ Abre cursor
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Ignora FFA já encerradas ou canceladas
        IF v_status_atual IN ('ENCERRADO','CANCELADO','ENCERRADO_AUTOMATICO') THEN
            ITERATE read_loop;
        END IF;

        -- Checa se paciente está internado
        SELECT COUNT(*)
          INTO v_paciente_internado
          FROM internacao
         WHERE id_paciente = (SELECT id_paciente FROM ffa WHERE id_ffa = v_id_ffa)
           AND status IN ('ATIVO','EM_ANDAMENTO');

        -- Se não houver retorno ativo ou paciente não internado, encerra automaticamente
        IF v_retorno_ativo = 0 OR v_paciente_internado = 0 THEN
            UPDATE ffa
               SET status = 'ENCERRADO_AUTOMATICO',
                   atualizado_em = NOW()
             WHERE id_ffa = v_id_ffa;

            -- Auditoria do fechamento
            INSERT INTO eventos_fluxo (
                id_ffa, evento, contexto, id_usuario, observacao, criado_em
            ) VALUES (
                v_id_ffa, 'FECHAMENTO_AUTOMATICO', 'SISTEMA', NULL,
                CONCAT('Fechamento automático após ', p_horas_limite, 'h sem movimentação. Status anterior: ', v_status_atual),
                NOW()
            );

            -- Chama SP complementar para criar observações e alertas
            CALL sp_ffa_complementar_alertas_permissao(v_id_ffa, NULL, 'OBSERVACAO');
            CALL sp_ffa_complementar_alertas_permissao(v_id_ffa, NULL, 'TTS');
        END IF;

    END LOOP;

    CLOSE cur;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechamento_ffa_ultimate`(
    IN p_horas_limite INT
)
BEGIN
    -- Variáveis do cursor
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo INT;
    DECLARE v_paciente_internado INT;

    -- Cursor para todas as FFA abertas ou em atendimento que ultrapassaram o tempo limite
    DECLARE cur CURSOR FOR
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO','EM_ATENDIMENTO','EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= IFNULL(p_horas_limite,24);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Define valor padrão de 24h
    IF p_horas_limite IS NULL OR p_horas_limite = 0 THEN
        SET p_horas_limite = 24;
    END IF;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Ignora FFA já encerradas ou canceladas
        IF v_status_atual IN ('ENCERRADO','CANCELADO','ENCERRADO_AUTOMATICO') THEN
            ITERATE read_loop;
        END IF;

        -- Checa se paciente está internado
        SELECT COUNT(*) 
          INTO v_paciente_internado
          FROM internacao
         WHERE id_paciente = (SELECT id_paciente FROM ffa WHERE id_ffa = v_id_ffa)
           AND status IN ('ATIVO','EM_ANDAMENTO');

        -- Verifica pendências críticas: medicação, exames, cuidados
        -- Cria fila de observação e alerta no painel
        INSERT INTO fila_observacao (
            id_ffa,
            tipo_evento,
            local_destino,
            criado_em,
            status
        )
        SELECT
            v_id_ffa,
            tipo_pendencia,
            local_destino,
            NOW(),
            'PENDENTE'
          FROM ffa_pendencias
         WHERE id_ffa = v_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        UPDATE ffa_pendencias
           SET alerta_painel = 1
         WHERE id_ffa = v_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        -- Se não houver retorno ativo ou paciente não internado, encerra automaticamente
        IF v_retorno_ativo = 0 OR v_paciente_internado = 0 THEN
            UPDATE ffa
               SET status = 'ENCERRADO_AUTOMATICO',
                   atualizado_em = NOW()
             WHERE id_ffa = v_id_ffa;

            -- Auditoria do fechamento
            INSERT INTO eventos_fluxo (
                id_ffa,
                evento,
                contexto,
                id_usuario,
                observacao,
                criado_em
            ) VALUES (
                v_id_ffa,
                'FECHAMENTO_AUTOMATICO',
                'SISTEMA',
                NULL,
                CONCAT('Fechamento automático após ', p_horas_limite, 'h sem movimentação. Status anterior: ', v_status_atual),
                NOW()
            );
        END IF;

        -- Gatilho de TTS e alertas do painel para pendências
        -- Se houver função/procedure TTS, chama aqui passando id_ffa e tipo de evento
        -- Exemplo: CALL sp_tts_alerta_painel(v_id_ffa);

        -- Atualiza medicações/exames atrasados automaticamente
        UPDATE ffa_pendencias
           SET status_pendencia = 'ATRASADO'
         WHERE id_ffa = v_id_ffa
           AND status_pendencia = 'PENDENTE'
           AND tipo_pendencia IN ('MEDICACAO','EXAME','CUIDADO');

    END LOOP;

    CLOSE cur;

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_conta_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    /* Marca itens como consolidados */
    UPDATE faturamento_item
       SET status = 'CONSOLIDADO'
     WHERE id_ffa = p_id_ffa
       AND (status IS NULL OR status <> 'CONSOLIDADO');

    /* Registra evento administrativo */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'FECHAMENTO_FATURAMENTO',
        'ADMINISTRATIVO',
        p_id_usuario,
        NOW()
    );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_ffa`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_tipo_fechamento ENUM('FECHAMENTO_NORMAL','ENCERRADO_AUTOMATICO','FECHAMENTO_CANCELADO'),
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permite_reabrir BOOLEAN DEFAULT FALSE;
    DECLARE v_id_paciente BIGINT;

    -- 1️⃣ Bloqueia a FFA para atualização
    SELECT status, id_paciente
      INTO v_status_atual, v_id_paciente
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    IF v_status_atual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'FFA inexistente';
    END IF;

    -- 2️⃣ Valida permissões
    IF p_tipo_fechamento = 'FECHAMENTO_CANCELADO' THEN
        -- Cancelamento só pode TI / usuário master
        IF NOT EXISTS (
            SELECT 1
              FROM usuario
             WHERE id_usuario = p_id_usuario
               AND perfil = 'MASTER'
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário sem permissão para cancelar FFA';
        END IF;
    ELSE
        -- Fechamento normal ou automático: médico, recepção, triagem, enfermagem, técnicos
        IF NOT EXISTS (
            SELECT 1
              FROM usuario
             WHERE id_usuario = p_id_usuario
               AND perfil IN ('MEDICO','RECEPCAO','TRIAGEM','ENFERMAGEM','TECNICO')
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário sem permissão para fechar FFA';
        END IF;
    END IF;

    -- 3️⃣ Determina status final
    CASE p_tipo_fechamento
        WHEN 'FECHAMENTO_NORMAL' THEN
            SET v_status_atual = 'ENCERRADO';
            SET v_permite_reabrir = TRUE;
        WHEN 'ENCERRADO_AUTOMATICO' THEN
            SET v_status_atual = 'ENCERRADO';
            SET v_permite_reabrir = TRUE;
        WHEN 'FECHAMENTO_CANCELADO' THEN
            SET v_status_atual = 'CANCELADO';
            SET v_permite_reabrir = FALSE;
    END CASE;

    -- 4️⃣ Atualiza FFA
    UPDATE ffa
       SET status = v_status_atual,
           atualizado_em = NOW()
     WHERE id_ffa = p_id_ffa;

    -- 5️⃣ Registra evento no histórico
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        p_id_ffa,
        CONCAT('FECHAMENTO: ', p_tipo_fechamento),
        'SISTEMA',
        p_id_usuario,
        p_motivo,
        NOW()
    );

    -- 6️⃣ Auditoria de exames/medicação pendentes
    INSERT INTO ffa_auditoria_pendencias (
        id_ffa,
        id_paciente,
        tipo_pendencia,
        criado_em
    )
    SELECT p_id_ffa, v_id_paciente, 'EXAMES/MEDICACAO', NOW()
      FROM ffa_medicacao fm
     WHERE fm.id_ffa = p_id_ffa
       AND (fm.status IS NULL OR fm.status <> 'MINISTRADO');

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fechar_ffa_automatico`()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_retorno_ativo TINYINT;
    DECLARE v_pendencias TINYINT;

    DECLARE cur CURSOR FOR 
        SELECT id_ffa, status, retorno_ativo
          FROM ffa
         WHERE status IN ('ABERTO', 'EM_ATENDIMENTO', 'EM_ATENDIMENTO_RETORNO')
           AND TIMESTAMPDIFF(HOUR, atualizado_em, NOW()) >= 24;
           
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id_ffa, v_status_atual, v_retorno_ativo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- 1️⃣ Verifica pendências de medicação ou exames
        SELECT COUNT(*)
          INTO v_pendencias
          FROM ffa_itens
         WHERE id_ffa = v_id_ffa
           AND status IN ('PENDENTE', 'AGUARDANDO_MINISTRACAO');

        -- 2️⃣ Atualiza status da FFA
        UPDATE ffa
           SET status = CASE
                            WHEN v_retorno_ativo = 1 THEN 'EM_ATENDIMENTO_RETORNO'
                            WHEN v_pendencias > 0 THEN 'ABERTO_COM_PENDENCIAS'
                            ELSE 'ENCERRADO_AUTOMATICO'
                        END,
               atualizado_em = NOW()
         WHERE id_ffa = v_id_ffa;

        -- 3️⃣ Insere evento de auditoria
        INSERT INTO eventos_fluxo
            (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
        VALUES
            (v_id_ffa,
             CASE
                WHEN v_retorno_ativo = 1 THEN 'RETORNO_PENDENTE_24H'
                WHEN v_pendencias > 0 THEN 'FECHAMENTO_COM_PENDENCIAS'
                ELSE 'FECHAMENTO_AUTOMATICO'
             END,
             'SISTEMA',
             NULL,
             CONCAT('Fechamento automático após 24h. Pendências: ', v_pendencias, 
                    '. Retorno ativo: ', v_retorno_ativo),
             NOW());

        -- 4️⃣ Se houver pendências de medicação/exame, colocar na fila de observação/painel
        IF v_pendencias > 0 THEN
            INSERT INTO fila_observacao
                (id_ffa, tipo, status, criado_em)
            VALUES
                (v_id_ffa, 'MEDICACAO_EXAME_PENDENTE', 'PENDENTE', NOW());
        END IF;

    END LOOP;

    CLOSE cur;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_complementar_alertas_permissao`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_acao VARCHAR(50) -- 'REABRIR', 'CANCELAR', 'OBSERVACAO', 'TTS'
)
BEGIN
    -- 1️⃣ Declara variáveis obrigatórias
    DECLARE v_status_atual VARCHAR(50);
    DECLARE v_permissao INT DEFAULT 0;
    DECLARE v_tem_pendencia INT;

    -- 2️⃣ Pega status atual da FFA
    SELECT status
      INTO v_status_atual
      FROM ffa
     WHERE id_ffa = p_id_ffa
     FOR UPDATE;

    -- 3️⃣ Valida permissões de acordo com ação
    IF p_acao = 'REABRIR' THEN
        IF v_status_atual = 'CANCELADO' THEN
            -- Só TI pode reabrir FFA cancelada
            SELECT CASE WHEN EXISTS (
                SELECT 1 
                  FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario 
                   AND sistema = 'TI'
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Somente TI pode reabrir FFA cancelada';
            END IF;
        ELSE
            -- Médicos, enfermeiros, recepção, TI podem reabrir FFA normal
            SELECT CASE WHEN EXISTS (
                SELECT 1 
                  FROM usuario_sistema 
                 WHERE id_usuario = p_id_usuario 
                   AND sistema IN ('MEDICO','ENFERMAGEM','RECEPCAO','TI')
            ) THEN 1 ELSE 0 END
            INTO v_permissao;
            IF v_permissao = 0 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Usuário não tem permissão para reabrir esta FFA';
            END IF;
        END IF;

        -- Atualiza status e auditoria
        UPDATE ffa
           SET status = 'EM_ATENDIMENTO',
               atualizado_em = NOW()
         WHERE id_ffa = p_id_ffa;

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'REABERTURA_MANUAL', 'SISTEMA', p_id_usuario, 
            'Reabertura via SP complementar', NOW()
        );
    END IF;

    -- 4️⃣ Cancelamento
    IF p_acao = 'CANCELAR' THEN
        -- Só TI pode cancelar
        SELECT CASE WHEN EXISTS (
            SELECT 1 
              FROM usuario_sistema 
             WHERE id_usuario = p_id_usuario 
               AND sistema = 'TI'
        ) THEN 1 ELSE 0 END
        INTO v_permissao;
        IF v_permissao = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Somente TI pode cancelar FFA';
        END IF;

        -- Atualiza status e auditoria
        UPDATE ffa
           SET status = 'CANCELADO',
               atualizado_em = NOW()
         WHERE id_ffa = p_id_ffa;

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'CANCELAMENTO_MANUAL', 'SISTEMA', p_id_usuario, 
            'Cancelamento da FFA pelo TI', NOW()
        );
    END IF;

    -- 5️⃣ Observação / Pendências
    IF p_acao = 'OBSERVACAO' THEN
        -- Cria/atualiza observações para todas as pendências abertas ou atrasadas
        INSERT INTO fila_observacao (id_ffa, tipo_evento, local_destino, criado_em, status)
        SELECT v.id_ffa, v.tipo_pendencia, v.local_destino, NOW(), 'PENDENTE'
          FROM ffa_pendencias v
         WHERE v.id_ffa = p_id_ffa
           AND v.status_pendencia IN ('PENDENTE','ATRASADO')
        ON DUPLICATE KEY UPDATE criado_em = NOW(), status = 'PENDENTE';

        -- Marca alerta visual no painel (bolinha preta)
        UPDATE ffa_pendencias
           SET alerta_painel = 1
         WHERE id_ffa = p_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        INSERT INTO eventos_fluxo (
            id_ffa, evento, contexto, id_usuario, observacao, criado_em
        ) VALUES (
            p_id_ffa, 'OBSERVACAO_ADICIONADA', 'SISTEMA', p_id_usuario,
            'Observação/pendência adicionada na FFA', NOW()
        );
    END IF;

    -- 6️⃣ TTS / alerta do painel
    IF p_acao = 'TTS' THEN
        SELECT COUNT(*) 
          INTO v_tem_pendencia
          FROM ffa_pendencias
         WHERE id_ffa = p_id_ffa
           AND status_pendencia IN ('PENDENTE','ATRASADO');

        IF v_tem_pendencia > 0 THEN
            INSERT INTO eventos_fluxo (
                id_ffa, evento, contexto, id_usuario, observacao, criado_em
            ) VALUES (
                p_id_ffa, 'TTS_ALERTA', 'PAINEL', p_id_usuario,
                CONCAT('Alerta de pendências TTS para FFA ', p_id_ffa), NOW()
            );
        END IF;

        -- Aqui pode ser integrado com TTS externo (Google TTS ou outro) via backend
    END IF;

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_atendimento`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_atendimento_medico`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_ecg`(
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'ECG', p_critico, p_resultado, p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_exame_generico`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_execucao_assistencial`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_internacao`(
    IN p_id_internacao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    UPDATE internacao
    SET status = 'ENCERRADA',
        data_saida = NOW(),
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, 'ENCERRADA', p_id_usuario, p_comentario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_lab`(
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'LAB', p_critico, p_resultado, p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_ecg`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_geral`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_laboratorio`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_rx`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_triagem`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_usg`(
    IN p_id_ffa BIGINT,
    IN p_critico TINYINT(1),
    IN p_resultado TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_finalizar_exame_generico(p_id_ffa, 'USG', p_critico, p_resultado, p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gerar_itens_faturamento_ffa`(
    IN p_id_ffa BIGINT
)
BEGIN
    /* Procedimentos executados */
    INSERT INTO faturamento_item (
        id_ffa,
        origem,
        id_origem,
        descricao,
        quantidade,
        criado_em
    )
    SELECT
        p_id_ffa,
        'PROCEDIMENTO',
        fp.id_procedimento,
        fp.tipo_procedimento,
        1,
        NOW()
    FROM ffa_procedimento fp
    WHERE fp.id_ffa = p_id_ffa
      AND fp.status = 'FINALIZADO'
      AND NOT EXISTS (
          SELECT 1
          FROM faturamento_item fi
          WHERE fi.origem = 'PROCEDIMENTO'
            AND fi.id_origem = fp.id_procedimento
      );

    /* Medicações administradas */
    INSERT INTO faturamento_item (
        id_ffa,
        origem,
        id_origem,
        descricao,
        quantidade,
        criado_em
    )
    SELECT
        p_id_ffa,
        'MEDICACAO',
        ma.id_administracao,
        ma.medicamento,
        ma.quantidade,
        NOW()
    FROM ffa_medicacao_administrada ma
    WHERE ma.id_ffa = p_id_ffa
      AND ma.status = 'ADMINISTRADA'
      AND NOT EXISTS (
          SELECT 1
          FROM faturamento_item fi
          WHERE fi.origem = 'MEDICACAO'
            AND fi.id_origem = ma.id_administracao
      );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gerar_senha`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historico_fila_ffa`(
    IN p_id_ffa BIGINT
)
BEGIN
    SELECT *
    FROM vw_historico_fila_operacional
    WHERE id_ffa = p_id_ffa
    ORDER BY data_entrada, data_inicio;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_ecg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'ECG', p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_assistencial`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_exame`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_execucao_procedimento_rx`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_lab`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'LAB', p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_medicacao`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_procedimento`(
    IN p_id_procedimento BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    UPDATE ffa_procedimento
       SET status = 'EM_EXECUCAO',
           iniciado_em = NOW(),
           id_usuario_execucao = p_id_usuario
     WHERE id_procedimento = p_id_procedimento;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_procedimento_rx`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_iniciar_usg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT
)
BEGIN
    CALL sp_iniciar_execucao_exame(p_id_ffa, 'USG', p_id_usuario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inicio_atendimento_medico`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inicio_triagem`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_inserir_fila`(
    IN p_id_ffa BIGINT,
    IN p_tipo ENUM('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO'),
    IN p_prioridade ENUM('VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
    IN p_id_local INT,
    IN p_observacao TEXT
)
BEGIN
    INSERT INTO fila_operacional (id_ffa, tipo, prioridade, substatus, id_local, observacao)
    VALUES (p_id_ffa, p_tipo, p_prioridade, 'AGUARDANDO', p_id_local, p_observacao);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_internar_paciente`(
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
END;


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_liberar_estado_pos_execucao`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
       SET status = 'PRONTO_PARA_DECISAO'
     WHERE id_ffa = p_id_ffa
       AND decisao_final IS NOT NULL;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_liberar_medicacao_farmacia`(
    IN p_id_ordem BIGINT,
    IN p_id_usuario BIGINT,
    IN p_lote BIGINT,
    IN p_quantidade INT,
    IN p_id_local BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_saldo_atual INT DEFAULT 0;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);

    -- 1️⃣ Valida perfil do usuário
    IF NOT EXISTS (
        SELECT 1
          FROM usuario_perfil up
          JOIN perfil p ON up.id_perfil = p.id_perfil
         WHERE up.id_usuario = p_id_usuario
           AND p.nome IN ('FARMACEUTICO','FARMACIA_PA','FARMACIA_UBS','FARMACIA_RUA')
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário sem permissão para liberar medicação';
    END IF;

    -- 2️⃣ Valida ordem de medicação
    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND tipo_ordem = 'MEDICACAO'
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ordem de medicação inválida ou não ativa';
    END IF;

    -- 3️⃣ Valida lote e farmaco
    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
      FROM lote
     WHERE id_lote = p_lote;

    IF v_id_farmaco IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote inválido';
    END IF;

    -- 4️⃣ Bloqueio sanitário
    SET v_dias = DATEDIFF(v_validade, NOW());

    SET v_risco = CASE
        WHEN v_dias < 0 THEN 'VENCIDO'
        WHEN v_dias <= 30 THEN 'CRITICO'
        ELSE 'OK'
    END;

    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lote vencido. Liberação bloqueada';
    END IF;

    -- 5️⃣ Verifica estoque
    SELECT quantidade_atual
      INTO v_saldo_atual
      FROM estoque_local
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local
     FOR UPDATE;

    IF v_saldo_atual IS NULL OR v_saldo_atual < p_quantidade THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    -- 6️⃣ Debita estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    -- 7️⃣ Registra dispensação
    INSERT INTO dispensacao_medicacao
        (id_ordem, id_ffa, lote, quantidade, liberado_por, observacao, liberado_em)
    VALUES
        (p_id_ordem, v_id_ffa, p_lote, p_quantidade, p_id_usuario, p_observacao, NOW());

    -- 8️⃣ Auditoria completa
    INSERT INTO eventos_fluxo
        (id_ffa, evento, contexto, id_usuario, observacao, criado_em)
    VALUES
        (v_id_ffa, 'LIBERACAO_MEDICACAO', 'FARMACIA', p_id_usuario, p_observacao, NOW());

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_fila_farmacia`()
BEGIN
    SELECT *
    FROM vw_fila_farmacia
    ORDER BY prioridade DESC, iniciado_em ASC;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_fila_operacional`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_marcar_nao_compareceu`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_mover_atendimento`(
    IN p_id_atendimento BIGINT,
    IN p_novo_local INT,
    IN p_nova_sala INT,
    IN p_usuario BIGINT,
    IN p_motivo TEXT
)
BEGIN
    INSERT INTO atendimento_movimentacao (
        id_atendimento,
        de_local,
        para_local,
        id_usuario,
        motivo
    )
    SELECT
        id_atendimento,
        id_local_atual,
        p_novo_local,
        p_usuario,
        p_motivo
    FROM atendimento
    WHERE id_atendimento = p_id_atendimento;

    UPDATE atendimento
    SET id_local_atual = p_novo_local,
        id_sala_atual = p_nova_sala
    WHERE id_atendimento = p_id_atendimento;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nao_atendido`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_chamar_paciente`(
    IN p_id_ffa       BIGINT,
    IN p_contexto     ENUM('RECEPCAO','TRIAGEM','MEDICO','RX','LAB','ECG','MEDICACAO'),
    IN p_local        VARCHAR(50),
    IN p_id_usuario   BIGINT
)
BEGIN
    INSERT INTO chamada_painel (
        id_ffa,
        contexto,
        local_chamada,
        chamado_por,
        chamado_em,
        status
    ) VALUES (
        p_id_ffa,
        p_contexto,
        p_local,
        p_id_usuario,
        NOW(),
        'CHAMADO'
    );

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        'CHAMADA_PAINEL',
        p_contexto,
        p_id_usuario,
        NOW()
    );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_nao_compareceu`(
    IN p_id_chamada BIGINT,
    IN p_id_usuario BIGINT,
    IN p_motivo     VARCHAR(255)
)
BEGIN
    UPDATE chamada_painel
       SET status = 'NAO_COMPARECEU'
     WHERE id_chamada = p_id_chamada;

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    )
    SELECT
        id_ffa,
        'NAO_COMPARECEU',
        contexto,
        p_id_usuario,
        p_motivo,
        NOW()
    FROM chamada_painel
    WHERE id_chamada = p_id_chamada;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_prescrever_medicacao`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_procedimento_critico`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reabrir_fluxo_manual`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rechamar_painel`(
    IN p_id_ffa BIGINT,
    IN p_local VARCHAR(50),
    IN p_id_usuario BIGINT
)
BEGIN
    -- Evento exclusivo de painel
    INSERT INTO chamada_painel (
        id_ffa,
        local_chamada,
        tipo_chamada,
        id_usuario,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_local,
        'RECHAMADA',
        p_id_usuario,
        NOW()
    );

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rechamar_procedimento`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_evento`(
    IN p_id_ffa BIGINT,
    IN p_id_fila BIGINT,
    IN p_evento VARCHAR(255),
    IN p_id_usuario BIGINT,
    IN p_detalhe TEXT
)
BEGIN
    START TRANSACTION;

    -- Inserir evento na fila
    INSERT INTO fila_evento (id_fila, evento, id_usuario, detalhe, criado_em)
    VALUES (p_id_fila, p_evento, p_id_usuario, p_detalhe, NOW());

    -- Inserir evento na FFA
    INSERT INTO evento_ffa (id_ffa, evento, id_usuario, detalhe, criado_em)
    VALUES (p_id_ffa, p_evento, p_id_usuario, p_detalhe, NOW());

    -- Registrar auditoria
    INSERT INTO log_auditoria (id_usuario, tabela, acao, detalhe, criado_em)
    VALUES (p_id_usuario, 'evento', 'INSERT', CONCAT('Evento FFA/Fila: ', p_evento), NOW());

    COMMIT;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_feedback_totem`(
    IN p_id_ffa     BIGINT,
    IN p_nota       INT,
    IN p_comentario TEXT
)
BEGIN
    INSERT INTO totem_feedback (
        id_ffa,
        nota,
        comentario,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_nota,
        p_comentario,
        NOW()
    );
END;


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_ordem_assistencial`(
    IN p_id_ffa        BIGINT,
    IN p_tipo_ordem    ENUM('MEDICACAO','CUIDADO','DIETA','OXIGENIO','PROCEDIMENTO'),
    IN p_payload       JSON,
    IN p_prioridade    INT,
    IN p_id_usuario    BIGINT
)
BEGIN
    /* Cria ordem */
    INSERT INTO ordem_assistencial (
        id_ffa,
        tipo_ordem,
        payload_clinico,
        prioridade,
        status,
        criado_por,
        iniciado_em
    ) VALUES (
        p_id_ffa,
        p_tipo_ordem,
        p_payload,
        p_prioridade,
        'ATIVA',
        p_id_usuario,
        NOW()
    );

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
        'REGISTRO_ORDEM_ASSISTENCIAL',
        p_tipo_ordem,
        p_id_usuario,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.descricao')),
        NOW()
    );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_paciente`(
    IN p_nome_completo VARCHAR(200),
    IN p_cpf VARCHAR(14),
    IN p_data_nascimento DATE,
    IN p_id_usuario BIGINT -- Para auditoria
)
BEGIN
    -- Verifica permissão (exemplo)
    IF NOT EXISTS (SELECT 1 FROM usuario_perfil WHERE id_usuario = p_id_usuario AND id_perfil = 1) THEN -- Assumindo perfil 1 = ADMIN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Permissão negada';
    END IF;
    
    INSERT INTO pessoa (nome_completo, cpf, data_nascimento) VALUES (p_nome_completo, p_cpf, p_data_nascimento);
    INSERT INTO paciente (id_pessoa) VALUES (LAST_INSERT_ID());
    
    -- Auditoria
    INSERT INTO log_auditoria (id_usuario, acao, tabela_afetada, id_registro, comentario)
    VALUES (p_id_usuario, 'INSERT', 'paciente', LAST_INSERT_ID(), 'Novo paciente registrado');
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reset_senha_usuario`(IN p_id_usuario BIGINT)
BEGIN
    DECLARE v_login VARCHAR(150);

    -- Pega login do usuário
    SELECT login INTO v_login
    FROM usuario
    WHERE id_usuario = p_id_usuario;

    -- Atualiza senha, hash e flags
    UPDATE usuario
    SET 
        senha = v_login,
        senha_hash = SHA2(v_login, 256),
        primeiro_login = 1,
        senha_expira_em = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
    WHERE id_usuario = p_id_usuario;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_medico`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE fila_operacional
       SET status = 'AGUARDANDO_MEDICO'
     WHERE id_ffa = p_id_ffa;

    UPDATE ffa
       SET status = 'AGUARDANDO_CHAMADA_MEDICO'
     WHERE id = p_id_ffa;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento_critico`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
    SET status = 'EMERGENCIA',
        classificacao_manchester = 'VERMELHO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retorno_procedimento_normal`(
    IN p_id_ffa BIGINT
)
BEGIN
    UPDATE ffa
    SET status = 'AGUARDANDO_CHAMADA_MEDICO',
        atualizado_em = NOW()
    WHERE id = p_id_ffa;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_ecg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'ECG', p_id_usuario, p_observacao);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_exame`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_exame_generico`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_exame_rx`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_laboratorio`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'LAB', p_id_usuario, p_observacao);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_procedimento`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_solicitar_usg`(
    IN p_id_ffa BIGINT,
    IN p_id_usuario BIGINT,
    IN p_observacao TEXT
)
BEGIN
    CALL sp_solicitar_exame_generico(p_id_ffa, 'USG', p_id_usuario, p_observacao);
END;


CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_suspender_ordem_assistencial`(
    IN p_id_ordem   BIGINT,
    IN p_motivo     TEXT,
    IN p_id_usuario BIGINT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordem não ativa ou inexistente';
    END IF;

    UPDATE ordem_assistencial
       SET status = 'SUSPENSA',
           encerrado_em = NOW()
     WHERE id = p_id_ordem;

    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        v_id_ffa,
        'SUSPENSAO_ORDEM_ASSISTENCIAL',
        'ORDEM',
        p_id_usuario,
        p_motivo,
        NOW()
    );
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_ffa`()
BEGIN
    UPDATE ffa
       SET status = 'TIMEOUT',
           encerrado_em = NOW()
     WHERE status NOT IN ('FINALIZADO','NAO_ATENDIDO','ALTA')
       AND TIMESTAMPDIFF(HOUR, criado_em, NOW()) >= 14;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_procedimento_rx`(
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

END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_transferir_internacao`(
    IN p_id_internacao BIGINT,
    IN p_novo_leito INT,
    IN p_id_usuario BIGINT,
    IN p_comentario TEXT
)
BEGIN
    DECLARE v_status_atual ENUM('ATIVA','EM_OBSERVACAO','TRANSFERIDA','ENCERRADA');

    SELECT status INTO v_status_atual FROM internacao WHERE id_internacao = p_id_internacao;

    -- Atualiza leito e status para TRANSFERIDA
    UPDATE internacao
    SET id_leito = p_novo_leito,
        status = 'TRANSFERIDA',
        atualizado_em = NOW()
    WHERE id_internacao = p_id_internacao;

    -- Insere histórico
    INSERT INTO internacao_historico (id_internacao, status_anterior, status_novo, id_usuario, comentario)
    VALUES (p_id_internacao, v_status_atual, 'TRANSFERIDA', p_id_usuario, p_comentario);
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_trocar_senha_usuario`(
    IN p_id_usuario BIGINT,
    IN p_nova_senha VARCHAR(150)
)
BEGIN
    UPDATE usuario
    SET 
        senha = p_nova_senha,
        senha_hash = SHA2(p_nova_senha, 256),
        primeiro_login = 0,
        senha_expira_em = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
    WHERE id_usuario = p_id_usuario;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_substatus_operacional`(
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
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_login`(
    IN p_login VARCHAR(150),
    IN p_senha VARCHAR(150)
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_senha_hash VARCHAR(255);
    DECLARE v_ativo TINYINT;
    DECLARE v_primeiro_login TINYINT;
    DECLARE v_senha_expira_em DATE;

    -- Inicializa
    SET v_id_usuario = NULL;
    SET v_senha_hash = NULL;
    SET v_ativo = 0;
    SET v_primeiro_login = 0;
    SET v_senha_expira_em = NULL;

    -- Busca usuário
    SELECT id_usuario, senha_hash, ativo, primeiro_login, senha_expira_em
    INTO v_id_usuario, v_senha_hash, v_ativo, v_primeiro_login, v_senha_expira_em
    FROM usuario
    WHERE login = p_login
    LIMIT 1;

    -- Valida existência e ativo
    IF v_id_usuario IS NULL OR v_ativo = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário inválido ou inativo.';
    END IF;

    -- Valida senha
    IF v_senha_hash <> SHA2(p_senha, 256) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha incorreta.';
    END IF;

    -- Verifica expiração
    IF v_senha_expira_em IS NOT NULL AND CURDATE() > v_senha_expira_em THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha expirada. Obrigatório trocar.';
    END IF;

    -- Retorna dados
    SELECT 
        v_id_usuario AS id_usuario,
        p_login AS login,
        v_primeiro_login AS primeiro_login,
        v_senha_expira_em AS senha_expira_em;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_verificar_pendencias_assistenciais`(
    IN p_id_ffa BIGINT,
    OUT p_pendencias INT
)
BEGIN
    SELECT COUNT(*)
      INTO p_pendencias
      FROM ffa_procedimento
     WHERE id_ffa = p_id_ffa
       AND status IN ('AGUARDANDO','EM_EXECUCAO');
END;
