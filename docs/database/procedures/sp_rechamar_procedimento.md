# sp_rechamar_procedimento

Objetivo: rechamar procedimento conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_protocolo | BIGINT | IN | |
| p_motivo | VARCHAR(255) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: procedimento_protocolo_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- COALESCE
- CONCAT
- IFNULL
- NOW

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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: main: BEGIN
- **Linha 7**: Declaracao de variavel local v_sqlstate.
- **Linha 8**: Declaracao de variavel local v_errno.
- **Linha 9**: Declaracao de variavel local v_msg.
- **Linha 11**: Declaracao de variavel local v_id_usuario.
- **Linha 13**: Declaracao de variavel local EXIT.
- **Linha 14**: inicio do bloco de execucao.
- **Linha 15**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 16**: ROLLBACK;
- **Linha 17**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 18**: Invoca a procedure sp_raise.
- **Linha 19**: CONCAT('ROTINA=sp_rechamar_procedimento | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 20**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 21**: ' | MSG=',IFNULL(v_msg,'(n/a)')));
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 27**: START TRANSACTION;
- **Linha 29**: execucao de query SELECT para consulta de dados.
- **Linha 30**: FROM sessao_usuario su
- **Linha 31**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 33**: LIMIT 1;
- **Linha 35**: Insere um novo registro na tabela procedimento_protocolo_evento.
- **Linha 36**: VALUES (p_id_protocolo, 'RECHAMADA', COALESCE(p_motivo,'(sem motivo)'), NOW(), p_id_sessao_usuario, v_id_usuario);
- **Linha 38**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 39**: p_id_sessao_usuario,
- **Linha 40**: 'procedimento_protocolo',
- **Linha 41**: p_id_protocolo,
- **Linha 42**: 'RECHAMADA',
- **Linha 43**: CONCAT('Rechamada | Motivo=',COALESCE(p_motivo,'(n/a)')),
- **Linha 44**: NULL,
- **Linha 45**: 'procedimento_protocolo',
- **Linha 46**: v_id_usuario
- **Linha 47**: );
- **Linha 49**: COMMIT;
- **Linha 50**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_rechamar_procedimento`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_protocolo      BIGINT,
    IN p_motivo            VARCHAR(255)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_id_usuario BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_rechamar_procedimento', 'Falha ao rechamar procedimento');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_rechamar_procedimento | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_protocolo IS NOT NULL, 'PARAM', 'id_protocolo é obrigatório.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    INSERT INTO procedimento_protocolo_evento(id_protocolo, tipo_evento, detalhe, criado_em, id_sessao_usuario, id_usuario)
    VALUES (p_id_protocolo, 'RECHAMADA', COALESCE(p_motivo,'(sem motivo)'), NOW(), p_id_sessao_usuario, v_id_usuario);

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'procedimento_protocolo',
        p_id_protocolo,
        'RECHAMADA',
        CONCAT('Rechamada | Motivo=',COALESCE(p_motivo,'(n/a)')),
        NULL,
        'procedimento_protocolo',
        v_id_usuario
    );

    COMMIT;
END ;;
```

