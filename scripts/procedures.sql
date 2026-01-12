DELIMITER $$
CREATE PROCEDURE sp_registrar_paciente(
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
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_atualizar_estoque(
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
END$$
DELIMITER ;

-- Procedure para agendamento
DELIMITER $$
CREATE PROCEDURE sp_criar_agendamento(
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
END$$
DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_liberar_medicacao_farmacia $$
CREATE PROCEDURE sp_liberar_medicacao_farmacia (
    IN p_id_ordem     BIGINT,
    IN p_id_usuario   BIGINT,
    IN p_lote         VARCHAR(50),
    IN p_validade     DATE,
    IN p_observacao   TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    /* 1️⃣ Valida ordem */
    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND tipo_ordem = 'MEDICACAO'
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordem de medicação inválida ou não ativa';
    END IF;

    /* 2️⃣ Registra liberação */
    INSERT INTO dispensacao_medicacao (
        id_ordem,
        id_ffa,
        lote,
        validade,
        liberado_por,
        observacao,
        liberado_em
    ) VALUES (
        p_id_ordem,
        v_id_ffa,
        p_lote,
        p_validade,
        p_id_usuario,
        p_observacao,
        NOW()
    );

    /* 3️⃣ Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        v_id_ffa,
        'LIBERACAO_MEDICACAO',
        'FARMACIA',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END $$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS sp_liberar_medicacao_farmacia $$
CREATE PROCEDURE sp_liberar_medicacao_farmacia (
    IN p_id_ordem     BIGINT,
    IN p_id_usuario   BIGINT,
    IN p_lote         VARCHAR(50),
    IN p_validade     DATE,
    IN p_observacao   TEXT
)
BEGIN
    DECLARE v_id_ffa BIGINT;

    /* 1️⃣ Valida ordem */
    SELECT id_ffa
      INTO v_id_ffa
      FROM ordem_assistencial
     WHERE id = p_id_ordem
       AND tipo_ordem = 'MEDICACAO'
       AND status = 'ATIVA';

    IF v_id_ffa IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ordem de medicação inválida ou não ativa';
    END IF;

    /* 2️⃣ Registra liberação */
    INSERT INTO dispensacao_medicacao (
        id_ordem,
        id_ffa,
        lote,
        validade,
        liberado_por,
        observacao,
        liberado_em
    ) VALUES (
        p_id_ordem,
        v_id_ffa,
        p_lote,
        p_validade,
        p_id_usuario,
        p_observacao,
        NOW()
    );

    /* 3️⃣ Auditoria */
    INSERT INTO eventos_fluxo (
        id_ffa,
        evento,
        contexto,
        id_usuario,
        observacao,
        criado_em
    ) VALUES (
        v_id_ffa,
        'LIBERACAO_MEDICACAO',
        'FARMACIA',
        p_id_usuario,
        p_observacao,
        NOW()
    );

END $$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS sp_registrar_ordem_assistencial $$
CREATE PROCEDURE sp_registrar_ordem_assistencial (
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
END $$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS sp_listar_fila_farmacia $$
CREATE PROCEDURE sp_listar_fila_farmacia ()
BEGIN
    SELECT *
    FROM vw_fila_farmacia
    ORDER BY
        prioridade DESC,
        iniciado_em ASC;
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_encerrar_ordem_assistencial $$
CREATE PROCEDURE sp_encerrar_ordem_assistencial (
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
END $$

DELIMITER ;




DELIMITER $$

DROP PROCEDURE IF EXISTS sp_suspender_ordem_assistencial $$
CREATE PROCEDURE sp_suspender_ordem_assistencial (
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
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_registrar_ordem_assistencial $$
CREATE PROCEDURE sp_registrar_ordem_assistencial (
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
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_faturamento_obter_conta $$
CREATE PROCEDURE sp_faturamento_obter_conta (
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
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_faturamento_gerar_item $$
CREATE PROCEDURE sp_faturamento_gerar_item (
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
END $$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS sp_faturamento_consolidar $$
CREATE PROCEDURE sp_faturamento_consolidar (
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
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_faturamento_fechar_conta $$
CREATE PROCEDURE sp_faturamento_fechar_conta (
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
END $$

DELIMITER ;



DELIMITER $$

DROP PROCEDURE IF EXISTS sp_painel_chamar_paciente $$
CREATE PROCEDURE sp_painel_chamar_paciente (
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
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_painel_nao_compareceu $$
CREATE PROCEDURE sp_painel_nao_compareceu (
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
END $$

DELIMITER ;


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_registrar_feedback_totem $$
CREATE PROCEDURE sp_registrar_feedback_totem (
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
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_farmaco_set_cota_minima (
    IN p_id_farmaco BIGINT,
    IN p_id_cidade BIGINT,
    IN p_cota_minima INT,
    IN p_usuario BIGINT
)
BEGIN
    INSERT INTO farmaco_unidade
        (id_farmaco, id_cidade, cota_minima, atualizado_por)
    VALUES
        (p_id_farmaco, p_id_cidade, p_cota_minima, p_usuario)
    ON DUPLICATE KEY UPDATE
        cota_minima = p_cota_minima,
        atualizado_por = p_usuario,
        atualizado_em = NOW();
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_farmaco_entrada (
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_cidade BIGINT,
    IN p_quantidade INT,
    IN p_origem ENUM('COMPRA','TRANSFERENCIA','AJUSTE'),
    IN p_usuario BIGINT
)
BEGIN
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_cidade, 'ENTRADA', p_quantidade, p_origem, p_usuario);
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE sp_farmaco_saida_paciente (
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_cidade BIGINT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_usuario BIGINT
)
BEGIN
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_cidade, 'SAIDA', p_quantidade, 'PACIENTE', p_id_ffa, p_usuario);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_farmaco_saida_paciente (
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_cidade BIGINT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_usuario BIGINT
)
BEGIN
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lote vencido. Saída bloqueada.';
    END IF;

    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_cidade, 'SAIDA', p_quantidade, 'PACIENTE', p_id_ffa, p_usuario);
END$$

DELIMITER ;
DROP PROCEDURE IF EXISTS sp_farmaco_saida_paciente;
DELIMITER $$

CREATE PROCEDURE sp_farmaco_saida_paciente (
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_cidade BIGINT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_usuario BIGINT
)
BEGIN

    -- BLOQUEIO SANITÁRIO COM AUDITORIA
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN

        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_cidade, p_quantidade, p_id_ffa, p_usuario,
             'Tentativa de saída com lote vencido');

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lote vencido. Saída bloqueada.';
    END IF;

    -- SAÍDA NORMAL
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_cidade, 'SAIDA', p_quantidade, 'PACIENTE',
         p_id_ffa, p_usuario);

END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_farmaco_saida_paciente;
DELIMITER $$

CREATE PROCEDURE sp_farmaco_saida_paciente (
    IN p_id_farmaco BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local INT,
    IN p_quantidade INT,
    IN p_id_ffa BIGINT,
    IN p_usuario BIGINT
)
BEGIN
    DECLARE v_saldo_atual INT DEFAULT 0;

    /* 1. BLOQUEIO SANITÁRIO */
    IF fn_farmaco_lote_valido(p_id_lote) = FALSE THEN

        INSERT INTO farmaco_auditoria_bloqueio
            (id_farmaco, id_lote, id_cidade, quantidade, id_ffa, usuario, motivo)
        VALUES
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_usuario,
             'Tentativa de saída com lote vencido');

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Lote vencido. Saída bloqueada.';
    END IF;

    /* 2. VERIFICA SALDO */
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
            (p_id_farmaco, p_id_lote, p_id_local, p_quantidade, p_id_ffa, p_usuario,
             'Tentativa de saída sem saldo suficiente');

        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente.';
    END IF;

    /* 3. DEBITA ESTOQUE */
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = p_id_farmaco
       AND id_local = p_id_local;

    /* 4. REGISTRA MOVIMENTAÇÃO */
    INSERT INTO farmaco_movimentacao
        (id_farmaco, id_lote, id_cidade, tipo, quantidade, origem, id_ffa, realizado_por)
    VALUES
        (p_id_farmaco, p_id_lote, p_id_local, 'SAIDA', p_quantidade,
         'PACIENTE', p_id_ffa, p_usuario);

END$$
DELIMITER ;


SHOW CREATE VIEW vw_farmacia_dashboard_critico;

DELIMITER $$

CREATE PROCEDURE sp_farmacia_saida_estoque (
    IN p_id_lote BIGINT,
    IN p_quantidade INT,
    IN p_id_usuario BIGINT,
    IN p_id_local INT
)
BEGIN
    DECLARE v_id_farmaco BIGINT;
    DECLARE v_validade DATE;
    DECLARE v_dias INT;
    DECLARE v_risco VARCHAR(20);
    DECLARE v_estoque INT;

    -- Dados do lote
    SELECT id_farmaco, data_validade
      INTO v_id_farmaco, v_validade
    FROM lote
    WHERE id_lote = p_id_lote;

    SET v_dias = fn_dias_para_vencimento(v_validade);

    SET v_risco =
        CASE
            WHEN v_dias < 0 THEN 'VENCIDO'
            WHEN v_dias <= 30 THEN 'CRITICO'
            ELSE 'OK'
        END;

    -- Bloqueio sanitário
    IF v_risco = 'VENCIDO' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saída bloqueada: medicamento vencido';
    END IF;

    -- Estoque atual
    SELECT quantidade_atual
      INTO v_estoque
    FROM estoque_local
    WHERE id_farmaco = v_id_farmaco
      AND id_local = p_id_local
    FOR UPDATE;

    IF v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    -- Atualiza estoque
    UPDATE estoque_local
       SET quantidade_atual = quantidade_atual - p_quantidade
     WHERE id_farmaco = v_id_farmaco
       AND id_local = p_id_local;

    -- Auditoria
    INSERT INTO auditoria_estoque_sanitario
        (id_farmaco, id_lote, id_local, quantidade, nivel_risco, criado_por)
    VALUES
        (v_id_farmaco, p_id_lote, p_id_local, p_quantidade, v_risco, p_id_usuario);

END$$
DELIMITER ;


ALTER TABLE usuario
ADD COLUMN primeiro_login TINYINT(1) NOT NULL DEFAULT 1,
ADD COLUMN senha_expira_em DATE DEFAULT NULL;

-- Troca o delimiter para permitir múltiplos comandos
DELIMITER $$

-- Se já existir a procedure, primeiro drop
DROP PROCEDURE IF EXISTS sp_reset_senha_usuario$$

-- Cria a procedure
CREATE PROCEDURE sp_reset_senha_usuario(IN p_id_usuario BIGINT)
BEGIN
    DECLARE v_login VARCHAR(150);

    -- Pega o login do usuário
    SELECT login INTO v_login
    FROM usuario
    WHERE id_usuario = p_id_usuario;

    -- Atualiza a senha para o login e seta flags
    UPDATE usuario
    SET senha = v_login,
        primeiro_login = 1,
        senha_expira_em = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
    WHERE id_usuario = p_id_usuario;
END $$

-- Volta o delimiter para o padrão
DELIMITER ;

DELIMITER $$

-- Remove caso já exista
DROP PROCEDURE IF EXISTS sp_trocar_senha_usuario$$

-- Criação da procedure
CREATE PROCEDURE sp_trocar_senha_usuario(
    IN p_id_usuario BIGINT,
    IN p_nova_senha VARCHAR(150)
)
BEGIN
    -- Atualiza a senha do usuário
    UPDATE usuario
    SET senha = p_nova_senha,
        primeiro_login = 0,
        senha_expira_em = DATE_ADD(CURDATE(), INTERVAL 6 MONTH)
    WHERE id_usuario = p_id_usuario;
END $$

DELIMITER ;
CALL sp_trocar_senha_usuario(10, 'MinhaNovaSenha123');

