SELECT 'test_sp' AS step;
CALL sp_totem_gerar_senha(201, 1, 3, NULL, 'CLINICO', 9, @id_senha, @resultado, @sucesso, @mensagem);
SELECT @id_senha AS id_senha, @resultado AS resultado, @sucesso AS sucesso, @mensagem AS mensagem;
SELECT 'sp_done' AS step;
