DROP FUNCTION IF EXISTS fn_usuario_tem_perfil;
DELIMITER $$
CREATE FUNCTION fn_usuario_tem_perfil(p_id_usuario BIGINT, p_perfil_nome VARCHAR(50))
RETURNS TINYINT(1)
DETERMINISTIC
READS SQL DATA
BEGIN
DECLARE v_count INT DEFAULT 0;


SELECT COUNT(*) INTO v_count
FROM usuario_sistema us
JOIN perfil p ON p.id_perfil = us.id_perfil
WHERE us.id_usuario = p_id_usuario
AND us.ativo = 1
AND p.nome = p_perfil_nome;


RETURN IF(v_count > 0, 1, 0);
END$$
DELIMITER ;


DROP VIEW IF EXISTS vw_usuario_perfis_front;
CREATE VIEW vw_usuario_perfis_front AS
SELECT
us.id_usuario,
CASE
WHEN p.nome = 'MASTER' THEN 'ADMIN_MASTER'
ELSE p.nome
END AS perfil
FROM usuario_sistema us
JOIN perfil p ON p.id_perfil = us.id_perfil
WHERE us.ativo = 1;


DROP VIEW IF EXISTS vw_usuario_permissoes;
CREATE VIEW vw_usuario_permissoes AS
SELECT
us.id_usuario,
CASE
WHEN pe.nome = 'MASTER' THEN 'ADMIN_MASTER'
ELSE pe.nome
END AS perfil,
pr.id_permissao,
pr.codigo AS permissao_codigo,
pr.descricao AS permissao_descricao
FROM usuario_sistema us
JOIN perfil pe ON pe.id_perfil = us.id_perfil
JOIN perfil_permissao pp ON pp.id_perfil = pe.id_perfil
JOIN permissao pr ON pr.id_permissao = pp.id_permissao
WHERE us.ativo = 1;