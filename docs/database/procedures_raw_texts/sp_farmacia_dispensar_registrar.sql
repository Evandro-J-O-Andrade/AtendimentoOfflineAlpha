CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmacia_dispensar_registrar`(
    IN p_id_sessao_usuario BIGINT, -- QUEM (Sessão rastreável)
    IN p_id_unidade BIGINT,        -- ONDE (Qual hospital/unidade)
    IN p_id_paciente BIGINT,       -- PARA QUEM
    IN p_id_produto BIGINT,        -- O QUÊ
    IN p_id_lote BIGINT,           -- QUAL LOTE ESPECÍFICO
    IN p_quantidade DECIMAL(15,4),
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_dispensacao BIGINT;
    DECLARE v_id_movimento BIGINT;

    -- 1. VALIDAÇÃO DE SESSÃO (SUA LEI Nº 1)
    IF p_id_sessao_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_LOGICA_IMUTAVEL: Sessao obrigatoria.';
    END IF;

    -- 2. REGISTRA A DISPENSAÇÃO (PARA QUEM/QUANDO)
    INSERT INTO farm_dispensacao (id_paciente, id_unidade, data_dispensacao, status)
    VALUES (p_id_paciente, p_id_unidade, NOW(), 'CONCLUIDA');
    
    SET v_id_dispensacao = LAST_INSERT_ID();

    -- 3. REGISTRA O ITEM E O LOTE
    INSERT INTO farm_dispensacao_item (id_dispensacao, id_produto, lote, quantidade)
    VALUES (v_id_dispensacao, p_id_produto, p_id_lote, p_quantidade);

    -- 4. MOVIMENTAÇÃO DE ESTOQUE (ONDE/QUANTO)
    -- Usando sua tabela 'estoque_movimento' identificada no dump
    INSERT INTO estoque_movimento (id_unidade, data_movimento, tipo_movimento, id_usuario_responsavel)
    VALUES (p_id_unidade, NOW(), 'SAIDA_DISPENSACAO', p_id_sessao_usuario);
    
    SET v_id_movimento = LAST_INSERT_ID();

    -- 5. ATUALIZAÇÃO DO SALDO (SEM TRIGGER)
    UPDATE estoque_lote 
    SET quantidade_atual = quantidade_atual - p_quantidade 
    WHERE id_lote = p_id_lote;

    -- 6. AUDITORIA TOTAL (SUA LEI Nº 2)
    -- "Sempre saber quem, onde, quando e para quem"
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FARM_DISPENSACAO',
        v_id_dispensacao,
        'DISPENSAR',
        CONCAT('Dispensação para paciente ', p_id_paciente, 
               ' | Produto: ', p_id_produto, 
               ' | Lote: ', p_id_lote, 
               ' | Qtd: ', p_quantidade,
               ' | Unidade: ', p_id_unidade)
    );

END ;;