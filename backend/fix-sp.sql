DELIMITER ;;
DROP PROCEDURE IF EXISTS sp_auth_menu_get ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_menu_get`(
    IN p_id_sessao BIGINT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_entidade BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_erro_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_erro_msg = MESSAGE_TEXT;
        SET p_resultado = JSON_OBJECT('erro', TRUE, 'mensagem', v_erro_msg);
        SET p_sucesso = FALSE;
        SET p_mensagem = 'ERRO_MENU';
        INSERT INTO menu_evento(id_sessao_usuario, sucesso, mensagem, criado_em)
        VALUES (p_id_sessao, 0, v_erro_msg, NOW());
    END;

    SET p_sucesso = FALSE;
    SET p_mensagem = '';
    SET p_resultado = JSON_OBJECT();

    sp_exit_block: BEGIN

        SELECT id_usuario, id_perfil, id_unidade, id_local, id_entidade, ativo
        INTO v_id_usuario, v_id_perfil, v_id_unidade, v_id_local, v_id_entidade, v_ativo
        FROM sessao_usuario
        WHERE id_sessao_usuario = p_id_sessao
          AND id_entidade IS NOT NULL
        LIMIT 1;

        IF v_id_usuario IS NULL THEN
            SET p_mensagem = 'SESSAO_INVALIDA';
            LEAVE sp_exit_block;
        END IF;

        IF v_ativo <> 1 THEN
            SET p_mensagem = 'SESSAO_INATIVA';
            LEAVE sp_exit_block;
        END IF;

        IF v_id_unidade IS NULL OR v_id_perfil IS NULL OR v_id_local IS NULL THEN
            SET p_mensagem = 'CONTEXTO_NAO_DEFINIDO';
            LEAVE sp_exit_block;
        END IF;

        SET p_resultado = (
            SELECT JSON_OBJECT(
                'modulos', JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'modulo', modulos.modulo,
                        'nome', modulos.nome,
                        'icone', modulos.icone,
                        'ordem', modulos.ordem,
                        'flags', JSON_OBJECT(
                            'ativo', modulos.flag_ativo,
                            'externo', modulos.flag_externo,
                            'restrito', modulos.flag_restrito
                        ),
                        'acoes', modulos.acoes
                    )
                )
            )
            FROM (
                SELECT
                    m.modulo,
                    m.nome,
                    m.icone,
                    m.ordem,
                    m.flag_ativo,
                    m.flag_externo,
                    m.flag_restrito,
                    (
                        SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                                'codigo', a.codigo,
                                'nome', a.nome,
                                'sp', a.nome_procedure,
                                'ordem', a.ordem
                            )
                        )
                        FROM (
                            SELECT p.codigo, p.nome, p.nome_procedure, p.ordem
                            FROM permissao p
                            JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                            LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
                            WHERE pp.id_perfil = v_id_perfil
                              AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
                              AND p.modulo = m.modulo
                              AND p.flag_ativo = 1
                              AND p.id_entidade = v_id_entidade
                            ORDER BY p.ordem, p.nome
                        ) AS a
                    ) AS acoes
                FROM (
                    SELECT DISTINCT
                        p.modulo,
                        p.modulo AS nome,
                        COALESCE(p.icone, 'default') AS icone,
                        COALESCE(p.ordem, 999) AS ordem,
                        COALESCE(p.flag_ativo, 1) AS flag_ativo,
                        COALESCE(p.flag_externo, 0) AS flag_externo,
                        COALESCE(p.flag_restrito, 0) AS flag_restrito
                    FROM permissao p
                    JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                    LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
                    WHERE pp.id_perfil = v_id_perfil
                      AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
                      AND p.flag_ativo = 1
                      AND p.id_entidade = v_id_entidade
                    ORDER BY ordem, modulo
                ) AS m
            ) AS modulos
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'MENU_OK';

        INSERT INTO menu_evento(id_sessao_usuario, sucesso, mensagem, criado_em)
        VALUES (p_id_sessao, 1, 'MENU_OK', NOW());

    END sp_exit_block;

END ;;
DELIMITER ;
