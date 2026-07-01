# sp_senha_chamar_proxima

Objetivo: senha chamar proxima conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: senha, sessao_usuario
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- IF
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
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: main: BEGIN
- **Linha 8**: Declaracao de variavel local v_id_senha.
- **Linha 9**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: Invoca a procedure sp_sessao_assert.
- **Linha 13**: execucao de query SELECT para consulta de dados.
- **Linha 14**: INTO v_id_usuario
- **Linha 15**: FROM sessao_usuario
- **Linha 16**: WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 18**: START TRANSACTION;
- **Linha 20**: execucao de query SELECT para consulta de dados.
- **Linha 21**: INTO v_id_senha
- **Linha 22**: FROM senha
- **Linha 23**: WHERE status = 'EMITIDA'
- **Linha 25**: ORDER BY prioridade DESC, criada_em ASC
- **Linha 26**: LIMIT 1
- **Linha 27**: FOR UPDATE;
- **Linha 29**: Estrutura condicional de controle de fluxo.
- **Linha 30**: UPDATE senha
- **Linha 31**: atribuicao de valor Ã  variavel status.
- **Linha 32**: id_usuario_chamada = v_id_usuario,
- **Linha 33**: chamada_em = NOW()
- **Linha 34**: WHERE id = v_id_senha;
- **Linha 36**: execucao de query SELECT para consulta de dados.
- **Linha 37**: Estrutura condicional de controle de fluxo.
- **Linha 39**: COMMIT;
- **Linha 41**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_chamar_proxima`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_local_operacional BIGINT
)
    SQL SECURITY INVOKER
main: BEGIN

    DECLARE v_id_senha BIGINT;
    DECLARE v_id_usuario BIGINT;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT id_usuario 
    INTO v_id_usuario
    FROM sessao_usuario 
    WHERE id_sessao_usuario = p_id_sessao_usuario;

    START TRANSACTION;

    SELECT id 
    INTO v_id_senha 
    FROM senha 
    WHERE status = 'EMITIDA'
      AND id_local_operacional = p_id_local_operacional
    ORDER BY prioridade DESC, criada_em ASC
    LIMIT 1
    FOR UPDATE;

    IF v_id_senha IS NOT NULL THEN
        UPDATE senha 
        SET status = 'CHAMANDO',
            id_usuario_chamada = v_id_usuario,
            chamada_em = NOW()
        WHERE id = v_id_senha;

        SELECT * FROM senha WHERE id = v_id_senha;
    END IF;

    COMMIT;

END ;;
```

