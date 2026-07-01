# sp_pedido_medico_criar

Objetivo: pedido medico criar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_usuario_solicitante | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_id_pedido_medico | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: ffa
- INSERT: pedido_medico
- UPDATE: (nenhuma)
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
- LAST_INSERT_ID

## Views Utilizadas
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
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: main: BEGIN
- **Linha 9**: Declaracao de variavel local v_sqlstate.
- **Linha 10**: Declaracao de variavel local v_errno.
- **Linha 11**: Declaracao de variavel local v_msg.
- **Linha 12**: Declaracao de variavel local v_id_gpat.
- **Linha 14**: Declaracao de variavel local EXIT.
- **Linha 15**: inicio do bloco de execucao.
- **Linha 16**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 17**: ROLLBACK;
- **Linha 18**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 19**: Invoca a procedure sp_raise.
- **Linha 20**: Fim do bloco da procedure.
- **Linha 22**: atribuicao de valor Ã  variavel p_id_pedido_medico.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 26**: Invoca a procedure sp_assert_true.
- **Linha 28**: START TRANSACTION;
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: FROM ffa f
- **Linha 32**: WHERE f.id = p_id_ffa
- **Linha 33**: LIMIT 1;
- **Linha 35**: Invoca a procedure sp_assert_true.
- **Linha 37**: Insere um novo registro na tabela pedido_medico.
- **Linha 38**: VALUES (p_id_ffa, v_id_gpat, p_id_usuario_solicitante, p_id_local_operacional, 'ABERTO');
- **Linha 40**: atribuicao de valor Ã  variavel p_id_pedido_medico.
- **Linha 42**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 44**: COMMIT;
- **Linha 45**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pedido_medico_criar`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_ffa            BIGINT, -- referencia ffa.id
    IN  p_id_usuario_solicitante BIGINT,
    IN  p_id_local_operacional BIGINT,
    OUT p_id_pedido_medico  BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;
    DECLARE v_id_gpat BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_pedido_medico_criar', 'Falha ao criar pedido médico');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_pedido_medico_criar | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_pedido_medico = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa (ffa.id) é obrigatório.');
    CALL sp_assert_true(p_id_usuario_solicitante IS NOT NULL, 'PARAM', 'id_usuario_solicitante é obrigatório.');

    START TRANSACTION;

    SELECT f.id_gpat INTO v_id_gpat
      FROM ffa f
     WHERE f.id = p_id_ffa
     LIMIT 1;

    CALL sp_assert_true(v_id_gpat IS NOT NULL, 'GPAT', 'FFA sem GPAT. Gere GPAT antes de criar pedido.');

    INSERT INTO pedido_medico (id_ffa, id_gpat, id_usuario_solicitante, id_local_operacional, status)
    VALUES (p_id_ffa, v_id_gpat, p_id_usuario_solicitante, p_id_local_operacional, 'ABERTO');

    SET p_id_pedido_medico = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PEDIDO_MEDICO_CRIADO', 'pedido_medico', p_id_pedido_medico);

    COMMIT;
END ;;
```

