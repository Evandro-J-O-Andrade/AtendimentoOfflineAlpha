# sp_coordenador_global

Objetivo: coordenador global conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_uuid_runtime | CHAR(36) | IN | |
| p_id_saas | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_estado | VARCHAR(80) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: coordenador_estado_global
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CURRENT_TIMESTAMP
- IFNULL
- JSON_UNQUOTE
- SHA2

## Views Utilizadas
- v_hash

## Eventos Gerados
- (nenhum)

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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: SQL SECURITY INVOKER
- **Linha 9**: inicio do bloco de execucao.
- **Linha 11**: Declaracao de variavel local v_hash.
- **Linha 13**: atribuicao de valor Ã  variavel v_hash.
- **Linha 15**: Insere um novo registro na tabela coordenador_estado_global.
- **Linha 16**: (
- **Linha 17**: uuid_runtime,
- **Linha 18**: id_saas_entidade,
- **Linha 19**: id_unidade,
- **Linha 20**: estado_atual,
- **Linha 21**: hash_estado,
- **Linha 22**: payload_snapshot,
- **Linha 23**: bloqueado
- **Linha 24**: fechamento da lista de Parametros.
- **Linha 25**: VALUES
- **Linha 26**: (
- **Linha 27**: p_uuid_runtime,
- **Linha 28**: p_id_saas,
- **Linha 29**: p_id_unidade,
- **Linha 30**: p_estado,
- **Linha 31**: v_hash,
- **Linha 32**: p_payload,
- **Linha 33**: FALSE
- **Linha 34**: fechamento da lista de Parametros.
- **Linha 35**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 36**: estado_atual = VALUES(estado_atual),
- **Linha 37**: hash_estado = VALUES(hash_estado),
- **Linha 38**: payload_snapshot = VALUES(payload_snapshot),
- **Linha 39**: atualizado_em = CURRENT_TIMESTAMP(6);
- **Linha 41**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_coordenador_global`(
    IN p_uuid_runtime CHAR(36),
    IN p_id_saas BIGINT,
    IN p_id_unidade BIGINT,
    IN p_estado VARCHAR(80),
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_hash CHAR(64);

    SET v_hash = SHA2(IFNULL(JSON_UNQUOTE(p_payload), ''), 256);

    INSERT INTO coordenador_estado_global
    (
        uuid_runtime,
        id_saas_entidade,
        id_unidade,
        estado_atual,
        hash_estado,
        payload_snapshot,
        bloqueado
    )
    VALUES
    (
        p_uuid_runtime,
        p_id_saas,
        p_id_unidade,
        p_estado,
        v_hash,
        p_payload,
        FALSE
    )
    ON DUPLICATE KEY UPDATE
        estado_atual = VALUES(estado_atual),
        hash_estado = VALUES(hash_estado),
        payload_snapshot = VALUES(payload_snapshot),
        atualizado_em = CURRENT_TIMESTAMP(6);

END ;;
```

