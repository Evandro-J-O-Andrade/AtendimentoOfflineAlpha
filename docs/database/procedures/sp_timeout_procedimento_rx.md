# sp_timeout_procedimento_rx

Objetivo: timeout procedimento rx conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_horas_limite | INT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditar_erro_sql
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- NOW
- TIMESTAMPDIFF

## Views Utilizadas
- v_sqlstate

## Eventos Gerados
- (nenhum)

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: main: BEGIN
- **Linha 6**: Declaracao de variavel local v_sqlstate.
- **Linha 7**: Declaracao de variavel local v_errno.
- **Linha 8**: Declaracao de variavel local v_msg.
- **Linha 10**: Declaracao de variavel local v_lim.
- **Linha 12**: Declaracao de variavel local EXIT.
- **Linha 13**: inicio do bloco de execucao.
- **Linha 14**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 15**: ROLLBACK;
- **Linha 16**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 17**: Invoca a procedure sp_raise.
- **Linha 18**: CONCAT('ROTINA=sp_timeout_procedimento_rx | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 19**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 20**: ' | MSG=',IFNULL(v_msg,'(n/a)')));
- **Linha 21**: Fim do bloco da procedure.
- **Linha 23**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: atribuicao de valor Ã  variavel v_lim.
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 28**: START TRANSACTION;
- **Linha 30**: UPDATE fila_operacional fo
- **Linha 31**: SET fo.substatus = 'REAVALIAR',
- **Linha 32**: fo.reavaliar_em = NOW()
- **Linha 33**: WHERE fo.tipo = 'RX'
- **Linha 38**: COMMIT;
- **Linha 39**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_procedimento_rx`(
    IN p_id_sessao_usuario BIGINT,
    IN p_horas_limite      INT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno    INT;
    DECLARE v_msg      TEXT;

    DECLARE v_lim INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_timeout_procedimento_rx', 'Falha no timeout RX');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_timeout_procedimento_rx | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SET v_lim = IFNULL(p_horas_limite, 8);
    IF v_lim < 1 THEN SET v_lim = 1; END IF;

    START TRANSACTION;

    UPDATE fila_operacional fo
       SET fo.substatus = 'REAVALIAR',
           fo.reavaliar_em = NOW()
     WHERE fo.tipo = 'RX'
       AND fo.substatus = 'EM_EXECUCAO'
       AND fo.data_inicio IS NOT NULL
       AND TIMESTAMPDIFF(HOUR, fo.data_inicio, NOW()) >= v_lim;

    COMMIT;
END ;;
```

