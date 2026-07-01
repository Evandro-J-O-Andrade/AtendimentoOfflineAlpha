# sp_ffa_orquestrador_transicao

Objetivo: ffa orquestrador transicao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_ffa | BIGINT | IN | |
| p_estado_atual | VARCHAR(60) | IN | |
| p_evento | VARCHAR(60) | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |
| p_contexto | VARCHAR(50) | IN | |
| p_id_sessao_usuario | BIGINT | IN | |
| p_estado_novo | VARCHAR(60) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: atendimento_evento
- UPDATE: ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_fluxo_executor_matriz
- sp_fluxo_guardiao_transicao

## Functions Utilizadas
- CONCAT
- CURRENT_TIMESTAMP

## Views Utilizadas
- v_estado_destino

## Eventos Gerados
- evento

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: SQL SECURITY INVOKER
- **Linha 13**: inicio do bloco de execucao.
- **Linha 15**: Declaracao de variavel local v_estado_destino.
- **Linha 17**: /* ===============================
- **Linha 18**: 1. RBAC Guardião
- **Linha 19**: =============================== */
- **Linha 21**: Invoca a procedure sp_fluxo_guardiao_transicao.
- **Linha 22**: p_id_usuario,
- **Linha 23**: p_id_sistema,
- **Linha 24**: CONCAT('sp_ffa_orquestrador_transicao'),
- **Linha 25**: p_contexto,
- **Linha 26**: p_id_sessao_usuario
- **Linha 27**: );
- **Linha 29**: /* ===============================
- **Linha 30**: 2. Resolver Matriz
- **Linha 31**: =============================== */
- **Linha 33**: Invoca a procedure sp_fluxo_executor_matriz.
- **Linha 34**: p_estado_atual,
- **Linha 35**: p_evento,
- **Linha 36**: p_id_perfil,
- **Linha 37**: p_contexto,
- **Linha 38**: p_id_sistema,
- **Linha 39**: p_id_sessao_usuario,
- **Linha 40**: v_estado_destino
- **Linha 41**: );
- **Linha 43**: /* ===============================
- **Linha 44**: 3. Atualizar FFA (Estado global)
- **Linha 45**: =============================== */
- **Linha 47**: UPDATE ffa
- **Linha 48**: atribuicao de valor Ã  variavel estado.
- **Linha 49**: atualizado_em = CURRENT_TIMESTAMP(6)
- **Linha 50**: WHERE id_ffa = p_id_ffa;
- **Linha 52**: /* ===============================
- **Linha 53**: 4. Ledger append-only (auditabilidade federal)
- **Linha 54**: =============================== */
- **Linha 56**: Insere um novo registro na tabela atendimento_evento.
- **Linha 57**: id_ffa,
- **Linha 58**: evento,
- **Linha 59**: estado_origem,
- **Linha 60**: estado_destino,
- **Linha 61**: id_usuario,
- **Linha 62**: id_sessao_usuario,
- **Linha 63**: criado_em
- **Linha 64**: fechamento da lista de Parametros.
- **Linha 65**: VALUES(
- **Linha 66**: p_id_ffa,
- **Linha 67**: p_evento,
- **Linha 68**: p_estado_atual,
- **Linha 69**: v_estado_destino,
- **Linha 70**: p_id_usuario,
- **Linha 71**: p_id_sessao_usuario,
- **Linha 72**: CURRENT_TIMESTAMP(6)
- **Linha 73**: );
- **Linha 75**: atribuicao de valor Ã  variavel p_estado_novo.
- **Linha 77**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ffa_orquestrador_transicao`(
    IN p_id_ffa BIGINT,
    IN p_estado_atual VARCHAR(60),
    IN p_evento VARCHAR(60),
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_sistema BIGINT,
    IN p_contexto VARCHAR(50),
    IN p_id_sessao_usuario BIGINT,
    OUT p_estado_novo VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_estado_destino VARCHAR(60);

    /* ===============================
       1. RBAC Guardião
    =============================== */

    CALL sp_fluxo_guardiao_transicao(
        p_id_usuario,
        p_id_sistema,
        CONCAT('sp_ffa_orquestrador_transicao'),
        p_contexto,
        p_id_sessao_usuario
    );

    /* ===============================
       2. Resolver Matriz
    =============================== */

    CALL sp_fluxo_executor_matriz(
        p_estado_atual,
        p_evento,
        p_id_perfil,
        p_contexto,
        p_id_sistema,
        p_id_sessao_usuario,
        v_estado_destino
    );

    /* ===============================
       3. Atualizar FFA (Estado global)
    =============================== */

    UPDATE ffa
    SET estado = v_estado_destino,
        atualizado_em = CURRENT_TIMESTAMP(6)
    WHERE id_ffa = p_id_ffa;

    /* ===============================
       4. Ledger append-only (auditabilidade federal)
    =============================== */

    INSERT INTO atendimento_evento(
        id_ffa,
        evento,
        estado_origem,
        estado_destino,
        id_usuario,
        id_sessao_usuario,
        criado_em
    )
    VALUES(
        p_id_ffa,
        p_evento,
        p_estado_atual,
        v_estado_destino,
        p_id_usuario,
        p_id_sessao_usuario,
        CURRENT_TIMESTAMP(6)
    );

    SET p_estado_novo = v_estado_destino;

END ;;
```

