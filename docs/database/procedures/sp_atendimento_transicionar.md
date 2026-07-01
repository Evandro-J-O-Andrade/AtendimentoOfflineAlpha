# sp_atendimento_transicionar

Objetivo: atendimento transicionar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_estado_destino | VARCHAR(60) | IN | |
| p_uuid_transacao | CHAR(64) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: atendimento_estado_ativo, atendimento_transicao_ledger
- INSERT: atendimento_transicao_ledger
- UPDATE: atendimento_estado_ativo
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- NOW
- SHA2

## Views Utilizadas
- v_estado_origem
- v_hash

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: proc_main: BEGIN
- **Linha 9**: Declaracao de variavel local v_estado_origem.
- **Linha 10**: Declaracao de variavel local v_hash.
- **Linha 12**: Invoca a procedure sp_sessao_assert.
- **Linha 14**: START TRANSACTION;
- **Linha 16**: /* ===============================
- **Linha 17**: Idempotência runtime
- **Linha 18**: =============================== */
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 21**: execucao de query SELECT para consulta de dados.
- **Linha 22**: FROM atendimento_transicao_ledger
- **Linha 23**: WHERE uuid_transacao = p_uuid_transacao
- **Linha 24**: LIMIT 1
- **Linha 25**: ) THEN
- **Linha 27**: COMMIT;
- **Linha 29**: Estrutura de repeticao/controle de loop.
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 33**: /* Estado atual */
- **Linha 34**: execucao de query SELECT para consulta de dados.
- **Linha 35**: INTO v_estado_origem
- **Linha 36**: FROM atendimento_estado_ativo
- **Linha 37**: WHERE id_sessao_usuario = p_id_sessao_usuario
- **Linha 38**: LIMIT 1;
- **Linha 40**: /* Fingerprint da decisão */
- **Linha 41**: atribuicao de valor Ã  variavel v_hash.
- **Linha 42**: CONCAT(
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 47**: ),
- **Linha 48**: 256
- **Linha 49**: );
- **Linha 51**: /* Ledger clínico */
- **Linha 52**: Insere um novo registro na tabela atendimento_transicao_ledger.
- **Linha 53**: (
- **Linha 54**: uuid_transacao,
- **Linha 55**: estado_origem,
- **Linha 56**: estado_destino,
- **Linha 57**: fingerprint_hash
- **Linha 58**: fechamento da lista de Parametros.
- **Linha 59**: VALUES
- **Linha 60**: (
- **Linha 61**: p_uuid_transacao,
- **Linha 62**: v_estado_origem,
- **Linha 63**: p_estado_destino,
- **Linha 64**: v_hash
- **Linha 65**: );
- **Linha 67**: /* Estado assistencial */
- **Linha 68**: UPDATE atendimento_estado_ativo
- **Linha 69**: atribuicao de valor Ã  variavel estado.
- **Linha 70**: atualizado_em = NOW(6)
- **Linha 71**: WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 73**: COMMIT;
- **Linha 75**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atendimento_transicionar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_estado_destino VARCHAR(60),
    IN p_uuid_transacao CHAR(64)
)
    SQL SECURITY INVOKER
proc_main: BEGIN

    DECLARE v_estado_origem VARCHAR(60);
    DECLARE v_hash CHAR(64);

    CALL sp_sessao_assert(p_id_sessao_usuario);

    START TRANSACTION;

    /* ===============================
       Idempotência runtime
    =============================== */

    IF EXISTS (
        SELECT 1
        FROM atendimento_transicao_ledger
        WHERE uuid_transacao = p_uuid_transacao
        LIMIT 1
    ) THEN

        COMMIT;

        LEAVE proc_main;

    END IF;

    /* Estado atual */
    SELECT estado
    INTO v_estado_origem
    FROM atendimento_estado_ativo
    WHERE id_sessao_usuario = p_id_sessao_usuario
    LIMIT 1;

    /* Fingerprint da decisão */
    SET v_hash = SHA2(
        CONCAT(
            IFNULL(v_estado_origem,''),
            IFNULL(p_estado_destino,''),
            IFNULL(p_id_sessao_usuario,''),
            IFNULL(p_uuid_transacao,'')
        ),
        256
    );

    /* Ledger clínico */
    INSERT INTO atendimento_transicao_ledger
    (
        uuid_transacao,
        estado_origem,
        estado_destino,
        fingerprint_hash
    )
    VALUES
    (
        p_uuid_transacao,
        v_estado_origem,
        p_estado_destino,
        v_hash
    );

    /* Estado assistencial */
    UPDATE atendimento_estado_ativo
    SET estado = p_estado_destino,
        atualizado_em = NOW(6)
    WHERE id_sessao_usuario = p_id_sessao_usuario;

    COMMIT;

END ;;
```

