# sp_raise

Objetivo: raise conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_codigo | VARCHAR(50) | IN | |
| p_mensagem | VARCHAR(4000) | IN | |

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
- LEFT
- SIGNAL
- TRUNCATE

## Views Utilizadas
- v_msg128

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: inicio do bloco de execucao.
- **Linha 6**: Declaracao de variavel local v_msg128.
- **Linha 8** (Comentario): Build message and truncate safely to 128 chars
- **Linha 9**: atribuicao de valor Ã  variavel v_msg128.
- **Linha 10**: CONCAT('[', IFNULL(p_codigo,'ERRO'), '] ', IFNULL(p_mensagem,'Erro')),
- **Linha 11**: 128
- **Linha 12**: );
- **Linha 14**: SIGNAL SQLSTATE '45000'
- **Linha 15**: atribuicao de valor Ã  variavel MYSQL_ERRNO.
- **Linha 16**: MESSAGE_TEXT = v_msg128;
- **Linha 17**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_raise`(
    IN p_codigo   VARCHAR(50),
    IN p_mensagem VARCHAR(4000)
)
BEGIN
    DECLARE v_msg128 VARCHAR(128);

    -- Build message and truncate safely to 128 chars
    SET v_msg128 = LEFT(
        CONCAT('[', IFNULL(p_codigo,'ERRO'), '] ', IFNULL(p_mensagem,'Erro')),
        128
    );

    SIGNAL SQLSTATE '45000'
        SET MYSQL_ERRNO  = 1644,
            MESSAGE_TEXT = v_msg128;
END ;;
```

