# fn_sha256i_hash

Objetivo: fn sha256i hash conforme definida no dump SQL do sistema.

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
- IF
- LENGTH
- SHA2

## Views Utilizadas
- v_hash
- v_salt

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
- **Linha 2**: p_senha     VARCHAR(255),
- **Linha 3**: p_salt_hex  CHAR(32),
- **Linha 4**: p_iter      INT
- **Linha 5**: ) RETURNS char(64) CHARSET utf8mb4
- **Linha 6**: NO SQL
- **Linha 7**: DETERMINISTIC
- **Linha 8**: SQL SECURITY INVOKER
- **Linha 9**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local i.
- **Linha 11**: Declaracao de variavel local v_hash.
- **Linha 12**: Declaracao de variavel local v_salt.
- **Linha 14**: Estrutura condicional de controle de fluxo.
- **Linha 15**: RETURN NULL;
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: RETURN NULL;
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 23**: atribuicao de valor Ã  variavel p_iter.
- **Linha 24**: Estrutura condicional de controle de fluxo.
- **Linha 26**: atribuicao de valor Ã  variavel v_salt.
- **Linha 28**: atribuicao de valor Ã  variavel v_hash.
- **Linha 30**: Estrutura de repeticao/controle de loop.
- **Linha 31**: atribuicao de valor Ã  variavel v_hash.
- **Linha 32**: atribuicao de valor Ã  variavel i.
- **Linha 33**: END WHILE;
- **Linha 35**: RETURN v_hash;
- **Linha 36**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_sha256i_hash`(
    p_senha     VARCHAR(255),
    p_salt_hex  CHAR(32),
    p_iter      INT
) RETURNS char(64) CHARSET utf8mb4
    NO SQL
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_hash CHAR(64);
    DECLARE v_salt BINARY(16);

    IF p_senha IS NULL THEN
        RETURN NULL;
    END IF;

    IF p_salt_hex IS NULL OR LENGTH(p_salt_hex) <> 32 THEN
        RETURN NULL;
    END IF;

    IF p_iter IS NULL OR p_iter < 2000 THEN
        SET p_iter = 12000;
    END IF;

    SET v_salt = UNHEX(p_salt_hex);

    SET v_hash = SHA2(CONCAT(v_salt, p_senha), 256);

    WHILE i < p_iter DO
        SET v_hash = SHA2(CONCAT(UNHEX(v_hash), v_salt, p_senha), 256);
        SET i = i + 1;
    END WHILE;

    RETURN v_hash;
END ;;
```

