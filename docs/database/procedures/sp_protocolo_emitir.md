# sp_protocolo_emitir

Objetivo: protocolo emitir conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_tipo | VARCHAR(30) | IN | |
| p_chave | VARCHAR(80) | IN | |
| p_data_ref | DATE | IN | |
| p_id_paciente | BIGINT | IN | |
| p_id_ffa | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_codigo | VARCHAR(50) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: protocolo_emissao
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sequencia_proximo_numero
- sp_sessao_assert

## Functions Utilizadas
- COALESCE
- CONCAT
- DATE_FORMAT
- IF
- IFNULL
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
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: main: BEGIN
- **Linha 12**: Declaracao de variavel local v_sqlstate.
- **Linha 13**: Declaracao de variavel local v_errno.
- **Linha 14**: Declaracao de variavel local v_msg.
- **Linha 16**: Declaracao de variavel local v_num.
- **Linha 17**: Declaracao de variavel local v_ano.
- **Linha 18**: Declaracao de variavel local v_id_usuario.
- **Linha 20**: Declaracao de variavel local EXIT.
- **Linha 21**: inicio do bloco de execucao.
- **Linha 22**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 23**: ROLLBACK;
- **Linha 24**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 25**: Invoca a procedure sp_raise.
- **Linha 26**: CONCAT('ROTINA=sp_protocolo_emitir | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 27**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 28**: ' | MSG=',IFNULL(v_msg,'(n/a)')));
- **Linha 29**: Fim do bloco da procedure.
- **Linha 31**: atribuicao de valor Ã  variavel p_codigo.
- **Linha 32**: Invoca a procedure sp_sessao_assert.
- **Linha 33**: Invoca a procedure sp_assert_true.
- **Linha 34**: Invoca a procedure sp_assert_true.
- **Linha 36**: START TRANSACTION;
- **Linha 38**: execucao de query SELECT para consulta de dados.
- **Linha 39**: FROM sessao_usuario su
- **Linha 40**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 42**: LIMIT 1;
- **Linha 44**: atribuicao de valor Ã  variavel v_ano.
- **Linha 46** (Comentario): sequência
- **Linha 47**: Invoca a procedure sp_sequencia_proximo_numero.
- **Linha 49** (Comentario): formato padrão vendável: TIPO-AAAAMMDD-000001 (quando data_ref informada) senão TIPO-ANO-000001
- **Linha 50**: Estrutura condicional de controle de fluxo.
- **Linha 51**: atribuicao de valor Ã  variavel p_codigo.
- **Linha 52**: Estrutura condicional de controle de fluxo.
- **Linha 53**: atribuicao de valor Ã  variavel p_codigo.
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 56**: Insere um novo registro na tabela protocolo_emissao.
- **Linha 57**: (tipo, chave, codigo, ano, data_ref, id_sessao_usuario, id_usuario, id_paciente, id_ffa, id_senha, criado_em)
- **Linha 58**: VALUES
- **Linha 59**: (UPPER(p_tipo), p_chave, p_codigo, v_ano, p_data_ref, p_id_sessao_usuario, v_id_usuario, p_id_paciente, p_id_ffa, p_id_senha, NOW());
- **Linha 61**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 62**: p_id_sessao_usuario,
- **Linha 63**: 'protocolo_emissao',
- **Linha 64**: LAST_INSERT_ID(),
- **Linha 65**: 'PROTOCOLO_EMITIDO',
- **Linha 66**: CONCAT('Tipo=',UPPER(p_tipo),' | Código=',p_codigo,' | Chave=',p_chave),
- **Linha 67**: NULL,
- **Linha 68**: 'protocolo_emissao',
- **Linha 69**: v_id_usuario
- **Linha 70**: );
- **Linha 72**: COMMIT;
- **Linha 73**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_protocolo_emitir`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_tipo              VARCHAR(30),
    IN  p_chave             VARCHAR(80),
    IN  p_data_ref          DATE,
    IN  p_id_paciente       BIGINT,
    IN  p_id_ffa            BIGINT,
    IN  p_id_senha          BIGINT,
    OUT p_codigo            VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_num      INT;
    DECLARE v_ano      INT;
    DECLARE v_id_usuario BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_protocolo_emitir', 'Falha na emissão de protocolo');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_protocolo_emitir | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_codigo = NULL;
    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_tipo IS NOT NULL AND p_tipo <> '', 'PARAM', 'tipo é obrigatório.');
    CALL sp_assert_true(p_chave IS NOT NULL AND p_chave <> '', 'PARAM', 'chave é obrigatória.');

    START TRANSACTION;

    SELECT su.id_usuario INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    SET v_ano = YEAR(COALESCE(p_data_ref, CURDATE()));

    -- sequência
    CALL sp_sequencia_proximo_numero(p_chave, v_num);

    -- formato padrão vendável: TIPO-AAAAMMDD-000001 (quando data_ref informada) senão TIPO-ANO-000001
    IF p_data_ref IS NOT NULL THEN
        SET p_codigo = CONCAT(UPPER(p_tipo), '-', DATE_FORMAT(p_data_ref, '%Y%m%d'), '-', LPAD(v_num, 6, '0'));
    ELSE
        SET p_codigo = CONCAT(UPPER(p_tipo), '-', v_ano, '-', LPAD(v_num, 6, '0'));
    END IF;

    INSERT INTO protocolo_emissao
        (tipo, chave, codigo, ano, data_ref, id_sessao_usuario, id_usuario, id_paciente, id_ffa, id_senha, criado_em)
    VALUES
        (UPPER(p_tipo), p_chave, p_codigo, v_ano, p_data_ref, p_id_sessao_usuario, v_id_usuario, p_id_paciente, p_id_ffa, p_id_senha, NOW());

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'protocolo_emissao',
        LAST_INSERT_ID(),
        'PROTOCOLO_EMITIDO',
        CONCAT('Tipo=',UPPER(p_tipo),' | Código=',p_codigo,' | Chave=',p_chave),
        NULL,
        'protocolo_emissao',
        v_id_usuario
    );

    COMMIT;
END ;;
```

