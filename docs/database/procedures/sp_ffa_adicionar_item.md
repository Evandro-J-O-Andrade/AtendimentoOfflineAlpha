# sp_ffa_adicionar_item

Objetivo: ffa adicionar item conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_ffa | BIGINT | IN | |
| p_tipo_item | VARCHAR(50) | IN | |
| p_descricao_item | VARCHAR(255) | IN | |
| p_quantidade | INT | IN | |
| p_id_item | BIGINT | OUT | |
| p_resultado | JSON | OUT | |
| p_sucesso | BOOLEAN | OUT | |
| p_mensagem | VARCHAR(500) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: ffa_item
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- JSON_OBJECT
- LAST_INSERT_ID
- NOW
- UUID

## Views Utilizadas
- v_error_msg
- v_uuid_transacao

## Eventos Gerados
- evento
- ledger_evento

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
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: Declaracao de parÃ¢metro.
- **Linha 12**: Declaracao de parÃ¢metro.
- **Linha 13**: fechamento da lista de Parametros.
- **Linha 14**: SQL SECURITY INVOKER
- **Linha 15**: proc_block: BEGIN
- **Linha 16**: Declaracao de variavel local v_uuid_transacao.
- **Linha 17**: Declaracao de variavel local v_error_msg.
- **Linha 19**: Declaracao de variavel local EXIT.
- **Linha 20**: inicio do bloco de execucao.
- **Linha 21**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 22**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 23**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 24**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 25**: ROLLBACK;
- **Linha 26**: Fim do bloco da procedure.
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 29**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 30**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 31**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 32**: Estrutura de repeticao/controle de loop.
- **Linha 33**: Estrutura condicional de controle de fluxo.
- **Linha 35**: START TRANSACTION;
- **Linha 37**: Insere um novo registro na tabela ffa_item.
- **Linha 38**: id_ffa,
- **Linha 39**: tipo_item,
- **Linha 40**: descricao_item,
- **Linha 41**: quantidade,
- **Linha 42**: criado_por,
- **Linha 43**: criado_em
- **Linha 44**: ) VALUES (
- **Linha 45**: p_id_ffa,
- **Linha 46**: p_tipo_item,
- **Linha 47**: p_descricao_item,
- **Linha 48**: p_quantidade,
- **Linha 49**: p_id_usuario,
- **Linha 50**: NOW(6)
- **Linha 51**: );
- **Linha 53**: atribuicao de valor Ã  variavel p_id_item.
- **Linha 55**: Invoca a procedure sp_ledger_evento_log.
- **Linha 56**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'FFA_ADICIONAR_ITEM',
- **Linha 57**: NULL, p_id_item,
- **Linha 58**: JSON_OBJECT('id_ffa', p_id_ffa, 'tipo_item', p_tipo_item),
- **Linha 59**: 'SUCESSO', 'Item adicionado à FFA'
- **Linha 60**: );
- **Linha 62**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 63**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 64**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 65**: 'id_item', p_id_item,
- **Linha 66**: 'id_ffa', p_id_ffa,
- **Linha 67**: 'uuid_transacao', v_uuid_transacao
- **Linha 68**: );
- **Linha 70**: COMMIT;
- **Linha 71**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_adicionar_item`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_ffa BIGINT,
    IN p_tipo_item VARCHAR(50),
    IN p_descricao_item VARCHAR(255),
    IN p_quantidade INT,
    OUT p_id_item BIGINT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;
    END;

    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    START TRANSACTION;

    INSERT INTO ffa_item (
        id_ffa,
        tipo_item,
        descricao_item,
        quantidade,
        criado_por,
        criado_em
    ) VALUES (
        p_id_ffa,
        p_tipo_item,
        p_descricao_item,
        p_quantidade,
        p_id_usuario,
        NOW(6)
    );

    SET p_id_item = LAST_INSERT_ID();

    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'FFA_ADICIONAR_ITEM',
        NULL, p_id_item,
        JSON_OBJECT('id_ffa', p_id_ffa, 'tipo_item', p_tipo_item),
        'SUCESSO', 'Item adicionado à FFA'
    );

    SET p_sucesso = TRUE;
    SET p_mensagem = 'Item adicionado à FFA com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_item', p_id_item,
        'id_ffa', p_id_ffa,
        'uuid_transacao', v_uuid_transacao
    );

    COMMIT;
END ;;
```

