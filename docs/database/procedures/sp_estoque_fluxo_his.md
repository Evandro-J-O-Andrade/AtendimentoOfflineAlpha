# sp_estoque_fluxo_his

Objetivo: estoque fluxo his conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_id_item | BIGINT | IN | |
| p_id_lote | BIGINT | IN | |
| p_quantidade | DECIMAL(15,4) | IN | |
| p_acao | ENUM('RESERVAR','DISPENSAR','ESTORNAR_RESERVA') | IN | |
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
- **Linha 14**: Declaracao de variavel local v_fis.
- **Linha 15**: Declaracao de variavel local v_res.
- **Linha 17** (Comentario): VALIDAÇÃO DE SESSÃO
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 21**: SIGNAL SQLSTATE '45000'
- **Linha 22**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 23**: Estrutura condicional de controle de fluxo.
- **Linha 26** (Comentario): PIPELINE HASH IDEMPOTENTE
- **Linha 29**: atribuicao de valor Ã  variavel v_hash.
- **Linha 30**: p_id_referencia,
- **Linha 31**: p_id_item,
- **Linha 32**: p_id_lote,
- **Linha 33**: p_acao,
- **Linha 34**: p_id_sessao
- **Linha 35**: ),256);
- **Linha 38** (Comentario): LOCK DISTRIBUÍDO (ANTI REPLAY)
- **Linha 41**: Insere um novo registro na tabela estoque_execucao_pipeline.
- **Linha 42**: VALUES(v_hash,'PROCESSANDO')
- **Linha 43**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 45**: START TRANSACTION;
- **Linha 48** (Comentario): LOCK PESSIMISTA DO SALDO
- **Linha 51**: execucao de query SELECT para consulta de dados.
- **Linha 52**: INTO v_fis,v_res
- **Linha 53**: FROM estoque_saldo
- **Linha 54**: WHERE id_unidade=p_id_unidade
- **Linha 58**: FOR UPDATE;
- **Linha 61** (Comentario): MATERIALIZA SALDO SE NÃO EXISTIR
- **Linha 64**: Estrutura condicional de controle de fluxo.
- **Linha 66**: atribuicao de valor Ã  variavel v_fis.
- **Linha 67**: atribuicao de valor Ã  variavel v_res.
- **Linha 69**: Insere um novo registro na tabela estoque_saldo.
- **Linha 70**: (
- **Linha 71**: id_unidade,
- **Linha 72**: id_local,
- **Linha 73**: id_item,
- **Linha 74**: id_lote,
- **Linha 75**: qtd_fisica,
- **Linha 76**: qtd_reservada,
- **Linha 77**: id_sessao_usuario
- **Linha 78**: fechamento da lista de Parametros.
- **Linha 79**: VALUES
- **Linha 80**: (
- **Linha 81**: p_id_unidade,
- **Linha 82**: p_id_local,
- **Linha 83**: p_id_item,
- **Linha 84**: p_id_lote,
- **Linha 85**: 0,
- **Linha 86**: 0,
- **Linha 87**: p_id_sessao
- **Linha 88**: fechamento da lista de Parametros.
- **Linha 89**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 91**: Estrutura condicional de controle de fluxo.
- **Linha 94** (Comentario): MOTOR HIS LOGÍSTICO
- **Linha 97**: CASE p_acao
- **Linha 99**: WHEN 'RESERVAR' THEN
- **Linha 101**: Estrutura condicional de controle de fluxo.
- **Linha 102**: ROLLBACK;
- **Linha 103**: SIGNAL SQLSTATE '45000'
- **Linha 104**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 105**: Estrutura condicional de controle de fluxo.
- **Linha 107**: UPDATE estoque_saldo
- **Linha 108**: atribuicao de valor Ã  variavel qtd_reservada.
- **Linha 109**: WHERE id_unidade=p_id_unidade
- **Linha 114**: WHEN 'DISPENSAR' THEN
- **Linha 116**: UPDATE estoque_saldo
- **Linha 117**: atribuicao de valor Ã  variavel qtd_fisica.
- **Linha 118**: qtd_reservada = GREATEST(qtd_reservada - p_quantidade,0)
- **Linha 119**: WHERE id_unidade=p_id_unidade
- **Linha 124**: WHEN 'ESTORNAR_RESERVA' THEN
- **Linha 126**: UPDATE estoque_saldo
- **Linha 127**: atribuicao de valor Ã  variavel qtd_reservada.
- **Linha 128**: WHERE id_unidade=p_id_unidade
- **Linha 133**: END CASE;
- **Linha 136** (Comentario): AUDITORIA SEMÂNTICA
- **Linha 139**: Insere um novo registro na tabela estoque_audit_stream.
- **Linha 140**: (
- **Linha 141**: id_referencia_externa,
- **Linha 142**: entidade_tipo,
- **Linha 143**: evento_tipo,
- **Linha 144**: payload,
- **Linha 145**: hash_pipeline
- **Linha 146**: fechamento da lista de Parametros.
- **Linha 147**: VALUES
- **Linha 148**: (
- **Linha 149**: p_id_referencia,
- **Linha 150**: 'ESTOQUE',
- **Linha 151**: p_acao,
- **Linha 152**: JSON_OBJECT(
- **Linha 153**: 'item',p_id_item,
- **Linha 154**: 'lote',p_id_lote,
- **Linha 155**: 'qtd',p_quantidade,
- **Linha 156**: 'sessao',p_id_sessao
- **Linha 157**: ),
- **Linha 158**: v_hash
- **Linha 159**: );
- **Linha 162** (Comentario): FINALIZA PIPELINE
- **Linha 165**: UPDATE estoque_execucao_pipeline
- **Linha 166**: atribuicao de valor Ã  variavel estado.
- **Linha 167**: WHERE pipeline_hash=v_hash;
- **Linha 169**: COMMIT;
- **Linha 171**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estoque_fluxo_his`(
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_id_item BIGINT,
    IN p_id_lote BIGINT,
    IN p_quantidade DECIMAL(15,4),
    IN p_acao ENUM('RESERVAR','DISPENSAR','ESTORNAR_RESERVA'),
    IN p_id_referencia BIGINT,
    IN p_id_sessao BIGINT
)
BEGIN

    DECLARE v_hash CHAR(64);
    DECLARE v_fis DECIMAL(15,4);
    DECLARE v_res DECIMAL(15,4);

    -- VALIDAÇÃO DE SESSÃO
  

    IF p_id_sessao IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='LEI_IMUTAVEL: Sessao obrigatoria';
    END IF;


    -- PIPELINE HASH IDEMPOTENTE
   

    SET v_hash = SHA2(CONCAT(
        p_id_referencia,
        p_id_item,
        p_id_lote,
        p_acao,
        p_id_sessao
    ),256);


    -- LOCK DISTRIBUÍDO (ANTI REPLAY)


    INSERT INTO estoque_execucao_pipeline(pipeline_hash,estado)
    VALUES(v_hash,'PROCESSANDO')
    ON DUPLICATE KEY UPDATE pipeline_hash=pipeline_hash;

    START TRANSACTION;

      
        -- LOCK PESSIMISTA DO SALDO
     

        SELECT qtd_fisica,qtd_reservada
        INTO v_fis,v_res
        FROM estoque_saldo
        WHERE id_unidade=p_id_unidade
        AND id_local=p_id_local
        AND id_item=p_id_item
        AND id_lote=p_id_lote
        FOR UPDATE;


        -- MATERIALIZA SALDO SE NÃO EXISTIR
   

        IF v_fis IS NULL THEN

            SET v_fis = 0;
            SET v_res = 0;

            INSERT INTO estoque_saldo
            (
                id_unidade,
                id_local,
                id_item,
                id_lote,
                qtd_fisica,
                qtd_reservada,
                id_sessao_usuario
            )
            VALUES
            (
                p_id_unidade,
                p_id_local,
                p_id_item,
                p_id_lote,
                0,
                0,
                p_id_sessao
            )
            ON DUPLICATE KEY UPDATE id_saldo=id_saldo;

        END IF;


        -- MOTOR HIS LOGÍSTICO


        CASE p_acao

            WHEN 'RESERVAR' THEN

                IF (v_fis - v_res) < p_quantidade THEN
                    ROLLBACK;
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT='SALDO_PROJETADO_INSUFICIENTE';
                END IF;

                UPDATE estoque_saldo
                SET qtd_reservada = qtd_reservada + p_quantidade
                WHERE id_unidade=p_id_unidade
                AND id_local=p_id_local
                AND id_item=p_id_item
                AND id_lote=p_id_lote;

            WHEN 'DISPENSAR' THEN

                UPDATE estoque_saldo
                SET qtd_fisica = qtd_fisica - p_quantidade,
                    qtd_reservada = GREATEST(qtd_reservada - p_quantidade,0)
                WHERE id_unidade=p_id_unidade
                AND id_local=p_id_local
                AND id_item=p_id_item
                AND id_lote=p_id_lote;

            WHEN 'ESTORNAR_RESERVA' THEN

                UPDATE estoque_saldo
                SET qtd_reservada = GREATEST(qtd_reservada - p_quantidade,0)
                WHERE id_unidade=p_id_unidade
                AND id_local=p_id_local
                AND id_item=p_id_item
                AND id_lote=p_id_lote;

        END CASE;


        -- AUDITORIA SEMÂNTICA


        INSERT INTO estoque_audit_stream
        (
            id_referencia_externa,
            entidade_tipo,
            evento_tipo,
            payload,
            hash_pipeline
        )
        VALUES
        (
            p_id_referencia,
            'ESTOQUE',
            p_acao,
            JSON_OBJECT(
                'item',p_id_item,
                'lote',p_id_lote,
                'qtd',p_quantidade,
                'sessao',p_id_sessao
            ),
            v_hash
        );


        -- FINALIZA PIPELINE


        UPDATE estoque_execucao_pipeline
        SET estado='CONCLUIDO'
        WHERE pipeline_hash=v_hash;

    COMMIT;

END ;;
```

