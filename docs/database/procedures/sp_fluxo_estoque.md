# sp_fluxo_estoque

Objetivo: fluxo estoque conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_contexto | VARCHAR(30) | IN | |
| p_id_item | BIGINT | IN | |
| p_id_lote | BIGINT | IN | |
| p_quantidade | DECIMAL(15,4) | IN | |
| p_acao | ENUM('RESERVAR', 'DISPENSAR', 'ESTORNAR_RESERVA') | IN | |
| p_id_referencia | BIGINT | IN | |
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
- JSON_OBJECT
- NOW
- SHA2
- SIGNAL

## Views Utilizadas
- v_fis
- v_hash
- v_res

## Eventos Gerados
- evento

## Tratamento de Erros

- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
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
- **Linha 12**: inicio do bloco de execucao.
- **Linha 13**: Declaracao de variavel local v_hash.
- **Linha 14**: DECLARE v_fis, v_res DECIMAL(15,4);
- **Linha 16** (Comentario): 1. VALIDAÇÃO DE SESSÃO (CORE REQUIREMENT)
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 18**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LEI_IMUTAVEL: Sessao obrigatoria';
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 21** (Comentario): 2. HASH IDEMPOTENTE (ANTI-REPLAY)
- **Linha 22**: atribuicao de valor Ã  variavel v_hash.
- **Linha 24** (Comentario): 3. LOCK DE PIPELINE COM LEASE (ANTI-DUPLA EXECUÇÃO)
- **Linha 25**: Insere um novo registro na tabela estoque_execucao_pipeline.
- **Linha 26**: VALUES (v_hash, 'PROCESSANDO', NOW() + INTERVAL 30 SECOND)
- **Linha 27**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 29**: START TRANSACTION;
- **Linha 31** (Comentario): 4. MATERIALIZAÇÃO DE SALDO (GARANTE EXISTÊNCIA NO RUNTIME)
- **Linha 32**: Insere um novo registro na tabela estoque_saldo.
- **Linha 33**: VALUES (p_id_unidade, p_id_local, p_contexto, p_id_item, p_id_lote, p_id_sessao)
- **Linha 34**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 36** (Comentario): 5. LOCK PESSIMISTA DO ESTADO ATUAL
- **Linha 37**: execucao de query SELECT para consulta de dados.
- **Linha 38**: FROM estoque_saldo
- **Linha 39**: WHERE id_unidade = p_id_unidade AND id_local = p_id_local
- **Linha 41**: FOR UPDATE;
- **Linha 43** (Comentario): 6. MOTOR LOGÍSTICO (DECISÃO ATÔMICA)
- **Linha 44**: CASE p_acao
- **Linha 45**: WHEN 'RESERVAR' THEN
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 47**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_PROJETADO_INSUFICIENTE';
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 49**: Atualiza registros existentes na tabela estoque_saldo.
- **Linha 50**: WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;
- **Linha 52**: WHEN 'DISPENSAR' THEN
- **Linha 53**: Estrutura condicional de controle de fluxo.
- **Linha 54**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_FISICO_INSUFICIENTE';
- **Linha 55**: Estrutura condicional de controle de fluxo.
- **Linha 56**: UPDATE estoque_saldo
- **Linha 57**: atribuicao de valor Ã  variavel qtd_fisica.
- **Linha 58**: qtd_reservada = GREATEST(qtd_reservada - p_quantidade, 0)
- **Linha 59**: WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;
- **Linha 61**: WHEN 'ESTORNAR_RESERVA' THEN
- **Linha 62**: Atualiza registros existentes na tabela estoque_saldo.
- **Linha 63**: WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;
- **Linha 64**: END CASE;
- **Linha 66** (Comentario): 7. AUDITORIA SEMÂNTICA (IMUTABILIDADE DO EVENTO)
- **Linha 67**: Insere um novo registro na tabela estoque_audit_stream.
- **Linha 68**: VALUES (p_id_referencia, 'ESTOQUE', p_acao, JSON_OBJECT('qtd', p_quantidade, 'sessao', p_id_sessao, 'contexto', p_contexto), v_hash);
- **Linha 70** (Comentario): 8. FINALIZAÇÃO DO ESTADO DO PIPELINE
- **Linha 71**: Atualiza registros existentes na tabela estoque_execucao_pipeline.
- **Linha 73**: COMMIT;
- **Linha 74**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_estoque`(
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_contexto VARCHAR(30),
    IN p_id_item BIGINT,
    IN p_id_lote BIGINT,
    IN p_quantidade DECIMAL(15,4),
    IN p_acao ENUM('RESERVAR', 'DISPENSAR', 'ESTORNAR_RESERVA'),
    IN p_id_referencia BIGINT,
    IN p_id_sessao BIGINT
)
BEGIN
    DECLARE v_hash CHAR(64);
    DECLARE v_fis, v_res DECIMAL(15,4);

    -- 1. VALIDAÇÃO DE SESSÃO (CORE REQUIREMENT)
    IF p_id_sessao IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LEI_IMUTAVEL: Sessao obrigatoria';
    END IF;

    -- 2. HASH IDEMPOTENTE (ANTI-REPLAY)
    SET v_hash = SHA2(CONCAT(p_id_unidade, p_id_local, p_id_item, p_id_lote, p_quantidade, p_acao, p_id_referencia, p_id_sessao), 256);

    -- 3. LOCK DE PIPELINE COM LEASE (ANTI-DUPLA EXECUÇÃO)
    INSERT INTO estoque_execucao_pipeline (pipeline_hash, estado, lease_expira_em)
    VALUES (v_hash, 'PROCESSANDO', NOW() + INTERVAL 30 SECOND)
    ON DUPLICATE KEY UPDATE lease_expira_em = NOW() + INTERVAL 30 SECOND;

    START TRANSACTION;

        -- 4. MATERIALIZAÇÃO DE SALDO (GARANTE EXISTÊNCIA NO RUNTIME)
        INSERT INTO estoque_saldo (id_unidade, id_local, contexto_tipo, id_item, id_lote, id_sessao_usuario)
        VALUES (p_id_unidade, p_id_local, p_contexto, p_id_item, p_id_lote, p_id_sessao)
        ON DUPLICATE KEY UPDATE id_saldo = id_saldo;

        -- 5. LOCK PESSIMISTA DO ESTADO ATUAL
        SELECT qtd_fisica, qtd_reservada INTO v_fis, v_res
        FROM estoque_saldo
        WHERE id_unidade = p_id_unidade AND id_local = p_id_local 
        AND id_item = p_id_item AND id_lote = p_id_lote
        FOR UPDATE;

        -- 6. MOTOR LOGÍSTICO (DECISÃO ATÔMICA)
        CASE p_acao
            WHEN 'RESERVAR' THEN
                IF (v_fis - v_res) < p_quantidade THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_PROJETADO_INSUFICIENTE';
                END IF;
                UPDATE estoque_saldo SET qtd_reservada = qtd_reservada + p_quantidade
                WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;

            WHEN 'DISPENSAR' THEN
                IF v_fis < p_quantidade THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'SALDO_FISICO_INSUFICIENTE';
                END IF;
                UPDATE estoque_saldo 
                SET qtd_fisica = qtd_fisica - p_quantidade, 
                    qtd_reservada = GREATEST(qtd_reservada - p_quantidade, 0)
                WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;

            WHEN 'ESTORNAR_RESERVA' THEN
                UPDATE estoque_saldo SET qtd_reservada = GREATEST(qtd_reservada - p_quantidade, 0)
                WHERE id_unidade = p_id_unidade AND id_local = p_id_local AND id_item = p_id_item AND id_lote = p_id_lote;
        END CASE;

        -- 7. AUDITORIA SEMÂNTICA (IMUTABILIDADE DO EVENTO)
        INSERT INTO estoque_audit_stream (id_referencia_externa, entidade_tipo, evento_tipo, payload, hash_pipeline)
        VALUES (p_id_referencia, 'ESTOQUE', p_acao, JSON_OBJECT('qtd', p_quantidade, 'sessao', p_id_sessao, 'contexto', p_contexto), v_hash);

        -- 8. FINALIZAÇÃO DO ESTADO DO PIPELINE
        UPDATE estoque_execucao_pipeline SET estado = 'CONCLUIDO' WHERE pipeline_hash = v_hash;

    COMMIT;
END ;;
```

