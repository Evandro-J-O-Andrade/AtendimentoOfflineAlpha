SET @p_sessao = 201;
SET @p_uuid = UUID();
SET @p_dominio = 'TOTEM';
SET @p_acao = 'GERAR_SENHA';
SET @p_ref = 1;
SET @p_pay = JSON_OBJECT('id_opcao', 1, 'id_unidade', 2, 'id_local_operacional', 1);

CALL sp_master_dispatcher(@p_sessao, @p_uuid, @p_dominio, @p_acao, @p_ref, @p_pay);
SELECT 'done' AS step;
