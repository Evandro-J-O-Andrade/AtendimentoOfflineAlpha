# sp_senha_chamar_setor

Objetivo: senha chamar setor conforme definida no dump SQL do sistema.

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
- v_status

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
- **Linha 7**: Declaracao de variavel local v_id_usuario.
- **Linha 8**: Declaracao de variavel local v_id_local.
- **Linha 9**: Declaracao de variavel local v_status.
- **Linha 11** (Comentario): 1️⃣ Valida sessão
- **Linha 12**: Invoca a procedure sp_sessao_assert.
- **Linha 14** (Comentario): 2️⃣ Obtém contexto da sessão
- **Linha 15**: execucao de query SELECT para consulta de dados.
- **Linha 16**: INTO v_id_usuario, v_id_local
- **Linha 17**: FROM sessao_usuario
- **Linha 18**: WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 20** (Comentario): 3️⃣ Obtém status atual da senha
- **Linha 21**: execucao de query SELECT para consulta de dados.
- **Linha 22**: INTO v_status
- **Linha 23**: FROM senha
- **Linha 24**: WHERE id = p_id_senha
- **Linha 26**: FOR UPDATE;
- **Linha 28** (Comentario): 4️⃣ Só permite chamar se estiver EMITIDA ou NAO_COMPARECEU
- **Linha 29**: Estrutura condicional de controle de fluxo.
- **Linha 31**: UPDATE senha
- **Linha 32**: atribuicao de valor Ã  variavel status.
- **Linha 33**: id_usuario_chamada = v_id_usuario,
- **Linha 34**: chamada_em = NOW()
- **Linha 35**: WHERE id = p_id_senha;
- **Linha 37**: Estrutura condicional de controle de fluxo.
- **Linha 39**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_chamar_setor`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
    SQL SECURITY INVOKER
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_status VARCHAR(30);

    -- 1️⃣ Valida sessão
    CALL sp_sessao_assert(p_id_sessao_usuario);

    -- 2️⃣ Obtém contexto da sessão
    SELECT id_usuario, id_local_operacional
    INTO v_id_usuario, v_id_local
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao_usuario;

    -- 3️⃣ Obtém status atual da senha
    SELECT status
    INTO v_status
    FROM senha
    WHERE id = p_id_senha
      AND id_local_operacional = v_id_local
    FOR UPDATE;

    -- 4️⃣ Só permite chamar se estiver EMITIDA ou NAO_COMPARECEU
    IF v_status IN ('EMITIDA','NAO_COMPARECEU') THEN

        UPDATE senha
        SET status = 'CHAMANDO',
            id_usuario_chamada = v_id_usuario,
            chamada_em = NOW()
        WHERE id = p_id_senha;

    END IF;

END ;;
```

