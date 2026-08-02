SELECT 'test_permissao' AS step;
SELECT nome_procedure INTO @v_nome_sp FROM permissao WHERE codigo = CONCAT(UPPER('TOTEM'), '.', UPPER('GERAR_SENHA')) AND ativo = 1 LIMIT 1;
SELECT @v_nome_sp AS nome_sp;
SELECT 'test_like' AS step;
SET @v_nome_sp = 'sp_executor_totem_gerar_senha';
SELECT @v_nome_sp NOT LIKE 'sp_executor_%' AS not_like;
SELECT 'done' AS step;
