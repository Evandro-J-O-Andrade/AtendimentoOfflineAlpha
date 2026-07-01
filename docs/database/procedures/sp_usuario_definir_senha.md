# sp_usuario_definir_senha

Objetivo: usuario definir senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_usuario_alvo | BIGINT | IN | |
| p_nova_senha | VARCHAR(255) | IN | |

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
- IFNULL
- LENGTH
- LOWER
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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: main: BEGIN
- **Linha 9**: Declaracao de variavel local v_sqlstate.
- **Linha 10**: Declaracao de variavel local v_errno.
- **Linha 11**: Declaracao de variavel local v_msg.
- **Linha 13**: Declaracao de variavel local v_login.
- **Linha 14**: Declaracao de variavel local v_hash_composto.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: SET @diag_sqlstate = v_sqlstate;
- **Linha 20**: SET @diag_errno    = v_errno;
- **Linha 21**: SET @diag_msg      = v_msg;
- **Linha 22**: ROLLBACK;
- **Linha 23**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 24**: Invoca a procedure sp_raise.
- **Linha 25**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 26**: ' | MSG=',IFNULL(v_msg,'(n/a)'),
- **Linha 27**: ' | CTX=Falha ao definir senha (TI)'));
- **Linha 28**: Fim do bloco da procedure.
- **Linha 30**: Invoca a procedure sp_sessao_assert.
- **Linha 31**: Invoca a procedure sp_assert_true.
- **Linha 32**: Invoca a procedure sp_assert_true.
- **Linha 34**: execucao de query SELECT para consulta de dados.
- **Linha 35**: FROM usuario u
- **Linha 36**: WHERE u.id_usuario = p_id_usuario_alvo
- **Linha 38**: LIMIT 1;
- **Linha 40**: Invoca a procedure sp_assert_true.
- **Linha 42** (Comentario): regra: não permitir senha = login em definição manual (só em reset TI)
- **Linha 43**: Invoca a procedure sp_assert_true.
- **Linha 45**: START TRANSACTION;
- **Linha 47**: Invoca a procedure sp_usuario_hash_gerar.
- **Linha 48**: Invoca a procedure sp_assert_true.
- **Linha 50**: UPDATE usuario
- **Linha 51**: atribuicao de valor Ã  variavel senha_hash.
- **Linha 52**: primeiro_login = 0,
- **Linha 53**: forcar_troca_senha = 0,
- **Linha 54**: senha_expira_em = NULL,
- **Linha 55**: updated_at = CURRENT_TIMESTAMP
- **Linha 56**: WHERE id_usuario = p_id_usuario_alvo;
- **Linha 58**: Invoca a procedure sp_assert_true.
- **Linha 60**: Insere um novo registro na tabela usuario_senha_historico.
- **Linha 61**: VALUES (p_id_usuario_alvo, v_hash_composto, 'CRIACAO', p_id_sessao_usuario, NOW());
- **Linha 63**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 64**: p_id_sessao_usuario,
- **Linha 65**: 'USUARIO',
- **Linha 66**: p_id_usuario_alvo,
- **Linha 67**: 'DEFINIR_SENHA_TI',
- **Linha 68**: CONCAT('login=',v_login,' | motivo=',IFNULL(p_motivo,'(n/a)')),
- **Linha 69**: NULL,
- **Linha 70**: 'usuario',
- **Linha 71**: NULL
- **Linha 72**: );
- **Linha 74**: COMMIT;
- **Linha 75**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_definir_senha`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_usuario_alvo   BIGINT,
    IN  p_nova_senha        VARCHAR(255),
    IN  p_motivo            VARCHAR(255)  -- texto livre para auditoria
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
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_usuario_definir_senha', 'Falha ao definir senha (TI)');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_usuario_definir_senha | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                                         ' | ERRNO=',IFNULL(v_errno,0),
                                         ' | MSG=',IFNULL(v_msg,'(n/a)'),
                                         ' | CTX=Falha ao definir senha (TI)'));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_usuario_alvo IS NOT NULL, 'PARAM', 'id_usuario_alvo é obrigatório.');
    CALL sp_assert_true(p_nova_senha IS NOT NULL AND LENGTH(p_nova_senha) >= 8, 'PARAM', 'Senha deve ter pelo menos 8 caracteres.');

    SELECT u.login INTO v_login
      FROM usuario u
     WHERE u.id_usuario = p_id_usuario_alvo
       AND u.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_login IS NOT NULL, 'NOT_FOUND', 'Usuário alvo não encontrado/ativo.');

    -- regra: não permitir senha = login em definição manual (só em reset TI)
    CALL sp_assert_true(LOWER(p_nova_senha) <> LOWER(v_login), 'SEC', 'Senha não pode ser igual ao login (use reset TI para default).');

    START TRANSACTION;

    CALL sp_usuario_hash_gerar(p_nova_senha, 12000, v_hash_composto);
    CALL sp_assert_true(v_hash_composto IS NOT NULL, 'SEC', 'Falha ao gerar hash de senha.');

    UPDATE usuario
       SET senha_hash = v_hash_composto,
           primeiro_login = 0,
           forcar_troca_senha = 0,
           senha_expira_em = NULL,
           updated_at = CURRENT_TIMESTAMP
     WHERE id_usuario = p_id_usuario_alvo;

    CALL sp_assert_true(ROW_COUNT() = 1, 'NOT_FOUND', 'Usuário alvo não atualizado.');

    INSERT INTO usuario_senha_historico(id_usuario, hash_composto, motivo, id_sessao_usuario, criado_em)
    VALUES (p_id_usuario_alvo, v_hash_composto, 'CRIACAO', p_id_sessao_usuario, NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'USUARIO',
        p_id_usuario_alvo,
        'DEFINIR_SENHA_TI',
        CONCAT('login=',v_login,' | motivo=',IFNULL(p_motivo,'(n/a)')),
        NULL,
        'usuario',
        NULL
    );

    COMMIT;
END ;;
```

