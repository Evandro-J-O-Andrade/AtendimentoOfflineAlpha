# sp_medicacao_complementar

Objetivo: medicacao complementar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |
| p_texto | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fila_operacional
- INSERT: fila_operacional_evento
- UPDATE: fila_operacional
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IFNULL
- NOW

## Views Utilizadas
- v_sqlstate
- v_tipo

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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: main: BEGIN
- **Linha 8**: Declaracao de variavel local v_sqlstate.
- **Linha 9**: Declaracao de variavel local v_errno.
- **Linha 10**: Declaracao de variavel local v_msg.
- **Linha 12**: Declaracao de variavel local v_tipo.
- **Linha 13**: Declaracao de variavel local v_id_ffa.
- **Linha 15**: Declaracao de variavel local EXIT.
- **Linha 16**: inicio do bloco de execucao.
- **Linha 17**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 18**: ROLLBACK;
- **Linha 19**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 20**: Invoca a procedure sp_raise.
- **Linha 21**: 'ROTINA=sp_medicacao_complementar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 22**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 23**: ' | MSG=', IFNULL(v_msg,'(n/a)')
- **Linha 24**: ));
- **Linha 25**: Fim do bloco da procedure.
- **Linha 27**: Invoca a procedure sp_sessao_assert.
- **Linha 28**: START TRANSACTION;
- **Linha 30**: Invoca a procedure sp_assert_true.
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: INTO v_tipo, v_id_ffa
- **Linha 34**: FROM fila_operacional fo
- **Linha 35**: WHERE fo.id_fila = p_id_fila
- **Linha 36**: LIMIT 1
- **Linha 37**: FOR UPDATE;
- **Linha 39**: Invoca a procedure sp_assert_true.
- **Linha 40**: Invoca a procedure sp_assert_true.
- **Linha 42**: UPDATE fila_operacional
- **Linha 43**: atribuicao de valor Ã  variavel observacao.
- **Linha 44**: WHEN p_texto IS NULL OR p_texto = '' THEN observacao
- **Linha 45**: WHEN observacao IS NULL OR observacao = '' THEN p_texto
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 47**: END
- **Linha 48**: WHERE id_fila = p_id_fila;
- **Linha 50**: Insere um novo registro na tabela fila_operacional_evento.
- **Linha 51**: VALUES (p_id_fila, p_id_sessao_usuario, 'COMPLEMENTAR', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());
- **Linha 53**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 54**: p_id_sessao_usuario,
- **Linha 55**: 'FILA_OPERACIONAL',
- **Linha 56**: p_id_fila,
- **Linha 57**: 'COMPLEMENTAR',
- **Linha 58**: CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
- **Linha 59**: NULL,
- **Linha 60**: 'fila_operacional',
- **Linha 61**: NULL
- **Linha 62**: );
- **Linha 64**: COMMIT;
- **Linha 65**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medicacao_complementar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_texto             TEXT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_tipo VARCHAR(20);
    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_medicacao_complementar', 'Falha na rotina');
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_medicacao_complementar | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=', IFNULL(v_errno,0),
            ' | MSG=', IFNULL(v_msg,'(n/a)')
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    START TRANSACTION;

    CALL sp_assert_true(p_id_fila IS NOT NULL, 'PARAM', 'id_fila é obrigatório.');

    SELECT fo.tipo, fo.id_ffa
      INTO v_tipo, v_id_ffa
      FROM fila_operacional fo
     WHERE fo.id_fila = p_id_fila
     LIMIT 1
     FOR UPDATE;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NAO_ENCONTRADO', 'Fila não encontrada.');
    CALL sp_assert_true(v_tipo = 'MEDICACAO', 'REGRA', 'Fila informada não é MEDICACAO.');

    UPDATE fila_operacional
       SET observacao = CASE
                          WHEN p_texto IS NULL OR p_texto = '' THEN observacao
                          WHEN observacao IS NULL OR observacao = '' THEN p_texto
                          ELSE CONCAT(observacao, '\n', p_texto)
                        END
     WHERE id_fila = p_id_fila;

    INSERT INTO fila_operacional_evento(id_fila, id_sessao_usuario, tipo_evento, detalhe, criado_em)
    VALUES (p_id_fila, p_id_sessao_usuario, 'COMPLEMENTAR', CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa), NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FILA_OPERACIONAL',
        p_id_fila,
        'COMPLEMENTAR',
        CONCAT('setor=MEDICACAO | id_ffa=', v_id_ffa),
        NULL,
        'fila_operacional',
        NULL
    );

    COMMIT;
END ;;
```

