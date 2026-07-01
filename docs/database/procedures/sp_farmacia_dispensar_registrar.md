# sp_farmacia_dispensar_registrar

Objetivo: farmacia dispensar registrar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_quantidade | DECIMAL(15,4) | IN | |
| p_observacao | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: estoque_movimento, farm_dispensacao, farm_dispensacao_item
- UPDATE: estoque_lote
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar

## Functions Utilizadas
- CONCAT
- IF
- LAST_INSERT_ID
- NOW
- SIGNAL

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- auditoria_evento
- evento

## Tratamento de Erros

- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

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
- **Linha 14** (Comentario): 1. VALIDAÇÃO DE SESSÃO (SUA LEI Nº 1)
- **Linha 15**: Estrutura condicional de controle de fluxo.
- **Linha 16**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_LOGICA_IMUTAVEL: Sessao obrigatoria.';
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 19** (Comentario): 2. REGISTRA A DISPENSAÇÃO (PARA QUEM/QUANDO)
- **Linha 20**: Insere um novo registro na tabela farm_dispensacao.
- **Linha 21**: VALUES (p_id_paciente, p_id_unidade, NOW(), 'CONCLUIDA');
- **Linha 23**: atribuicao de valor Ã  variavel v_id_dispensacao.
- **Linha 25** (Comentario): 3. REGISTRA O ITEM E O LOTE
- **Linha 26**: Insere um novo registro na tabela farm_dispensacao_item.
- **Linha 27**: VALUES (v_id_dispensacao, p_id_produto, p_id_lote, p_quantidade);
- **Linha 29** (Comentario): 4. MOVIMENTAÇÃO DE ESTOQUE (ONDE/QUANTO)
- **Linha 30** (Comentario): Usando sua tabela 'estoque_movimento' identificada no dump
- **Linha 31**: Insere um novo registro na tabela estoque_movimento.
- **Linha 32**: VALUES (p_id_unidade, NOW(), 'SAIDA_DISPENSACAO', p_id_sessao_usuario);
- **Linha 34**: atribuicao de valor Ã  variavel v_id_movimento.
- **Linha 36** (Comentario): 5. ATUALIZAÇÃO DO SALDO (SEM TRIGGER)
- **Linha 37**: UPDATE estoque_lote
- **Linha 38**: atribuicao de valor Ã  variavel quantidade_atual.
- **Linha 39**: WHERE id_lote = p_id_lote;
- **Linha 41** (Comentario): 6. AUDITORIA TOTAL (SUA LEI Nº 2)
- **Linha 42** (Comentario): "Sempre saber quem, onde, quando e para quem"
- **Linha 43**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 44**: p_id_sessao_usuario,
- **Linha 45**: 'FARM_DISPENSACAO',
- **Linha 46**: v_id_dispensacao,
- **Linha 47**: 'DISPENSAR',
- **Linha 48**: CONCAT('Dispensação para paciente ', p_id_paciente,
- **Linha 49**: ' | Produto: ', p_id_produto,
- **Linha 50**: ' | Lote: ', p_id_lote,
- **Linha 51**: ' | Qtd: ', p_quantidade,
- **Linha 52**: ' | Unidade: ', p_id_unidade)
- **Linha 53**: );
- **Linha 55**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_farmacia_dispensar_registrar`(
    IN p_id_sessao_usuario BIGINT, -- QUEM (Sessão rastreável)
    IN p_id_unidade BIGINT,        -- ONDE (Qual hospital/unidade)
    IN p_id_paciente BIGINT,       -- PARA QUEM
    IN p_id_produto BIGINT,        -- O QUÊ
    IN p_id_lote BIGINT,           -- QUAL LOTE ESPECÍFICO
    IN p_quantidade DECIMAL(15,4),
    IN p_observacao TEXT
)
BEGIN
    DECLARE v_id_dispensacao BIGINT;
    DECLARE v_id_movimento BIGINT;

    -- 1. VALIDAÇÃO DE SESSÃO (SUA LEI Nº 1)
    IF p_id_sessao_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_LOGICA_IMUTAVEL: Sessao obrigatoria.';
    END IF;

    -- 2. REGISTRA A DISPENSAÇÃO (PARA QUEM/QUANDO)
    INSERT INTO farm_dispensacao (id_paciente, id_unidade, data_dispensacao, status)
    VALUES (p_id_paciente, p_id_unidade, NOW(), 'CONCLUIDA');
    
    SET v_id_dispensacao = LAST_INSERT_ID();

    -- 3. REGISTRA O ITEM E O LOTE
    INSERT INTO farm_dispensacao_item (id_dispensacao, id_produto, lote, quantidade)
    VALUES (v_id_dispensacao, p_id_produto, p_id_lote, p_quantidade);

    -- 4. MOVIMENTAÇÃO DE ESTOQUE (ONDE/QUANTO)
    -- Usando sua tabela 'estoque_movimento' identificada no dump
    INSERT INTO estoque_movimento (id_unidade, data_movimento, tipo_movimento, id_usuario_responsavel)
    VALUES (p_id_unidade, NOW(), 'SAIDA_DISPENSACAO', p_id_sessao_usuario);
    
    SET v_id_movimento = LAST_INSERT_ID();

    -- 5. ATUALIZAÇÃO DO SALDO (SEM TRIGGER)
    UPDATE estoque_lote 
    SET quantidade_atual = quantidade_atual - p_quantidade 
    WHERE id_lote = p_id_lote;

    -- 6. AUDITORIA TOTAL (SUA LEI Nº 2)
    -- "Sempre saber quem, onde, quando e para quem"
    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'FARM_DISPENSACAO',
        v_id_dispensacao,
        'DISPENSAR',
        CONCAT('Dispensação para paciente ', p_id_paciente, 
               ' | Produto: ', p_id_produto, 
               ' | Lote: ', p_id_lote, 
               ' | Qtd: ', p_quantidade,
               ' | Unidade: ', p_id_unidade)
    );

END ;;
```

