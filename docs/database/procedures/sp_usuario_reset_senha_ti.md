# sp_usuario_reset_senha_ti

Objetivo: usuario reset senha ti conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_usuario_alvo | BIGINT | IN | |
| p_motivo | VARCHAR(255) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: usuario
- INSERT: usuario_senha_historico
- UPDATE: usuario
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert
- sp_usuario_hash_gerar

## Functions Utilizadas
- CONCAT
- CURRENT_TIMESTAMP
- DATE_ADD
- IFNULL
- NOW
- ROW_COUNT

## Views Utilizadas
- v_hash_composto
- v_login
- v_sqlstate

## Eventos Gerados
- auditoria_evento
- evento
- historico

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
- **Linha 12**: Declaracao de variavel local v_login.
- **Linha 13**: Declaracao de variavel local v_hash_composto.
- **Linha 15**: Declaracao de variavel local EXIT.
- **Linha 16**: inicio do bloco de execucao.
- **Linha 17**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 18**: SET @diag_sqlstate = v_sqlstate;
- **Linha 19**: SET @diag_errno    = v_errno;
- **Linha 20**: SET @diag_msg      = v_msg;
- **Linha 21**: ROLLBACK;
- **Linha 22**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 23**: Invoca a procedure sp_raise.
- **Linha 24**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 25**: ' | MSG=',IFNULL(v_msg,'(n/a)'),
- **Linha 26**: ' | CTX=Falha ao resetar senha (TI)'));
- **Linha 27**: Fim do bloco da procedure.
- **Linha 29**: Invoca a procedure sp_sessao_assert.
- **Linha 30**: Invoca a procedure sp_assert_true.
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: FROM usuario u
- **Linha 34**: WHERE u.id_usuario = p_id_usuario_alvo
- **Linha 36**: LIMIT 1;
- **Linha 38**: Invoca a procedure sp_assert_true.
- **Linha 40**: START TRANSACTION;
- **Linha 42** (Comentario): default = login
- **Linha 43**: Invoca a procedure sp_usuario_hash_gerar.
- **Linha 44**: Invoca a procedure sp_assert_true.
- **Linha 46**: UPDATE usuario
- **Linha 47**: atribuicao de valor Ã  variavel senha_hash.
- **Linha 48**: primeiro_login = 1,
- **Linha 49**: forcar_troca_senha = 1,
- **Linha 50**: senha_expira_em = DATE_ADD(NOW(), INTERVAL 7 DAY), -- ajustável (7 dias p/ efetuar troca)
- **Linha 51**: updated_at = CURRENT_TIMESTAMP
- **Linha 52**: WHERE id_usuario = p_id_usuario_alvo;
- **Linha 54**: Invoca a procedure sp_assert_true.
- **Linha 56**: Insere um novo registro na tabela usuario_senha_historico.
- **Linha 57**: VALUES (p_id_usuario_alvo, v_hash_composto, 'RESET_TI', p_id_sessao_usuario, NOW());
- **Linha 59**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 60**: p_id_sessao_usuario,
- **Linha 61**: 'USUARIO',
- **Linha 62**: p_id_usuario_alvo,
- **Linha 63**: 'RESET_SENHA_TI',
- **Linha 64**: CONCAT('login=',v_login,' | default=%username% | motivo=',IFNULL(p_motivo,'(n/a)')),
- **Linha 65**: NULL,
- **Linha 66**: 'usuario',
- **Linha 67**: NULL
- **Linha 68**: );
- **Linha 70**: COMMIT;
- **Linha 71**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_reset_senha_ti`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_usuario_alvo   BIGINT,
    IN p_motivo            VARCHAR(255)
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_login VARCHAR(50);
    DECLARE v_hash_composto VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_usuario_reset_senha_ti', 'Falha ao resetar senha (TI)');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_usuario_reset_senha_ti | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao resetar senha (TI)'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_usuario_alvo IS NOT NULL, 'PARAM', 'id_usuario_alvo é obrigatório.');

    SELECT u.login INTO v_login
      FROM usuario u
     WHERE u.id_usuario = p_id_usuario_alvo
       AND u.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_login IS NOT NULL, 'NOT_FOUND', 'Usuário alvo não encontrado/ativo.');

    START TRANSACTION;

    -- default = login
    CALL sp_usuario_hash_gerar(v_login, 12000, v_hash_composto);
    CALL sp_assert_true(v_hash_composto IS NOT NULL, 'SEC', 'Falha ao gerar hash de senha default.');

    UPDATE usuario
       SET senha_hash = v_hash_composto,
           primeiro_login = 1,
           forcar_troca_senha = 1,
           senha_expira_em = DATE_ADD(NOW(), INTERVAL 7 DAY), -- ajustável (7 dias p/ efetuar troca)
           updated_at = CURRENT_TIMESTAMP
     WHERE id_usuario = p_id_usuario_alvo;

    CALL sp_assert_true(ROW_COUNT() = 1, 'NOT_FOUND', 'Usuário alvo não atualizado.');

    INSERT INTO usuario_senha_historico(id_usuario, hash_composto, motivo, id_sessao_usuario, criado_em)
    VALUES (p_id_usuario_alvo, v_hash_composto, 'RESET_TI', p_id_sessao_usuario, NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'USUARIO',
        p_id_usuario_alvo,
        'RESET_SENHA_TI',
        CONCAT('login=',v_login,' | default=%username% | motivo=',IFNULL(p_motivo,'(n/a)')),
        NULL,
        'usuario',
        NULL
    );

    COMMIT;
END ;;
```

