# sp_master_atendimento

Objetivo: master atendimento conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_payload | JSON | IN | |
| p_resultado | JSON | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: atendimento, atendimento_evolucao
- UPDATE: atendimento, ffa
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- LAST_INSERT_ID
- NOW
- SIGNAL

## Views Utilizadas
- v_action
- v_diagnostico_cid
- v_status_novo

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
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: proc: BEGIN
- **Linha 9** (Comentario): Variáveis de Controle
- **Linha 10**: Declaracao de variavel local v_action.
- **Linha 11**: Declaracao de variavel local v_id_atendimento.
- **Linha 12**: Declaracao de variavel local v_id_paciente.
- **Linha 13**: Declaracao de variavel local v_id_ffa.
- **Linha 14**: Declaracao de variavel local v_status_novo.
- **Linha 16** (Comentario): Variáveis de Dados Clínicos
- **Linha 17**: Declaracao de variavel local v_queixa_principal.
- **Linha 18**: Declaracao de variavel local v_evolucao_texto.
- **Linha 19**: Declaracao de variavel local v_diagnostico_cid.
- **Linha 21** (Comentario): Handler de Erro Global (Sua Lei)
- **Linha 22**: Declaracao de variavel local EXIT.
- **Linha 23**: GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
- **Linha 24**: ROLLBACK;
- **Linha 25**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 26**: 'sucesso', FALSE,
- **Linha 27**: 'mensagem', CONCAT('ERRO_MASTER_ATENDIMENTO: ', @msg),
- **Linha 28**: 'timestamp', NOW()
- **Linha 29**: );
- **Linha 30**: Fim do bloco da procedure.
- **Linha 32** (Comentario): 1. Guardião de Runtime (Sessão)
- **Linha 33**: Invoca a procedure sp_sessao_assert.
- **Linha 35** (Comentario): 2. Extração de Intenção e Dados
- **Linha 36**: atribuicao de valor Ã  variavel v_action.
- **Linha 37**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 38**: atribuicao de valor Ã  variavel v_id_paciente.
- **Linha 39**: atribuicao de valor Ã  variavel v_id_ffa.
- **Linha 41**: START TRANSACTION;
- **Linha 43** (Comentario): =========================================================================
- **Linha 44** (Comentario): FLUXO: INICIAR (Antiga sp_atendimento_iniciar)
- **Linha 45** (Comentario): =========================================================================
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 47** (Comentario): Cria o atendimento vinculado ao paciente e ao fluxo (FFA)
- **Linha 48**: Insere um novo registro na tabela atendimento.
- **Linha 49**: VALUES (v_id_paciente, v_id_ffa, p_id_usuario, NOW(), 'EM_ATENDIMENTO');
- **Linha 51**: atribuicao de valor Ã  variavel v_id_atendimento.
- **Linha 53** (Comentario): Atualiza o status no FFA (Sincronia de Fluxo)
- **Linha 54**: Atualiza registros existentes na tabela ffa.
- **Linha 56**: atribuicao de valor Ã  variavel v_status_novo.
- **Linha 58** (Comentario): =========================================================================
- **Linha 59** (Comentario): FLUXO: EVOLUIR (Antiga sp_atendimento_adicionar_evolucao)
- **Linha 60** (Comentario): =========================================================================
- **Linha 61**: Estrutura condicional de controle de fluxo.
- **Linha 62**: atribuicao de valor Ã  variavel v_evolucao_texto.
- **Linha 64**: Insere um novo registro na tabela atendimento_evolucao.
- **Linha 65**: VALUES (v_id_atendimento, p_id_usuario, v_evolucao_texto, NOW());
- **Linha 67**: atribuicao de valor Ã  variavel v_status_novo.
- **Linha 69** (Comentario): =========================================================================
- **Linha 70** (Comentario): FLUXO: FINALIZAR (Antiga sp_atendimento_finalizar)
- **Linha 71** (Comentario): =========================================================================
- **Linha 72**: Estrutura condicional de controle de fluxo.
- **Linha 73**: atribuicao de valor Ã  variavel v_diagnostico_cid.
- **Linha 75**: Atualiza registros existentes na tabela atendimento.
- **Linha 76**: data_fim = NOW(),
- **Linha 77**: status = 'CONCLUIDO',
- **Linha 78**: cid_principal = v_diagnostico_cid
- **Linha 79**: WHERE id_atendimento = v_id_atendimento;
- **Linha 81** (Comentario): Libera o FFA
- **Linha 82**: Atualiza registros existentes na tabela ffa.
- **Linha 84**: atribuicao de valor Ã  variavel v_status_novo.
- **Linha 86**: Estrutura condicional de controle de fluxo.
- **Linha 87**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'AÇÃO NÃO RECONHECIDA NA MASTER ATENDIMENTO';
- **Linha 88**: Estrutura condicional de controle de fluxo.
- **Linha 90** (Comentario): 3. Auditoria Imutável Unificada
- **Linha 91**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 92**: p_id_sessao,
- **Linha 93**: 'ATENDIMENTO',
- **Linha 94**: v_id_atendimento,
- **Linha 95**: v_action,
- **Linha 96**: p_payload, -- Salva o payload completo para rastreabilidade total
- **Linha 97**: p_id_usuario,
- **Linha 98**: 'atendimento',
- **Linha 99**: NULL
- **Linha 100**: );
- **Linha 102**: COMMIT;
- **Linha 104** (Comentario): 4. Output padronizado para o Front (React)
- **Linha 105**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 106**: 'sucesso', TRUE,
- **Linha 107**: 'id_atendimento', v_id_atendimento,
- **Linha 108**: 'novo_status', v_status_novo,
- **Linha 109**: 'mensagem', 'Operação de atendimento processada com sucesso'
- **Linha 110**: );
- **Linha 112**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_atendimento`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON
)
    SQL SECURITY INVOKER
proc: BEGIN
    -- Variáveis de Controle
    DECLARE v_action VARCHAR(50);
    DECLARE v_id_atendimento BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;
    DECLARE v_status_novo VARCHAR(50);
    
    -- Variáveis de Dados Clínicos
    DECLARE v_queixa_principal TEXT;
    DECLARE v_evolucao_texto TEXT;
    DECLARE v_diagnostico_cid VARCHAR(20);

    -- Handler de Erro Global (Sua Lei)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        GET DIAGNOSTICS CONDITION 1 @msg = MESSAGE_TEXT;
        ROLLBACK;
        SET p_resultado = JSON_OBJECT(
            'sucesso', FALSE, 
            'mensagem', CONCAT('ERRO_MASTER_ATENDIMENTO: ', @msg),
            'timestamp', NOW()
        );
    END;

    -- 1. Guardião de Runtime (Sessão)
    CALL sp_sessao_assert(p_id_sessao);

    -- 2. Extração de Intenção e Dados
    SET v_action = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.action'));
    SET v_id_atendimento = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento'));
    SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));
    SET v_id_ffa = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_ffa'));
    
    START TRANSACTION;

    -- =========================================================================
    -- FLUXO: INICIAR (Antiga sp_atendimento_iniciar)
    -- =========================================================================
    IF v_action = 'INICIAR' THEN
        -- Cria o atendimento vinculado ao paciente e ao fluxo (FFA)
        INSERT INTO atendimento (id_paciente, id_ffa, id_profissional, data_inicio, status)
        VALUES (v_id_paciente, v_id_ffa, p_id_usuario, NOW(), 'EM_ATENDIMENTO');
        
        SET v_id_atendimento = LAST_INSERT_ID();
        
        -- Atualiza o status no FFA (Sincronia de Fluxo)
        UPDATE ffa SET status = 'EM_CONSULTA', atualizado_em = NOW() WHERE id_ffa = v_id_ffa;
        
        SET v_status_novo = 'INICIADO';

    -- =========================================================================
    -- FLUXO: EVOLUIR (Antiga sp_atendimento_adicionar_evolucao)
    -- =========================================================================
    ELSEIF v_action = 'EVOLUIR' THEN
        SET v_evolucao_texto = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data.evolucao'));
        
        INSERT INTO atendimento_evolucao (id_atendimento, id_profissional, texto_evolucao, criado_em)
        VALUES (v_id_atendimento, p_id_usuario, v_evolucao_texto, NOW());
        
        SET v_status_novo = 'EVOLUCAO_ADICIONADA';

    -- =========================================================================
    -- FLUXO: FINALIZAR (Antiga sp_atendimento_finalizar)
    -- =========================================================================
    ELSEIF v_action = 'FINALIZAR' THEN
        SET v_diagnostico_cid = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data.cid'));
        
        UPDATE atendimento SET 
            data_fim = NOW(), 
            status = 'CONCLUIDO',
            cid_principal = v_diagnostico_cid
        WHERE id_atendimento = v_id_atendimento;
        
        -- Libera o FFA
        UPDATE ffa SET status = 'ALTA_MEDICA', atualizado_em = NOW() WHERE id_ffa = v_id_ffa;
        
        SET v_status_novo = 'CONCLUIDO';

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'AÇÃO NÃO RECONHECIDA NA MASTER ATENDIMENTO';
    END IF;

    -- 3. Auditoria Imutável Unificada
    CALL sp_auditoria_evento_registrar(
        p_id_sessao, 
        'ATENDIMENTO', 
        v_id_atendimento, 
        v_action, 
        p_payload, -- Salva o payload completo para rastreabilidade total
        p_id_usuario, 
        'atendimento', 
        NULL
    );

    COMMIT;

    -- 4. Output padronizado para o Front (React)
    SET p_resultado = JSON_OBJECT(
        'sucesso', TRUE,
        'id_atendimento', v_id_atendimento,
        'novo_status', v_status_novo,
        'mensagem', 'Operação de atendimento processada com sucesso'
    );

END ;;
```

