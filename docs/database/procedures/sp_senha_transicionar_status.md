# sp_senha_transicionar_status

Objetivo: senha transicionar status conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_codigo_status_destino | VARCHAR(30) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: senha, senha_status, senha_transicao_matriz, sessao_usuario
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- COUNT
- IF
- NOW
- SIGNAL

## Views Utilizadas
- (nenhuma)

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_id_usuario.
- **Linha 9**: Declaracao de variavel local v_id_local.
- **Linha 10**: Declaracao de variavel local v_id_status_atual.
- **Linha 11**: Declaracao de variavel local v_id_status_destino.
- **Linha 12**: Declaracao de variavel local v_permitido.
- **Linha 14** (Comentario): Valida sessão
- **Linha 15**: Invoca a procedure sp_sessao_assert.
- **Linha 17**: execucao de query SELECT para consulta de dados.
- **Linha 18**: INTO v_id_usuario, v_id_local
- **Linha 19**: FROM sessao_usuario
- **Linha 20**: WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 22** (Comentario): Status atual
- **Linha 23**: execucao de query SELECT para consulta de dados.
- **Linha 24**: INTO v_id_status_atual
- **Linha 25**: FROM senha sn
- **Linha 26**: JOIN senha_status s ON s.codigo = sn.status
- **Linha 27**: WHERE sn.id = p_id_senha
- **Linha 29**: FOR UPDATE;
- **Linha 31** (Comentario): Status destino
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: INTO v_id_status_destino
- **Linha 34**: FROM senha_status
- **Linha 35**: WHERE codigo = p_codigo_status_destino;
- **Linha 37** (Comentario): Verifica matriz
- **Linha 38**: execucao de query SELECT para consulta de dados.
- **Linha 39**: INTO v_permitido
- **Linha 40**: FROM senha_transicao_matriz
- **Linha 41**: WHERE id_status_origem = v_id_status_atual
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 47**: UPDATE senha
- **Linha 48**: atribuicao de valor Ã  variavel status.
- **Linha 49**: id_usuario_ultima_acao = v_id_usuario,
- **Linha 50**: atualizado_em = NOW()
- **Linha 51**: WHERE id = p_id_senha;
- **Linha 53**: Estrutura condicional de controle de fluxo.
- **Linha 54**: SIGNAL SQLSTATE '45000'
- **Linha 55**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_transicionar_status`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT,
    IN p_codigo_status_destino VARCHAR(30)
)
    SQL SECURITY INVOKER
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_status_atual BIGINT;
    DECLARE v_id_status_destino BIGINT;
    DECLARE v_permitido INT;

    -- Valida sessão
    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT id_usuario, id_local_operacional
    INTO v_id_usuario, v_id_local
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao_usuario;

    -- Status atual
    SELECT s.id_senha_status
    INTO v_id_status_atual
    FROM senha sn
    JOIN senha_status s ON s.codigo = sn.status
    WHERE sn.id = p_id_senha
      AND sn.id_local_operacional = v_id_local
    FOR UPDATE;

    -- Status destino
    SELECT id_senha_status
    INTO v_id_status_destino
    FROM senha_status
    WHERE codigo = p_codigo_status_destino;

    -- Verifica matriz
    SELECT COUNT(*)
    INTO v_permitido
    FROM senha_transicao_matriz
    WHERE id_status_origem = v_id_status_atual
      AND id_status_destino = v_id_status_destino
      AND ativo = 1;

    IF v_permitido = 1 THEN

        UPDATE senha
        SET status = p_codigo_status_destino,
            id_usuario_ultima_acao = v_id_usuario,
            atualizado_em = NOW()
        WHERE id = p_id_senha;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transição de status não permitida';
    END IF;

END ;;
```

