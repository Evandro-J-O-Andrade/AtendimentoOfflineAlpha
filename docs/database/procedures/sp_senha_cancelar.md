# sp_senha_cancelar

Objetivo: senha cancelar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |

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
- NOW

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: inicio do bloco de execucao.
- **Linha 8**: Invoca a procedure sp_sessao_assert.
- **Linha 10**: UPDATE senha
- **Linha 11**: atribuicao de valor Ã  variavel status.
- **Linha 12**: finalizada_em = NOW()
- **Linha 13**: WHERE id = p_id_senha;
- **Linha 15**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_cancelar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    CALL sp_sessao_assert(p_id_sessao_usuario);

    UPDATE senha 
    SET status = 'CANCELADA',
        finalizada_em = NOW()
    WHERE id = p_id_senha;

END ;;
```

