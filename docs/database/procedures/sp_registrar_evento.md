# sp_registrar_evento

Objetivo: registrar evento conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_uuid_transacao_pai | CHAR(36) | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_sessao | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_nome_usuario | VARCHAR(100) | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_modulo | VARCHAR(50) | IN | |
| p_sub_modulo | VARCHAR(50) | IN | |
| p_estado_origem | VARCHAR(50) | IN | |
| p_estado_destino | VARCHAR(50) | IN | |
| p_estado_anterior | JSON | IN | |
| p_estado_novo | JSON | IN | |
| p_payload_original | JSON | IN | |
| p_status_evento | ENUM('SUCESSO', 'ERRO', 'AVISO', 'CANCELADO', 'ROLLBACK') | IN | |
| p_codigo_erro | VARCHAR(50) | IN | |
| p_mensagem | VARCHAR(1000) | IN | |
| p_processing_time_ms | INT | IN | |
| p_uuid_transacao | CHAR(36) | OUT | |
| p_id_evento | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: atendimento_evento_ledger
- INSERT: atendimento_evento_ledger
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COALESCE
- LAST_INSERT_ID
- MAX
- NOW
- UUID

## Views Utilizadas
- v_uuid

## Eventos Gerados
- evento

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
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
- **Linha 12**: Declaracao de parÃ¢metro.
- **Linha 13**: Declaracao de parÃ¢metro.
- **Linha 14**: Declaracao de parÃ¢metro.
- **Linha 15**: Declaracao de parÃ¢metro.
- **Linha 16**: Declaracao de parÃ¢metro.
- **Linha 17**: Declaracao de parÃ¢metro.
- **Linha 18**: Declaracao de parÃ¢metro.
- **Linha 19**: Declaracao de parÃ¢metro.
- **Linha 20**: Declaracao de parÃ¢metro.
- **Linha 21**: fechamento da lista de Parametros.
- **Linha 22**: inicio do bloco de execucao.
- **Linha 23**: Declaracao de variavel local v_uuid.
- **Linha 24**: Declaracao de variavel local v_sequencia.
- **Linha 26**: execucao de query SELECT para consulta de dados.
- **Linha 27**: FROM atendimento_evento_ledger
- **Linha 28**: WHERE uuid_transacao = v_uuid;
- **Linha 30**: Insere um novo registro na tabela atendimento_evento_ledger.
- **Linha 31**: uuid_transacao, uuid_transacao_pai, sequencia_evento, id_usuario, id_sessao,
- **Linha 32**: id_perfil, nome_usuario, acao, modulo, sub_modulo, estado_origem,
- **Linha 33**: estado_destino, estado_anterior, estado_novo, payload_original,
- **Linha 34**: status_evento, codigo_erro, mensagem, processing_time_ms, created_at
- **Linha 35**: ) VALUES (
- **Linha 36**: v_uuid, p_uuid_transacao_pai, v_sequencia, p_id_usuario, p_id_sessao,
- **Linha 37**: p_id_perfil, p_nome_usuario, p_acao, p_modulo, p_sub_modulo, p_estado_origem,
- **Linha 38**: p_estado_destino, p_estado_anterior, p_estado_novo, p_payload_original,
- **Linha 39**: p_status_evento, p_codigo_erro, p_mensagem, p_processing_time_ms, NOW(6)
- **Linha 40**: );
- **Linha 42**: atribuicao de valor Ã  variavel p_uuid_transacao.
- **Linha 43**: atribuicao de valor Ã  variavel p_id_evento.
- **Linha 44**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_evento`(
    IN p_uuid_transacao_pai CHAR(36),
    IN p_id_usuario BIGINT,
    IN p_id_sessao BIGINT,
    IN p_id_perfil BIGINT,
    IN p_nome_usuario VARCHAR(100),
    IN p_acao VARCHAR(100),
    IN p_modulo VARCHAR(50),
    IN p_sub_modulo VARCHAR(50),
    IN p_estado_origem VARCHAR(50),
    IN p_estado_destino VARCHAR(50),
    IN p_estado_anterior JSON,
    IN p_estado_novo JSON,
    IN p_payload_original JSON,
    IN p_status_evento ENUM('SUCESSO', 'ERRO', 'AVISO', 'CANCELADO', 'ROLLBACK'),
    IN p_codigo_erro VARCHAR(50),
    IN p_mensagem VARCHAR(1000),
    IN p_processing_time_ms INT,
    OUT p_uuid_transacao CHAR(36),
    OUT p_id_evento BIGINT
)
BEGIN
    DECLARE v_uuid CHAR(36) DEFAULT UUID();
    DECLARE v_sequencia INT DEFAULT 1;

    SELECT COALESCE(MAX(sequencia_evento), 0) + 1 INTO v_sequencia 
    FROM atendimento_evento_ledger 
    WHERE uuid_transacao = v_uuid;

    INSERT INTO atendimento_evento_ledger (
        uuid_transacao, uuid_transacao_pai, sequencia_evento, id_usuario, id_sessao, 
        id_perfil, nome_usuario, acao, modulo, sub_modulo, estado_origem, 
        estado_destino, estado_anterior, estado_novo, payload_original, 
        status_evento, codigo_erro, mensagem, processing_time_ms, created_at
    ) VALUES (
        v_uuid, p_uuid_transacao_pai, v_sequencia, p_id_usuario, p_id_sessao, 
        p_id_perfil, p_nome_usuario, p_acao, p_modulo, p_sub_modulo, p_estado_origem, 
        p_estado_destino, p_estado_anterior, p_estado_novo, p_payload_original, 
        p_status_evento, p_codigo_erro, p_mensagem, p_processing_time_ms, NOW(6)
    );

    SET p_uuid_transacao = v_uuid;
    SET p_id_evento = LAST_INSERT_ID();
END ;;
```

