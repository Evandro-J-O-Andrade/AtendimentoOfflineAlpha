# sp_atendimento_senha_nao_compareceu

Objetivo: atendimento senha nao compareceu conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: senha, sessao_usuario, usuario, usuario_sistema
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_ledger_registrar_evento

## Functions Utilizadas
- IF
- JSON_OBJECT
- SIGNAL
- UUID

## Views Utilizadas
- v_nome_usuario
- v_uuid_transacao

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: main: BEGIN
- **Linha 7**: Declaracao de variavel local v_id_usuario.
- **Linha 8**: Declaracao de variavel local v_id_unidade.
- **Linha 9**: Declaracao de variavel local v_id_perfil.
- **Linha 10**: Declaracao de variavel local v_nome_usuario.
- **Linha 11**: Declaracao de variavel local v_payload_old.
- **Linha 12**: Declaracao de variavel local v_uuid_transacao.
- **Linha 13**: Declaracao de variavel local v_id_evento.
- **Linha 15** (Comentario): 1. Validação de Contexto (Sessão Ativa e Dados do Usuário)
- **Linha 16** (Comentario): Colunas validadas: su.ativo, su.id_unidade, u.nome
- **Linha 17**: SELECT
- **Linha 18**: su.id_usuario,
- **Linha 19**: su.id_unidade,
- **Linha 20**: us.id_perfil,
- **Linha 21**: u.nome
- **Linha 22**: INTO
- **Linha 23**: v_id_usuario,
- **Linha 24**: v_id_unidade,
- **Linha 25**: v_id_perfil,
- **Linha 26**: v_nome_usuario
- **Linha 27**: FROM sessao_usuario su
- **Linha 28**: INNER JOIN usuario_sistema us ON su.id_usuario = us.id_usuario
- **Linha 29**: INNER JOIN usuario u ON u.id_usuario = su.id_usuario
- **Linha 30**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 32**: LIMIT 1;
- **Linha 34** (Comentario): Se a sessão não for encontrada ou não estiver ativa, interrompe
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 36**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão inválida ou utilizador não autenticado.';
- **Linha 37**: Estrutura condicional de controle de fluxo.
- **Linha 39** (Comentario): 2. Snapshot do Estado Atual (Garante a Auditoria antes da mudança)
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 41**: 'id_senha', id_senha,
- **Linha 42**: 'codigo_visual', codigo_visual,
- **Linha 43**: 'id_fluxo_status', id_fluxo_status,
- **Linha 44**: 'id_atendimento', id_atendimento
- **Linha 45**: ) INTO v_payload_old
- **Linha 46**: FROM senha
- **Linha 47**: WHERE id_senha = p_id_senha;
- **Linha 49** (Comentario): 3. Transação de Dados
- **Linha 50**: START TRANSACTION;
- **Linha 52** (Comentario): Atualiza para o status 99 (Não Compareceu/Evasão)
- **Linha 53**: UPDATE senha
- **Linha 54**: atribuicao de valor Ã  variavel id_fluxo_status.
- **Linha 55**: WHERE id_senha = p_id_senha;
- **Linha 57** (Comentario): 4. Registro no Ledger Imutável (Chamando sua sp_ledger_registrar_evento)
- **Linha 58**: Invoca a procedure sp_ledger_registrar_evento.
- **Linha 59**: NULL,                  -- uuid_transacao_pai
- **Linha 60**: v_id_usuario,          -- id_usuario
- **Linha 61**: p_id_sessao_usuario,   -- id_sessao
- **Linha 62**: v_id_perfil,           -- id_perfil
- **Linha 63**: v_nome_usuario,        -- nome_usuario
- **Linha 64**: 'SENHA_NAO_COMPARECEU',-- acao
- **Linha 65**: 'RECEPCAO',            -- modulo
- **Linha 66**: 'PAINEL',              -- sub_modulo
- **Linha 67**: 'CHAMANDO',            -- estado_origem
- **Linha 68**: 'NAO_COMPARECEU',      -- estado_destino
- **Linha 69**: v_payload_old,         -- estado_anterior (JSON capturado)
- **Linha 70**: JSON_OBJECT('id_fluxo_status', 99), -- estado_novo
- **Linha 71**: JSON_OBJECT('id_senha', p_id_senha), -- payload_original
- **Linha 72**: 'SUCESSO',             -- status_evento
- **Linha 73**: NULL,                  -- codigo_erro
- **Linha 74**: 'Chamada encerrada por não comparecimento do paciente', -- mensagem
- **Linha 75**: 0,                     -- processing_time_ms
- **Linha 76**: v_uuid_transacao,      -- OUT uuid
- **Linha 77**: v_id_evento            -- OUT id_evento
- **Linha 78**: );
- **Linha 80**: COMMIT;
- **Linha 82**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atendimento_senha_nao_compareceu`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_nome_usuario VARCHAR(100);
    DECLARE v_payload_old JSON;
    DECLARE v_uuid_transacao CHAR(36);
    DECLARE v_id_evento BIGINT;

    -- 1. Validação de Contexto (Sessão Ativa e Dados do Usuário)
    -- Colunas validadas: su.ativo, su.id_unidade, u.nome
    SELECT 
        su.id_usuario, 
        su.id_unidade,
        us.id_perfil,
        u.nome
    INTO 
        v_id_usuario, 
        v_id_unidade,
        v_id_perfil,
        v_nome_usuario
    FROM sessao_usuario su
    INNER JOIN usuario_sistema us ON su.id_usuario = us.id_usuario
    INNER JOIN usuario u ON u.id_usuario = su.id_usuario
    WHERE su.id_sessao_usuario = p_id_sessao_usuario 
      AND su.ativo = 1 
    LIMIT 1;

    -- Se a sessão não for encontrada ou não estiver ativa, interrompe
    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sessão inválida ou utilizador não autenticado.';
    END IF;

    -- 2. Snapshot do Estado Atual (Garante a Auditoria antes da mudança)
    SELECT JSON_OBJECT(
        'id_senha', id_senha,
        'codigo_visual', codigo_visual,
        'id_fluxo_status', id_fluxo_status,
        'id_atendimento', id_atendimento
    ) INTO v_payload_old
    FROM senha 
    WHERE id_senha = p_id_senha;

    -- 3. Transação de Dados
    START TRANSACTION;

        -- Atualiza para o status 99 (Não Compareceu/Evasão)
        UPDATE senha 
        SET id_fluxo_status = 99 
        WHERE id_senha = p_id_senha;

        -- 4. Registro no Ledger Imutável (Chamando sua sp_ledger_registrar_evento)
        CALL sp_ledger_registrar_evento(
            NULL,                  -- uuid_transacao_pai
            v_id_usuario,          -- id_usuario
            p_id_sessao_usuario,   -- id_sessao
            v_id_perfil,           -- id_perfil
            v_nome_usuario,        -- nome_usuario
            'SENHA_NAO_COMPARECEU',-- acao
            'RECEPCAO',            -- modulo
            'PAINEL',              -- sub_modulo
            'CHAMANDO',            -- estado_origem
            'NAO_COMPARECEU',      -- estado_destino
            v_payload_old,         -- estado_anterior (JSON capturado)
            JSON_OBJECT('id_fluxo_status', 99), -- estado_novo
            JSON_OBJECT('id_senha', p_id_senha), -- payload_original
            'SUCESSO',             -- status_evento
            NULL,                  -- codigo_erro
            'Chamada encerrada por não comparecimento do paciente', -- mensagem
            0,                     -- processing_time_ms
            v_uuid_transacao,      -- OUT uuid
            v_id_evento            -- OUT id_evento
        );

    COMMIT;

END ;;
```

