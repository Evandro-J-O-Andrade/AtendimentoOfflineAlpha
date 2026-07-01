# sp_master_ffa_movimentar

Objetivo: master ffa movimentar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_ffa | INT | IN | |
| p_novo_status | VARCHAR(50) | IN | |
| p_resultado | JSON | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: workflow_ffa_evento
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- JSON_OBJECT
- NOW

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
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
- **Linha 8**: SQL SECURITY INVOKER
- **Linha 9**: proc: BEGIN
- **Linha 10**: Declaracao de variavel local EXIT.
- **Linha 11**: GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
- **Linha 12**: ROLLBACK;
- **Linha 13**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 14**: Fim do bloco da procedure.
- **Linha 16**: START TRANSACTION;
- **Linha 18** (Comentario): Atualiza o workflow (FFA)
- **Linha 19**: Atualiza registros existentes na tabela ffa.
- **Linha 21** (Comentario): Registro no Ledger de Movimentação (Workflow Evento)
- **Linha 22**: Insere um novo registro na tabela workflow_ffa_evento.
- **Linha 23**: VALUES (p_id_ffa, 'STATUS_CHANGE', CONCAT('Status alterado para: ', p_novo_status), p_id_sessao);
- **Linha 25**: COMMIT;
- **Linha 26**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 27**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_ffa_movimentar`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_ffa INT,
    IN p_novo_status VARCHAR(50),
    OUT p_resultado JSON
)
    SQL SECURITY INVOKER
proc: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        SET p_resultado = JSON_OBJECT('sucesso', FALSE, 'mensagem', @msg);
    END;

    START TRANSACTION;

    -- Atualiza o workflow (FFA)
    UPDATE ffa SET status = p_novo_status, atualizado_em = NOW() WHERE id_ffa = p_id_ffa;

    -- Registro no Ledger de Movimentação (Workflow Evento)
    INSERT INTO workflow_ffa_evento (id_ffa, tipo_evento, detalhe, id_sessao_usuario)
    VALUES (p_id_ffa, 'STATUS_CHANGE', CONCAT('Status alterado para: ', p_novo_status), p_id_sessao);

    COMMIT;
    SET p_resultado = JSON_OBJECT('sucesso', TRUE, 'mensagem', 'Fluxo atualizado');
END ;;
```

