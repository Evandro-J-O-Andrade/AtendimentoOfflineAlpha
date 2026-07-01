# sp_laboratorio_protocolo_evento_add

Objetivo: laboratorio protocolo evento add conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_laboratorio_protocolo | BIGINT | IN | |
| p_evento | VARCHAR(40) | IN | |
| p_detalhe | VARCHAR(255) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: laboratorio_protocolo_evento
- UPDATE: laboratorio_protocolo
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
- IF
- IFNULL
- NOW
- UPPER

## Views Utilizadas
- v_sqlstate
- v_status

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
- **Linha 13**: Declaracao de variavel local v_status.
- **Linha 15**: Declaracao de variavel local EXIT.
- **Linha 16**: inicio do bloco de execucao.
- **Linha 17**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 18**: ROLLBACK;
- **Linha 19**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 20**: Invoca a procedure sp_raise.
- **Linha 21**: Fim do bloco da procedure.
- **Linha 23**: Invoca a procedure sp_sessao_assert.
- **Linha 24**: Invoca a procedure sp_assert_true.
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 27**: START TRANSACTION;
- **Linha 29**: Insere um novo registro na tabela laboratorio_protocolo_evento.
- **Linha 30**: VALUES (p_id_laboratorio_protocolo, p_id_sessao_usuario, UPPER(p_evento), p_detalhe, p_payload);
- **Linha 32**: atribuicao de valor Ã  variavel v_status.
- **Linha 33**: atribuicao de valor Ã  variavel v_status.
- **Linha 34**: WHEN 'GERADO'   THEN 'GERADO'
- **Linha 35**: WHEN 'COLETADO' THEN 'COLETADO'
- **Linha 36**: WHEN 'ENVIADO'  THEN 'ENVIADO'
- **Linha 37**: WHEN 'RECEBIDO' THEN 'RECEBIDO'
- **Linha 38**: WHEN 'RESULTADO'THEN 'RESULTADO'
- **Linha 39**: WHEN 'CANCELADO'THEN 'CANCELADO'
- **Linha 40**: Estrutura condicional de controle de fluxo.
- **Linha 41**: Fim do bloco da procedure.
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 44**: UPDATE laboratorio_protocolo
- **Linha 45**: atribuicao de valor Ã  variavel status.
- **Linha 46**: atualizado_em = NOW()
- **Linha 47**: WHERE id_laboratorio_protocolo = p_id_laboratorio_protocolo;
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 50**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 52**: COMMIT;
- **Linha 53**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_laboratorio_protocolo_evento_add`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_laboratorio_protocolo BIGINT,
    IN p_evento VARCHAR(40),
    IN p_detalhe VARCHAR(255),
    IN p_payload JSON
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_status VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_laboratorio_protocolo_evento_add', 'Falha ao registrar evento LAB');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_laboratorio_protocolo_evento_add | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_laboratorio_protocolo IS NOT NULL, 'PARAM', 'id_laboratorio_protocolo é obrigatório.');
    CALL sp_assert_true(p_evento IS NOT NULL AND CHAR_LENGTH(p_evento)>0, 'PARAM', 'evento é obrigatório.');

    START TRANSACTION;

    INSERT INTO laboratorio_protocolo_evento (id_laboratorio_protocolo, id_sessao_usuario, evento, detalhe, payload_json)
    VALUES (p_id_laboratorio_protocolo, p_id_sessao_usuario, UPPER(p_evento), p_detalhe, p_payload);

    SET v_status = NULL;
    SET v_status = CASE UPPER(p_evento)
        WHEN 'GERADO'   THEN 'GERADO'
        WHEN 'COLETADO' THEN 'COLETADO'
        WHEN 'ENVIADO'  THEN 'ENVIADO'
        WHEN 'RECEBIDO' THEN 'RECEBIDO'
        WHEN 'RESULTADO'THEN 'RESULTADO'
        WHEN 'CANCELADO'THEN 'CANCELADO'
        ELSE NULL
    END;

    IF v_status IS NOT NULL THEN
        UPDATE laboratorio_protocolo
           SET status = v_status,
               atualizado_em = NOW()
         WHERE id_laboratorio_protocolo = p_id_laboratorio_protocolo;
    END IF;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, CONCAT('LAB_PROTOCOLO_', UPPER(p_evento)), 'laboratorio_protocolo', p_id_laboratorio_protocolo);

    COMMIT;
END ;;
```

