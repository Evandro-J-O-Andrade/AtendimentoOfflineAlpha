# sp_usuario_hash_gerar

Objetivo: usuario hash gerar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_senha | VARCHAR(255) | IN | |
| p_iter | INT | IN | |
| p_hash_composto | VARCHAR(255) | OUT | |

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
- IFNULL
- LENGTH
- REPLACE
- ROUND
- SHA2
- UUID

## Views Utilizadas
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
- **Linha 8**: Declaracao de variavel local i.
- **Linha 9**: Declaracao de variavel local v_iter.
- **Linha 10**: Declaracao de variavel local v_salt_hex.
- **Linha 11**: Declaracao de variavel local v_hash_hex.
- **Linha 13** (Comentario): validações
- **Linha 14**: Estrutura condicional de controle de fluxo.
- **Linha 15**: atribuicao de valor Ã  variavel p_hash_composto.
- **Linha 16**: Estrutura de repeticao/controle de loop.
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 19** (Comentario): mínimo de iterações (ajustável)
- **Linha 20**: atribuicao de valor Ã  variavel v_iter.
- **Linha 21**: Estrutura condicional de controle de fluxo.
- **Linha 22**: atribuicao de valor Ã  variavel v_iter.
- **Linha 23**: Estrutura condicional de controle de fluxo.
- **Linha 25** (Comentario): salt 16 bytes -> 32 hex
- **Linha 26**: atribuicao de valor Ã  variavel v_salt_hex.
- **Linha 27**: Estrutura condicional de controle de fluxo.
- **Linha 28** (Comentario): fallback determinístico em tamanho (UUID sem hífen)
- **Linha 29**: atribuicao de valor Ã  variavel v_salt_hex.
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 32** (Comentario): primeiro round
- **Linha 33**: atribuicao de valor Ã  variavel v_hash_hex.
- **Linha 35** (Comentario): rounds adicionais
- **Linha 36**: Estrutura de repeticao/controle de loop.
- **Linha 37**: atribuicao de valor Ã  variavel v_hash_hex.
- **Linha 38**: atribuicao de valor Ã  variavel i.
- **Linha 39**: END WHILE;
- **Linha 41**: atribuicao de valor Ã  variavel p_hash_composto.
- **Linha 42**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_hash_gerar`(
    IN  p_senha VARCHAR(255),
    IN  p_iter  INT,
    OUT p_hash_composto VARCHAR(255)
)
    SQL SECURITY INVOKER
proc: BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_iter INT;
    DECLARE v_salt_hex CHAR(32);
    DECLARE v_hash_hex CHAR(64);

    -- validações
    IF p_senha IS NULL OR LENGTH(p_senha) = 0 THEN
        SET p_hash_composto = NULL;
        LEAVE proc;
    END IF;

    -- mínimo de iterações (ajustável)
    SET v_iter = IFNULL(p_iter, 12000);
    IF v_iter < 12000 THEN
        SET v_iter = 12000;
    END IF;

    -- salt 16 bytes -> 32 hex
    SET v_salt_hex = HEX(RANDOM_BYTES(16));
    IF v_salt_hex IS NULL OR LENGTH(v_salt_hex) <> 32 THEN
        -- fallback determinístico em tamanho (UUID sem hífen)
        SET v_salt_hex = REPLACE(UUID(), '-', '');
    END IF;

    -- primeiro round
    SET v_hash_hex = SHA2(CONCAT(UNHEX(v_salt_hex), p_senha), 256);

    -- rounds adicionais
    WHILE i < v_iter DO
        SET v_hash_hex = SHA2(CONCAT(UNHEX(v_hash_hex), UNHEX(v_salt_hex), p_senha), 256);
        SET i = i + 1;
    END WHILE;

    SET p_hash_composto = CONCAT('SHA256I$', v_iter, '$', v_salt_hex, '$', v_hash_hex);
END ;;
```

