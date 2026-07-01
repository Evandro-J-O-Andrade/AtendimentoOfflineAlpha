# sp_sessao_contexto_get

Objetivo: sessao contexto get conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
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
- **Linha 3**: fechamento da lista de Parametros.
- **Linha 4**: inicio do bloco de execucao.
- **Linha 5**: Invoca a procedure sp_sessao_assert.
- **Linha 7**: SELECT
- **Linha 8**: su.id_sessao_usuario,
- **Linha 9**: su.id_usuario,
- **Linha 10**: su.id_sistema,
- **Linha 11**: su.id_unidade,
- **Linha 12**: su.id_local_operacional,
- **Linha 13**: su.ip_acesso,
- **Linha 14**: su.user_agent,
- **Linha 15**: su.iniciado_em,
- **Linha 16**: su.expira_em,
- **Linha 17**: su.ativo
- **Linha 18**: FROM sessao_usuario su
- **Linha 19**: WHERE su.id_sessao_usuario = p_id_sessao_usuario;
- **Linha 20**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_contexto_get`(
    IN p_id_sessao_usuario BIGINT
)
BEGIN
    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT
        su.id_sessao_usuario,
        su.id_usuario,
        su.id_sistema,
        su.id_unidade,
        su.id_local_operacional,
        su.ip_acesso,
        su.user_agent,
        su.iniciado_em,
        su.expira_em,
        su.ativo
    FROM sessao_usuario su
    WHERE su.id_sessao_usuario = p_id_sessao_usuario;
END ;;
```

