# sp_procedimento_protocolo_criar

Objetivo: procedimento protocolo criar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |
| p_tipo | ENUM('EXAME','RX') | IN | |
| p_id_protocolo | BIGINT | OUT | |
| p_codigo | VARCHAR(50) | OUT | |
| p_barcode | VARCHAR(50) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fila_operacional, procedimento_protocolo, sessao_usuario
- INSERT: procedimento_protocolo, procedimento_protocolo_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_protocolo_emitir
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- DATE_FORMAT
- IF
- IFNULL
- LAST_INSERT_ID
- NOW

## Views Utilizadas
- v_chave
- v_sqlstate

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
- **Linha 14**: Declaracao de variavel local v_id_ffa.
- **Linha 15**: Declaracao de variavel local v_id_usuario.
- **Linha 16**: Declaracao de variavel local v_exist.
- **Linha 17**: Declaracao de variavel local v_chave.
- **Linha 19**: Declaracao de variavel local EXIT.
- **Linha 20**: inicio do bloco de execucao.
- **Linha 21**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 22**: ROLLBACK;
- **Linha 23**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 24**: Invoca a procedure sp_raise.
- **Linha 25**: CONCAT('ROTINA=sp_procedimento_protocolo_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 26**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 27**: ' | MSG=',IFNULL(v_msg,'(n/a)')));
- **Linha 28**: Fim do bloco da procedure.
- **Linha 30**: atribuicao de valor Ã  variavel p_id_protocolo.
- **Linha 31**: atribuicao de valor Ã  variavel p_codigo.
- **Linha 32**: atribuicao de valor Ã  variavel p_barcode.
- **Linha 34**: Invoca a procedure sp_sessao_assert.
- **Linha 35**: Invoca a procedure sp_assert_true.
- **Linha 37**: START TRANSACTION;
- **Linha 39**: execucao de query SELECT para consulta de dados.
- **Linha 40**: FROM fila_operacional fo
- **Linha 41**: WHERE fo.id_fila = p_id_fila
- **Linha 42**: LIMIT 1;
- **Linha 44**: Invoca a procedure sp_assert_true.
- **Linha 46**: execucao de query SELECT para consulta de dados.
- **Linha 47**: FROM sessao_usuario su
- **Linha 48**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 50**: LIMIT 1;
- **Linha 52** (Comentario): já existe?
- **Linha 53**: execucao de query SELECT para consulta de dados.
- **Linha 54**: FROM procedimento_protocolo pp
- **Linha 55**: WHERE pp.id_fila = p_id_fila
- **Linha 57**: LIMIT 1;
- **Linha 59**: Estrutura condicional de controle de fluxo.
- **Linha 60**: execucao de query SELECT para consulta de dados.
- **Linha 61**: INTO p_id_protocolo, p_codigo, p_barcode
- **Linha 62**: FROM procedimento_protocolo pp
- **Linha 63**: WHERE pp.id_protocolo = v_exist
- **Linha 64**: LIMIT 1;
- **Linha 65**: COMMIT;
- **Linha 66**: Estrutura de repeticao/controle de loop.
- **Linha 67**: Estrutura condicional de controle de fluxo.
- **Linha 69**: atribuicao de valor Ã  variavel v_chave.
- **Linha 71** (Comentario): usa o mesmo emissor (vai registrar em protocolo_emissao)
- **Linha 72**: Invoca a procedure sp_protocolo_emitir.
- **Linha 73**: p_id_sessao_usuario,
- **Linha 74**: p_tipo,
- **Linha 75**: v_chave,
- **Linha 76**: CURDATE(),
- **Linha 77**: NULL,
- **Linha 78**: v_id_ffa,
- **Linha 79**: NULL,
- **Linha 80**: p_codigo
- **Linha 81**: );
- **Linha 83** (Comentario): barcode: por padrão igual ao código (Code128 no front)
- **Linha 84**: atribuicao de valor Ã  variavel p_barcode.
- **Linha 86**: Insere um novo registro na tabela procedimento_protocolo.
- **Linha 87**: VALUES (p_tipo, p_codigo, p_barcode, 'CRIADO', v_id_ffa, p_id_fila, p_id_sessao_usuario, v_id_usuario, NOW(), NOW());
- **Linha 89**: atribuicao de valor Ã  variavel p_id_protocolo.
- **Linha 91**: Insere um novo registro na tabela procedimento_protocolo_evento.
- **Linha 92**: VALUES (p_id_protocolo, 'PROTOCOLO_CRIADO', CONCAT('Tipo=',p_tipo,' | Código=',p_codigo), NOW(), p_id_sessao_usuario, v_id_usuario);
- **Linha 94**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 95**: p_id_sessao_usuario,
- **Linha 96**: 'procedimento_protocolo',
- **Linha 97**: p_id_protocolo,
- **Linha 98**: 'PROTOCOLO_CRIADO',
- **Linha 99**: CONCAT('Fila=',p_id_fila,' | Tipo=',p_tipo,' | Código=',p_codigo),
- **Linha 100**: NULL,
- **Linha 101**: 'procedimento_protocolo',
- **Linha 102**: v_id_usuario
- **Linha 103**: );
- **Linha 105**: COMMIT;
- **Linha 106**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_procedimento_protocolo_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_fila           BIGINT,
    IN  p_tipo              ENUM('EXAME','RX'),
    OUT p_id_protocolo      BIGINT,
    OUT p_codigo            VARCHAR(50),
    OUT p_barcode           VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_ffa BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_exist BIGINT;
    DECLARE v_chave VARCHAR(80);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_procedimento_protocolo_criar', 'Falha ao criar protocolo procedimento');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_procedimento_protocolo_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_protocolo = NULL;
    SET p_codigo = NULL;
    SET p_barcode = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    START TRANSACTION;

    SELECT fo.id_ffa INTO v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1;

    CALL sp_assert_true(v_id_ffa IS NOT NULL, 'FILA', 'Fila operacional não encontrada.');

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    -- já existe?
    SELECT pp.id_protocolo INTO v_exist
      FROM procedimento_protocolo pp
     WHERE pp.id_fila = p_id_fila
       AND pp.tipo = p_tipo
     LIMIT 1;

    IF v_exist IS NOT NULL THEN
        SELECT pp.id_protocolo, pp.codigo, pp.barcode
          INTO p_id_protocolo, p_codigo, p_barcode
          FROM procedimento_protocolo pp
         WHERE pp.id_protocolo = v_exist
         LIMIT 1;
        COMMIT;
        LEAVE main;
    END IF;

    SET v_chave = CONCAT(p_tipo,'-', DATE_FORMAT(CURDATE(), '%Y%m%d'));

    -- usa o mesmo emissor (vai registrar em protocolo_emissao)
    CALL sp_protocolo_emitir(
        p_id_sessao_usuario,
        p_tipo,
        v_chave,
        CURDATE(),
        NULL,
        v_id_ffa,
        NULL,
        p_codigo
    );

    -- barcode: por padrão igual ao código (Code128 no front)
    SET p_barcode = p_codigo;

    INSERT INTO procedimento_protocolo(tipo, codigo, barcode, status, id_ffa, id_fila, id_sessao_criacao, id_usuario_criacao, criado_em, atualizado_em)
    VALUES (p_tipo, p_codigo, p_barcode, 'CRIADO', v_id_ffa, p_id_fila, p_id_sessao_usuario, v_id_usuario, NOW(), NOW());

    SET p_id_protocolo = LAST_INSERT_ID();

    INSERT INTO procedimento_protocolo_evento(id_protocolo, tipo_evento, detalhe, criado_em, id_sessao_usuario, id_usuario)
    VALUES (p_id_protocolo, 'PROTOCOLO_CRIADO', CONCAT('Tipo=',p_tipo,' | Código=',p_codigo), NOW(), p_id_sessao_usuario, v_id_usuario);

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'procedimento_protocolo',
        p_id_protocolo,
        'PROTOCOLO_CRIADO',
        CONCAT('Fila=',p_id_fila,' | Tipo=',p_tipo,' | Código=',p_codigo),
        NULL,
        'procedimento_protocolo',
        v_id_usuario
    );

    COMMIT;
END ;;
```

