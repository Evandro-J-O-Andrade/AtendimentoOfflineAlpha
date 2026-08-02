SELECT 'test1' AS step;
SELECT id_atendimento INTO @v_id_atendimento_vinculo FROM atendimento_vinculo WHERE id_ffa = 1 AND ativo = 1 LIMIT 1;
SELECT @v_id_atendimento_vinculo AS v_id_atendimento_vinculo;
SELECT 'test2' AS step;
INSERT INTO atendimento_evento (uuid_transacao, id_entidade, id_unidade, id_ffa, id_atendimento, id_paciente, dominio, tipo_evento, estado_origem, estado_destino, contexto_fluxo, payload, id_sessao_usuario, id_usuario, hash_evento, criado_em) VALUES (UUID(), 1, 1, 1, @v_id_atendimento_vinculo, 1, 'TOTEM', 'GERAR_SENHA', NULL, NULL, NULL, '{}', 7, 1, SHA2('test', 256), NOW(6));
SELECT 'test3' AS step;
