# sp_senha_iniciar_complementacao

Objetivo: senha iniciar complementacao conforme definida no dump SQL do sistema.

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
- SELECT: sessao_usuario
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
- **Linha 8**: Declaracao de variavel local v_id_usuario.
- **Linha 10**: Invoca a procedure sp_sessao_assert.
- **Linha 12**: execucao de query SELECT para consulta de dados.
- **Linha 13**: INTO v_id_usuario
- **Linha 14**: FROM sessao_usuario
- **Linha 15**: WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 17**: UPDATE senha
- **Linha 18**: atribuicao de valor Ã  variavel status.
- **Linha 19**: id_usuario_operador = v_id_usuario,
- **Linha 20**: inicio_atendimento_em = NOW()
- **Linha 21**: WHERE id = p_id_senha;
- **Linha 23**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_iniciar_complementacao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_usuario BIGINT;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT id_usuario
    INTO v_id_usuario
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao_usuario;

    UPDATE senha 
    SET status = 'EM_ATENDIMENTO',
        id_usuario_operador = v_id_usuario,
        inicio_atendimento_em = NOW()
    WHERE id = p_id_senha;

END ;;
```

