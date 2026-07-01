# fn_runtime_chain_fingerprint

Objetivo: fn runtime chain fingerprint conforme definida no dump SQL do sistema.

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
- **Linha 2**: p_id_tenant BIGINT,
- **Linha 3**: p_id_usuario BIGINT,
- **Linha 4**: p_id_sessao BIGINT,
- **Linha 5**: p_id_dispositivo BIGINT,
- **Linha 6**: p_estado VARCHAR(60)
- **Linha 7**: ) RETURNS char(64) CHARSET utf8mb4
- **Linha 8**: DETERMINISTIC
- **Linha 9**: RETURN SHA2(
- **Linha 10**: CONCAT(
- **Linha 11**: Estrutura condicional de controle de fluxo.
- **Linha 12**: '|',
- **Linha 13**: Estrutura condicional de controle de fluxo.
- **Linha 14**: '|',
- **Linha 15**: Estrutura condicional de controle de fluxo.
- **Linha 16**: '|',
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 18**: '|',
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: ),256) ;;

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_runtime_chain_fingerprint`(
    p_id_tenant BIGINT,
    p_id_usuario BIGINT,
    p_id_sessao BIGINT,
    p_id_dispositivo BIGINT,
    p_estado VARCHAR(60)
) RETURNS char(64) CHARSET utf8mb4
    DETERMINISTIC
RETURN SHA2(
    CONCAT(
        IFNULL(p_id_tenant,''),
        '|',
        IFNULL(p_id_usuario,''),
        '|',
        IFNULL(p_id_sessao,''),
        '|',
        IFNULL(p_id_dispositivo,''),
        '|',
        IFNULL(p_estado,'')
    ),256) ;;
```

