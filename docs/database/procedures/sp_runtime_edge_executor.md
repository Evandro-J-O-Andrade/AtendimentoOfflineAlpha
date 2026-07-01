# sp_runtime_edge_executor

Objetivo: runtime edge executor conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_ffa | BIGINT | IN | |
| p_evento | VARCHAR(60) | IN | |
| p_estado_atual | VARCHAR(60) | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_sessao_usuario | BIGINT | IN | |
| p_estado_novo | VARCHAR(60) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fluxo_transicao_matriz
- INSERT: runtime_evento_local
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CURRENT_TIMESTAMP
- IF
- SIGNAL

## Views Utilizadas
- v_estado_destino

## Eventos Gerados
- evento

## Tratamento de Erros

- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: SQL SECURITY INVOKER
- **Linha 10**: inicio do bloco de execucao.
- **Linha 12**: Declaracao de variavel local v_estado_destino.
- **Linha 14**: /*
- **Linha 15**: Runtime local tenta resolver transição primeiro
- **Linha 16**: (opera mesmo sem conectividade SaaS)
- **Linha 17**: */
- **Linha 19**: execucao de query SELECT para consulta de dados.
- **Linha 20**: INTO v_estado_destino
- **Linha 21**: FROM fluxo_transicao_matriz
- **Linha 22**: WHERE estado_origem = p_estado_atual
- **Linha 25**: ORDER BY prioridade DESC
- **Linha 26**: LIMIT 1;
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 29**: SIGNAL SQLSTATE '45000'
- **Linha 30**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 33**: /* Atualiza estado local */
- **Linha 35**: UPDATE ffa
- **Linha 36**: atribuicao de valor Ã  variavel estado.
- **Linha 37**: atualizado_em = CURRENT_TIMESTAMP(6)
- **Linha 38**: WHERE id_ffa = p_id_ffa;
- **Linha 40**: /* Ledger local */
- **Linha 42**: Insere um novo registro na tabela runtime_evento_local.
- **Linha 43**: id_ffa,
- **Linha 44**: evento,
- **Linha 45**: estado_origem,
- **Linha 46**: estado_destino,
- **Linha 47**: id_usuario,
- **Linha 48**: id_sessao_usuario,
- **Linha 49**: sincronizado
- **Linha 50**: fechamento da lista de Parametros.
- **Linha 51**: VALUES(
- **Linha 52**: p_id_ffa,
- **Linha 53**: p_evento,
- **Linha 54**: p_estado_atual,
- **Linha 55**: v_estado_destino,
- **Linha 56**: p_id_usuario,
- **Linha 57**: p_id_sessao_usuario,
- **Linha 58**: 0
- **Linha 59**: );
- **Linha 61**: atribuicao de valor Ã  variavel p_estado_novo.
- **Linha 63**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_runtime_edge_executor`(
    IN p_id_ffa BIGINT,
    IN p_evento VARCHAR(60),
    IN p_estado_atual VARCHAR(60),
    IN p_id_usuario BIGINT,
    IN p_id_sessao_usuario BIGINT,
    OUT p_estado_novo VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_estado_destino VARCHAR(60);

    /* 
       Runtime local tenta resolver transição primeiro
       (opera mesmo sem conectividade SaaS)
    */

    SELECT estado_destino
    INTO v_estado_destino
    FROM fluxo_transicao_matriz
    WHERE estado_origem = p_estado_atual
      AND evento = p_evento
      AND ativo = 1
    ORDER BY prioridade DESC
    LIMIT 1;

    IF v_estado_destino IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transição inválida no runtime edge';
    END IF;

    /* Atualiza estado local */

    UPDATE ffa
    SET estado = v_estado_destino,
        atualizado_em = CURRENT_TIMESTAMP(6)
    WHERE id_ffa = p_id_ffa;

    /* Ledger local */

    INSERT INTO runtime_evento_local(
        id_ffa,
        evento,
        estado_origem,
        estado_destino,
        id_usuario,
        id_sessao_usuario,
        sincronizado
    )
    VALUES(
        p_id_ffa,
        p_evento,
        p_estado_atual,
        v_estado_destino,
        p_id_usuario,
        p_id_sessao_usuario,
        0
    );

    SET p_estado_novo = v_estado_destino;

END ;;
```

