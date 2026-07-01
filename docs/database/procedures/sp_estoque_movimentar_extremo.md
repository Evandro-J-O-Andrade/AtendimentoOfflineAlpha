# sp_estoque_movimentar_extremo

Objetivo: estoque movimentar extremo conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_unidade | BIGINT | IN | |
| p_id_item | BIGINT | IN | |
| p_id_lote | BIGINT | IN | |
| p_id_local_origem | BIGINT | IN | |
| p_id_local_destino | BIGINT | IN | |
| p_quantidade | DECIMAL(15,4) | IN | |
| p_tipo_fluxo | ENUM('RESERVA', 'DISPENSACO', 'ADMINISTRACAO', 'AJUSTE') | IN | |
| p_id_sessao | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: estoque_saldo
- INSERT: estoque_audit_stream, estoque_execucao_pipeline, estoque_saldo
- UPDATE: estoque_execucao_pipeline, estoque_saldo
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- JSON_OBJECT
- SHA2
- SIGNAL

## Views Utilizadas
- v_pipeline_hash
- v_saldo_fis
- v_saldo_res

## Eventos Gerados
- evento

## Tratamento de Erros

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: proc_label: BEGIN
- **Linha 13**: Declaracao de variavel local v_pipeline_hash.
- **Linha 14**: DECLARE v_saldo_fis, v_saldo_res DECIMAL(15,4);
- **Linha 16** (Comentario): 1. GERAÇÃO DE HASH ANTI-RACE CONDITION (LOCK DE PIPELINE)
- **Linha 17**: atribuicao de valor Ã  variavel v_pipeline_hash.
- **Linha 19**: START TRANSACTION;
- **Linha 21** (Comentario): LOCK DE SEMÁFORO: Impede Retries e Double Execution nível Banco
- **Linha 22**: Insere um novo registro na tabela estoque_execucao_pipeline.
- **Linha 24** (Comentario): LOCK PESSIMISTA DE SALDO
- **Linha 25**: execucao de query SELECT para consulta de dados.
- **Linha 26**: FROM estoque_saldo
- **Linha 27**: WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem
- **Linha 28**: FOR UPDATE;
- **Linha 30** (Comentario): 2. LÓGICA DE LEDGER TRIPLO
- **Linha 31**: CASE p_tipo_fluxo
- **Linha 32**: WHEN 'RESERVA' THEN
- **Linha 33** (Comentario): Médico prescreveu: Aumenta reserva, diminui projetado (Disponibilidade Real)
- **Linha 34**: Estrutura condicional de controle de fluxo.
- **Linha 35**: ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_HIS: Saldo projetado insuficiente para reserva.';
- **Linha 36**: Estrutura condicional de controle de fluxo.
- **Linha 37**: Atualiza registros existentes na tabela estoque_saldo.
- **Linha 38**: WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem;
- **Linha 40**: WHEN 'DISPENSACO' THEN
- **Linha 41** (Comentario): Farmácia enviou para o setor: Diminui físico e diminui reserva (Consumo de prateleira)
- **Linha 42**: Atualiza registros existentes na tabela estoque_saldo.
- **Linha 43**: WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem;
- **Linha 45** (Comentario): Se houver destino, entra como físico lá
- **Linha 46**: Insere um novo registro na tabela estoque_saldo.
- **Linha 47**: VALUES (p_id_unidade, p_id_local_destino, p_id_item, p_id_lote, p_quantidade, p_quantidade, p_id_sessao)
- **Linha 48**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 50**: WHEN 'ADMINISTRACAO' THEN
- **Linha 51** (Comentario): Enfermeira administrou: Baixa definitiva do físico do setor (Gera gatilho para faturamento)
- **Linha 52**: Atualiza registros existentes na tabela estoque_saldo.
- **Linha 53**: WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem;
- **Linha 54**: END CASE;
- **Linha 56** (Comentario): 3. AUDITORIA SEMÂNTICA (AUDIT EVENT STREAM)
- **Linha 57**: Insere um novo registro na tabela estoque_audit_stream.
- **Linha 58**: VALUES (NULL, 'ESTOQUE', CONCAT('HIS_', p_tipo_fluxo), JSON_OBJECT('item', p_id_item, 'lote', p_id_lote, 'qtd', p_quantidade, 'ref', p_id_referencia_assistencial));
- **Linha 60** (Comentario): FINALIZA PIPELINE
- **Linha 61**: Atualiza registros existentes na tabela estoque_execucao_pipeline.
- **Linha 63**: COMMIT;
- **Linha 64**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_movimentar_extremo`(
    IN p_id_unidade BIGINT,
    IN p_id_item BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_local_origem BIGINT,
    IN p_id_local_destino BIGINT,
    IN p_quantidade DECIMAL(15,4),
    IN p_tipo_fluxo ENUM('RESERVA', 'DISPENSACO', 'ADMINISTRACAO', 'AJUSTE'),
    IN p_id_sessao BIGINT,
    IN p_id_referencia_assistencial BIGINT -- ID da Prescrição ou FFA
)
proc_label: BEGIN
    DECLARE v_pipeline_hash CHAR(64);
    DECLARE v_saldo_fis, v_saldo_res DECIMAL(15,4);

    -- 1. GERAÇÃO DE HASH ANTI-RACE CONDITION (LOCK DE PIPELINE)
    SET v_pipeline_hash = SHA2(CONCAT(p_id_item, p_id_lote, p_quantidade, p_id_sessao, p_tipo_fluxo, IFNULL(p_id_referencia_assistencial, 0)), 256);

    START TRANSACTION;

        -- LOCK DE SEMÁFORO: Impede Retries e Double Execution nível Banco
        INSERT INTO estoque_execucao_pipeline (pipeline_hash, estado) VALUES (v_pipeline_hash, 'PROCESSANDO');

        -- LOCK PESSIMISTA DE SALDO
        SELECT qtd_fisica, qtd_reservada INTO v_saldo_fis, v_saldo_res 
        FROM estoque_saldo 
        WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem 
        FOR UPDATE;

        -- 2. LÓGICA DE LEDGER TRIPLO
        CASE p_tipo_fluxo
            WHEN 'RESERVA' THEN
                -- Médico prescreveu: Aumenta reserva, diminui projetado (Disponibilidade Real)
                IF (v_saldo_fis - v_saldo_res) < p_quantidade THEN
                    ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_HIS: Saldo projetado insuficiente para reserva.';
                END IF;
                UPDATE estoque_saldo SET qtd_reservada = qtd_reservada + p_quantidade, qtd_projetada = qtd_fisica - (qtd_reservada + p_quantidade)
                WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem;

            WHEN 'DISPENSACO' THEN
                -- Farmácia enviou para o setor: Diminui físico e diminui reserva (Consumo de prateleira)
                UPDATE estoque_saldo SET qtd_fisica = qtd_fisica - p_quantidade, qtd_reservada = qtd_reservada - p_quantidade
                WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem;
                
                -- Se houver destino, entra como físico lá
                INSERT INTO estoque_saldo (id_unidade, id_local, id_item, id_lote, qtd_fisica, qtd_projetada, id_sessao_usuario)
                VALUES (p_id_unidade, p_id_local_destino, p_id_item, p_id_lote, p_quantidade, p_quantidade, p_id_sessao)
                ON DUPLICATE KEY UPDATE qtd_fisica = qtd_fisica + p_quantidade, qtd_projetada = qtd_fisica + p_quantidade;

            WHEN 'ADMINISTRACAO' THEN
                -- Enfermeira administrou: Baixa definitiva do físico do setor (Gera gatilho para faturamento)
                UPDATE estoque_saldo SET qtd_fisica = qtd_fisica - p_quantidade, qtd_projetada = qtd_fisica - p_quantidade
                WHERE id_item = p_id_item AND id_lote = p_id_lote AND id_local = p_id_local_origem;
        END CASE;

        -- 3. AUDITORIA SEMÂNTICA (AUDIT EVENT STREAM)
        INSERT INTO estoque_audit_stream (id_movimento, entidade_tipo, evento_tipo, payload_depois)
        VALUES (NULL, 'ESTOQUE', CONCAT('HIS_', p_tipo_fluxo), JSON_OBJECT('item', p_id_item, 'lote', p_id_lote, 'qtd', p_quantidade, 'ref', p_id_referencia_assistencial));

        -- FINALIZA PIPELINE
        UPDATE estoque_execucao_pipeline SET estado = 'CONCLUIDO' WHERE pipeline_hash = v_pipeline_hash;

    COMMIT;
END ;;
```

