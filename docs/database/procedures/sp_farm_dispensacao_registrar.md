# sp_farm_dispensacao_registrar

Objetivo: farm dispensacao registrar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_receita | BIGINT | IN | |
| p_id_produto | BIGINT | IN | |
| p_id_lote | BIGINT | IN | |
| p_id_estoque_local | BIGINT | IN | |
| p_quantidade | DECIMAL(14,3) | IN | |
| p_observacao | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: farm_operacao, farm_receita_controlada
- INSERT: estoque_movimento, estoque_movimento_item, estoque_reserva, farm_dispensacao, farm_dispensacao_item
- UPDATE: estoque_lote
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar

## Functions Utilizadas
- IF
- LAST_INSERT_ID
- NOW
- SIGNAL

## Views Utilizadas
- v_tipo_dispensacao

## Eventos Gerados
- auditoria_evento
- evento

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: inicio do bloco de execucao.
- **Linha 11**: Declaracao de variavel local v_id_dispensacao.
- **Linha 12**: Declaracao de variavel local v_id_movimento.
- **Linha 13**: Declaracao de variavel local v_tipo_dispensacao.
- **Linha 14**: Declaracao de variavel local v_exige_dupla.
- **Linha 16**: Declaracao de variavel local EXIT.
- **Linha 17**: inicio do bloco de execucao.
- **Linha 18**: ROLLBACK;
- **Linha 19**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao registrar dispensacao';
- **Linha 20**: Fim do bloco da procedure.
- **Linha 22**: START TRANSACTION;
- **Linha 24** (Comentario): Busca tipo de dispensacao pela receita
- **Linha 25**: execucao de query SELECT para consulta de dados.
- **Linha 26**: FROM farm_receita_controlada fr
- **Linha 27**: JOIN farm_operacao fo ON fo.id_operacao = fr.id_operacao
- **Linha 28**: WHERE fr.id_receita = p_id_receita;
- **Linha 30** (Comentario): Cria dispensacao
- **Linha 31**: Insere um novo registro na tabela farm_dispensacao.
- **Linha 32**: VALUES (p_id_receita, v_tipo_dispensacao, IF(v_exige_dupla, 'PARCIAL', 'FINALIZADA'), NOW());
- **Linha 33**: atribuicao de valor Ã  variavel v_id_dispensacao.
- **Linha 35** (Comentario): Cria item de dispensacao
- **Linha 36**: Insere um novo registro na tabela farm_dispensacao_item.
- **Linha 37**: VALUES (v_id_dispensacao, p_id_produto, p_id_lote, p_quantidade);
- **Linha 39** (Comentario): Registra movimento append-only (permanente, imutável)
- **Linha 40**: Insere um novo registro na tabela estoque_movimento.
- **Linha 41**: VALUES (p_id_estoque_local, 'SAIDA', 'FARMACIA', v_id_dispensacao, p_observacao, p_id_sessao_usuario, NOW());
- **Linha 42**: atribuicao de valor Ã  variavel v_id_movimento.
- **Linha 44** (Comentario): Registra item de movimento
- **Linha 45**: Insere um novo registro na tabela estoque_movimento_item.
- **Linha 46**: VALUES (v_id_movimento, p_id_produto, p_id_lote, p_quantidade, NOW());
- **Linha 48** (Comentario): Se exige dupla baixa, cria reserva
- **Linha 49**: Estrutura condicional de controle de fluxo.
- **Linha 50**: Insere um novo registro na tabela estoque_reserva.
- **Linha 51**: VALUES (p_id_estoque_local, p_id_produto, p_id_lote, p_quantidade, 'FARM_DISP', v_id_dispensacao, 'ATIVA', p_id_sessao_usuario, NOW());
- **Linha 52**: Estrutura condicional de controle de fluxo.
- **Linha 53** (Comentario): Sem dupla: aplica movimento diretamente no lote
- **Linha 54**: Atualiza registros existentes na tabela estoque_lote.
- **Linha 55**: WHERE id_lote = p_id_lote;
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58** (Comentario): Auditoria
- **Linha 59**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 61**: COMMIT;
- **Linha 62**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farm_dispensacao_registrar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_receita BIGINT,
    IN p_id_produto BIGINT,
    IN p_id_lote BIGINT,
    IN p_id_estoque_local BIGINT,
    IN p_quantidade DECIMAL(14,3),
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_dispensacao BIGINT;
    DECLARE v_id_movimento BIGINT;
    DECLARE v_tipo_dispensacao VARCHAR(20);
    DECLARE v_exige_dupla TINYINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao registrar dispensacao';
    END;

    START TRANSACTION;

    -- Busca tipo de dispensacao pela receita
    SELECT fr.tipo, fo.exige_dupla_baixa INTO v_tipo_dispensacao, v_exige_dupla
    FROM farm_receita_controlada fr
    JOIN farm_operacao fo ON fo.id_operacao = fr.id_operacao
    WHERE fr.id_receita = p_id_receita;

    -- Cria dispensacao
    INSERT INTO farm_dispensacao (id_receita, tipo, status, criado_em)
    VALUES (p_id_receita, v_tipo_dispensacao, IF(v_exige_dupla, 'PARCIAL', 'FINALIZADA'), NOW());
    SET v_id_dispensacao = LAST_INSERT_ID();

    -- Cria item de dispensacao
    INSERT INTO farm_dispensacao_item (id_dispensacao, id_produto, lote, quantidade)
    VALUES (v_id_dispensacao, p_id_produto, p_id_lote, p_quantidade);

    -- Registra movimento append-only (permanente, imutável)
    INSERT INTO estoque_movimento (id_estoque_local, tipo, origem, id_documento, observacao, id_sessao_usuario, criado_em)
    VALUES (p_id_estoque_local, 'SAIDA', 'FARMACIA', v_id_dispensacao, p_observacao, p_id_sessao_usuario, NOW());
    SET v_id_movimento = LAST_INSERT_ID();

    -- Registra item de movimento
    INSERT INTO estoque_movimento_item (id_movimento, id_produto, id_lote, quantidade, criado_em)
    VALUES (v_id_movimento, p_id_produto, p_id_lote, p_quantidade, NOW());

    -- Se exige dupla baixa, cria reserva
    IF v_exige_dupla = 1 THEN
        INSERT INTO estoque_reserva (id_estoque_local, id_produto, id_lote, quantidade, origem_tipo, id_documento, status, id_sessao_criou, criado_em)
        VALUES (p_id_estoque_local, p_id_produto, p_id_lote, p_quantidade, 'FARM_DISP', v_id_dispensacao, 'ATIVA', p_id_sessao_usuario, NOW());
    ELSE
        -- Sem dupla: aplica movimento diretamente no lote
        UPDATE estoque_lote SET quantidade = quantidade - p_quantidade, atualizado_em = NOW()
        WHERE id_lote = p_id_lote;
    END IF;

    -- Auditoria
    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'FARM_DISP_REGISTRADA', 'farm_dispensacao', v_id_dispensacao);

    COMMIT;
END ;;
```

