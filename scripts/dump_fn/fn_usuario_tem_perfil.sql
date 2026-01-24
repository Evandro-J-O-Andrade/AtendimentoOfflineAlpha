CREATE DEFINER=`root`@`localhost` FUNCTION `fn_usuario_tem_perfil`(p_id_usuario BIGINT, p_perfil_nome VARCHAR(50)) RETURNS tinyint(1)
    READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE v_count INT DEFAULT 0;


SELECT COUNT(*) INTO v_count
FROM usuario_sistema us
JOIN perfil p ON p.id_perfil = us.id_perfil
WHERE us.id_usuario = p_id_usuario
AND us.ativo = 1
AND p.nome = p_perfil_nome;


RETURN IF(v_count > 0, 1, 0);
END