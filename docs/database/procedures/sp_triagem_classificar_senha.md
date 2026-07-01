# sp_triagem_classificar_senha

Objetivo: triagem classificar senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_id_paciente | BIGINT | IN | |
| p_resultado | JSON | OUT | |
| p_sucesso | BOOLEAN | OUT | |
| p_mensagem | VARCHAR(500) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: classificacao_manchester, paciente
- INSERT: triagem
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_evento_log

## Functions Utilizadas
- CONCAT
- IF
- JSON_OBJECT
- LAST_INSERT_ID
- NOW
- TIMESTAMPDIFF
- UUID

## Views Utilizadas
- v_cor_interna
- v_error_msg
- v_hora_classificacao
- v_uuid_transacao

## Eventos Gerados
- evento
- ledger_evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

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
- **Linha 12**: SQL SECURITY INVOKER
- **Linha 13**: proc_block: BEGIN
- **Linha 14**: Declaracao de variavel local v_uuid_transacao.
- **Linha 15**: Declaracao de variavel local v_error_msg.
- **Linha 16**: Declaracao de variavel local v_id_triagem.
- **Linha 17**: Declaracao de variavel local v_manchester.
- **Linha 18**: Declaracao de variavel local v_idade.
- **Linha 19**: Declaracao de variavel local v_prioridade_especialidade.
- **Linha 20**: Declaracao de variavel local v_grau_prioridade.
- **Linha 21**: Declaracao de variavel local v_cor_interna.
- **Linha 22**: Declaracao de variavel local v_hora_classificacao.
- **Linha 24** (Comentario): =========================
- **Linha 25** (Comentario): HANDLER GLOBAL DE ERRO
- **Linha 26** (Comentario): =========================
- **Linha 27**: Declaracao de variavel local EXIT.
- **Linha 28**: inicio do bloco de execucao.
- **Linha 29**: GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
- **Linha 30**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 31**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 32**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 33**: ROLLBACK;
- **Linha 35**: Invoca a procedure sp_ledger_evento_log.
- **Linha 36**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'TRIAGEM_CLASSIFICAR',
- **Linha 37**: NULL, v_id_triagem,
- **Linha 38**: JSON_OBJECT('id_senha', p_id_senha, 'id_paciente', p_id_paciente),
- **Linha 39**: 'ERRO', v_error_msg
- **Linha 40**: );
- **Linha 41**: Fim do bloco da procedure.
- **Linha 43** (Comentario): =========================
- **Linha 44** (Comentario): VALIDAR SESSÃO
- **Linha 45** (Comentario): =========================
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 47**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 48**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 49**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 50**: Estrutura de repeticao/controle de loop.
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 53** (Comentario): =========================
- **Linha 54** (Comentario): INICIAR TRANSAÇÃO
- **Linha 55** (Comentario): =========================
- **Linha 56**: START TRANSACTION;
- **Linha 58** (Comentario): =========================
- **Linha 59** (Comentario): OBTER IDADE E DADOS DO PACIENTE
- **Linha 60** (Comentario): =========================
- **Linha 61**: execucao de query SELECT para consulta de dados.
- **Linha 62**: especialidade
- **Linha 63**: INTO v_idade, v_prioridade_especialidade
- **Linha 64**: FROM paciente
- **Linha 65**: WHERE id_paciente = p_id_paciente;
- **Linha 67** (Comentario): =========================
- **Linha 68** (Comentario): CALCULAR PRIORIDADE MANCHESTER + IDADE + ESPECIALIDADE
- **Linha 69** (Comentario): =========================
- **Linha 70**: Estrutura condicional de controle de fluxo.
- **Linha 71**: execucao de query SELECT para consulta de dados.
- **Linha 72**: INTO v_manchester
- **Linha 73**: FROM classificacao_manchester
- **Linha 74**: WHERE id_paciente = p_id_paciente
- **Linha 75**: ORDER BY criado_em DESC
- **Linha 76**: LIMIT 1;
- **Linha 78**: atribuicao de valor Ã  variavel v_grau_prioridade.
- **Linha 79**: + IF(v_idade >= 65, 1, 0)
- **Linha 80**: + IF(v_prioridade_especialidade IS NOT NULL, 1, 0);
- **Linha 81**: Estrutura condicional de controle de fluxo.
- **Linha 82**: atribuicao de valor Ã  variavel v_grau_prioridade.
- **Linha 83**: atribuicao de valor Ã  variavel v_manchester.
- **Linha 84**: Estrutura condicional de controle de fluxo.
- **Linha 86** (Comentario): =========================
- **Linha 87** (Comentario): DEFINIR COR INTERNA PARA PAINEL
- **Linha 88** (Comentario): =========================
- **Linha 89**: atribuicao de valor Ã  variavel v_cor_interna.
- **Linha 90**: WHEN v_grau_prioridade >= 3 THEN 'VERMELHO'
- **Linha 91**: WHEN v_grau_prioridade = 2 THEN 'AMARELO'
- **Linha 92**: WHEN v_grau_prioridade = 1 THEN 'VERDE'
- **Linha 93**: Estrutura condicional de controle de fluxo.
- **Linha 94**: Fim do bloco da procedure.
- **Linha 96** (Comentario): =========================
- **Linha 97** (Comentario): INSERIR REGISTRO DE TRIAGEM
- **Linha 98** (Comentario): =========================
- **Linha 99**: Insere um novo registro na tabela triagem.
- **Linha 100**: id_senha,
- **Linha 101**: id_paciente,
- **Linha 102**: manchester,
- **Linha 103**: idade,
- **Linha 104**: prioridade_especialidade,
- **Linha 105**: grau_prioridade,
- **Linha 106**: cor_interna,
- **Linha 107**: classificado_por,
- **Linha 108**: criado_em
- **Linha 109**: ) VALUES (
- **Linha 110**: p_id_senha,
- **Linha 111**: p_id_paciente,
- **Linha 112**: v_manchester,
- **Linha 113**: v_idade,
- **Linha 114**: v_prioridade_especialidade,
- **Linha 115**: v_grau_prioridade,
- **Linha 116**: v_cor_interna,
- **Linha 117**: p_id_usuario,
- **Linha 118**: v_hora_classificacao
- **Linha 119**: );
- **Linha 121**: atribuicao de valor Ã  variavel v_id_triagem.
- **Linha 123** (Comentario): =========================
- **Linha 124** (Comentario): REGISTRAR LEDGER
- **Linha 125** (Comentario): =========================
- **Linha 126**: Invoca a procedure sp_ledger_evento_log.
- **Linha 127**: v_uuid_transacao, p_id_usuario, p_id_perfil, 'TRIAGEM_CLASSIFICAR',
- **Linha 128**: NULL, v_id_triagem,
- **Linha 129**: JSON_OBJECT('id_senha', p_id_senha, 'id_paciente', p_id_paciente),
- **Linha 130**: 'SUCESSO', CONCAT('Paciente classificado com prioridade ', v_grau_prioridade)
- **Linha 131**: );
- **Linha 133** (Comentario): =========================
- **Linha 134** (Comentario): RETORNO PADRÃO
- **Linha 135** (Comentario): =========================
- **Linha 136**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 137**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 138**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 139**: 'id_triagem', v_id_triagem,
- **Linha 140**: 'id_senha', p_id_senha,
- **Linha 141**: 'id_paciente', p_id_paciente,
- **Linha 142**: 'manchester', v_manchester,
- **Linha 143**: 'idade', v_idade,
- **Linha 144**: 'prioridade_especialidade', v_prioridade_especialidade,
- **Linha 145**: 'grau_prioridade', v_grau_prioridade,
- **Linha 146**: 'cor_interna', v_cor_interna,
- **Linha 147**: 'uuid_transacao', v_uuid_transacao
- **Linha 148**: );
- **Linha 150** (Comentario): =========================
- **Linha 151** (Comentario): COMMIT TRANSAÇÃO
- **Linha 152** (Comentario): =========================
- **Linha 153**: COMMIT;
- **Linha 155**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_triagem_classificar_senha`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_paciente BIGINT,
    IN p_manha_prioridade BOOLEAN,  -- TRUE = aplicar lógica de prioridade
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem VARCHAR(500)
)
    SQL SECURITY INVOKER
proc_block: BEGIN
    DECLARE v_uuid_transacao CHAR(36) DEFAULT UUID();
    DECLARE v_error_msg VARCHAR(500) DEFAULT NULL;
    DECLARE v_id_triagem BIGINT DEFAULT NULL;
    DECLARE v_manchester INT DEFAULT NULL;
    DECLARE v_idade INT DEFAULT NULL;
    DECLARE v_prioridade_especialidade INT DEFAULT NULL;
    DECLARE v_grau_prioridade INT DEFAULT NULL;
    DECLARE v_cor_interna VARCHAR(20) DEFAULT 'AZUL';
    DECLARE v_hora_classificacao DATETIME DEFAULT NOW(6);

    -- =========================
    -- HANDLER GLOBAL DE ERRO
    -- =========================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_error_msg = MESSAGE_TEXT;
        SET p_sucesso = FALSE;
        SET p_mensagem = CONCAT('ERRO: ', v_error_msg);
        SET p_resultado = JSON_OBJECT('error', v_error_msg, 'uuid_transacao', v_uuid_transacao);
        ROLLBACK;

        CALL sp_ledger_evento_log(
            v_uuid_transacao, p_id_usuario, p_id_perfil, 'TRIAGEM_CLASSIFICAR',
            NULL, v_id_triagem,
            JSON_OBJECT('id_senha', p_id_senha, 'id_paciente', p_id_paciente),
            'ERRO', v_error_msg
        );
    END;

    -- =========================
    -- VALIDAR SESSÃO
    -- =========================
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SET p_sucesso = FALSE;
        SET p_mensagem = 'Sessão inválida';
        SET p_resultado = JSON_OBJECT('error', 'Sessão inválida', 'uuid_transacao', v_uuid_transacao);
        LEAVE proc_block;
    END IF;

    -- =========================
    -- INICIAR TRANSAÇÃO
    -- =========================
    START TRANSACTION;

    -- =========================
    -- OBTER IDADE E DADOS DO PACIENTE
    -- =========================
    SELECT TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()),
           especialidade
    INTO v_idade, v_prioridade_especialidade
    FROM paciente
    WHERE id_paciente = p_id_paciente;

    -- =========================
    -- CALCULAR PRIORIDADE MANCHESTER + IDADE + ESPECIALIDADE
    -- =========================
    IF p_manha_prioridade THEN
        SELECT manchester
        INTO v_manchester
        FROM classificacao_manchester
        WHERE id_paciente = p_id_paciente
        ORDER BY criado_em DESC
        LIMIT 1;

        SET v_grau_prioridade = v_manchester
                                 + IF(v_idade >= 65, 1, 0)
                                 + IF(v_prioridade_especialidade IS NOT NULL, 1, 0);
    ELSE
        SET v_grau_prioridade = 1; -- padrão
        SET v_manchester = 0;
    END IF;

    -- =========================
    -- DEFINIR COR INTERNA PARA PAINEL
    -- =========================
    SET v_cor_interna = CASE
        WHEN v_grau_prioridade >= 3 THEN 'VERMELHO'
        WHEN v_grau_prioridade = 2 THEN 'AMARELO'
        WHEN v_grau_prioridade = 1 THEN 'VERDE'
        ELSE 'AZUL'
    END;

    -- =========================
    -- INSERIR REGISTRO DE TRIAGEM
    -- =========================
    INSERT INTO triagem (
        id_senha,
        id_paciente,
        manchester,
        idade,
        prioridade_especialidade,
        grau_prioridade,
        cor_interna,
        classificado_por,
        criado_em
    ) VALUES (
        p_id_senha,
        p_id_paciente,
        v_manchester,
        v_idade,
        v_prioridade_especialidade,
        v_grau_prioridade,
        v_cor_interna,
        p_id_usuario,
        v_hora_classificacao
    );

    SET v_id_triagem = LAST_INSERT_ID();

    -- =========================
    -- REGISTRAR LEDGER
    -- =========================
    CALL sp_ledger_evento_log(
        v_uuid_transacao, p_id_usuario, p_id_perfil, 'TRIAGEM_CLASSIFICAR',
        NULL, v_id_triagem,
        JSON_OBJECT('id_senha', p_id_senha, 'id_paciente', p_id_paciente),
        'SUCESSO', CONCAT('Paciente classificado com prioridade ', v_grau_prioridade)
    );

    -- =========================
    -- RETORNO PADRÃO
    -- =========================
    SET p_sucesso = TRUE;
    SET p_mensagem = 'Triagem realizada com sucesso';
    SET p_resultado = JSON_OBJECT(
        'id_triagem', v_id_triagem,
        'id_senha', p_id_senha,
        'id_paciente', p_id_paciente,
        'manchester', v_manchester,
        'idade', v_idade,
        'prioridade_especialidade', v_prioridade_especialidade,
        'grau_prioridade', v_grau_prioridade,
        'cor_interna', v_cor_interna,
        'uuid_transacao', v_uuid_transacao
    );

    -- =========================
    -- COMMIT TRANSAÇÃO
    -- =========================
    COMMIT;

END ;;
```

