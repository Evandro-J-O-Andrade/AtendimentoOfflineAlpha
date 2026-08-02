SELECT 'test_executor' AS step;
CALL sp_executor_totem_gerar_senha(201, 'GERAR_SENHA', 1, JSON_OBJECT('id_opcao', 1, 'id_unidade', 1, 'id_local_operacional', 1));
SELECT 'executor_done' AS step;
