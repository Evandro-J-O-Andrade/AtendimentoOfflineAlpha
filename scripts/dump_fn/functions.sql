DELIMITER $$
CREATE FUNCTION fn_calcula_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION fn_gera_protocolo(p_id_usuario BIGINT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE seq INT;
    INSERT INTO protocolo_sequencia (id) VALUES (NULL); -- Gera sequência
    SET seq = LAST_INSERT_ID();
    RETURN CONCAT(YEAR(NOW()), 'GPAT/', LPAD(seq, 6, '0'));
END$$
DELIMITER ;

-- Function para pontuação de prioridade
DELIMITER $$
CREATE FUNCTION fn_prioridade_score(p_prioridade ENUM('NORMAL','IDOSO','CRIANCA_COLO','ESPECIAL','EMERGENCIA'))
RETURNS INT
DETERMINISTIC
BEGIN
    CASE p_prioridade
        WHEN 'EMERGENCIA' THEN RETURN 5;
        WHEN 'IDOSO' THEN RETURN 4;
        WHEN 'CRIANCA_COLO' THEN RETURN 3;
        WHEN 'ESPECIAL' THEN RETURN 2;
        ELSE RETURN 1;
    END CASE;
END$$
DELIMITER ;;

DELIMITER $$

CREATE FUNCTION fn_farmaco_estoque_atual (
    p_id_farmaco BIGINT,
    p_id_cidade BIGINT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_estoque INT;

    SELECT IFNULL(estoque_total,0)
    INTO v_estoque
    FROM vw_farmaco_estoque_total
    WHERE id_farmaco = p_id_farmaco
      AND id_cidade  = p_id_cidade;

    RETURN v_estoque;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION fn_farmaco_lote_valido (
    p_id_lote BIGINT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_validade DATE;

    SELECT data_validade
    INTO v_validade
    FROM farmaco_lote
    WHERE id_lote = p_id_lote;

    IF v_validade < CURDATE() THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION fn_dias_para_vencimento(p_data_validade DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(p_data_validade, CURDATE());
END$$

DELIMITER ;
DELIMITER $$

CREATE FUNCTION fn_dias_para_vencimento(p_data_validade DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(p_data_validade, CURDATE());
END$$

DELIMITER ;
