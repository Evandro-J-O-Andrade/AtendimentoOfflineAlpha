# sp_dispatcher_kernel

Objetivo: dispatcher kernel conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_tenant | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_sessao | BIGINT | IN | |
| p_worker_type | VARCHAR(50) | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_payload | JSON | IN | |
| p_uuid_execution | CHAR(36) | OUT | |
| p_sucesso | BOOLEAN | OUT | |
| p_mensagem | VARCHAR(500) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: runtime_execution_queue
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_kernel_writer_lock
- sp_kernel_writer_unlock

## Functions Utilizadas
- UUID

## Views Utilizadas
- v_fingerprint
- v_uuid

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: Declaracao de parÃ¢metro.
- **Linha 12**: fechamento da lista de Parametros.
- **Linha 13**: inicio do bloco de execucao.
- **Linha 15**: Declaracao de variavel local v_uuid.
- **Linha 16**: Declaracao de variavel local v_lock.
- **Linha 17**: Declaracao de variavel local v_fingerprint.
- **Linha 19**: atribuicao de valor Ã  variavel v_uuid.
- **Linha 21**: atribuicao de valor Ã  variavel v_fingerprint.
- **Linha 22**: fn_decision_fingerprint(
- **Linha 23**: p_acao,
- **Linha 24**: p_id_tenant,
- **Linha 25**: p_id_usuario,
- **Linha 26**: p_payload
- **Linha 27**: );
- **Linha 29**: Invoca a procedure sp_kernel_writer_lock.
- **Linha 31**: Insere um novo registro na tabela runtime_execution_queue.
- **Linha 32**: (
- **Linha 33**: uuid_transacao,
- **Linha 34**: uuid_execution,
- **Linha 35**: id_tenant,
- **Linha 36**: id_usuario,
- **Linha 37**: id_perfil,
- **Linha 38**: id_sessao,
- **Linha 39**: worker_type,
- **Linha 40**: acao,
- **Linha 41**: payload,
- **Linha 42**: decision_fingerprint,
- **Linha 43**: status
- **Linha 44**: fechamento da lista de Parametros.
- **Linha 45**: VALUES
- **Linha 46**: (
- **Linha 47**: v_uuid,
- **Linha 48**: v_uuid,
- **Linha 49**: p_id_tenant,
- **Linha 50**: p_id_usuario,
- **Linha 51**: p_id_perfil,
- **Linha 52**: p_id_sessao,
- **Linha 53**: p_worker_type,
- **Linha 54**: p_acao,
- **Linha 55**: p_payload,
- **Linha 56**: v_fingerprint,
- **Linha 57**: 'PENDENTE'
- **Linha 58**: );
- **Linha 60**: Invoca a procedure sp_kernel_writer_unlock.
- **Linha 62**: atribuicao de valor Ã  variavel p_uuid_execution.
- **Linha 63**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 64**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 66**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_dispatcher_kernel`(
    IN p_id_tenant BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_sessao BIGINT,
    IN p_worker_type VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_payload JSON,
    OUT p_uuid_execution CHAR(36),
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
BEGIN

    DECLARE v_uuid CHAR(36);
    DECLARE v_lock BIGINT;
    DECLARE v_fingerprint CHAR(64);

    SET v_uuid = UUID();

    SET v_fingerprint =
        fn_decision_fingerprint(
            p_acao,
            p_id_tenant,
            p_id_usuario,
            p_payload
        );

    CALL sp_kernel_writer_lock(v_uuid,v_lock);

    INSERT INTO runtime_execution_queue
    (
        uuid_transacao,
        uuid_execution,
        id_tenant,
        id_usuario,
        id_perfil,
        id_sessao,
        worker_type,
        acao,
        payload,
        decision_fingerprint,
        status
    )
    VALUES
    (
        v_uuid,
        v_uuid,
        p_id_tenant,
        p_id_usuario,
        p_id_perfil,
        p_id_sessao,
        p_worker_type,
        p_acao,
        p_payload,
        v_fingerprint,
        'PENDENTE'
    );

    CALL sp_kernel_writer_unlock(v_lock);

    SET p_uuid_execution = v_uuid;
    SET p_sucesso = TRUE;
    SET p_mensagem = 'EXEC_ENFILEIRADA';

END ;;
```

