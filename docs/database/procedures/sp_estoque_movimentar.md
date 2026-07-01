# sp_estoque_movimentar

Objetivo: estoque movimentar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_unidade | BIGINT | IN | |
| p_id_item | BIGINT | IN | |
| p_id_local_origem | BIGINT | IN | |
| p_id_local_destino | BIGINT | IN | |
| p_id_lote | BIGINT | IN | |
| p_quantidade | DECIMAL(15,4) | IN | |
| p_tipo_movimento | VARCHAR(30) | IN | |
| p_id_sessao | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: estoque_lote, estoque_movimento, estoque_saldo
- INSERT: estoque_movimento, estoque_saldo
- UPDATE: estoque_saldo
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- SHA2
- SIGNAL

## Views Utilizadas
- v_hash
- v_saldo

## Eventos Gerados
- (nenhum)

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
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: inicio do bloco de execucao.
- **Linha 13**: Declaracao de variavel local v_hash.
- **Linha 14**: Declaracao de variavel local v_saldo.
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 17**: SIGNAL SQLSTATE '45000'
- **Linha 18**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 21**: atribuicao de valor Ã  variavel v_hash.
- **Linha 22**: p_id_item,
- **Linha 23**: p_id_lote,
- **Linha 24**: p_quantidade,
- **Linha 25**: p_id_sessao,
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 27**: Estrutura condicional de controle de fluxo.
- **Linha 28**: ),256);
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 31**: execucao de query SELECT para consulta de dados.
- **Linha 32**: FROM estoque_movimento
- **Linha 33**: WHERE hash_duplicidade = v_hash
- **Linha 34**: ) THEN
- **Linha 35**: SIGNAL SQLSTATE '45000'
- **Linha 36**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 37**: Estrutura condicional de controle de fluxo.
- **Linha 39**: Estrutura condicional de controle de fluxo.
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 41**: FROM estoque_lote
- **Linha 42**: WHERE id_lote=p_id_lote
- **Linha 44**: ) THEN
- **Linha 45**: SIGNAL SQLSTATE '45000'
- **Linha 46**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 47**: Estrutura condicional de controle de fluxo.
- **Linha 49**: START TRANSACTION;
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 53**: execucao de query SELECT para consulta de dados.
- **Linha 54**: INTO v_saldo
- **Linha 55**: FROM estoque_saldo
- **Linha 56**: WHERE id_item=p_id_item
- **Linha 59**: FOR UPDATE;
- **Linha 61**: Estrutura condicional de controle de fluxo.
- **Linha 62**: ROLLBACK;
- **Linha 63**: SIGNAL SQLSTATE '45000'
- **Linha 64**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 65**: Estrutura condicional de controle de fluxo.
- **Linha 67**: UPDATE estoque_saldo
- **Linha 68**: atribuicao de valor Ã  variavel quantidade_atual.
- **Linha 69**: WHERE id_item=p_id_item
- **Linha 73**: Estrutura condicional de controle de fluxo.
- **Linha 75**: Estrutura condicional de controle de fluxo.
- **Linha 77**: Insere um novo registro na tabela estoque_saldo.
- **Linha 78**: (id_unidade,id_local,id_item,id_lote,quantidade_atual,id_sessao_usuario)
- **Linha 79**: VALUES
- **Linha 80**: (p_id_unidade,p_id_local_destino,p_id_item,p_id_lote,p_quantidade,p_id_sessao)
- **Linha 82**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 83**: quantidade_atual=quantidade_atual+p_quantidade;
- **Linha 85**: Estrutura condicional de controle de fluxo.
- **Linha 87**: Insere um novo registro na tabela estoque_movimento.
- **Linha 88**: (
- **Linha 89**: id_item,id_unidade,
- **Linha 90**: id_local_origem,id_local_destino,
- **Linha 91**: id_lote,tipo_movimento,
- **Linha 92**: quantidade,hash_duplicidade,id_sessao_usuario
- **Linha 93**: fechamento da lista de Parametros.
- **Linha 94**: VALUES
- **Linha 95**: (
- **Linha 96**: p_id_item,p_id_unidade,
- **Linha 97**: p_id_local_origem,p_id_local_destino,
- **Linha 98**: p_id_lote,p_tipo_movimento,
- **Linha 99**: p_quantidade,v_hash,p_id_sessao
- **Linha 100**: );
- **Linha 102**: COMMIT;
- **Linha 104**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_movimentar`(
    IN p_id_unidade BIGINT,
    IN p_id_item BIGINT,
    IN p_id_local_origem BIGINT,
    IN p_id_local_destino BIGINT,
    IN p_id_lote BIGINT,
    IN p_quantidade DECIMAL(15,4),
    IN p_tipo_movimento VARCHAR(30),
    IN p_id_sessao BIGINT
)
BEGIN

    DECLARE v_hash CHAR(64);
    DECLARE v_saldo DECIMAL(15,4);

    IF p_id_sessao IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='LEI_IMUTAVEL: Sessao obrigatoria';
    END IF;

    SET v_hash = SHA2(CONCAT(
        p_id_item,
        p_id_lote,
        p_quantidade,
        p_id_sessao,
        IFNULL(p_id_local_origem,0),
        IFNULL(p_id_local_destino,0)
    ),256);

    IF EXISTS (
        SELECT 1
        FROM estoque_movimento
        WHERE hash_duplicidade = v_hash
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='ALERTA_REPLAY: Operacao ja processada';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM estoque_lote
        WHERE id_lote=p_id_lote
        AND id_item=p_id_item
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='ERRO_CONSISTENCIA: Lote invalido';
    END IF;

    START TRANSACTION;

    IF p_id_local_origem IS NOT NULL THEN

        SELECT quantidade_atual
        INTO v_saldo
        FROM estoque_saldo
        WHERE id_item=p_id_item
        AND id_local=p_id_local_origem
        AND id_lote=p_id_lote
        FOR UPDATE;

        IF v_saldo IS NULL OR v_saldo < p_quantidade THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='ERRO_SALDO: Saldo insuficiente';
        END IF;

        UPDATE estoque_saldo
        SET quantidade_atual=quantidade_atual-p_quantidade
        WHERE id_item=p_id_item
        AND id_local=p_id_local_origem
        AND id_lote=p_id_lote;

    END IF;

    IF p_id_local_destino IS NOT NULL THEN

        INSERT INTO estoque_saldo
        (id_unidade,id_local,id_item,id_lote,quantidade_atual,id_sessao_usuario)
        VALUES
        (p_id_unidade,p_id_local_destino,p_id_item,p_id_lote,p_quantidade,p_id_sessao)

        ON DUPLICATE KEY UPDATE
        quantidade_atual=quantidade_atual+p_quantidade;

    END IF;

    INSERT INTO estoque_movimento
    (
        id_item,id_unidade,
        id_local_origem,id_local_destino,
        id_lote,tipo_movimento,
        quantidade,hash_duplicidade,id_sessao_usuario
    )
    VALUES
    (
        p_id_item,p_id_unidade,
        p_id_local_origem,p_id_local_destino,
        p_id_lote,p_tipo_movimento,
        p_quantidade,v_hash,p_id_sessao
    );

    COMMIT;

END ;;
```

