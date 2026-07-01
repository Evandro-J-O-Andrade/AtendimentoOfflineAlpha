# sp_guardiao_runtime_decidir

Objetivo: guardiao runtime decidir conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_contexto | VARCHAR(60) | IN | |
| p_recurso | VARCHAR(120) | IN | |
| p_permitido | TINYINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: guardiao_acl_runtime
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COUNT
- IF

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
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local v_count.
- **Linha 12**: execucao de query SELECT para consulta de dados.
- **Linha 13**: INTO v_count
- **Linha 14**: FROM guardiao_acl_runtime
- **Linha 15**: WHERE id_usuario = p_id_usuario
- **Linha 20**: atribuicao de valor Ã  variavel p_permitido.
- **Linha 22**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_guardiao_runtime_decidir`(
    IN p_id_usuario BIGINT,
    IN p_contexto VARCHAR(60),
    IN p_recurso VARCHAR(120),
    OUT p_permitido TINYINT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_count
    FROM guardiao_acl_runtime
    WHERE id_usuario = p_id_usuario
      AND contexto = p_contexto
      AND recurso = p_recurso
      AND permitido = 1;

    SET p_permitido = IF(v_count > 0, 1, 0);

END ;;
```

