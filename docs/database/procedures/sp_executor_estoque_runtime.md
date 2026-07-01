# sp_executor_estoque_runtime

Objetivo: executor estoque runtime conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: almoxarifado_central, farm_operacao, farmacia_estoque_lote, ledger_evento_log, sessao_usuario
- INSERT: farmacia_atendimento_externo_dispensacao, sistema_alerta
- UPDATE: almoxarifado_central, farmacia_estoque_lote
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW
- SIGNAL
- UUID

## Views Utilizadas
- v_quantidade
- v_uuid_transacao

## Eventos Gerados
- evento
- ledger_evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).
- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: main: BEGIN
- **Linha 9** (Comentario): 1. DECLARAÇÕES (Padrão de Segurança)
- **Linha 10**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: Declaracao de variavel local v_id_perfil.
- **Linha 12**: Declaracao de variavel local v_uuid_transacao.
- **Linha 13**: Declaracao de variavel local v_sucesso_interno.
- **Linha 14**: Declaracao de variavel local v_error_msg_final.
- **Linha 16**: Declaracao de variavel local v_quantidade.
- **Linha 17**: Declaracao de variavel local v_id_lote.
- **Linha 18**: Declaracao de variavel local v_id_local.
- **Linha 19**: Declaracao de variavel local v_snapshot_antes.
- **Linha 20**: Declaracao de variavel local v_dupla_baixa.
- **Linha 22** (Comentario): Handler Global: Captura erros e formata a mensagem para o Front
- **Linha 23**: Declaracao de variavel local EXIT.
- **Linha 24**: inicio do bloco de execucao.
- **Linha 25**: GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
- **Linha 26**: ROLLBACK;
- **Linha 27**: atribuicao de valor Ã  variavel v_error_msg_final.
- **Linha 28**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg_final;
- **Linha 29**: Fim do bloco da procedure.
- **Linha 31** (Comentario): 2. CONTEXTO E IDEMPOTÊNCIA
- **Linha 32**: execucao de query SELECT para consulta de dados.
- **Linha 33**: FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao;
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 36**: execucao de query SELECT para consulta de dados.
- **Linha 37**: WHERE id_referencia = p_id_referencia AND acao = p_acao
- **Linha 39**: ) THEN
- **Linha 40**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_IDEMPOTENCIA: Operação já realizada recentemente.';
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 43** (Comentario): 3. ROTEAMENTO DE EIXOS
- **Linha 44**: CASE p_acao
- **Linha 46**: /* =============================================================
- **Linha 47**: EIXO 1: FARMÁCIA (CLÍNICO / PACIENTE)
- **Linha 48**: ============================================================= */
- **Linha 49**: WHEN 'DISPENSAR_MEDICAMENTO' THEN
- **Linha 50**: START TRANSACTION;
- **Linha 51**: atribuicao de valor Ã  variavel v_id_lote.
- **Linha 52**: atribuicao de valor Ã  variavel v_quantidade.
- **Linha 54**: execucao de query SELECT para consulta de dados.
- **Linha 55**: INTO v_snapshot_antes
- **Linha 56**: FROM farmacia_estoque_lote WHERE id = v_id_lote FOR UPDATE;
- **Linha 58**: Estrutura condicional de controle de fluxo.
- **Linha 59**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_INSUFICIENTE_NA_FARMACIA';
- **Linha 60**: Estrutura condicional de controle de fluxo.
- **Linha 62**: execucao de query SELECT para consulta de dados.
- **Linha 64**: Atualiza registros existentes na tabela farmacia_estoque_lote.
- **Linha 66**: Insere um novo registro na tabela farmacia_atendimento_externo_dispensacao.
- **Linha 67**: (id_atendimento, id_lote, quantidade, id_usuario_dispensou, data_dispensacao)
- **Linha 68**: VALUES (p_id_referencia, v_id_lote, v_quantidade, v_id_usuario, NOW());
- **Linha 70**: Estrutura condicional de controle de fluxo.
- **Linha 71** (Comentario): Registro de conferência/dupla checagem conforme regra do banco
- **Linha 72**: Insere um novo registro na tabela farmacia_atendimento_externo_dispensacao.
- **Linha 73**: (id_atendimento, id_lote, quantidade, id_usuario_dispensou, data_dispensacao)
- **Linha 74**: VALUES (p_id_referencia, v_id_lote, v_quantidade, v_id_usuario, NOW());
- **Linha 75**: Estrutura condicional de controle de fluxo.
- **Linha 77**: Invoca a procedure sp_ledger_evento_log.
- **Linha 78**: COMMIT;
- **Linha 79**: atribuicao de valor Ã  variavel v_sucesso_interno.
- **Linha 81**: /* =============================================================
- **Linha 82**: EIXO 2: ALMOXARIFADO CENTRAL (OPERACIONAL)
- **Linha 83**: Uso: Limpeza, EPIs, Papelaria, Manutenção.
- **Linha 84**: ============================================================= */
- **Linha 85**: WHEN 'CONSUMO_ALMOXARIFADO' THEN
- **Linha 86**: START TRANSACTION;
- **Linha 88**: atribuicao de valor Ã  variavel v_id_local.
- **Linha 89**: atribuicao de valor Ã  variavel v_quantidade.
- **Linha 91** (Comentario): Trava e Snapshot (Tabela almoxarifado_central do seu dump)
- **Linha 92**: execucao de query SELECT para consulta de dados.
- **Linha 93**: INTO v_snapshot_antes
- **Linha 94**: FROM almoxarifado_central
- **Linha 95**: WHERE id_item = p_id_referencia AND id_local = v_id_local FOR UPDATE;
- **Linha 97**: Estrutura condicional de controle de fluxo.
- **Linha 98**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_INSUFICIENTE_NO_ALMOXARIFADO';
- **Linha 99**: Estrutura condicional de controle de fluxo.
- **Linha 101** (Comentario): Baixa Operacional
- **Linha 102**: UPDATE almoxarifado_central
- **Linha 103**: atribuicao de valor Ã  variavel quantidade_atual.
- **Linha 104**: WHERE id_item = p_id_referencia AND id_local = v_id_local;
- **Linha 106** (Comentario): Verificação de Nível Crítico (Regra de 100 unidades ou valor da tabela)
- **Linha 107**: Estrutura condicional de controle de fluxo.
- **Linha 108**: Insere um novo registro na tabela sistema_alerta.
- **Linha 109**: VALUES ('ESTOQUE_CRITICO', CONCAT('Item ', p_id_referencia, ' atingiu o estoque mínimo no local ', v_id_local), 'ALTO', NOW());
- **Linha 110**: Estrutura condicional de controle de fluxo.
- **Linha 112**: Invoca a procedure sp_ledger_evento_log.
- **Linha 113**: COMMIT;
- **Linha 114**: atribuicao de valor Ã  variavel v_sucesso_interno.
- **Linha 116**: Estrutura condicional de controle de fluxo.
- **Linha 117**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ACAO_ESTOQUE_DESCONHECIDA';
- **Linha 118**: END CASE;
- **Linha 120**: Estrutura condicional de controle de fluxo.
- **Linha 121**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_FATAL_MOTOR_ESTOQUE';
- **Linha 122**: Estrutura condicional de controle de fluxo.
- **Linha 124**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_estoque_runtime`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT, -- ID do Item ou Atendimento
    IN p_payload JSON
)
    SQL SECURITY INVOKER
main: BEGIN
    -- 1. DECLARAÇÕES (Padrão de Segurança)
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_sucesso_interno BOOLEAN DEFAULT FALSE;
    DECLARE v_error_msg_final TEXT;

    DECLARE v_quantidade DECIMAL(10,3);
    DECLARE v_id_lote INT;
    DECLARE v_id_local INT;
    DECLARE v_snapshot_antes JSON;
    DECLARE v_dupla_baixa TINYINT DEFAULT 0;

    -- Handler Global: Captura erros e formata a mensagem para o Front
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        SET v_error_msg_final = CONCAT('MOTOR_ESTOQUE_FALHA: ', @msg);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg_final;
    END;

    -- 2. CONTEXTO E IDEMPOTÊNCIA
    SELECT id_usuario, id_perfil INTO v_id_usuario, v_id_perfil
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao;

    IF EXISTS (
        SELECT 1 FROM ledger_evento_log
        WHERE id_referencia = p_id_referencia AND acao = p_acao
          AND status = 'SUCESSO' AND criado_em > NOW() - INTERVAL 1 MINUTE
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_IDEMPOTENCIA: Operação já realizada recentemente.';
    END IF;

    -- 3. ROTEAMENTO DE EIXOS
    CASE p_acao

        /* =============================================================
           EIXO 1: FARMÁCIA (CLÍNICO / PACIENTE)
        ============================================================= */
        WHEN 'DISPENSAR_MEDICAMENTO' THEN
            START TRANSACTION;
            SET v_id_lote = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_lote'));
            SET v_quantidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.quantidade'));

            SELECT JSON_OBJECT('saldo', quantidade_atual, 'lote', numero_lote)
            INTO v_snapshot_antes
            FROM farmacia_estoque_lote WHERE id = v_id_lote FOR UPDATE;

            IF (JSON_EXTRACT(v_snapshot_antes, '$.saldo') < v_quantidade) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_INSUFICIENTE_NA_FARMACIA';
            END IF;

            SELECT dupla_baixa INTO v_dupla_baixa FROM farm_operacao WHERE id_lote = v_id_lote LIMIT 1;

            UPDATE farmacia_estoque_lote SET quantidade_atual = quantidade_atual - v_quantidade WHERE id = v_id_lote;

            INSERT INTO farmacia_atendimento_externo_dispensacao
                (id_atendimento, id_lote, quantidade, id_usuario_dispensou, data_dispensacao)
            VALUES (p_id_referencia, v_id_lote, v_quantidade, v_id_usuario, NOW());

            IF v_dupla_baixa = 1 THEN
                -- Registro de conferência/dupla checagem conforme regra do banco
                INSERT INTO farmacia_atendimento_externo_dispensacao
                    (id_atendimento, id_lote, quantidade, id_usuario_dispensou, data_dispensacao)
                VALUES (p_id_referencia, v_id_lote, v_quantidade, v_id_usuario, NOW());
            END IF;

            CALL sp_ledger_evento_log(v_uuid_transacao, v_id_usuario, v_id_perfil, p_acao, v_snapshot_antes, 'EXECUTADO', p_payload, 'SUCESSO', 'Baixa Farmácia concluída');
            COMMIT;
            SET v_sucesso_interno = TRUE;

        /* =============================================================
           EIXO 2: ALMOXARIFADO CENTRAL (OPERACIONAL)
           Uso: Limpeza, EPIs, Papelaria, Manutenção.
        ============================================================= */
        WHEN 'CONSUMO_ALMOXARIFADO' THEN
            START TRANSACTION;
            
            SET v_id_local = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_local')); -- Ex: Central, Setor A, Copa
            SET v_quantidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.quantidade'));

            -- Trava e Snapshot (Tabela almoxarifado_central do seu dump)
            SELECT JSON_OBJECT('saldo', quantidade_atual, 'minimo', quantidade_minima)
            INTO v_snapshot_antes
            FROM almoxarifado_central 
            WHERE id_item = p_id_referencia AND id_local = v_id_local FOR UPDATE;

            IF (JSON_EXTRACT(v_snapshot_antes, '$.saldo') < v_quantidade) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_INSUFICIENTE_NO_ALMOXARIFADO';
            END IF;

            -- Baixa Operacional
            UPDATE almoxarifado_central 
            SET quantidade_atual = quantidade_atual - v_quantidade 
            WHERE id_item = p_id_referencia AND id_local = v_id_local;

            -- Verificação de Nível Crítico (Regra de 100 unidades ou valor da tabela)
            IF (SELECT quantidade_atual FROM almoxarifado_central WHERE id_item = p_id_referencia AND id_local = v_id_local) <= JSON_EXTRACT(v_snapshot_antes, '$.minimo') THEN
                INSERT INTO sistema_alerta (tipo, mensagem, nivel, criado_em)
                VALUES ('ESTOQUE_CRITICO', CONCAT('Item ', p_id_referencia, ' atingiu o estoque mínimo no local ', v_id_local), 'ALTO', NOW());
            END IF;

            CALL sp_ledger_evento_log(v_uuid_transacao, v_id_usuario, v_id_perfil, p_acao, v_snapshot_antes, 'EXECUTADO', p_payload, 'SUCESSO', 'Consumo almoxarifado registrado');
            COMMIT;
            SET v_sucesso_interno = TRUE;

        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ACAO_ESTOQUE_DESCONHECIDA';
    END CASE;

    IF NOT v_sucesso_interno THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_FATAL_MOTOR_ESTOQUE';
    END IF;

END ;;
```

