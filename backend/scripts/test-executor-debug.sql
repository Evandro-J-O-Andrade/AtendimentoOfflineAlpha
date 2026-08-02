DROP PROCEDURE IF EXISTS test_executor_debug;
DELIMITER ;;
CREATE PROCEDURE test_executor_debug()
BEGIN
    DECLARE v_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
        SELECT LEFT(v_msg, 4000) AS real_error;
    END;

    CALL sp_executor_totem_gerar_senha(201, 'GERAR_SENHA', 1, JSON_OBJECT('id_opcao', 1, 'id_unidade', 2, 'id_local_operacional', 1));
    SELECT 'executor_ok' AS status;
END ;;
DELIMITER ;
