# sp_runtime_decision_engine

Objetivo: runtime decision engine conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_transicao_solicitada | VARCHAR(60) | IN | |
| p_payload_json | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: atendimento_estado_ativo, sessao_usuario
- INSERT: atendimento_evento_ledger
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- JSON_EXTRACT
- JSON_UNQUOTE
- NOW
- SHA2

## Views Utilizadas
- v_estado_atual
- v_fingerprint

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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Declaracao de variavel local v_id_usuario.
- **Linha 8**: Declaracao de variavel local v_estado_atual.
- **Linha 9**: Declaracao de variavel local v_fingerprint.
- **Linha 11** (Comentario): LAYER 1: GATEKEEPER (Rápido/No-Lock)
- **Linha 12**: Invoca a procedure sp_sessao_assert.
- **Linha 13**: execucao de query SELECT para consulta de dados.
- **Linha 15** (Comentario): LAYER 2: ORCHESTRATOR (Lógica de Workflow)
- **Linha 16** (Comentario): Busca estado atual no Core Imutável
- **Linha 17**: execucao de query SELECT para consulta de dados.
- **Linha 18**: FROM atendimento_estado_ativo
- **Linha 19**: WHERE id_ffa = JSON_UNQUOTE(JSON_EXTRACT(p_payload_json, '$.id_ffa'));
- **Linha 21** (Comentario): LAYER 3: SEMANTIC WORKER (Escrita e Fingerprint)
- **Linha 22** (Comentario): Gerar o Fingerprint Determinístico
- **Linha 23**: atribuicao de valor Ã  variavel v_fingerprint.
- **Linha 25** (Comentario): Gravação no Ledger (Append-Only)
- **Linha 26**: Insere um novo registro na tabela atendimento_evento_ledger.
- **Linha 27**: id_sessao_usuario,
- **Linha 28**: evento,
- **Linha 29**: estado_de,
- **Linha 30**: estado_para,
- **Linha 31**: decision_fingerprint,
- **Linha 32**: payload
- **Linha 33**: ) VALUES (
- **Linha 34**: p_id_sessao_usuario,
- **Linha 35**: p_transicao_solicitada,
- **Linha 36**: v_estado_atual,
- **Linha 37**: 'ESTADO_DESTINO_RESOLVIDO', -- vindo da matriz
- **Linha 38**: v_fingerprint,
- **Linha 39**: p_payload_json
- **Linha 40**: );
- **Linha 41**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_runtime_decision_engine`(
    IN p_id_sessao_usuario BIGINT,
    IN p_transicao_solicitada VARCHAR(60),
    IN p_payload_json JSON
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_estado_atual VARCHAR(60);
    DECLARE v_fingerprint CHAR(64);
    
    -- LAYER 1: GATEKEEPER (Rápido/No-Lock)
    CALL sp_sessao_assert(p_id_sessao_usuario);
    SELECT id_usuario INTO v_id_usuario FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao_usuario;
    
    -- LAYER 2: ORCHESTRATOR (Lógica de Workflow)
    -- Busca estado atual no Core Imutável
    SELECT estado_atual INTO v_estado_atual 
    FROM atendimento_estado_ativo 
    WHERE id_ffa = JSON_UNQUOTE(JSON_EXTRACT(p_payload_json, '$.id_ffa'));

    -- LAYER 3: SEMANTIC WORKER (Escrita e Fingerprint)
    -- Gerar o Fingerprint Determinístico
    SET v_fingerprint = SHA2(CONCAT(v_id_usuario, v_estado_atual, p_transicao_solicitada, NOW(6)), 256);

    -- Gravação no Ledger (Append-Only)
    INSERT INTO atendimento_evento_ledger (
        id_sessao_usuario, 
        evento, 
        estado_de, 
        estado_para, 
        decision_fingerprint,
        payload
    ) VALUES (
        p_id_sessao_usuario, 
        p_transicao_solicitada, 
        v_estado_atual, 
        'ESTADO_DESTINO_RESOLVIDO', -- vindo da matriz
        v_fingerprint,
        p_payload_json
    );
END ;;
```

