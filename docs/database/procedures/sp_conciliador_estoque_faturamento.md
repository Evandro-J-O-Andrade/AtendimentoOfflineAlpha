# sp_conciliador_estoque_faturamento

Objetivo: conciliador estoque faturamento conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_atendimento | BIGINT | IN | |
| p_id_convenio | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_id_item | BIGINT | IN | |
| p_id_lote | BIGINT | IN | |
| p_quantidade | DECIMAL(15,4) | IN | |
| p_id_referencia_externa | BIGINT | IN | |
| p_id_sessao | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: estoque_pipeline_estado, estoque_saldo, faturamento_tabela_preco
- INSERT: estoque_audit_stream, estoque_pipeline_estado, faturamento_conta_item
- UPDATE: estoque_pipeline_estado, estoque_saldo
- DELETE: estoque_pipeline_estado

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
- v_preco_unitario
- v_res

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
- **Linha 12**: proc_main: BEGIN
- **Linha 14**: Declaracao de variavel local v_hash.
- **Linha 15**: Declaracao de variavel local v_fis.
- **Linha 16**: Declaracao de variavel local v_res.
- **Linha 17**: Declaracao de variavel local v_preco_unitario.
- **Linha 19**: /* ===============================
- **Linha 20**: PIPELINE IDEMPOTENTE
- **Linha 21**: =============================== */
- **Linha 23**: atribuicao de valor Ã  variavel v_hash.
- **Linha 24**: 'CFA_',
- **Linha 25**: p_id_atendimento,
- **Linha 26**: p_id_item,
- **Linha 27**: p_id_referencia_externa,
- **Linha 28**: p_id_sessao
- **Linha 29**: ),256);
- **Linha 31**: Remove registros da tabela estoque_pipeline_estado.
- **Linha 32**: WHERE lease_expira_em < NOW();
- **Linha 34**: Insere um novo registro na tabela estoque_pipeline_estado.
- **Linha 35**: (hash_execucao, etapa_atual, bloqueado, lease_expira_em)
- **Linha 36**: VALUES
- **Linha 37**: (v_hash,'PROCESSANDO',1,NOW() + INTERVAL 30 SECOND)
- **Linha 38**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 39**: lease_expira_em = NOW() + INTERVAL 30 SECOND;
- **Linha 41**: START TRANSACTION;
- **Linha 43**: /* SALDO LOCK */
- **Linha 45**: execucao de query SELECT para consulta de dados.
- **Linha 46**: INTO v_fis, v_res
- **Linha 47**: FROM estoque_saldo
- **Linha 48**: WHERE id_unidade = p_id_unidade
- **Linha 52**: FOR UPDATE;
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 55**: ROLLBACK;
- **Linha 57**: Remove registros da tabela estoque_pipeline_estado.
- **Linha 58**: WHERE hash_execucao = v_hash;
- **Linha 60**: SIGNAL SQLSTATE '45000'
- **Linha 61**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 62**: Estrutura condicional de controle de fluxo.
- **Linha 64**: /* PREÇO FATURAMENTO */
- **Linha 66**: execucao de query SELECT para consulta de dados.
- **Linha 67**: INTO v_preco_unitario
- **Linha 68**: FROM faturamento_tabela_preco
- **Linha 69**: WHERE id_item = p_id_item
- **Linha 72**: ORDER BY id_convenio DESC, inicio_vigencia DESC
- **Linha 73**: LIMIT 1;
- **Linha 75**: Estrutura condicional de controle de fluxo.
- **Linha 76**: ROLLBACK;
- **Linha 77**: SIGNAL SQLSTATE '45000'
- **Linha 78**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 79**: Estrutura condicional de controle de fluxo.
- **Linha 81**: /* LEDGER */
- **Linha 83**: UPDATE estoque_saldo
- **Linha 84**: SET
- **Linha 85**: qtd_fisica = qtd_fisica - p_quantidade,
- **Linha 86**: qtd_reservada = GREATEST(qtd_reservada - p_quantidade,0)
- **Linha 87**: WHERE
- **Linha 88**: id_unidade = p_id_unidade
- **Linha 93**: /* CONTA PACIENTE */
- **Linha 95**: Insere um novo registro na tabela faturamento_conta_item.
- **Linha 96**: id_referencia_estoque,
- **Linha 97**: id_atendimento,
- **Linha 98**: id_item,
- **Linha 99**: quantidade,
- **Linha 100**: valor_unitario,
- **Linha 101**: id_sessao_usuario
- **Linha 102**: fechamento da lista de Parametros.
- **Linha 103**: VALUES(
- **Linha 104**: p_id_referencia_externa,
- **Linha 105**: p_id_atendimento,
- **Linha 106**: p_id_item,
- **Linha 107**: p_quantidade,
- **Linha 108**: v_preco_unitario,
- **Linha 109**: p_id_sessao
- **Linha 110**: );
- **Linha 112**: /* AUDIT */
- **Linha 114**: Insere um novo registro na tabela estoque_audit_stream.
- **Linha 115**: id_referencia_externa,
- **Linha 116**: entidade_tipo,
- **Linha 117**: evento_tipo,
- **Linha 118**: payload,
- **Linha 119**: hash_pipeline
- **Linha 120**: fechamento da lista de Parametros.
- **Linha 121**: VALUES(
- **Linha 122**: p_id_referencia_externa,
- **Linha 123**: 'FATURAMENTO',
- **Linha 124**: 'DISPENSA_FATURADA',
- **Linha 125**: JSON_OBJECT(
- **Linha 126**: 'valor',v_preco_unitario,
- **Linha 127**: 'total',(v_preco_unitario*p_quantidade)
- **Linha 128**: ),
- **Linha 129**: v_hash
- **Linha 130**: );
- **Linha 132**: UPDATE estoque_pipeline_estado
- **Linha 133**: atribuicao de valor Ã  variavel etapa_atual.
- **Linha 134**: WHERE hash_execucao=v_hash;
- **Linha 136**: COMMIT;
- **Linha 138**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_conciliador_estoque_faturamento`(
    IN p_id_atendimento BIGINT,
    IN p_id_convenio BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_id_item BIGINT,
    IN p_id_lote BIGINT,
    IN p_quantidade DECIMAL(15,4),
    IN p_id_referencia_externa BIGINT,
    IN p_id_sessao BIGINT
)
proc_main: BEGIN

    DECLARE v_hash CHAR(64);
    DECLARE v_fis DECIMAL(15,4);
    DECLARE v_res DECIMAL(15,4);
    DECLARE v_preco_unitario DECIMAL(15,4);

    /* ===============================
       PIPELINE IDEMPOTENTE
    =============================== */

    SET v_hash = SHA2(CONCAT(
        'CFA_',
        p_id_atendimento,
        p_id_item,
        p_id_referencia_externa,
        p_id_sessao
    ),256);

    DELETE FROM estoque_pipeline_estado
    WHERE lease_expira_em < NOW();

    INSERT INTO estoque_pipeline_estado
    (hash_execucao, etapa_atual, bloqueado, lease_expira_em)
    VALUES
    (v_hash,'PROCESSANDO',1,NOW() + INTERVAL 30 SECOND)
    ON DUPLICATE KEY UPDATE
        lease_expira_em = NOW() + INTERVAL 30 SECOND;

    START TRANSACTION;

    /* SALDO LOCK */

    SELECT qtd_fisica, qtd_reservada
    INTO v_fis, v_res
    FROM estoque_saldo
    WHERE id_unidade = p_id_unidade
    AND id_local = p_id_local
    AND id_item = p_id_item
    AND id_lote = p_id_lote
    FOR UPDATE;

    IF v_fis IS NULL OR v_fis < p_quantidade THEN
        ROLLBACK;

        DELETE FROM estoque_pipeline_estado
        WHERE hash_execucao = v_hash;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SALDO_FISICO_INSUFICIENTE';
    END IF;

    /* PREÇO FATURAMENTO */

    SELECT valor_venda
    INTO v_preco_unitario
    FROM faturamento_tabela_preco
    WHERE id_item = p_id_item
    AND (id_convenio = p_id_convenio OR id_convenio = 0)
    AND inicio_vigencia <= CURDATE()
    ORDER BY id_convenio DESC, inicio_vigencia DESC
    LIMIT 1;

    IF v_preco_unitario IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ITEM_SEM_PRECO_CONVENIO';
    END IF;

    /* LEDGER */

    UPDATE estoque_saldo
    SET
        qtd_fisica = qtd_fisica - p_quantidade,
        qtd_reservada = GREATEST(qtd_reservada - p_quantidade,0)
    WHERE
        id_unidade = p_id_unidade
        AND id_local = p_id_local
        AND id_item = p_id_item
        AND id_lote = p_id_lote;

    /* CONTA PACIENTE */

    INSERT INTO faturamento_conta_item(
        id_referencia_estoque,
        id_atendimento,
        id_item,
        quantidade,
        valor_unitario,
        id_sessao_usuario
    )
    VALUES(
        p_id_referencia_externa,
        p_id_atendimento,
        p_id_item,
        p_quantidade,
        v_preco_unitario,
        p_id_sessao
    );

    /* AUDIT */

    INSERT INTO estoque_audit_stream(
        id_referencia_externa,
        entidade_tipo,
        evento_tipo,
        payload,
        hash_pipeline
    )
    VALUES(
        p_id_referencia_externa,
        'FATURAMENTO',
        'DISPENSA_FATURADA',
        JSON_OBJECT(
            'valor',v_preco_unitario,
            'total',(v_preco_unitario*p_quantidade)
        ),
        v_hash
    );

    UPDATE estoque_pipeline_estado
    SET etapa_atual='CONCLUIDO'
    WHERE hash_execucao=v_hash;

    COMMIT;

END ;;
```

