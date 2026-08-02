SELECT 'test_evento' AS step;
CALL sp_master_registrar_evento(201, 'TOTEM', 'GERAR_SENHA', 1, JSON_OBJECT('id_opcao', 1, 'id_unidade', 1, 'id_atendimento', 2, 'id_saas_entidade', 1, 'id_local_operacional', 1), JSON_OBJECT('id_saas', 1, 'id_unidade', 1), 'teste-uuid', @id_evento);
SELECT @id_evento AS id_evento;
SELECT 'evento_done' AS step;
