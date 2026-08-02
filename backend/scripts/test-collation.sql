SELECT 'test1' AS step;
SELECT prefixo, codigo INTO @v_prefixo, @v_codigo_visual FROM totem_senha_opcao WHERE id_painel = 9 AND tipo_atendimento = 'CLINICO' AND ativo = 1 LIMIT 1;
SELECT @v_prefixo AS prefixo, @v_codigo_visual AS codigo;
SELECT 'test2' AS step;
SELECT prefixo, codigo INTO @v_prefixo2, @v_codigo_visual2 FROM totem_senha_opcao WHERE id_painel = 9 AND tipo_atendimento COLLATE utf8mb4_0900_ai_ci = 'CLINICO' COLLATE utf8mb4_0900_ai_ci AND ativo = 1 LIMIT 1;
SELECT @v_prefixo2 AS prefixo2, @v_codigo_visual2 AS codigo2;
SELECT 'done' AS step;
