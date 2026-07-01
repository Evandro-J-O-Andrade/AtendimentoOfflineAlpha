# sp_farm_reserva_confirmar

Objetivo: farm reserva confirmar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_reserva | BIGINT | IN | |
| p_id_usuario_confirmador | BIGINT | IN | |
| p_observacao | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: estoque_reserva
- INSERT: (nenhuma)
- UPDATE: estoque_lote, estoque_reserva, farm_dispensacao
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- NOW
- SIGNAL

## Views Utilizadas
- v_msg
- v_quantidade
- v_reserva_status

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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_id_lote.
- **Linha 9**: Declaracao de variavel local v_id_dispensacao.
- **Linha 10**: Declaracao de variavel local v_quantidade.
- **Linha 11**: Declaracao de variavel local v_reserva_status.
- **Linha 12**: Declaracao de variavel local v_msg.
- **Linha 14**: Declaracao de variavel local EXIT.
- **Linha 15**: inicio do bloco de execucao.
- **Linha 16**: ROLLBACK;
- **Linha 17**: atribuicao de valor Ã  variavel v_msg.
- **Linha 18**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
- **Linha 19**: Fim do bloco da procedure.
- **Linha 21**: START TRANSACTION;
- **Linha 23** (Comentario): Busca reserva (com lock)
- **Linha 24**: execucao de query SELECT para consulta de dados.
- **Linha 25**: INTO v_id_lote, v_id_dispensacao, v_quantidade, v_reserva_status
- **Linha 26**: FROM estoque_reserva
- **Linha 27**: WHERE id_reserva = p_id_reserva
- **Linha 28**: FOR UPDATE;
- **Linha 30** (Comentario): Valida estado
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 32**: atribuicao de valor Ã  variavel v_msg.
- **Linha 33**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
- **Linha 34**: Estrutura condicional de controle de fluxo.
- **Linha 36** (Comentario): Aplica baixa do lote
- **Linha 37**: UPDATE estoque_lote
- **Linha 38**: atribuicao de valor Ã  variavel quantidade.
- **Linha 39**: atualizado_em = NOW()
- **Linha 40**: WHERE id_lote = v_id_lote;
- **Linha 42** (Comentario): Marca reserva como efetivada
- **Linha 43**: UPDATE estoque_reserva
- **Linha 44**: atribuicao de valor Ã  variavel status.
- **Linha 45**: id_sessao_finalizou = p_id_sessao_usuario,
- **Linha 46**: finalizado_em = NOW(),
- **Linha 47**: motivo = p_observacao
- **Linha 48**: WHERE id_reserva = p_id_reserva;
- **Linha 50** (Comentario): Atualiza dispensacao: marca segunda baixa
- **Linha 51**: UPDATE farm_dispensacao
- **Linha 52**: atribuicao de valor Ã  variavel status.
- **Linha 53**: id_usuario_segunda_baixa = p_id_usuario_confirmador,
- **Linha 54**: segunda_baixa_em = NOW()
- **Linha 55**: WHERE id_dispensacao = v_id_dispensacao;
- **Linha 57** (Comentario): Auditoria
- **Linha 58**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 59**: p_id_sessao_usuario,
- **Linha 60**: 'FARM_RESERVA_CONFIRMADA',
- **Linha 61**: 'estoque_reserva',
- **Linha 62**: p_id_reserva
- **Linha 63**: );
- **Linha 65**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 66**: p_id_sessao_usuario,
- **Linha 67**: 'FARM_DISP_FINALIZADA',
- **Linha 68**: 'farm_dispensacao',
- **Linha 69**: v_id_dispensacao
- **Linha 70**: );
- **Linha 72**: COMMIT;
- **Linha 73**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farm_reserva_confirmar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_reserva BIGINT,
    IN p_id_usuario_confirmador BIGINT,
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_lote BIGINT;
    DECLARE v_id_dispensacao BIGINT;
    DECLARE v_quantidade DECIMAL(14,3);
    DECLARE v_reserva_status VARCHAR(40);
    DECLARE v_msg VARCHAR(255);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET v_msg = 'Erro ao confirmar reserva';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END;

    START TRANSACTION;

    -- Busca reserva (com lock)
    SELECT id_lote, id_documento, quantidade, status
    INTO v_id_lote, v_id_dispensacao, v_quantidade, v_reserva_status
    FROM estoque_reserva
    WHERE id_reserva = p_id_reserva
    FOR UPDATE;

    -- Valida estado
    IF v_reserva_status NOT IN ('ATIVA', 'CONFIRMADA') THEN
        SET v_msg = CONCAT('Reserva invalida: ', IFNULL(v_reserva_status,'NULL'));
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
    END IF;

    -- Aplica baixa do lote
    UPDATE estoque_lote
    SET quantidade = quantidade - v_quantidade,
        atualizado_em = NOW()
    WHERE id_lote = v_id_lote;

    -- Marca reserva como efetivada
    UPDATE estoque_reserva
    SET status = 'CONFIRMADA',
        id_sessao_finalizou = p_id_sessao_usuario,
        finalizado_em = NOW(),
        motivo = p_observacao
    WHERE id_reserva = p_id_reserva;

    -- Atualiza dispensacao: marca segunda baixa
    UPDATE farm_dispensacao
    SET status = 'FINALIZADA',
        id_usuario_segunda_baixa = p_id_usuario_confirmador,
        segunda_baixa_em = NOW()
    WHERE id_dispensacao = v_id_dispensacao;

    -- Auditoria
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FARM_RESERVA_CONFIRMADA',
        'estoque_reserva',
        p_id_reserva
    );

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FARM_DISP_FINALIZADA',
        'farm_dispensacao',
        v_id_dispensacao
    );

    COMMIT;
END ;;
```

