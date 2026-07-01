# sp_medico_marcar_retorno

Objetivo: medico marcar retorno conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_data_limite | DATETIME | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- (nenhuma)

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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Invoca a procedure sp_sessao_assert.
- **Linha 10**: UPDATE senha
- **Linha 11**: atribuicao de valor Ã  variavel retorno_permitido_ate.
- **Linha 12**: retorno_utilizado = 0
- **Linha 13**: WHERE id = p_id_senha;
- **Linha 15**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_medico_marcar_retorno`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT,
    IN p_data_limite DATETIME
)
    SQL SECURITY INVOKER
BEGIN
    CALL sp_sessao_assert(p_id_sessao_usuario);

    UPDATE senha
    SET retorno_permitido_ate = p_data_limite,
        retorno_utilizado = 0
    WHERE id = p_id_senha;

END ;;
```

