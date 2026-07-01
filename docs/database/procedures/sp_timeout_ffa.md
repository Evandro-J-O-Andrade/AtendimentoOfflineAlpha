# sp_timeout_ffa

Objetivo: timeout ffa conforme definida no dump SQL do sistema.

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
- COALESCE
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
- **Linha 18**: CONCAT('ROTINA=sp_timeout_ffa | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 19**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 20**: ' | MSG=',IFNULL(v_msg,'(n/a)')));
- **Linha 21**: Fim do bloco da procedure.
- **Linha 23**: Invoca a procedure sp_sessao_assert.
- **Linha 25**: atribuicao de valor Ã  variavel v_lim.
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 28**: START TRANSACTION;
- **Linha 30**: UPDATE ffa f
- **Linha 31**: SET f.status = 'FINALIZADO',
- **Linha 32**: f.atualizado_em = NOW()
- **Linha 33**: WHERE f.status IN ('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_COLETA','AGUARDANDO_ECG','AGUARDANDO_RETORNO')
- **Linha 36**: COMMIT;
- **Linha 37**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_timeout_ffa`(
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
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_timeout_ffa', 'Falha no timeout FFA');
        CALL sp_raise('ERRO_SQL',
            CONCAT('ROTINA=sp_timeout_ffa | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
                   ' | ERRNO=',IFNULL(v_errno,0),
                   ' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SET v_lim = IFNULL(p_horas_limite, 14);
    IF v_lim < 1 THEN SET v_lim = 1; END IF;

    START TRANSACTION;

    UPDATE ffa f
       SET f.status = 'FINALIZADO',
           f.atualizado_em = NOW()
     WHERE f.status IN ('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_COLETA','AGUARDANDO_ECG','AGUARDANDO_RETORNO')
       AND TIMESTAMPDIFF(HOUR, COALESCE(f.atualizado_em, f.criado_em), NOW()) >= v_lim;

    COMMIT;
END ;;
```

