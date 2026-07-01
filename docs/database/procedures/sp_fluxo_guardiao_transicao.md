# sp_fluxo_guardiao_transicao

Objetivo: fluxo guardiao transicao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |
| p_contexto | VARCHAR(50) | IN | |
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_ffa | BIGINT | IN | |
| p_evento | VARCHAR(60) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: assistencial_evento_hash, tombstone_evento_assistencial, vw_usuario_permissoes
- INSERT: assistencial_evento_hash, auditoria_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- INTERNO
- sp_checkpoint_global_validar

## Functions Utilizadas
- CONCAT
- COUNT
- IF
- SHA2
- SIGNAL

## Views Utilizadas
- v_fingerprint
- vw_usuario_permissoes

## Eventos Gerados
- auditoria_evento
- evento

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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: SQL SECURITY INVOKER
- **Linha 11**: inicio do bloco de execucao.
- **Linha 13**: Declaracao de variavel local v_permitido.
- **Linha 14**: Declaracao de variavel local v_tombstone.
- **Linha 15**: Declaracao de variavel local v_hash_existente.
- **Linha 16**: Declaracao de variavel local v_fingerprint.
- **Linha 18**: /* =====================================================
- **Linha 19**: RBAC CENTRAL
- **Linha 20**: ===================================================== */
- **Linha 22**: execucao de query SELECT para consulta de dados.
- **Linha 23**: INTO v_permitido
- **Linha 24**: FROM vw_usuario_permissoes vp
- **Linha 25**: WHERE vp.id_usuario = p_id_usuario
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 31**: SIGNAL SQLSTATE '45000'
- **Linha 32**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 33**: Estrutura condicional de controle de fluxo.
- **Linha 35**: /* =====================================================
- **Linha 36**: TOMBSTONE ASSISTENCIAL
- **Linha 37**: ===================================================== */
- **Linha 39**: execucao de query SELECT para consulta de dados.
- **Linha 40**: INTO v_tombstone
- **Linha 41**: FROM tombstone_evento_assistencial
- **Linha 42**: WHERE id_ffa = p_id_ffa
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 46**: SIGNAL SQLSTATE '45000'
- **Linha 47**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 50**: /* =====================================================
- **Linha 51**: HASH ASSISTENCIAL (IDEMPOTÊNCIA FORTE)
- **Linha 52**: ===================================================== */
- **Linha 54**: atribuicao de valor Ã  variavel v_fingerprint.
- **Linha 55**: CONCAT(
- **Linha 56**: p_id_ffa,
- **Linha 57**: '|',
- **Linha 58**: p_evento,
- **Linha 59**: '|',
- **Linha 60**: p_id_usuario
- **Linha 61**: ),
- **Linha 62**: 256
- **Linha 63**: );
- **Linha 65**: execucao de query SELECT para consulta de dados.
- **Linha 66**: INTO v_hash_existente
- **Linha 67**: FROM assistencial_evento_hash
- **Linha 68**: WHERE hash_fingerprint = v_fingerprint;
- **Linha 70**: Estrutura condicional de controle de fluxo.
- **Linha 71**: SIGNAL SQLSTATE '45000'
- **Linha 72**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 73**: Estrutura condicional de controle de fluxo.
- **Linha 75**: Insere um novo registro na tabela assistencial_evento_hash.
- **Linha 76**: hash_fingerprint,
- **Linha 77**: id_ffa,
- **Linha 78**: evento
- **Linha 79**: fechamento da lista de Parametros.
- **Linha 80**: VALUES(
- **Linha 81**: v_fingerprint,
- **Linha 82**: p_id_ffa,
- **Linha 83**: p_evento
- **Linha 84**: );
- **Linha 86**: /* =====================================================
- **Linha 87**: CHECKPOINT GLOBAL (CALL INTERNO)
- **Linha 88**: ===================================================== */
- **Linha 90**: Invoca a procedure sp_checkpoint_global_validar.
- **Linha 91**: p_id_ffa,
- **Linha 92**: p_evento,
- **Linha 93**: p_id_sessao_usuario
- **Linha 94**: );
- **Linha 96**: /* =====================================================
- **Linha 97**: OBSERVABILIDADE OPERACIONAL (BEST EFFORT)
- **Linha 98**: ===================================================== */
- **Linha 100**: Insere um novo registro na tabela auditoria_evento.
- **Linha 101**: id_sessao_usuario,
- **Linha 102**: evento,
- **Linha 103**: sucesso,
- **Linha 104**: descricao
- **Linha 105**: fechamento da lista de Parametros.
- **Linha 106**: VALUES(
- **Linha 107**: p_id_sessao_usuario,
- **Linha 108**: 'GUARDIAO_OK',
- **Linha 109**: 1,
- **Linha 110**: CONCAT(
- **Linha 111**: 'Procedure=',p_nome_procedure,
- **Linha 112**: '|Contexto=',p_contexto
- **Linha 113**: fechamento da lista de Parametros.
- **Linha 114**: );
- **Linha 116**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_guardiao_transicao`(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_nome_procedure VARCHAR(150),
    IN p_contexto VARCHAR(50),
    IN p_id_sessao_usuario BIGINT,
    IN p_id_ffa BIGINT,
    IN p_evento VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_permitido INT DEFAULT 0;
    DECLARE v_tombstone INT DEFAULT 0;
    DECLARE v_hash_existente INT DEFAULT 0;
    DECLARE v_fingerprint CHAR(64);

    /* =====================================================
       RBAC CENTRAL
    ===================================================== */

    SELECT COUNT(1)
    INTO v_permitido
    FROM vw_usuario_permissoes vp
    WHERE vp.id_usuario = p_id_usuario
      AND vp.id_sistema = p_id_sistema
      AND vp.nome_procedure = p_nome_procedure
      AND vp.permitido = 1;

    IF v_permitido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Acesso negado pelo guardião de fluxo';
    END IF;

    /* =====================================================
       TOMBSTONE ASSISTENCIAL
    ===================================================== */

    SELECT COUNT(1)
    INTO v_tombstone
    FROM tombstone_evento_assistencial
    WHERE id_ffa = p_id_ffa
    AND evento = p_evento;

    IF v_tombstone > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Evento bloqueado por tombstone assistencial';
    END IF;

    /* =====================================================
       HASH ASSISTENCIAL (IDEMPOTÊNCIA FORTE)
    ===================================================== */

    SET v_fingerprint = SHA2(
        CONCAT(
            p_id_ffa,
            '|',
            p_evento,
            '|',
            p_id_usuario
        ),
        256
    );

    SELECT COUNT(1)
    INTO v_hash_existente
    FROM assistencial_evento_hash
    WHERE hash_fingerprint = v_fingerprint;

    IF v_hash_existente > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Evento bloqueado por idempotência assistencial';
    END IF;

    INSERT INTO assistencial_evento_hash(
        hash_fingerprint,
        id_ffa,
        evento
    )
    VALUES(
        v_fingerprint,
        p_id_ffa,
        p_evento
    );

    /* =====================================================
       CHECKPOINT GLOBAL (CALL INTERNO)
    ===================================================== */

    CALL sp_checkpoint_global_validar(
        p_id_ffa,
        p_evento,
        p_id_sessao_usuario
    );

    /* =====================================================
       OBSERVABILIDADE OPERACIONAL (BEST EFFORT)
    ===================================================== */

    INSERT INTO auditoria_evento(
        id_sessao_usuario,
        evento,
        sucesso,
        descricao
    )
    VALUES(
        p_id_sessao_usuario,
        'GUARDIAO_OK',
        1,
        CONCAT(
            'Procedure=',p_nome_procedure,
            '|Contexto=',p_contexto
        )
    );

END ;;
```

