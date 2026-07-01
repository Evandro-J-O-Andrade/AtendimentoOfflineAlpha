# sp_gera_protocolo_lab

Objetivo: gera protocolo lab conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_pedido_item | BIGINT | IN | |
| p_codigo | VARCHAR(60) | OUT | |
| p_barcode | VARCHAR(60) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: laboratorio_protocolo, pedido_medico, pedido_medico_item, sessao_usuario
- INSERT: codigo_externo_vinculo, laboratorio_protocolo, laboratorio_protocolo_evento
- UPDATE: pedido_medico_item
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_codigo_emitir_interno
- sp_codigo_prefixo_resolver
- sp_ffa_gpat_garantir
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- JSON_OBJECT
- LAST_INSERT_ID
- NOW

## Views Utilizadas
- v_barcode
- v_codigo
- v_prefixo5
- v_sqlstate
- v_tipo_item

## Eventos Gerados
- auditoria_evento
- evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: main: BEGIN
- **Linha 10**: Declaracao de variavel local v_sqlstate.
- **Linha 11**: Declaracao de variavel local v_errno.
- **Linha 12**: Declaracao de variavel local v_msg.
- **Linha 14**: Declaracao de variavel local v_id_pedido.
- **Linha 15**: Declaracao de variavel local v_id_ffa.
- **Linha 16**: Declaracao de variavel local v_id_gpat.
- **Linha 17**: Declaracao de variavel local v_id_local.
- **Linha 18**: Declaracao de variavel local v_id_unidade.
- **Linha 20**: Declaracao de variavel local v_prefixo5.
- **Linha 21**: Declaracao de variavel local v_id_codigo.
- **Linha 22**: Declaracao de variavel local v_codigo.
- **Linha 23**: Declaracao de variavel local v_barcode.
- **Linha 24**: Declaracao de variavel local v_id_proto.
- **Linha 26**: Declaracao de variavel local v_tipo_item.
- **Linha 28**: Declaracao de variavel local EXIT.
- **Linha 29**: inicio do bloco de execucao.
- **Linha 30**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 31**: ROLLBACK;
- **Linha 32**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 33**: Invoca a procedure sp_raise.
- **Linha 34**: Fim do bloco da procedure.
- **Linha 36**: atribuicao de valor Ã  variavel p_codigo.
- **Linha 37**: atribuicao de valor Ã  variavel p_barcode.
- **Linha 39**: Invoca a procedure sp_sessao_assert.
- **Linha 40**: Invoca a procedure sp_assert_true.
- **Linha 42**: START TRANSACTION;
- **Linha 44** (Comentario): evita duplicidade
- **Linha 45**: execucao de query SELECT para consulta de dados.
- **Linha 46**: INTO p_codigo, p_barcode
- **Linha 47**: FROM laboratorio_protocolo lp
- **Linha 48**: WHERE lp.id_pedido_item = p_id_pedido_item
- **Linha 49**: LIMIT 1;
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 52**: COMMIT;
- **Linha 53**: Estrutura de repeticao/controle de loop.
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 56**: execucao de query SELECT para consulta de dados.
- **Linha 57**: INTO v_id_pedido, v_tipo_item
- **Linha 58**: FROM pedido_medico_item i
- **Linha 59**: WHERE i.id_pedido_item = p_id_pedido_item
- **Linha 60**: LIMIT 1;
- **Linha 62**: Invoca a procedure sp_assert_true.
- **Linha 63** (Comentario): regra: exame/procedimento gera protocolo lab; se quiser liberar outros, muda aqui
- **Linha 64**: Invoca a procedure sp_assert_true.
- **Linha 66**: execucao de query SELECT para consulta de dados.
- **Linha 67**: INTO v_id_ffa, v_id_gpat, v_id_local
- **Linha 68**: FROM pedido_medico p
- **Linha 69**: WHERE p.id_pedido_medico = v_id_pedido
- **Linha 70**: LIMIT 1;
- **Linha 72**: Invoca a procedure sp_assert_true.
- **Linha 73**: Invoca a procedure sp_assert_true.
- **Linha 75** (Comentario): garantir GPAT na FFA (se alguém criou pedido errado no futuro)
- **Linha 76**: Invoca a procedure sp_ffa_gpat_garantir.
- **Linha 78** (Comentario): resolve unidade/local via sessão (padrão), com fallback no local do pedido
- **Linha 79**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 80**: execucao de query SELECT para consulta de dados.
- **Linha 81**: INTO v_id_unidade
- **Linha 82**: FROM sessao_usuario su
- **Linha 83**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 84**: LIMIT 1;
- **Linha 86**: Invoca a procedure sp_codigo_prefixo_resolver.
- **Linha 88** (Comentario): emite código interno (código + barcode). Regra: barcode = código.
- **Linha 89**: Invoca a procedure sp_codigo_emitir_interno.
- **Linha 90**: p_id_sessao_usuario,
- **Linha 91**: 'LAB',
- **Linha 92**: v_prefixo5,
- **Linha 93**: NULL, NULL, NULL,
- **Linha 94**: v_id_ffa,
- **Linha 95**: NULL, NULL, NULL, NULL, NULL,
- **Linha 96**: NULL,
- **Linha 97**: @out_id_codigo,
- **Linha 98**: @out_codigo_interno,
- **Linha 99**: @out_barcode
- **Linha 100**: );
- **Linha 102**: atribuicao de valor Ã  variavel v_id_codigo.
- **Linha 103**: atribuicao de valor Ã  variavel v_codigo.
- **Linha 104**: atribuicao de valor Ã  variavel v_barcode.
- **Linha 106**: Insere um novo registro na tabela laboratorio_protocolo.
- **Linha 107**: id_ffa, id_gpat, id_pedido_item, id_codigo_universal,
- **Linha 108**: codigo, barcode, status,
- **Linha 109**: sistema_externo, codigo_externo
- **Linha 110**: ) VALUES (
- **Linha 111**: v_id_ffa, v_id_gpat, p_id_pedido_item, v_id_codigo,
- **Linha 112**: v_codigo, v_barcode, 'GERADO',
- **Linha 113**: p_sistema_externo, p_codigo_externo
- **Linha 114**: );
- **Linha 116**: atribuicao de valor Ã  variavel v_id_proto.
- **Linha 118** (Comentario): atualiza o item do pedido com o vínculo
- **Linha 119**: UPDATE pedido_medico_item
- **Linha 120**: atribuicao de valor Ã  variavel id_codigo_universal.
- **Linha 121**: sistema_externo     = p_sistema_externo,
- **Linha 122**: codigo_externo      = p_codigo_externo,
- **Linha 123**: atualizado_em       = NOW()
- **Linha 124**: WHERE id_pedido_item = p_id_pedido_item;
- **Linha 126** (Comentario): vinculo externo opcional (quando informado)
- **Linha 127**: Estrutura condicional de controle de fluxo.
- **Linha 128**: Insere um novo registro na tabela codigo_externo_vinculo.
- **Linha 129**: VALUES ('LAB', p_sistema_externo, p_codigo_externo, v_id_codigo, p_id_sessao_usuario, 'Protocolo LAB mapeado');
- **Linha 130**: Estrutura condicional de controle de fluxo.
- **Linha 132**: Insere um novo registro na tabela laboratorio_protocolo_evento.
- **Linha 133**: VALUES (v_id_proto, p_id_sessao_usuario, 'GERADO', NULL,
- **Linha 134**: JSON_OBJECT('id_pedido_item', p_id_pedido_item, 'codigo', v_codigo, 'barcode', v_barcode));
- **Linha 136**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 138**: atribuicao de valor Ã  variavel p_codigo.
- **Linha 139**: atribuicao de valor Ã  variavel p_barcode.
- **Linha 141**: COMMIT;
- **Linha 142**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
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
```

