# sp_guardiao_runtime_final

Objetivo: guardiao runtime final conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_uuid_runtime | CHAR(36) | IN | |
| p_id_saas | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: guardiao_runtime_final
- INSERT: guardiao_runtime_final
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- CURRENT_TIMESTAMP
- IF
- IFNULL
- JSON_UNQUOTE
- SHA2
- SIGNAL

## Views Utilizadas
- v_estado
- v_hash

## Eventos Gerados
- (nenhum)

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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local v_hash.
- **Linha 12**: atribuicao de valor Ã  variavel v_hash.
- **Linha 13**: CONCAT(
- **Linha 14**: p_uuid_runtime,
- **Linha 15**: Estrutura condicional de controle de fluxo.
- **Linha 16**: ),
- **Linha 17**: 256
- **Linha 18**: );
- **Linha 20**: execucao de query SELECT para consulta de dados.
- **Linha 21**: INTO @v_estado
- **Linha 22**: FROM guardiao_runtime_final
- **Linha 23**: WHERE uuid_runtime = p_uuid_runtime
- **Linha 24**: LIMIT 1;
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 27**: SIGNAL SQLSTATE '45000'
- **Linha 28**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 29**: Estrutura condicional de controle de fluxo.
- **Linha 31**: Insere um novo registro na tabela guardiao_runtime_final.
- **Linha 32**: (
- **Linha 33**: uuid_runtime,
- **Linha 34**: id_saas_entidade,
- **Linha 35**: id_unidade,
- **Linha 36**: hash_contexto,
- **Linha 37**: estado_permitido
- **Linha 38**: fechamento da lista de Parametros.
- **Linha 39**: VALUES
- **Linha 40**: (
- **Linha 41**: p_uuid_runtime,
- **Linha 42**: p_id_saas,
- **Linha 43**: p_id_unidade,
- **Linha 44**: v_hash,
- **Linha 45**: TRUE
- **Linha 46**: fechamento da lista de Parametros.
- **Linha 47**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 48**: hash_contexto = VALUES(hash_contexto),
- **Linha 49**: atualizado_em = CURRENT_TIMESTAMP(6);
- **Linha 51**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_guardiao_runtime_final`(
    IN p_uuid_runtime CHAR(36),
    IN p_id_saas BIGINT,
    IN p_id_unidade BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_hash CHAR(64);

    SET v_hash = SHA2(
        CONCAT(
            p_uuid_runtime,
            IFNULL(JSON_UNQUOTE(p_payload), '')
        ),
        256
    );

    SELECT estado_permitido
    INTO @v_estado
    FROM guardiao_runtime_final
    WHERE uuid_runtime = p_uuid_runtime
    LIMIT 1;

    IF @v_estado IS NOT NULL AND @v_estado = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Runtime bloqueado pelo guardiao final';
    END IF;

    INSERT INTO guardiao_runtime_final
    (
        uuid_runtime,
        id_saas_entidade,
        id_unidade,
        hash_contexto,
        estado_permitido
    )
    VALUES
    (
        p_uuid_runtime,
        p_id_saas,
        p_id_unidade,
        v_hash,
        TRUE
    )
    ON DUPLICATE KEY UPDATE
        hash_contexto = VALUES(hash_contexto),
        atualizado_em = CURRENT_TIMESTAMP(6);

END ;;
```

