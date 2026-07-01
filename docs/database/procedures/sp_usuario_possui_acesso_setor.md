# sp_usuario_possui_acesso_setor

Objetivo: usuario possui acesso setor conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_setor | INT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: usuario_setor
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: inicio do bloco de execucao.
- **Linha 8**: execucao de query SELECT para consulta de dados.
- **Linha 9**: FROM usuario_setor
- **Linha 10**: WHERE id_usuario = p_id_usuario
- **Linha 13**: LIMIT 1;
- **Linha 15**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_possui_acesso_setor`(
    IN p_id_usuario BIGINT,
    IN p_id_setor INT
)
    SQL SECURITY INVOKER
BEGIN

    SELECT 1
    FROM usuario_setor
    WHERE id_usuario = p_id_usuario
    AND id_setor = p_id_setor
    AND pode_operar = TRUE
    LIMIT 1;

END ;;
```

