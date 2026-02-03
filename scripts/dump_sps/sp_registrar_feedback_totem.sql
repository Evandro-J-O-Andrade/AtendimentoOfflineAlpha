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
END