DROP PROCEDURE IF EXISTS test_executor_raw;
DELIMITER ;;
CREATE PROCEDURE test_executor_raw()
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_painel BIGINT;
    DECLARE v_id_opcao BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_tipo_senha VARCHAR(20);
    DECLARE v_id_senha BIGINT;
    DECLARE v_resultado JSON;
    DECLARE v_sucesso BOOLEAN;
    DECLARE v_mensagem VARCHAR(500);

    SELECT id_usuario, id_perfil, id_unidade, id_local
    INTO v_id_usuario, v_id_perfil, v_id_unidade, v_id_local
    FROM sessao_usuario
    WHERE id_sessao_usuario = 201
    LIMIT 1;

    SET v_id_opcao = CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(JSON_OBJECT('id_opcao', 1, 'id_unidade', 2, 'id_local_operacional', 1), '$.id_opcao')), 'null') AS UNSIGNED);
    SET v_id_paciente = CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(JSON_OBJECT('id_opcao', 1, 'id_unidade', 2, 'id_local_operacional', 1), '$.id_paciente')), 'null') AS UNSIGNED);

    SELECT id_painel INTO v_id_painel
    FROM painel
    WHERE tipo = 'TOTEM'
      AND id_unidade = v_id_unidade
      AND (id_local_operacional = v_id_local OR id_local_operacional IS NULL)
    LIMIT 1;

    SELECT 'step1' AS step, v_id_painel AS id_painel;

    SELECT tipo_atendimento INTO v_tipo_senha
    FROM totem_senha_opcao
    WHERE id_opcao = v_id_opcao
      AND id_painel = v_id_painel
      AND ativo = 1
    LIMIT 1;

    SELECT 'step2' AS step, v_tipo_senha AS tipo_senha;

    IF v_tipo_senha IS NULL OR v_tipo_senha = '' THEN
        SET v_tipo_senha = 'NORMAL';
    END IF;

    SELECT 'step3' AS step, v_tipo_senha AS tipo_senha_final;

    CALL sp_totem_gerar_senha(
        201,
        v_id_usuario,
        v_id_perfil,
        v_id_paciente,
        v_tipo_senha,
        v_id_painel,
        v_id_senha,
        v_resultado,
        v_sucesso,
        v_mensagem
    );

    SELECT 'step4' AS step, v_id_senha AS id_senha, v_sucesso AS sucesso, v_mensagem AS mensagem;
END ;;
DELIMITER ;
