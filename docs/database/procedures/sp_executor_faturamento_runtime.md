# sp_executor_faturamento_runtime

Objetivo: executor faturamento runtime conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fat_conta_hospitalar, sessao_usuario
- INSERT: fat_conta_hospitalar, fat_conta_itens, fat_conta_procedimentos
- UPDATE: fat_conta_hospitalar
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- LAST_INSERT_ID
- NOW
- SIGNAL
- UUID

## Views Utilizadas
- v_uuid_transacao
- v_valor_total

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
- **Linha 9** (Comentario): 1. DECLARAÇÕES TÉCNICAS
- **Linha 10**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: Declaracao de variavel local v_id_perfil.
- **Linha 12**: Declaracao de variavel local v_uuid_transacao.
- **Linha 13**: Declaracao de variavel local v_sucesso_interno.
- **Linha 14**: Declaracao de variavel local v_error_msg_final.
- **Linha 16**: Declaracao de variavel local v_snapshot_antes.
- **Linha 17**: Declaracao de variavel local v_id_conta_hospitalar.
- **Linha 18**: Declaracao de variavel local v_valor_total.
- **Linha 20** (Comentario): Handler Global de Erro
- **Linha 21**: Declaracao de variavel local EXIT.
- **Linha 22**: inicio do bloco de execucao.
- **Linha 23**: GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
- **Linha 24**: ROLLBACK;
- **Linha 25**: atribuicao de valor Ã  variavel v_error_msg_final.
- **Linha 26**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg_final;
- **Linha 27**: Fim do bloco da procedure.
- **Linha 29** (Comentario): 2. CONTEXTO
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao;
- **Linha 33** (Comentario): 3. LOCALIZA OU CRIA CONTA HOSPITALAR (Vínculo com Atendimento)
- **Linha 34** (Comentario): Tentamos pegar a conta ativa para este atendimento
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: FROM fat_conta_hospitalar
- **Linha 37**: WHERE id_atendimento = p_id_referencia AND status = 'ABERTA' LIMIT 1;
- **Linha 39** (Comentario): Se não existir, a gente provisiona uma nova conta
- **Linha 40**: Estrutura condicional de controle de fluxo.
- **Linha 41**: Insere um novo registro na tabela fat_conta_hospitalar.
- **Linha 42**: VALUES (p_id_referencia, 'ABERTA', NOW(), v_id_usuario);
- **Linha 43**: atribuicao de valor Ã  variavel v_id_conta_hospitalar.
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 46** (Comentario): 4. INÍCIO DA TRANSAÇÃO
- **Linha 47**: START TRANSACTION;
- **Linha 49** (Comentario): Capturamos o saldo atual da conta para o Snapshot
- **Linha 50**: execucao de query SELECT para consulta de dados.
- **Linha 51**: INTO v_snapshot_antes
- **Linha 52**: FROM fat_conta_hospitalar WHERE id_conta = v_id_conta_hospitalar FOR UPDATE;
- **Linha 54** (Comentario): 5. ROTEAMENTO FINANCEIRO
- **Linha 55**: CASE p_acao
- **Linha 57** (Comentario): LANÇAR ITEM (Vindo da Farmácia ou Almoxarifado)
- **Linha 58**: WHEN 'LANCAR_CONSUMO' THEN
- **Linha 59**: atribuicao de valor Ã  variavel v_valor_total.
- **Linha 61**: Insere um novo registro na tabela fat_conta_itens.
- **Linha 62**: VALUES (
- **Linha 63**: v_id_conta_hospitalar,
- **Linha 64**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_item')),
- **Linha 65**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo')),
- **Linha 66**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.qtd')),
- **Linha 67**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.valor_un')),
- **Linha 68**: v_valor_total,
- **Linha 69**: NOW()
- **Linha 70**: );
- **Linha 72** (Comentario): Atualiza o total da conta
- **Linha 73**: UPDATE fat_conta_hospitalar
- **Linha 74**: atribuicao de valor Ã  variavel total_acumulado.
- **Linha 75**: WHERE id_conta = v_id_conta_hospitalar;
- **Linha 77**: atribuicao de valor Ã  variavel v_sucesso_interno.
- **Linha 79** (Comentario): LANÇAR TAXA / HONORÁRIO (Vindo da Fila/Atendimento Médico)
- **Linha 80**: WHEN 'LANCAR_PROCEDIMENTO' THEN
- **Linha 81** (Comentario): Lógica para Tabela TUSS/Honorários
- **Linha 82**: Insere um novo registro na tabela fat_conta_procedimentos.
- **Linha 83**: VALUES (
- **Linha 84**: v_id_conta_hospitalar,
- **Linha 85**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_procedimento')),
- **Linha 86**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.valor')),
- **Linha 87**: NOW()
- **Linha 88**: );
- **Linha 90**: UPDATE fat_conta_hospitalar
- **Linha 91**: atribuicao de valor Ã  variavel total_acumulado.
- **Linha 92**: WHERE id_conta = v_id_conta_hospitalar;
- **Linha 94**: atribuicao de valor Ã  variavel v_sucesso_interno.
- **Linha 96** (Comentario): FECHAR CONTA PARA AUDITORIA
- **Linha 97**: WHEN 'FECHAR_CONTA' THEN
- **Linha 98**: Atualiza registros existentes na tabela fat_conta_hospitalar.
- **Linha 99**: WHERE id_conta = v_id_conta_hospitalar;
- **Linha 100**: atribuicao de valor Ã  variavel v_sucesso_interno.
- **Linha 102**: Estrutura condicional de controle de fluxo.
- **Linha 103**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ACAO_FATURAMENTO_NAO_MAPEADA';
- **Linha 104**: END CASE;
- **Linha 106** (Comentario): 6. AUDITORIA E FINALIZAÇÃO
- **Linha 107**: Estrutura condicional de controle de fluxo.
- **Linha 108**: Invoca a procedure sp_ledger_evento_log.
- **Linha 109**: v_uuid_transacao, v_id_usuario, v_id_perfil, p_acao,
- **Linha 110**: v_snapshot_antes, 'EXECUTADO', p_payload, 'SUCESSO', 'Lançamento financeiro concluído'
- **Linha 111**: );
- **Linha 112**: COMMIT;
- **Linha 113**: Estrutura condicional de controle de fluxo.
- **Linha 114**: ROLLBACK;
- **Linha 115**: Estrutura condicional de controle de fluxo.
- **Linha 117**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_faturamento_runtime`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT, -- ID do Atendimento (id_atendimento / id_ffa)
    IN p_payload JSON          -- { "id_item": 123, "tipo": "MEDICAMENTO", "valor_un": 50.00, "qtd": 2 }
)
    SQL SECURITY INVOKER
main: BEGIN
    -- 1. DECLARAÇÕES TÉCNICAS
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_sucesso_interno BOOLEAN DEFAULT FALSE;
    DECLARE v_error_msg_final TEXT;
    
    DECLARE v_snapshot_antes JSON;
    DECLARE v_id_conta_hospitalar BIGINT;
    DECLARE v_valor_total DECIMAL(15,2);

    -- Handler Global de Erro
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        SET v_error_msg_final = CONCAT('MOTOR_FATURAMENTO_FALHA: ', @msg);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg_final;
    END;

    -- 2. CONTEXTO
    SELECT id_usuario, id_perfil INTO v_id_usuario, v_id_perfil
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao;

    -- 3. LOCALIZA OU CRIA CONTA HOSPITALAR (Vínculo com Atendimento)
    -- Tentamos pegar a conta ativa para este atendimento
    SELECT id_conta INTO v_id_conta_hospitalar 
    FROM fat_conta_hospitalar 
    WHERE id_atendimento = p_id_referencia AND status = 'ABERTA' LIMIT 1;

    -- Se não existir, a gente provisiona uma nova conta
    IF v_id_conta_hospitalar IS NULL THEN
        INSERT INTO fat_conta_hospitalar (id_atendimento, status, criado_em, id_usuario_abertura)
        VALUES (p_id_referencia, 'ABERTA', NOW(), v_id_usuario);
        SET v_id_conta_hospitalar = LAST_INSERT_ID();
    END IF;

    -- 4. INÍCIO DA TRANSAÇÃO
    START TRANSACTION;

    -- Capturamos o saldo atual da conta para o Snapshot
    SELECT JSON_OBJECT('id_conta', v_id_conta_hospitalar, 'total_atual', total_acumulado)
    INTO v_snapshot_antes
    FROM fat_conta_hospitalar WHERE id_conta = v_id_conta_hospitalar FOR UPDATE;

    -- 5. ROTEAMENTO FINANCEIRO
    CASE p_acao

        -- LANÇAR ITEM (Vindo da Farmácia ou Almoxarifado)
        WHEN 'LANCAR_CONSUMO' THEN
            SET v_valor_total = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.valor_un')) * JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.qtd'));

            INSERT INTO fat_conta_itens (id_conta, id_item, tipo_item, quantidade, valor_unitario, valor_total, data_lancamento)
            VALUES (
                v_id_conta_hospitalar, 
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_item')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.qtd')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.valor_un')),
                v_valor_total,
                NOW()
            );

            -- Atualiza o total da conta
            UPDATE fat_conta_hospitalar 
            SET total_acumulado = total_acumulado + v_valor_total 
            WHERE id_conta = v_id_conta_hospitalar;

            SET v_sucesso_interno = TRUE;

        -- LANÇAR TAXA / HONORÁRIO (Vindo da Fila/Atendimento Médico)
        WHEN 'LANCAR_PROCEDIMENTO' THEN
            -- Lógica para Tabela TUSS/Honorários
            INSERT INTO fat_conta_procedimentos (id_conta, id_procedimento, valor, data_execucao)
            VALUES (
                v_id_conta_hospitalar,
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_procedimento')),
                JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.valor')),
                NOW()
            );
            
            UPDATE fat_conta_hospitalar 
            SET total_acumulado = total_acumulado + JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.valor'))
            WHERE id_conta = v_id_conta_hospitalar;

            SET v_sucesso_interno = TRUE;

        -- FECHAR CONTA PARA AUDITORIA
        WHEN 'FECHAR_CONTA' THEN
            UPDATE fat_conta_hospitalar SET status = 'AGUARDANDO_FATURAMENTO', data_fechamento = NOW()
            WHERE id_conta = v_id_conta_hospitalar;
            SET v_sucesso_interno = TRUE;

        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ACAO_FATURAMENTO_NAO_MAPEADA';
    END CASE;

    -- 6. AUDITORIA E FINALIZAÇÃO
    IF v_sucesso_interno THEN
        CALL sp_ledger_evento_log(
            v_uuid_transacao, v_id_usuario, v_id_perfil, p_acao,
            v_snapshot_antes, 'EXECUTADO', p_payload, 'SUCESSO', 'Lançamento financeiro concluído'
        );
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;

END ;;
```

