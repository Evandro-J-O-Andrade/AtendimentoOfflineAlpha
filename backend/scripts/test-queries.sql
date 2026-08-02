SELECT 'test1' AS step;
SELECT id_painel INTO @v_id_painel FROM painel WHERE tipo = 'TOTEM' AND id_unidade = 1 LIMIT 1;
SELECT @v_id_painel AS id_painel;
SELECT 'test2' AS step;
SELECT tipo_atendimento INTO @v_tipo_senha FROM totem_senha_opcao WHERE id_opcao = 1 AND id_painel = @v_id_painel AND ativo = 1 LIMIT 1;
SELECT @v_tipo_senha AS tipo_senha;
SELECT 'done' AS step;
