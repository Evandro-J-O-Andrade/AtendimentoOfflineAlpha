# sp_paciente_cns_set

Objetivo: paciente cns set conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_paciente | BIGINT | IN | |
| p_cns | VARCHAR(20) | IN | |
| p_origem | VARCHAR(20) | IN | |
| p_validado | TINYINT | IN | |
| p_observacao | VARCHAR(255) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: paciente_cns, paciente_cns_evento
- UPDATE: paciente_cns
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CHAR_LENGTH
- CONCAT
- IFNULL
- JSON_OBJECT
- LAST_INSERT_ID
- NOW
- UPPER

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
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: main: BEGIN
- **Linha 10**: Declaracao de variavel local v_sqlstate.
- **Linha 11**: Declaracao de variavel local v_errno.
- **Linha 12**: Declaracao de variavel local v_msg.
- **Linha 14**: Declaracao de variavel local v_id.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: ROLLBACK;
- **Linha 20**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 21**: Invoca a procedure sp_raise.
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 26**: Invoca a procedure sp_assert_true.
- **Linha 28**: START TRANSACTION;
- **Linha 30**: UPDATE paciente_cns
- **Linha 31**: atribuicao de valor Ã  variavel status.
- **Linha 32**: atualizado_em = NOW()
- **Linha 33**: WHERE id_paciente = p_id_paciente
- **Linha 37**: Insere um novo registro na tabela paciente_cns.
- **Linha 38**: VALUES (
- **Linha 39**: p_id_paciente, p_cns, 'ATIVO',
- **Linha 40**: Estrutura condicional de controle de fluxo.
- **Linha 41**: CASE
- **Linha 42**: WHEN p_origem IS NULL THEN 'MANUAL'
- **Linha 43**: WHEN UPPER(p_origem) IN ('MANUAL','IMPORTADO','SUS','INTEGRACAO') THEN UPPER(p_origem)
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 45**: END,
- **Linha 46**: CASE WHEN IFNULL(p_validado,0)=1 THEN NOW() ELSE NULL END,
- **Linha 47**: p_observacao
- **Linha 48**: );
- **Linha 50**: atribuicao de valor Ã  variavel v_id.
- **Linha 52**: Insere um novo registro na tabela paciente_cns_evento.
- **Linha 53**: VALUES (v_id, p_id_sessao_usuario, 'CNS_SET', p_observacao, JSON_OBJECT('cns', p_cns, 'validado', IFNULL(p_validado,0)));
- **Linha 55**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 57**: COMMIT;
- **Linha 58**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_paciente_cns_set`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_paciente       BIGINT,
    IN p_cns               VARCHAR(20),
    IN p_origem            VARCHAR(20),
    IN p_validado          TINYINT,
    IN p_observacao        VARCHAR(255)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_paciente_cns_set', 'Falha ao set CNS');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_paciente_cns_set | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_paciente IS NOT NULL, 'PARAM', 'id_paciente é obrigatório.');
    CALL sp_assert_true(p_cns IS NOT NULL AND CHAR_LENGTH(p_cns) >= 10, 'PARAM', 'CNS inválido.');

    START TRANSACTION;

    UPDATE paciente_cns
       SET status = 'INATIVO',
           atualizado_em = NOW()
     WHERE id_paciente = p_id_paciente
       AND status = 'ATIVO'
       AND cns <> p_cns;

    INSERT INTO paciente_cns (id_paciente, cns, status, validado, origem, data_validacao, observacao)
    VALUES (
        p_id_paciente, p_cns, 'ATIVO',
        IFNULL(p_validado,0),
        CASE
            WHEN p_origem IS NULL THEN 'MANUAL'
            WHEN UPPER(p_origem) IN ('MANUAL','IMPORTADO','SUS','INTEGRACAO') THEN UPPER(p_origem)
            ELSE 'MANUAL'
        END,
        CASE WHEN IFNULL(p_validado,0)=1 THEN NOW() ELSE NULL END,
        p_observacao
    );

    SET v_id = LAST_INSERT_ID();

    INSERT INTO paciente_cns_evento (id_paciente_cns, id_sessao_usuario, evento, detalhe, payload_json)
    VALUES (v_id, p_id_sessao_usuario, 'CNS_SET', p_observacao, JSON_OBJECT('cns', p_cns, 'validado', IFNULL(p_validado,0)));

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CNS_SET', 'paciente_cns', v_id);

    COMMIT;
END ;;
```

