# sp_master_paciente

Objetivo: master paciente conforme definida no dump SQL do sistema.

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
- SELECT: paciente
- INSERT: log_erros, paciente
- UPDATE: paciente
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar
- sp_sessao_assert

## Functions Utilizadas
- CAST
- CONCAT
- IF
- IFNULL
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- LAST_INSERT_ID
- LOG
- NOW
- SIGNAL

## Views Utilizadas
- v_action
- v_cpf
- v_genero
- v_nome
- v_nome_mae
- v_status_registro

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
- **Linha 9** (Comentario): Variáveis de Fluxo
- **Linha 10**: Declaracao de variavel local v_action.
- **Linha 11**: Declaracao de variavel local v_id_paciente.
- **Linha 12**: Declaracao de variavel local v_nome.
- **Linha 13**: Declaracao de variavel local v_cpf.
- **Linha 14**: Declaracao de variavel local v_data_nascimento.
- **Linha 15**: Declaracao de variavel local v_nome_mae.
- **Linha 16**: Declaracao de variavel local v_genero.
- **Linha 17**: Declaracao de variavel local v_status_registro.
- **Linha 19** (Comentario): Variáveis de Auditoria/Erro
- **Linha 20**: Declaracao de variavel local v_info_anterior.
- **Linha 21**: Declaracao de variavel local v_id_audit.
- **Linha 23** (Comentario): Handler Global de Erros (Padrão Parrudo)
- **Linha 24**: Declaracao de variavel local EXIT.
- **Linha 25**: GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
- **Linha 26**: ROLLBACK;
- **Linha 27**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 28**: 'sucesso', FALSE,
- **Linha 29**: 'erro', JSON_OBJECT('codigo', @errno, 'estado', @sqlstate, 'mensagem', @text),
- **Linha 30**: 'contexto', 'sp_master_paciente'
- **Linha 31**: );
- **Linha 32** (Comentario): Log de erro na auditoria imutável
- **Linha 33**: Insere um novo registro na tabela log_erros.
- **Linha 34**: VALUES (p_id_usuario, 'sp_master_paciente', @text, p_payload);
- **Linha 35**: Fim do bloco da procedure.
- **Linha 37** (Comentario): 1. Validação de Sessão (Lei Imutável)
- **Linha 38**: Invoca a procedure sp_sessao_assert.
- **Linha 40** (Comentario): 2. Extração de Parâmetros do Payload
- **Linha 41**: atribuicao de valor Ã  variavel v_action.
- **Linha 42**: atribuicao de valor Ã  variavel v_id_paciente.
- **Linha 44** (Comentario): Mapeamento dos dados do paciente dentro do objeto 'data'
- **Linha 45**: atribuicao de valor Ã  variavel v_nome.
- **Linha 46**: atribuicao de valor Ã  variavel v_cpf.
- **Linha 47**: atribuicao de valor Ã  variavel v_data_nascimento.
- **Linha 48**: atribuicao de valor Ã  variavel v_nome_mae.
- **Linha 49**: atribuicao de valor Ã  variavel v_genero.
- **Linha 51**: START TRANSACTION;
- **Linha 53** (Comentario): =========================================================================
- **Linha 54** (Comentario): FLUXO: SALVAR (INSERT OU UPDATE)
- **Linha 55** (Comentario): =========================================================================
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58** (Comentario): Captura estado anterior para auditoria (se existir)
- **Linha 59**: Estrutura condicional de controle de fluxo.
- **Linha 60**: execucao de query SELECT para consulta de dados.
- **Linha 61**: INTO v_info_anterior FROM paciente WHERE id = v_id_paciente FOR UPDATE;
- **Linha 62**: Estrutura condicional de controle de fluxo.
- **Linha 64**: Estrutura condicional de controle de fluxo.
- **Linha 65** (Comentario): Lógica de Inserção (Substitui sp_paciente_cadastrar_basico)
- **Linha 66**: Insere um novo registro na tabela paciente.
- **Linha 67**: VALUES (v_nome, v_cpf, v_data_nascimento, v_nome_mae, v_genero, NOW());
- **Linha 69**: atribuicao de valor Ã  variavel v_id_paciente.
- **Linha 70**: atribuicao de valor Ã  variavel v_status_registro.
- **Linha 71**: Estrutura condicional de controle de fluxo.
- **Linha 72** (Comentario): Lógica de Atualização (Substitui sp_update_nome_paciente)
- **Linha 73**: Atualiza registros existentes na tabela paciente.
- **Linha 74**: nome = IFNULL(v_nome, nome),
- **Linha 75**: cpf = IFNULL(v_cpf, cpf),
- **Linha 76**: data_nascimento = IFNULL(v_data_nascimento, data_nascimento),
- **Linha 77**: nome_mae = IFNULL(v_nome_mae, nome_mae),
- **Linha 78**: genero = IFNULL(v_genero, genero),
- **Linha 79**: atualizado_em = NOW()
- **Linha 80**: WHERE id = v_id_paciente;
- **Linha 82**: atribuicao de valor Ã  variavel v_status_registro.
- **Linha 83**: Estrutura condicional de controle de fluxo.
- **Linha 85** (Comentario): =========================================================================
- **Linha 86** (Comentario): FLUXO: INATIVAR/BLOQUEAR
- **Linha 87** (Comentario): =========================================================================
- **Linha 88**: Estrutura condicional de controle de fluxo.
- **Linha 89**: Atualiza registros existentes na tabela paciente.
- **Linha 90**: atribuicao de valor Ã  variavel v_status_registro.
- **Linha 92**: Estrutura condicional de controle de fluxo.
- **Linha 93**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação (action) inválida ou não informada na Master Paciente.';
- **Linha 94**: Estrutura condicional de controle de fluxo.
- **Linha 96** (Comentario): 3. Registro de Auditoria (Sua Lei: sp_auditoria_evento_registrar)
- **Linha 97** (Comentario): Registra quem, quando, onde e o que mudou (com snapshot anterior se for update)
- **Linha 98**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 99**: p_id_sessao,
- **Linha 100**: 'PACIENTE',
- **Linha 101**: v_id_paciente,
- **Linha 102**: v_action,
- **Linha 103**: JSON_OBJECT('status', v_status_registro, 'anterior', v_info_anterior),
- **Linha 104**: p_id_usuario,
- **Linha 105**: 'paciente',
- **Linha 106**: NULL
- **Linha 107**: );
- **Linha 109**: COMMIT;
- **Linha 111** (Comentario): 4. Retorno Estruturado para o Front-end (React)
- **Linha 112**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 113**: 'sucesso', TRUE,
- **Linha 114**: 'id_paciente', v_id_paciente,
- **Linha 115**: 'action', v_action,
- **Linha 116**: 'mensagem', CONCAT('Paciente ', v_status_registro, ' com sucesso.')
- **Linha 117**: );
- **Linha 119**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_paciente`(
    IN p_id_sessao BIGINT,
    IN p_id_usuario BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON
)
    SQL SECURITY INVOKER
proc: BEGIN
    -- Variáveis de Fluxo
    DECLARE v_action VARCHAR(50);
    DECLARE v_id_paciente BIGINT;
    DECLARE v_nome VARCHAR(255);
    DECLARE v_cpf VARCHAR(14);
    DECLARE v_data_nascimento DATE;
    DECLARE v_nome_mae VARCHAR(255);
    DECLARE v_genero VARCHAR(20);
    DECLARE v_status_registro VARCHAR(20);
    
    -- Variáveis de Auditoria/Erro
    DECLARE v_info_anterior JSON;
    DECLARE v_id_audit BIGINT;

    -- Handler Global de Erros (Padrão Parrudo)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
        ROLLBACK;
        SET p_resultado = JSON_OBJECT(
            'sucesso', FALSE, 
            'erro', JSON_OBJECT('codigo', @errno, 'estado', @sqlstate, 'mensagem', @text),
            'contexto', 'sp_master_paciente'
        );
        -- Log de erro na auditoria imutável
        INSERT INTO log_erros (id_usuario, rotina, erro_msg, payload_origem) 
        VALUES (p_id_usuario, 'sp_master_paciente', @text, p_payload);
    END;

    -- 1. Validação de Sessão (Lei Imutável)
    CALL sp_sessao_assert(p_id_sessao);

    -- 2. Extração de Parâmetros do Payload
    SET v_action = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.action'));
    SET v_id_paciente = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_paciente'));
    
    -- Mapeamento dos dados do paciente dentro do objeto 'data'
    SET v_nome = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data.nome'));
    SET v_cpf = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data.cpf'));
    SET v_data_nascimento = CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data.data_nascimento')) AS DATE);
    SET v_nome_mae = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data.nome_mae'));
    SET v_genero = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.data.genero'));

    START TRANSACTION;

    -- =========================================================================
    -- FLUXO: SALVAR (INSERT OU UPDATE)
    -- =========================================================================
    IF v_action = 'SALVAR' THEN
        
        -- Captura estado anterior para auditoria (se existir)
        IF v_id_paciente IS NOT NULL THEN
            SELECT JSON_OBJECT('nome', nome, 'cpf', cpf, 'nome_mae', nome_mae) 
            INTO v_info_anterior FROM paciente WHERE id = v_id_paciente FOR UPDATE;
        END IF;

        IF v_id_paciente IS NULL OR v_id_paciente = 0 THEN
            -- Lógica de Inserção (Substitui sp_paciente_cadastrar_basico)
            INSERT INTO paciente (nome, cpf, data_nascimento, nome_mae, genero, criado_em)
            VALUES (v_nome, v_cpf, v_data_nascimento, v_nome_mae, v_genero, NOW());
            
            SET v_id_paciente = LAST_INSERT_ID();
            SET v_status_registro = 'CRIADO';
        ELSE
            -- Lógica de Atualização (Substitui sp_update_nome_paciente)
            UPDATE paciente SET 
                nome = IFNULL(v_nome, nome),
                cpf = IFNULL(v_cpf, cpf),
                data_nascimento = IFNULL(v_data_nascimento, data_nascimento),
                nome_mae = IFNULL(v_nome_mae, nome_mae),
                genero = IFNULL(v_genero, genero),
                atualizado_em = NOW()
            WHERE id = v_id_paciente;
            
            SET v_status_registro = 'ATUALIZADO';
        END IF;

    -- =========================================================================
    -- FLUXO: INATIVAR/BLOQUEAR
    -- =========================================================================
    ELSEIF v_action = 'INATIVAR' THEN
        UPDATE paciente SET ativo = 0, atualizado_em = NOW() WHERE id = v_id_paciente;
        SET v_status_registro = 'INATIVADO';

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação (action) inválida ou não informada na Master Paciente.';
    END IF;

    -- 3. Registro de Auditoria (Sua Lei: sp_auditoria_evento_registrar)
    -- Registra quem, quando, onde e o que mudou (com snapshot anterior se for update)
    CALL sp_auditoria_evento_registrar(
        p_id_sessao, 
        'PACIENTE', 
        v_id_paciente, 
        v_action, 
        JSON_OBJECT('status', v_status_registro, 'anterior', v_info_anterior), 
        p_id_usuario, 
        'paciente', 
        NULL
    );

    COMMIT;

    -- 4. Retorno Estruturado para o Front-end (React)
    SET p_resultado = JSON_OBJECT(
        'sucesso', TRUE,
        'id_paciente', v_id_paciente,
        'action', v_action,
        'mensagem', CONCAT('Paciente ', v_status_registro, ' com sucesso.')
    );

END ;;
```

