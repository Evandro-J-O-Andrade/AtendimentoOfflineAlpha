# fn_decision_fingerprint

Objetivo: fn decision fingerprint conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

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
- (nenhuma)

## Functions Utilizadas
- CONCAT
- IFNULL
- JSON_UNQUOTE
- SHA2

## Views Utilizadas
- (nenhuma)

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
- **Linha 2**: p_acao VARCHAR(100),
- **Linha 3**: p_id_tenant BIGINT,
- **Linha 4**: p_id_usuario BIGINT,
- **Linha 5**: p_payload JSON
- **Linha 6**: ) RETURNS char(64) CHARSET utf8mb4
- **Linha 7**: DETERMINISTIC
- **Linha 8**: inicio do bloco de execucao.
- **Linha 9**: RETURN SHA2(
- **Linha 10**: CONCAT(
- **Linha 11**: Estrutura condicional de controle de fluxo.
- **Linha 12**: '|',
- **Linha 13**: Estrutura condicional de controle de fluxo.
- **Linha 14**: '|',
- **Linha 15**: Estrutura condicional de controle de fluxo.
- **Linha 16**: '|',
- **Linha 17**: JSON_UNQUOTE(JSON_SORT(IFNULL(p_payload,'{}')))
- **Linha 18**: ),
- **Linha 19**: 256);
- **Linha 20**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_decision_fingerprint`(
    p_acao VARCHAR(100),
    p_id_tenant BIGINT,
    p_id_usuario BIGINT,
    p_payload JSON
) RETURNS char(64) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN SHA2(
        CONCAT(
            IFNULL(p_acao,''),
            '|',
            IFNULL(p_id_tenant,0),
            '|',
            IFNULL(p_id_usuario,0),
            '|',
            JSON_UNQUOTE(JSON_SORT(IFNULL(p_payload,'{}')))
        ),
    256);
END ;;
```

