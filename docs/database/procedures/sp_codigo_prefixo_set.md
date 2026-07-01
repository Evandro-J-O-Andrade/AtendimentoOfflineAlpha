# sp_codigo_prefixo_set

Objetivo: codigo prefixo set conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_dominio | ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | IN | |
| p_prefixo_5 | CHAR(5) | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_id_laboratorio | BIGINT | IN | |
| p_ativo | TINYINT | IN | |
| p_observacao | VARCHAR(255) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: codigo_prefixo_config
- UPDATE: (nenhuma)
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
- CURRENT_TIMESTAMP
- IFNULL
- JSON_OBJECT

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
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 19**: ROLLBACK;
- **Linha 20**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 21**: Invoca a procedure sp_raise.
- **Linha 22**: Fim do bloco da procedure.
- **Linha 24**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 27**: START TRANSACTION;
- **Linha 29**: Insere um novo registro na tabela codigo_prefixo_config.
- **Linha 30**: VALUES(p_dominio,p_prefixo_5,p_id_unidade,p_id_local_operacional,p_id_laboratorio,IFNULL(p_ativo,1),p_observacao)
- **Linha 31**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 32**: ativo = VALUES(ativo),
- **Linha 33**: observacao = VALUES(observacao),
- **Linha 34**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 36**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 37**: 'dominio', p_dominio,
- **Linha 38**: 'prefixo_5', p_prefixo_5,
- **Linha 39**: 'id_unidade', p_id_unidade,
- **Linha 40**: 'id_local_operacional', p_id_local_operacional,
- **Linha 41**: 'id_laboratorio', p_id_laboratorio,
- **Linha 42**: 'ativo', IFNULL(p_ativo,1)
- **Linha 43**: ));
- **Linha 45**: COMMIT;
- **Linha 46**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_prefixo_set`(
    IN p_id_sessao_usuario BIGINT,
    IN p_dominio ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO'),
    IN p_prefixo_5 CHAR(5),
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_laboratorio BIGINT,
    IN p_ativo TINYINT,
    IN p_observacao VARCHAR(255)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_prefixo_set', 'Falha ao setar prefixo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_prefixo_set | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_prefixo_5 IS NOT NULL AND CHAR_LENGTH(p_prefixo_5)=5, 'PARAM', 'prefixo_5 deve ter 5 caracteres.');

    START TRANSACTION;

    INSERT INTO codigo_prefixo_config(dominio,prefixo_5,id_unidade,id_local_operacional,id_laboratorio,ativo,observacao)
    VALUES(p_dominio,p_prefixo_5,p_id_unidade,p_id_local_operacional,p_id_laboratorio,IFNULL(p_ativo,1),p_observacao)
    ON DUPLICATE KEY UPDATE
      ativo = VALUES(ativo),
      observacao = VALUES(observacao),
      atualizado_em = CURRENT_TIMESTAMP;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_PREFIXO_SET', JSON_OBJECT(
      'dominio', p_dominio,
      'prefixo_5', p_prefixo_5,
      'id_unidade', p_id_unidade,
      'id_local_operacional', p_id_local_operacional,
      'id_laboratorio', p_id_laboratorio,
      'ativo', IFNULL(p_ativo,1)
    ));

    COMMIT;
END ;;
```

