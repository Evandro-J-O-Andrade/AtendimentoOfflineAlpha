# sp_usuario_hash_verificar

Objetivo: usuario hash verificar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_senha | VARCHAR(255) | IN | |
| p_hash_composto | VARCHAR(255) | IN | |
| p_ok | TINYINT | OUT | |

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
- CAST
- CONCAT
- IF
- LENGTH
- SHA2
- SUBSTRING_INDEX

## Views Utilizadas
- v_alg
- v_hash_calc
- v_hash_hex
- v_salt_hex

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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: proc: BEGIN
- **Linha 8**: Declaracao de variavel local v_alg.
- **Linha 9**: Declaracao de variavel local v_iter.
- **Linha 10**: Declaracao de variavel local v_salt_hex.
- **Linha 11**: Declaracao de variavel local v_hash_hex.
- **Linha 13**: Declaracao de variavel local i.
- **Linha 14**: Declaracao de variavel local v_hash_calc.
- **Linha 16**: atribuicao de valor Ã  variavel p_ok.
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: Estrutura de repeticao/controle de loop.
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 22** (Comentario): parse: ALG$ITER$SALT$HASH
- **Linha 23**: atribuicao de valor Ã  variavel v_alg.
- **Linha 24**: Estrutura condicional de controle de fluxo.
- **Linha 25**: Estrutura de repeticao/controle de loop.
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 28**: atribuicao de valor Ã  variavel v_iter.
- **Linha 29**: atribuicao de valor Ã  variavel v_salt_hex.
- **Linha 30**: atribuicao de valor Ã  variavel v_hash_hex.
- **Linha 32**: Estrutura condicional de controle de fluxo.
- **Linha 33**: Estrutura de repeticao/controle de loop.
- **Linha 34**: Estrutura condicional de controle de fluxo.
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 36**: Estrutura de repeticao/controle de loop.
- **Linha 37**: Estrutura condicional de controle de fluxo.
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 39**: Estrutura de repeticao/controle de loop.
- **Linha 40**: Estrutura condicional de controle de fluxo.
- **Linha 42** (Comentario): calcula
- **Linha 43**: atribuicao de valor Ã  variavel v_hash_calc.
- **Linha 44**: Estrutura de repeticao/controle de loop.
- **Linha 45**: atribuicao de valor Ã  variavel v_hash_calc.
- **Linha 46**: atribuicao de valor Ã  variavel i.
- **Linha 47**: END WHILE;
- **Linha 49**: Estrutura condicional de controle de fluxo.
- **Linha 50**: atribuicao de valor Ã  variavel p_ok.
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 52**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_hash_verificar`(
    IN  p_senha VARCHAR(255),
    IN  p_hash_composto VARCHAR(255),
    OUT p_ok TINYINT
)
    SQL SECURITY INVOKER
proc: BEGIN
    DECLARE v_alg VARCHAR(20);
    DECLARE v_iter INT;
    DECLARE v_salt_hex CHAR(32);
    DECLARE v_hash_hex CHAR(64);

    DECLARE i INT DEFAULT 1;
    DECLARE v_hash_calc CHAR(64);

    SET p_ok = 0;

    IF p_senha IS NULL OR p_hash_composto IS NULL OR LENGTH(p_hash_composto) = 0 THEN
        LEAVE proc;
    END IF;

    -- parse: ALG$ITER$SALT$HASH
    SET v_alg = SUBSTRING_INDEX(p_hash_composto, '$', 1);
    IF v_alg <> 'SHA256I' THEN
        LEAVE proc;
    END IF;

    SET v_iter = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(p_hash_composto, '$', 2), '$', -1) AS UNSIGNED);
    SET v_salt_hex = SUBSTRING_INDEX(SUBSTRING_INDEX(p_hash_composto, '$', 3), '$', -1);
    SET v_hash_hex = SUBSTRING_INDEX(p_hash_composto, '$', -1);

    IF v_iter IS NULL OR v_iter < 12000 THEN
        LEAVE proc;
    END IF;
    IF v_salt_hex IS NULL OR LENGTH(v_salt_hex) <> 32 THEN
        LEAVE proc;
    END IF;
    IF v_hash_hex IS NULL OR LENGTH(v_hash_hex) <> 64 THEN
        LEAVE proc;
    END IF;

    -- calcula
    SET v_hash_calc = SHA2(CONCAT(UNHEX(v_salt_hex), p_senha), 256);
    WHILE i < v_iter DO
        SET v_hash_calc = SHA2(CONCAT(UNHEX(v_hash_calc), UNHEX(v_salt_hex), p_senha), 256);
        SET i = i + 1;
    END WHILE;

    IF v_hash_calc = v_hash_hex THEN
        SET p_ok = 1;
    END IF;
END ;;
```

