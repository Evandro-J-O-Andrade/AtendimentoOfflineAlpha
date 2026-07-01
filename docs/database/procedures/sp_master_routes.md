# sp_master_routes

Objetivo: master routes conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_metodo | VARCHAR(20) | IN | |
| p_rota | VARCHAR(150) | IN | |
| p_id_sessao | BIGINT | IN | |
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
- SELECT: perfil_permissao, permissao, sessao_usuario
- INSERT: auditoria_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auth_assert
- sp_auth_contexto_get
- sp_auth_contexto_set
- sp_master_login

## Functions Utilizadas
- IF
- JSON_EXTRACT
- JSON_OBJECT
- LOG
- NOW
- UPPER

## Views Utilizadas
- v_now

## Eventos Gerados
- auditoria_evento
- evento

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
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: proc: BEGIN
- **Linha 13** (Comentario): ==========================================
- **Linha 14** (Comentario): VARIÁVEIS
- **Linha 15** (Comentario): ==========================================
- **Linha 16**: Declaracao de variavel local v_usuario.
- **Linha 17**: Declaracao de variavel local v_unidade.
- **Linha 18**: Declaracao de variavel local v_local.
- **Linha 19**: Declaracao de variavel local v_perfil.
- **Linha 20**: Declaracao de variavel local v_sala.
- **Linha 22**: Declaracao de variavel local v_now.
- **Linha 23**: Declaracao de variavel local v_erro_msg.
- **Linha 24**: Declaracao de variavel local v_erro_code.
- **Linha 26** (Comentario): ==========================================
- **Linha 27** (Comentario): HANDLER
- **Linha 28** (Comentario): ==========================================
- **Linha 29**: Declaracao de variavel local EXIT.
- **Linha 30**: inicio do bloco de execucao.
- **Linha 31**: GET DIAGNOSTICS CONDITION 1
- **Linha 32**: v_erro_msg = MESSAGE_TEXT,
- **Linha 33**: v_erro_code = MYSQL_ERRNO;
- **Linha 35**: ROLLBACK;
- **Linha 37**: Insere um novo registro na tabela auditoria_evento.
- **Linha 38**: id_usuario,
- **Linha 39**: entidade,
- **Linha 40**: acao,
- **Linha 41**: detalhe,
- **Linha 42**: criado_em
- **Linha 43**: ) VALUES (
- **Linha 44**: v_usuario,
- **Linha 45**: 'sp_master_routes',
- **Linha 46**: 'ERRO',
- **Linha 47**: JSON_OBJECT(
- **Linha 48**: 'erro_code', v_erro_code,
- **Linha 49**: 'erro_msg', v_erro_msg,
- **Linha 50**: 'rota', p_rota
- **Linha 51**: ),
- **Linha 52**: NOW(6)
- **Linha 53**: );
- **Linha 55**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 56**: 'erro', TRUE,
- **Linha 57**: 'codigo', v_erro_code,
- **Linha 58**: 'mensagem', v_erro_msg
- **Linha 59**: );
- **Linha 61**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 62**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 63**: Fim do bloco da procedure.
- **Linha 65** (Comentario): ==========================================
- **Linha 66** (Comentario): INIT
- **Linha 67** (Comentario): ==========================================
- **Linha 68**: atribuicao de valor Ã  variavel v_now.
- **Linha 69**: atribuicao de valor Ã  variavel p_metodo.
- **Linha 71**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 72**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 73**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 75**: Estrutura condicional de controle de fluxo.
- **Linha 76**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 77**: Estrutura de repeticao/controle de loop.
- **Linha 78**: Estrutura condicional de controle de fluxo.
- **Linha 80**: START TRANSACTION;
- **Linha 82** (Comentario): ==========================================
- **Linha 83** (Comentario): LOGIN (SEM CONTEXTO)
- **Linha 84** (Comentario): ==========================================
- **Linha 85**: Estrutura condicional de controle de fluxo.
- **Linha 87**: Invoca a procedure sp_master_login.
- **Linha 88**: 'LOGIN',
- **Linha 89**: p_payload,
- **Linha 90**: p_resultado,
- **Linha 91**: p_sucesso,
- **Linha 92**: p_mensagem
- **Linha 93**: );
- **Linha 95** (Comentario): ==========================================
- **Linha 96** (Comentario): CARREGAR CONTEXTO (LISTA)
- **Linha 97** (Comentario): ==========================================
- **Linha 98**: Estrutura condicional de controle de fluxo.
- **Linha 100**: Invoca a procedure sp_auth_contexto_get.
- **Linha 101**: p_id_sessao,
- **Linha 102**: p_resultado,
- **Linha 103**: p_sucesso,
- **Linha 104**: p_mensagem
- **Linha 105**: );
- **Linha 107** (Comentario): ==========================================
- **Linha 108** (Comentario): DEFINIR CONTEXTO (AGORA COM SALA)
- **Linha 109** (Comentario): ==========================================
- **Linha 110**: Estrutura condicional de controle de fluxo.
- **Linha 112**: Invoca a procedure sp_auth_contexto_set.
- **Linha 113**: p_id_sessao,
- **Linha 114**: JSON_EXTRACT(p_payload, '$.id_unidade'),
- **Linha 115**: JSON_EXTRACT(p_payload, '$.id_local'),
- **Linha 116**: JSON_EXTRACT(p_payload, '$.id_perfil'),
- **Linha 117**: JSON_EXTRACT(p_payload, '$.id_sala'),
- **Linha 118**: p_resultado,
- **Linha 119**: p_sucesso,
- **Linha 120**: p_mensagem
- **Linha 121**: );
- **Linha 123** (Comentario): ==========================================
- **Linha 124** (Comentario): ASSERT CONTEXTO
- **Linha 125** (Comentario): ==========================================
- **Linha 126**: Estrutura condicional de controle de fluxo.
- **Linha 128**: Invoca a procedure sp_auth_assert.
- **Linha 129**: p_id_sessao,
- **Linha 130**: p_resultado,
- **Linha 131**: p_sucesso,
- **Linha 132**: p_mensagem
- **Linha 133**: );
- **Linha 135** (Comentario): ==========================================
- **Linha 136** (Comentario): MENU DINÂMICO REAL
- **Linha 137** (Comentario): ==========================================
- **Linha 138**: Estrutura condicional de controle de fluxo.
- **Linha 140**: SELECT
- **Linha 141**: su.id_usuario,
- **Linha 142**: su.id_unidade,
- **Linha 143**: su.id_local,
- **Linha 144**: su.id_perfil,
- **Linha 145**: su.id_sala
- **Linha 146**: INTO
- **Linha 147**: v_usuario,
- **Linha 148**: v_unidade,
- **Linha 149**: v_local,
- **Linha 150**: v_perfil,
- **Linha 151**: v_sala
- **Linha 152**: FROM sessao_usuario su
- **Linha 153**: WHERE su.id_sessao = p_id_sessao;
- **Linha 155**: Estrutura condicional de controle de fluxo.
- **Linha 156**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 157**: ROLLBACK;
- **Linha 158**: Estrutura de repeticao/controle de loop.
- **Linha 159**: Estrutura condicional de controle de fluxo.
- **Linha 161**: execucao de query SELECT para consulta de dados.
- **Linha 162**: JSON_OBJECT(
- **Linha 163**: 'codigo', p.codigo,
- **Linha 164**: 'nome', p.nome
- **Linha 165**: fechamento da lista de Parametros.
- **Linha 166**: fechamento da lista de Parametros.
- **Linha 167**: INTO p_resultado
- **Linha 168**: FROM permissao p
- **Linha 169**: INNER JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
- **Linha 170**: WHERE pp.id_perfil = v_perfil
- **Linha 173**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 174**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 176** (Comentario): ==========================================
- **Linha 177** (Comentario): LOGOUT
- **Linha 178** (Comentario): ==========================================
- **Linha 179**: Estrutura condicional de controle de fluxo.
- **Linha 181**: Invoca a procedure sp_master_login.
- **Linha 182**: 'LOGOUT',
- **Linha 183**: p_payload,
- **Linha 184**: p_resultado,
- **Linha 185**: p_sucesso,
- **Linha 186**: p_mensagem
- **Linha 187**: );
- **Linha 189**: Estrutura condicional de controle de fluxo.
- **Linha 190**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 191**: ROLLBACK;
- **Linha 192**: Estrutura de repeticao/controle de loop.
- **Linha 193**: Estrutura condicional de controle de fluxo.
- **Linha 195** (Comentario): ==========================================
- **Linha 196** (Comentario): LOG EXECUÇÃO
- **Linha 197** (Comentario): ==========================================
- **Linha 198**: Insere um novo registro na tabela auditoria_evento.
- **Linha 199**: id_usuario,
- **Linha 200**: entidade,
- **Linha 201**: acao,
- **Linha 202**: detalhe,
- **Linha 203**: criado_em
- **Linha 204**: ) VALUES (
- **Linha 205**: v_usuario,
- **Linha 206**: 'sp_master_routes',
- **Linha 207**: 'EXEC',
- **Linha 208**: JSON_OBJECT(
- **Linha 209**: 'rota', p_rota,
- **Linha 210**: 'metodo', p_metodo,
- **Linha 211**: 'sucesso', p_sucesso
- **Linha 212**: ),
- **Linha 213**: v_now
- **Linha 214**: );
- **Linha 216** (Comentario): ==========================================
- **Linha 217** (Comentario): FINAL
- **Linha 218** (Comentario): ==========================================
- **Linha 219**: Estrutura condicional de controle de fluxo.
- **Linha 220**: COMMIT;
- **Linha 221**: Estrutura condicional de controle de fluxo.
- **Linha 222**: ROLLBACK;
- **Linha 223**: Estrutura condicional de controle de fluxo.
- **Linha 225**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_routes`(
    IN p_metodo VARCHAR(20),
    IN p_rota VARCHAR(150),
    IN p_id_sessao BIGINT,
    IN p_payload JSON,

    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
proc: BEGIN

    -- ==========================================
    -- VARIÁVEIS
    -- ==========================================
    DECLARE v_usuario BIGINT;
    DECLARE v_unidade BIGINT;
    DECLARE v_local BIGINT;
    DECLARE v_perfil BIGINT;
    DECLARE v_sala BIGINT;

    DECLARE v_now DATETIME(6);
    DECLARE v_erro_msg TEXT;
    DECLARE v_erro_code INT;

    -- ==========================================
    -- HANDLER
    -- ==========================================
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_erro_msg = MESSAGE_TEXT,
            v_erro_code = MYSQL_ERRNO;

        ROLLBACK;

        INSERT INTO auditoria_evento (
            id_usuario,
            entidade,
            acao,
            detalhe,
            criado_em
        ) VALUES (
            v_usuario,
            'sp_master_routes',
            'ERRO',
            JSON_OBJECT(
                'erro_code', v_erro_code,
                'erro_msg', v_erro_msg,
                'rota', p_rota
            ),
            NOW(6)
        );

        SET p_resultado = JSON_OBJECT(
            'erro', TRUE,
            'codigo', v_erro_code,
            'mensagem', v_erro_msg
        );

        SET p_sucesso = FALSE;
        SET p_mensagem = 'ERRO_INTERNO';
    END;

    -- ==========================================
    -- INIT
    -- ==========================================
    SET v_now = NOW(6);
    SET p_metodo = UPPER(p_metodo);

    SET p_resultado = JSON_OBJECT();
    SET p_sucesso = FALSE;
    SET p_mensagem = 'INIT';

    IF p_metodo IS NULL OR p_rota IS NULL THEN
        SET p_mensagem = 'METODO_ROTA_OBRIGATORIOS';
        LEAVE proc;
    END IF;

    START TRANSACTION;

    -- ==========================================
    -- LOGIN (SEM CONTEXTO)
    -- ==========================================
    IF p_metodo = 'POST' AND p_rota = 'AUTH.LOGIN' THEN

        CALL sp_master_login(
            'LOGIN',
            p_payload,
            p_resultado,
            p_sucesso,
            p_mensagem
        );

    -- ==========================================
    -- CARREGAR CONTEXTO (LISTA)
    -- ==========================================
    ELSEIF p_metodo = 'GET' AND p_rota = 'AUTH.CONTEXTO_GET' THEN

        CALL sp_auth_contexto_get(
            p_id_sessao,
            p_resultado,
            p_sucesso,
            p_mensagem
        );

    -- ==========================================
    -- DEFINIR CONTEXTO (AGORA COM SALA)
    -- ==========================================
    ELSEIF p_metodo = 'SET' AND p_rota = 'AUTH.CONTEXTO_SET' THEN

        CALL sp_auth_contexto_set(
            p_id_sessao,
            JSON_EXTRACT(p_payload, '$.id_unidade'),
            JSON_EXTRACT(p_payload, '$.id_local'),
            JSON_EXTRACT(p_payload, '$.id_perfil'),
            JSON_EXTRACT(p_payload, '$.id_sala'),
            p_resultado,
            p_sucesso,
            p_mensagem
        );

    -- ==========================================
    -- ASSERT CONTEXTO
    -- ==========================================
    ELSEIF p_metodo = 'REQUEST' AND p_rota = 'AUTH.ASSERT' THEN

        CALL sp_auth_assert(
            p_id_sessao,
            p_resultado,
            p_sucesso,
            p_mensagem
        );

    -- ==========================================
    -- MENU DINÂMICO REAL
    -- ==========================================
    ELSEIF p_metodo = 'GET' AND p_rota = 'AUTH.MENU' THEN

        SELECT 
            su.id_usuario,
            su.id_unidade,
            su.id_local,
            su.id_perfil,
            su.id_sala
        INTO
            v_usuario,
            v_unidade,
            v_local,
            v_perfil,
            v_sala
        FROM sessao_usuario su
        WHERE su.id_sessao = p_id_sessao;

        IF v_usuario IS NULL THEN
            SET p_mensagem = 'SESSAO_INVALIDA';
            ROLLBACK;
            LEAVE proc;
        END IF;

        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'codigo', p.codigo,
                'nome', p.nome
            )
        )
        INTO p_resultado
        FROM permissao p
        INNER JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
        WHERE pp.id_perfil = v_perfil
        AND p.ativo = 1;

        SET p_sucesso = TRUE;
        SET p_mensagem = 'MENU_OK';

    -- ==========================================
    -- LOGOUT
    -- ==========================================
    ELSEIF p_metodo = 'POST' AND p_rota = 'AUTH.LOGOUT' THEN

        CALL sp_master_login(
            'LOGOUT',
            p_payload,
            p_resultado,
            p_sucesso,
            p_mensagem
        );

    ELSE
        SET p_mensagem = 'ROTA_NAO_IMPLEMENTADA';
        ROLLBACK;
        LEAVE proc;
    END IF;

    -- ==========================================
    -- LOG EXECUÇÃO
    -- ==========================================
    INSERT INTO auditoria_evento (
        id_usuario,
        entidade,
        acao,
        detalhe,
        criado_em
    ) VALUES (
        v_usuario,
        'sp_master_routes',
        'EXEC',
        JSON_OBJECT(
            'rota', p_rota,
            'metodo', p_metodo,
            'sucesso', p_sucesso
        ),
        v_now
    );

    -- ==========================================
    -- FINAL
    -- ==========================================
    IF p_sucesso = TRUE THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;

END ;;
```

