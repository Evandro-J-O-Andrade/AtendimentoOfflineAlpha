CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gera_protocolo_lab`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_pedido_item    BIGINT,
    IN  p_sistema_externo   VARCHAR(50),   -- opcional
    IN  p_codigo_externo    VARCHAR(80),   -- opcional
    OUT p_codigo            VARCHAR(60),
    OUT p_barcode           VARCHAR(60)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_pedido BIGINT;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_gpat BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_unidade BIGINT;

    DECLARE v_prefixo5 CHAR(5);
    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo VARCHAR(60);
    DECLARE v_barcode VARCHAR(60);
    DECLARE v_id_proto BIGINT;

    DECLARE v_tipo_item VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_gera_protocolo_lab', 'Falha ao gerar protocolo LAB');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_gera_protocolo_lab | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_codigo  = NULL;
    SET p_barcode = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_pedido_item IS NOT NULL, 'PARAM', 'id_pedido_item é obrigatório.');

    START TRANSACTION;

    -- evita duplicidade
    SELECT lp.codigo, lp.barcode
      INTO p_codigo, p_barcode
      FROM laboratorio_protocolo lp
     WHERE lp.id_pedido_item = p_id_pedido_item
     LIMIT 1;

    IF p_codigo IS NOT NULL THEN
        COMMIT;
        LEAVE main;
    END IF;

    SELECT i.id_pedido_medico, i.tipo_item
      INTO v_id_pedido, v_tipo_item
      FROM pedido_medico_item i
     WHERE i.id_pedido_item = p_id_pedido_item
     LIMIT 1;

    CALL sp_assert_true(v_id_pedido IS NOT NULL, 'LAB', 'Item do pedido não encontrado.');
    -- regra: exame/procedimento gera protocolo lab; se quiser liberar outros, muda aqui
    CALL sp_assert_true(v_tipo_item IN ('EXAME','PROCEDIMENTO'), 'LAB', 'Item não é EXAME/PROCEDIMENTO.');

    SELECT p.id_ffa, p.id_gpat, p.id_local_operacional
      INTO v_id_ffa, v_id_gpat, v_id_local
      FROM pedido_medico p
     WHERE p.id_pedido_medico = v_id_pedido
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL, 'LAB', 'Pedido sem id_ffa.');
    CALL sp_assert_true(v_id_gpat IS NOT NULL, 'LAB', 'Pedido sem GPAT. Garanta GPAT antes.');

    -- garantir GPAT na FFA (se alguém criou pedido errado no futuro)
    CALL sp_ffa_gpat_garantir(p_id_sessao_usuario, v_id_ffa, 'GPAT');

    -- resolve unidade/local via sessão (padrão), com fallback no local do pedido
    SET v_id_unidade = NULL;
    SELECT su.id_unidade
      INTO v_id_unidade
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
     LIMIT 1;

    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, 'LAB', v_id_unidade, v_id_local, v_prefixo5);

    -- emite código interno (código + barcode). Regra: barcode = código.
    CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'LAB',
        v_prefixo5,
        NULL, NULL, NULL,
        v_id_ffa,
        NULL, NULL, NULL, NULL, NULL,
        NULL,
        @out_id_codigo,
        @out_codigo_interno,
        @out_barcode
    );

    SET v_id_codigo = @out_id_codigo;
    SET v_codigo    = @out_codigo_interno;
    SET v_barcode   = @out_codigo_interno; -- força bater com o código humano (regra do projeto)

    INSERT INTO laboratorio_protocolo (
        id_ffa, id_gpat, id_pedido_item, id_codigo_universal,
        codigo, barcode, status,
        sistema_externo, codigo_externo
    ) VALUES (
        v_id_ffa, v_id_gpat, p_id_pedido_item, v_id_codigo,
        v_codigo, v_barcode, 'GERADO',
        p_sistema_externo, p_codigo_externo
    );

    SET v_id_proto = LAST_INSERT_ID();

    -- atualiza o item do pedido com o vínculo
    UPDATE pedido_medico_item
       SET id_codigo_universal = v_id_codigo,
           sistema_externo     = p_sistema_externo,
           codigo_externo      = p_codigo_externo,
           atualizado_em       = NOW()
     WHERE id_pedido_item = p_id_pedido_item;

    -- vinculo externo opcional (quando informado)
    IF p_sistema_externo IS NOT NULL AND p_codigo_externo IS NOT NULL THEN
        INSERT INTO codigo_externo_vinculo (tipo, sistema_externo, codigo_externo, id_codigo_universal, id_sessao_usuario, observacao)
        VALUES ('LAB', p_sistema_externo, p_codigo_externo, v_id_codigo, p_id_sessao_usuario, 'Protocolo LAB mapeado');
    END IF;

    INSERT INTO laboratorio_protocolo_evento (id_laboratorio_protocolo, id_sessao_usuario, evento, detalhe, payload_json)
    VALUES (v_id_proto, p_id_sessao_usuario, 'GERADO', NULL,
            JSON_OBJECT('id_pedido_item', p_id_pedido_item, 'codigo', v_codigo, 'barcode', v_barcode));

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'LAB_PROTOCOLO_GERADO', 'laboratorio_protocolo', v_id_proto);

    SET p_codigo  = v_codigo;
    SET p_barcode = v_barcode;

    COMMIT;
END ;;