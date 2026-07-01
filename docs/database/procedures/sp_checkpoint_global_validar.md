# sp_checkpoint_global_validar

Objetivo: checkpoint global validar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_ffa | BIGINT | IN | |
| p_estado_snapshot | VARCHAR(60) | IN | |
| p_id_sessao_usuario | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: assistencial_checkpoint_global
- INSERT: assistencial_checkpoint_global, auditoria_evento
- UPDATE: assistencial_checkpoint_global
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- COUNT
- CURRENT_TIMESTAMP
- IF

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- auditoria_evento
- evento

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 9**: Declaracao de variavel local v_existente.
- **Linha 11**: /* Verifica snapshot atual */
- **Linha 13**: execucao de query SELECT para consulta de dados.
- **Linha 14**: INTO v_existente
- **Linha 15**: FROM assistencial_checkpoint_global
- **Linha 16**: WHERE id_ffa = p_id_ffa;
- **Linha 18**: /* Se não existir, cria checkpoint inicial */
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 22**: Insere um novo registro na tabela assistencial_checkpoint_global.
- **Linha 23**: id_ffa,
- **Linha 24**: estado_snapshot,
- **Linha 25**: quorum_valido
- **Linha 26**: fechamento da lista de Parametros.
- **Linha 27**: VALUES(
- **Linha 28**: p_id_ffa,
- **Linha 29**: p_estado_snapshot,
- **Linha 30**: 1
- **Linha 31**: );
- **Linha 33**: Estrutura condicional de controle de fluxo.
- **Linha 35**: UPDATE assistencial_checkpoint_global
- **Linha 36**: atribuicao de valor Ã  variavel estado_snapshot.
- **Linha 37**: quorum_valido = 1,
- **Linha 38**: criado_em = CURRENT_TIMESTAMP(6)
- **Linha 39**: WHERE id_ffa = p_id_ffa;
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 43**: /* Observabilidade operacional (não bloqueante) */
- **Linha 45**: Insere um novo registro na tabela auditoria_evento.
- **Linha 46**: id_sessao_usuario,
- **Linha 47**: evento,
- **Linha 48**: sucesso,
- **Linha 49**: descricao
- **Linha 50**: fechamento da lista de Parametros.
- **Linha 51**: VALUES(
- **Linha 52**: p_id_sessao_usuario,
- **Linha 53**: 'CHECKPOINT_GLOBAL_OK',
- **Linha 54**: 1,
- **Linha 55**: CONCAT('FFA=',p_id_ffa)
- **Linha 56**: );
- **Linha 58**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_checkpoint_global_validar`(
    IN p_id_ffa BIGINT,
    IN p_estado_snapshot VARCHAR(60),
    IN p_id_sessao_usuario BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_existente INT DEFAULT 0;

    /* Verifica snapshot atual */

    SELECT COUNT(1)
    INTO v_existente
    FROM assistencial_checkpoint_global
    WHERE id_ffa = p_id_ffa;

    /* Se não existir, cria checkpoint inicial */

    IF v_existente = 0 THEN

        INSERT INTO assistencial_checkpoint_global(
            id_ffa,
            estado_snapshot,
            quorum_valido
        )
        VALUES(
            p_id_ffa,
            p_estado_snapshot,
            1
        );

    ELSE

        UPDATE assistencial_checkpoint_global
        SET estado_snapshot = p_estado_snapshot,
            quorum_valido = 1,
            criado_em = CURRENT_TIMESTAMP(6)
        WHERE id_ffa = p_id_ffa;

    END IF;

    /* Observabilidade operacional (não bloqueante) */

    INSERT INTO auditoria_evento(
        id_sessao_usuario,
        evento,
        sucesso,
        descricao
    )
    VALUES(
        p_id_sessao_usuario,
        'CHECKPOINT_GLOBAL_OK',
        1,
        CONCAT('FFA=',p_id_ffa)
    );

END ;;
```

