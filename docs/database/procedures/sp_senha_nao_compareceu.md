# sp_senha_nao_compareceu

Objetivo: senha nao compareceu conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_observacao | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: senha
- INSERT: workflow_ffa_evento
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- IF
- NOW
- RESIGNAL

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).
- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

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
- **Linha 7**: inicio do bloco de execucao.
- **Linha 9**: Declaracao de variavel local v_id_ffa.
- **Linha 11**: Declaracao de variavel local EXIT.
- **Linha 12**: inicio do bloco de execucao.
- **Linha 13**: ROLLBACK;
- **Linha 14**: RESIGNAL;
- **Linha 15**: Fim do bloco da procedure.
- **Linha 17**: Invoca a procedure sp_sessao_assert.
- **Linha 19**: START TRANSACTION;
- **Linha 21**: execucao de query SELECT para consulta de dados.
- **Linha 22**: INTO v_id_ffa
- **Linha 23**: FROM senha
- **Linha 24**: WHERE id_senha = p_id_senha
- **Linha 25**: LIMIT 1;
- **Linha 27**: UPDATE senha
- **Linha 28**: SET
- **Linha 29**: nao_compareceu = TRUE,
- **Linha 30**: nao_compareceu_em = NOW(6),
- **Linha 31**: retorno_utilizado = FALSE,
- **Linha 32**: id_fluxo_status = 99,
- **Linha 33**: contexto_fluxo = 'AGUARDANDO_RETORNO',
- **Linha 34**: atualizado_em = NOW(6)
- **Linha 35**: WHERE id_senha = p_id_senha
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 40**: Insere um novo registro na tabela workflow_ffa_evento.
- **Linha 41**: (
- **Linha 42**: id_ffa,
- **Linha 43**: tipo_evento,
- **Linha 44**: detalhe,
- **Linha 45**: id_sessao_usuario,
- **Linha 46**: criado_em
- **Linha 47**: fechamento da lista de Parametros.
- **Linha 48**: VALUES
- **Linha 49**: (
- **Linha 50**: v_id_ffa,
- **Linha 51**: 'CHAMADA_NAO_ATENDIDA',
- **Linha 52**: p_observacao,
- **Linha 53**: p_id_sessao_usuario,
- **Linha 54**: NOW(6)
- **Linha 55**: );
- **Linha 57**: Estrutura condicional de controle de fluxo.
- **Linha 59**: COMMIT;
- **Linha 61**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_nao_compareceu`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT,
    IN p_observacao TEXT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_ffa BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    START TRANSACTION;

    SELECT id_ffa
    INTO v_id_ffa
    FROM senha
    WHERE id_senha = p_id_senha
    LIMIT 1;

    UPDATE senha
    SET
        nao_compareceu = TRUE,
        nao_compareceu_em = NOW(6),
        retorno_utilizado = FALSE,
        id_fluxo_status = 99,
        contexto_fluxo = 'AGUARDANDO_RETORNO',
        atualizado_em = NOW(6)
    WHERE id_senha = p_id_senha
    AND nao_compareceu = FALSE;

    IF v_id_ffa IS NOT NULL THEN

        INSERT INTO workflow_ffa_evento
        (
            id_ffa,
            tipo_evento,
            detalhe,
            id_sessao_usuario,
            criado_em
        )
        VALUES
        (
            v_id_ffa,
            'CHAMADA_NAO_ATENDIDA',
            p_observacao,
            p_id_sessao_usuario,
            NOW(6)
        );

    END IF;

    COMMIT;

END ;;
```

