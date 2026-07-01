# sp_master_orquestradora

Objetivo: master orquestradora conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_modulo | VARCHAR(50) | IN | |
| p_acao | VARCHAR(50) | IN | |
| p_payload | JSON | IN | |
| p_resultado | JSON | OUT | |
| p_sucesso | BOOLEAN | OUT | |
| p_mensagem | TEXT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: auditoria_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_master_assistencial
- sp_master_estoque
- sp_master_faturamento
- sp_master_login
- sp_master_query_dispatcher

## Functions Utilizadas
- CONCAT
- IF
- JSON_ARRAY
- JSON_OBJECT
- NOW

## Views Utilizadas
- v_erro_msg

## Eventos Gerados
- auditoria_evento
- evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

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
- **Linha 10**: SQL SECURITY INVOKER
- **Linha 11**: main: BEGIN
- **Linha 13** (Comentario): ==========================================
- **Linha 14** (Comentario): 1. DECLARAÇÕES
- **Linha 15** (Comentario): ==========================================
- **Linha 16**: Declaracao de variavel local v_id_usuario.
- **Linha 17**: Declaracao de variavel local v_id_unidade.
- **Linha 18**: Declaracao de variavel local v_erro_msg.
- **Linha 20** (Comentario): Handler global de erro
- **Linha 21**: Declaracao de variavel local EXIT.
- **Linha 22**: inicio do bloco de execucao.
- **Linha 23**: GET DIAGNOSTICS CONDITION 1 v_erro_msg = MESSAGE_TEXT;
- **Linha 24**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 25**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 26**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 28**: Insere um novo registro na tabela auditoria_evento.
- **Linha 29**: id_usuario, entidade, id_entidade, acao, detalhe, criado_em
- **Linha 30**: ) VALUES (
- **Linha 31**: v_id_usuario, 'orquestradora', NULL, CONCAT('ERRO_', p_modulo),
- **Linha 32**: JSON_OBJECT('acao', p_acao, 'payload', p_payload, 'erro', v_erro_msg),
- **Linha 33**: NOW(6)
- **Linha 34**: );
- **Linha 35**: Fim do bloco da procedure.
- **Linha 37** (Comentario): Inicializa saída
- **Linha 38**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 39**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 40**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 42** (Comentario): ==========================================
- **Linha 43** (Comentario): 2. VALIDAÇÃO DE SESSÃO
- **Linha 44** (Comentario): ==========================================
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 46**: execucao de query SELECT para consulta de dados.
- **Linha 47**: FROM sessao_usuario
- **Linha 48**: WHERE id_sessao_usuario = p_id_sessao AND ativo = 1
- **Linha 49**: LIMIT 1;
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 52**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 53**: Estrutura de repeticao/controle de loop.
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 55**: Estrutura condicional de controle de fluxo.
- **Linha 57** (Comentario): ==========================================
- **Linha 58** (Comentario): 3. DISPATCH PRINCIPAL
- **Linha 59** (Comentario): ==========================================
- **Linha 60**: CASE p_modulo
- **Linha 62**: WHEN 'LOGIN' THEN
- **Linha 63**: Invoca a procedure sp_master_login.
- **Linha 64**: p_acao,
- **Linha 65**: p_payload,
- **Linha 66**: p_resultado,
- **Linha 67**: p_sucesso,
- **Linha 68**: p_mensagem
- **Linha 69**: );
- **Linha 71**: WHEN 'ASSISTENCIAL' THEN
- **Linha 72**: Invoca a procedure sp_master_assistencial.
- **Linha 73**: v_id_usuario,
- **Linha 74**: p_acao,
- **Linha 75**: p_payload,
- **Linha 76**: p_resultado,
- **Linha 77**: p_sucesso,
- **Linha 78**: p_mensagem
- **Linha 79**: );
- **Linha 81**: WHEN 'ESTOQUE' THEN
- **Linha 82**: Invoca a procedure sp_master_estoque.
- **Linha 83**: v_id_usuario,
- **Linha 84**: p_acao,
- **Linha 85**: p_payload,
- **Linha 86**: p_resultado,
- **Linha 87**: p_sucesso,
- **Linha 88**: p_mensagem
- **Linha 89**: );
- **Linha 91**: WHEN 'FATURAMENTO' THEN
- **Linha 92**: Invoca a procedure sp_master_faturamento.
- **Linha 93**: v_id_usuario,
- **Linha 94**: p_acao,
- **Linha 95**: p_payload,
- **Linha 96**: p_resultado,
- **Linha 97**: p_sucesso,
- **Linha 98**: p_mensagem
- **Linha 99**: );
- **Linha 101**: WHEN 'PACIENTE'
- **Linha 108**: Invoca a procedure sp_master_query_dispatcher.
- **Linha 109**: p_id_sessao,
- **Linha 110**: p_modulo,
- **Linha 111**: p_payload,
- **Linha 112**: p_resultado,
- **Linha 113**: p_sucesso,
- **Linha 114**: p_mensagem
- **Linha 115**: );
- **Linha 117**: Estrutura condicional de controle de fluxo.
- **Linha 118**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 119**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 121**: END CASE;
- **Linha 123** (Comentario): ==========================================
- **Linha 124** (Comentario): 4. LOGGING PADRÃO
- **Linha 125** (Comentario): ==========================================
- **Linha 126**: Estrutura condicional de controle de fluxo.
- **Linha 127**: Insere um novo registro na tabela auditoria_evento.
- **Linha 128**: id_usuario, entidade, id_entidade, acao, detalhe, criado_em
- **Linha 129**: ) VALUES (
- **Linha 130**: v_id_usuario, 'orquestradora', NULL, CONCAT('SUCCESS_', p_modulo),
- **Linha 131**: JSON_OBJECT('acao', p_acao, 'payload', p_payload, 'resultado', p_resultado),
- **Linha 132**: NOW(6)
- **Linha 133**: );
- **Linha 134**: Estrutura condicional de controle de fluxo.
- **Linha 136**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_orquestradora`(
    IN p_id_sessao BIGINT,
    IN p_modulo VARCHAR(50),
    IN p_acao VARCHAR(50),
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
    SQL SECURITY INVOKER
main: BEGIN

    -- ==========================================
    -- 1. DECLARAÇÕES
    -- ==========================================
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_erro_msg TEXT DEFAULT '';

    -- Handler global de erro
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_erro_msg = MESSAGE_TEXT;
        SET p_resultado = JSON_OBJECT();
        SET p_sucesso = FALSE;
        SET p_mensagem = v_erro_msg;

        INSERT INTO auditoria_evento(
            id_usuario, entidade, id_entidade, acao, detalhe, criado_em
        ) VALUES (
            v_id_usuario, 'orquestradora', NULL, CONCAT('ERRO_', p_modulo),
            JSON_OBJECT('acao', p_acao, 'payload', p_payload, 'erro', v_erro_msg),
            NOW(6)
        );
    END;

    -- Inicializa saída
    SET p_sucesso = FALSE;
    SET p_resultado = JSON_ARRAY();
    SET p_mensagem = '';

    -- ==========================================
    -- 2. VALIDAÇÃO DE SESSÃO
    -- ==========================================
    IF p_modulo NOT IN ('LOGIN') THEN
        SELECT id_usuario, id_unidade INTO v_id_usuario, v_id_unidade
        FROM sessao_usuario
        WHERE id_sessao_usuario = p_id_sessao AND ativo = 1
        LIMIT 1;

        IF v_id_usuario IS NULL THEN
            SET p_mensagem = 'SESSAO_INVALIDA_OU_EXPIRADA';
            LEAVE main;
        END IF;
    END IF;

    -- ==========================================
    -- 3. DISPATCH PRINCIPAL
    -- ==========================================
    CASE p_modulo

        WHEN 'LOGIN' THEN
            CALL sp_master_login(
                p_acao,
                p_payload,
                p_resultado,
                p_sucesso,
                p_mensagem
            );

        WHEN 'ASSISTENCIAL' THEN
            CALL sp_master_assistencial(
                v_id_usuario,
                p_acao,
                p_payload,
                p_resultado,
                p_sucesso,
                p_mensagem
            );

        WHEN 'ESTOQUE' THEN
            CALL sp_master_estoque(
                v_id_usuario,
                p_acao,
                p_payload,
                p_resultado,
                p_sucesso,
                p_mensagem
            );

        WHEN 'FATURAMENTO' THEN
            CALL sp_master_faturamento(
                v_id_usuario,
                p_acao,
                p_payload,
                p_resultado,
                p_sucesso,
                p_mensagem
            );

        WHEN 'PACIENTE'
          OR 'PACIENTE_TIMELINE'
          OR 'TRIAGEM'
          OR 'FILA_ESPERA'
          OR 'USUARIO'
          OR 'PERMISSAO_USUARIO' THEN

            CALL sp_master_query_dispatcher(
                p_id_sessao,
                p_modulo,
                p_payload,
                p_resultado,
                p_sucesso,
                p_mensagem
            );

        ELSE
            SET p_mensagem = 'MODULO_INVALIDO';
            SET p_sucesso = FALSE;

    END CASE;

    -- ==========================================
    -- 4. LOGGING PADRÃO
    -- ==========================================
    IF p_sucesso = TRUE THEN
        INSERT INTO auditoria_evento(
            id_usuario, entidade, id_entidade, acao, detalhe, criado_em
        ) VALUES (
            v_id_usuario, 'orquestradora', NULL, CONCAT('SUCCESS_', p_modulo),
            JSON_OBJECT('acao', p_acao, 'payload', p_payload, 'resultado', p_resultado),
            NOW(6)
        );
    END IF;

END ;;
```

