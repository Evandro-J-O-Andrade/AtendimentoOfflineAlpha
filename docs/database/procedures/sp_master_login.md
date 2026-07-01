# sp_master_login

Objetivo: master login conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_acao | VARCHAR(100) | IN | |
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
- SELECT: local, login_tentativa, perfil, sessao_usuario, unidade, usuario, usuario_local, usuario_perfil, usuario_unidade
- INSERT: sessao_usuario
- UPDATE: sessao_usuario
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COUNT
- DATE_ADD
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- LAST_INSERT_ID
- NOW
- UUID

## Views Utilizadas
- v_device
- v_fingerprint
- v_ip
- v_login
- v_refresh_token
- v_senha_hash
- v_token_jwt
- v_uuid_sessao

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Sem Tratamento de erro explicito detectado.

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
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: SQL SECURITY INVOKER
- **Linha 9**: proc: BEGIN
- **Linha 11** (Comentario): ==========================================
- **Linha 12** (Comentario): DECLARAÇÕES
- **Linha 13** (Comentario): ==========================================
- **Linha 14**: Declaracao de variavel local v_id_usuario.
- **Linha 15**: Declaracao de variavel local v_login.
- **Linha 16**: Declaracao de variavel local v_senha_hash.
- **Linha 17**: Declaracao de variavel local v_ativo.
- **Linha 19**: Declaracao de variavel local v_id_sessao.
- **Linha 20**: Declaracao de variavel local v_uuid_sessao.
- **Linha 22**: Declaracao de variavel local v_token_jwt.
- **Linha 23**: Declaracao de variavel local v_refresh_token.
- **Linha 25**: Declaracao de variavel local v_ip.
- **Linha 26**: Declaracao de variavel local v_device.
- **Linha 27**: Declaracao de variavel local v_fingerprint.
- **Linha 29**: Declaracao de variavel local v_id_unidade.
- **Linha 30**: Declaracao de variavel local v_id_local.
- **Linha 31**: Declaracao de variavel local v_id_perfil.
- **Linha 33**: Declaracao de variavel local v_tentativas.
- **Linha 34**: Declaracao de variavel local v_tem_permissao.
- **Linha 36**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 37**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 38**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 40** (Comentario): ==========================================
- **Linha 41** (Comentario): AUTH.LOGIN.REQUEST
- **Linha 42** (Comentario): ==========================================
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 45**: atribuicao de valor Ã  variavel v_login.
- **Linha 46**: atribuicao de valor Ã  variavel v_token_jwt.
- **Linha 47**: atribuicao de valor Ã  variavel v_refresh_token.
- **Linha 48**: atribuicao de valor Ã  variavel v_ip.
- **Linha 49**: atribuicao de valor Ã  variavel v_device.
- **Linha 50**: atribuicao de valor Ã  variavel v_fingerprint.
- **Linha 52**: Estrutura condicional de controle de fluxo.
- **Linha 53**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 54**: Estrutura de repeticao/controle de loop.
- **Linha 55**: Estrutura condicional de controle de fluxo.
- **Linha 57**: execucao de query SELECT para consulta de dados.
- **Linha 58**: INTO v_id_usuario, v_senha_hash, v_ativo
- **Linha 59**: FROM usuario
- **Linha 60**: WHERE login = v_login
- **Linha 61**: LIMIT 1;
- **Linha 63**: Estrutura condicional de controle de fluxo.
- **Linha 64**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 65**: Estrutura de repeticao/controle de loop.
- **Linha 66**: Estrutura condicional de controle de fluxo.
- **Linha 68**: Estrutura condicional de controle de fluxo.
- **Linha 69**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 70**: Estrutura de repeticao/controle de loop.
- **Linha 71**: Estrutura condicional de controle de fluxo.
- **Linha 73**: execucao de query SELECT para consulta de dados.
- **Linha 74**: FROM login_tentativa
- **Linha 75**: WHERE id_usuario = v_id_usuario
- **Linha 79**: Estrutura condicional de controle de fluxo.
- **Linha 80**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 81**: Estrutura de repeticao/controle de loop.
- **Linha 82**: Estrutura condicional de controle de fluxo.
- **Linha 84**: Estrutura condicional de controle de fluxo.
- **Linha 85**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 86**: Estrutura de repeticao/controle de loop.
- **Linha 87**: Estrutura condicional de controle de fluxo.
- **Linha 89**: atribuicao de valor Ã  variavel v_uuid_sessao.
- **Linha 91**: Insere um novo registro na tabela sessao_usuario.
- **Linha 92**: uuid_sessao,
- **Linha 93**: id_usuario,
- **Linha 94**: id_sistema,
- **Linha 95**: id_unidade,
- **Linha 96**: id_local,
- **Linha 97**: id_perfil,
- **Linha 98**: token_jwt,
- **Linha 99**: refresh_token,
- **Linha 100**: ip_origem,
- **Linha 101**: user_agent,
- **Linha 102**: device_fingerprint,
- **Linha 103**: iniciado_em,
- **Linha 104**: expira_em,
- **Linha 105**: criado_em,
- **Linha 106**: ativo
- **Linha 107**: ) VALUES (
- **Linha 108**: v_uuid_sessao,
- **Linha 109**: v_id_usuario,
- **Linha 110**: 1,
- **Linha 111**: NULL,
- **Linha 112**: NULL,
- **Linha 113**: NULL,
- **Linha 114**: v_token_jwt,
- **Linha 115**: v_refresh_token,
- **Linha 116**: v_ip,
- **Linha 117**: v_device,
- **Linha 118**: v_fingerprint,
- **Linha 119**: NOW(6),
- **Linha 120**: DATE_ADD(NOW(6), INTERVAL 24 HOUR),
- **Linha 121**: NOW(6),
- **Linha 122**: 1
- **Linha 123**: );
- **Linha 125**: atribuicao de valor Ã  variavel v_id_sessao.
- **Linha 127**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 128**: 'sessao', JSON_OBJECT(
- **Linha 129**: 'id_sessao_usuario', v_id_sessao,
- **Linha 130**: 'uuid_sessao', v_uuid_sessao,
- **Linha 131**: 'contexto_definido', FALSE
- **Linha 132**: fechamento da lista de Parametros.
- **Linha 133**: );
- **Linha 135**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 136**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 138** (Comentario): ==========================================
- **Linha 139** (Comentario): AUTH.CONTEXTO.GET
- **Linha 140** (Comentario): ==========================================
- **Linha 141**: Estrutura condicional de controle de fluxo.
- **Linha 143**: atribuicao de valor Ã  variavel v_id_sessao.
- **Linha 145**: execucao de query SELECT para consulta de dados.
- **Linha 146**: FROM sessao_usuario
- **Linha 147**: WHERE id_sessao_usuario = v_id_sessao;
- **Linha 149**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 150**: 'unidades', (
- **Linha 151**: execucao de query SELECT para consulta de dados.
- **Linha 152**: FROM usuario_unidade uu
- **Linha 153**: JOIN unidade u ON u.id_unidade = uu.id_unidade
- **Linha 154**: WHERE uu.id_usuario = v_id_usuario
- **Linha 155**: ),
- **Linha 156**: 'locais', (
- **Linha 157**: execucao de query SELECT para consulta de dados.
- **Linha 158**: 'id_local', l.id_local,
- **Linha 159**: 'nome', l.nome
- **Linha 160**: ))
- **Linha 161**: FROM usuario_local ul
- **Linha 162**: JOIN local l ON l.id_local = ul.id_local
- **Linha 163**: WHERE ul.id_usuario = v_id_usuario
- **Linha 164**: ),
- **Linha 165**: 'perfis', (
- **Linha 166**: execucao de query SELECT para consulta de dados.
- **Linha 167**: FROM usuario_perfil up
- **Linha 168**: JOIN perfil p ON p.id_perfil = up.id_perfil
- **Linha 169**: WHERE up.id_usuario = v_id_usuario
- **Linha 170**: fechamento da lista de Parametros.
- **Linha 171**: );
- **Linha 173**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 174**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 176** (Comentario): ==========================================
- **Linha 177** (Comentario): AUTH.CONTEXTO.SET
- **Linha 178** (Comentario): ==========================================
- **Linha 179**: Estrutura condicional de controle de fluxo.
- **Linha 181**: atribuicao de valor Ã  variavel v_id_sessao.
- **Linha 182**: atribuicao de valor Ã  variavel v_id_unidade.
- **Linha 183**: atribuicao de valor Ã  variavel v_id_local.
- **Linha 184**: atribuicao de valor Ã  variavel v_id_perfil.
- **Linha 186**: UPDATE sessao_usuario
- **Linha 187**: SET
- **Linha 188**: id_unidade = v_id_unidade,
- **Linha 189**: id_local   = v_id_local,
- **Linha 190**: id_perfil  = v_id_perfil,
- **Linha 191**: contexto_definido_em = NOW(6)
- **Linha 192**: WHERE id_sessao_usuario = v_id_sessao;
- **Linha 194**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 195**: 'contexto_definido', TRUE
- **Linha 196**: );
- **Linha 198**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 199**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 201** (Comentario): ==========================================
- **Linha 202** (Comentario): AUTH.SESSAO.ASSERT
- **Linha 203** (Comentario): ==========================================
- **Linha 204**: Estrutura condicional de controle de fluxo.
- **Linha 206**: atribuicao de valor Ã  variavel v_id_sessao.
- **Linha 208**: execucao de query SELECT para consulta de dados.
- **Linha 209**: INTO v_id_usuario, v_id_unidade, v_id_local, v_id_perfil
- **Linha 210**: FROM sessao_usuario
- **Linha 211**: WHERE id_sessao_usuario = v_id_sessao AND ativo = 1;
- **Linha 213**: Estrutura condicional de controle de fluxo.
- **Linha 214**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 215**: Estrutura de repeticao/controle de loop.
- **Linha 216**: Estrutura condicional de controle de fluxo.
- **Linha 218**: Estrutura condicional de controle de fluxo.
- **Linha 219**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 220**: Estrutura de repeticao/controle de loop.
- **Linha 221**: Estrutura condicional de controle de fluxo.
- **Linha 223**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 224**: 'id_usuario', v_id_usuario,
- **Linha 225**: 'id_unidade', v_id_unidade,
- **Linha 226**: 'id_local', v_id_local,
- **Linha 227**: 'id_perfil', v_id_perfil
- **Linha 228**: );
- **Linha 230**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 231**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 233** (Comentario): ==========================================
- **Linha 234** (Comentario): AUTH.LOGOUT.REQUEST
- **Linha 235** (Comentario): ==========================================
- **Linha 236**: Estrutura condicional de controle de fluxo.
- **Linha 238**: atribuicao de valor Ã  variavel v_id_sessao.
- **Linha 240**: UPDATE sessao_usuario
- **Linha 241**: SET
- **Linha 242**: ativo = 0,
- **Linha 243**: revogado = 1,
- **Linha 244**: finalizado_em = NOW(6),
- **Linha 245**: motivo_finalizacao = 'LOGOUT'
- **Linha 246**: WHERE id_sessao_usuario = v_id_sessao;
- **Linha 248**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 249**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 251**: Estrutura condicional de controle de fluxo.
- **Linha 252**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 253**: Estrutura condicional de controle de fluxo.
- **Linha 255**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_login`(
    IN p_acao VARCHAR(100),
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
    SQL SECURITY INVOKER
proc: BEGIN

    -- ==========================================
    -- DECLARAÇÕES
    -- ==========================================
    DECLARE v_id_usuario BIGINT;
    DECLARE v_login VARCHAR(120);
    DECLARE v_senha_hash VARCHAR(255);
    DECLARE v_ativo TINYINT;

    DECLARE v_id_sessao BIGINT;
    DECLARE v_uuid_sessao CHAR(36);

    DECLARE v_token_jwt VARCHAR(512);
    DECLARE v_refresh_token VARCHAR(512);

    DECLARE v_ip VARCHAR(45);
    DECLARE v_device VARCHAR(255);
    DECLARE v_fingerprint VARCHAR(255);

    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_perfil BIGINT;

    DECLARE v_tentativas INT DEFAULT 0;
    DECLARE v_tem_permissao INT DEFAULT 1;

    SET p_sucesso = FALSE;
    SET p_mensagem = '';
    SET p_resultado = JSON_OBJECT();

    -- ==========================================
    -- AUTH.LOGIN.REQUEST
    -- ==========================================
    IF p_acao = 'AUTH.LOGIN.REQUEST' THEN

        SET v_login         = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.login'));
        SET v_token_jwt     = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.token_jwt'));
        SET v_refresh_token = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.refresh_token'));
        SET v_ip            = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip'));
        SET v_device        = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device'));
        SET v_fingerprint   = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.fingerprint'));

        IF v_login IS NULL THEN
            SET p_mensagem = 'LOGIN_OBRIGATORIO';
            LEAVE proc;
        END IF;

        SELECT id_usuario, senha, ativo
        INTO v_id_usuario, v_senha_hash, v_ativo
        FROM usuario
        WHERE login = v_login
        LIMIT 1;

        IF v_id_usuario IS NULL THEN
            SET p_mensagem = 'USUARIO_NAO_ENCONTRADO';
            LEAVE proc;
        END IF;

        IF v_ativo <> 1 THEN
            SET p_mensagem = 'USUARIO_INATIVO';
            LEAVE proc;
        END IF;

        SELECT COUNT(*) INTO v_tentativas
        FROM login_tentativa
        WHERE id_usuario = v_id_usuario
          AND sucesso = 0
          AND criado_em >= NOW() - INTERVAL 15 MINUTE;

        IF v_tentativas >= 5 THEN
            SET p_mensagem = 'USUARIO_BLOQUEADO_TEMP';
            LEAVE proc;
        END IF;

        IF v_token_jwt IS NULL THEN
            SET p_mensagem = 'TOKEN_OBRIGATORIO';
            LEAVE proc;
        END IF;

        SET v_uuid_sessao = UUID();

        INSERT INTO sessao_usuario (
            uuid_sessao,
            id_usuario,
            id_sistema,
            id_unidade,
            id_local,
            id_perfil,
            token_jwt,
            refresh_token,
            ip_origem,
            user_agent,
            device_fingerprint,
            iniciado_em,
            expira_em,
            criado_em,
            ativo
        ) VALUES (
            v_uuid_sessao,
            v_id_usuario,
            1,
            NULL,
            NULL,
            NULL,
            v_token_jwt,
            v_refresh_token,
            v_ip,
            v_device,
            v_fingerprint,
            NOW(6),
            DATE_ADD(NOW(6), INTERVAL 24 HOUR),
            NOW(6),
            1
        );

        SET v_id_sessao = LAST_INSERT_ID();

        SET p_resultado = JSON_OBJECT(
            'sessao', JSON_OBJECT(
                'id_sessao_usuario', v_id_sessao,
                'uuid_sessao', v_uuid_sessao,
                'contexto_definido', FALSE
            )
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGIN_OK';

    -- ==========================================
    -- AUTH.CONTEXTO.GET
    -- ==========================================
    ELSEIF p_acao = 'AUTH.CONTEXTO.GET' THEN

        SET v_id_sessao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sessao'));

        SELECT id_usuario INTO v_id_usuario
        FROM sessao_usuario
        WHERE id_sessao_usuario = v_id_sessao;

        SET p_resultado = JSON_OBJECT(
            'unidades', (
                SELECT JSON_ARRAYAGG(JSON_OBJECT('id_unidade', u.id_unidade, 'nome', u.nome))
                FROM usuario_unidade uu
                JOIN unidade u ON u.id_unidade = uu.id_unidade
                WHERE uu.id_usuario = v_id_usuario
            ),
            'locais', (
                SELECT JSON_ARRAYAGG(JSON_OBJECT(
                    'id_local', l.id_local,
                    'nome', l.nome
                ))
                FROM usuario_local ul
                JOIN local l ON l.id_local = ul.id_local
                WHERE ul.id_usuario = v_id_usuario
            ),
            'perfis', (
                SELECT JSON_ARRAYAGG(JSON_OBJECT('id_perfil', p.id_perfil, 'nome', p.nome))
                FROM usuario_perfil up
                JOIN perfil p ON p.id_perfil = up.id_perfil
                WHERE up.id_usuario = v_id_usuario
            )
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'CONTEXTOS';

    -- ==========================================
    -- AUTH.CONTEXTO.SET
    -- ==========================================
    ELSEIF p_acao = 'AUTH.CONTEXTO.SET' THEN

        SET v_id_sessao  = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sessao'));
        SET v_id_unidade = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade'));
        SET v_id_local   = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_local'));
        SET v_id_perfil  = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_perfil'));

        UPDATE sessao_usuario
        SET 
            id_unidade = v_id_unidade,
            id_local   = v_id_local,
            id_perfil  = v_id_perfil,
            contexto_definido_em = NOW(6)
        WHERE id_sessao_usuario = v_id_sessao;

        SET p_resultado = JSON_OBJECT(
            'contexto_definido', TRUE
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'CONTEXTO_OK';

    -- ==========================================
    -- AUTH.SESSAO.ASSERT
    -- ==========================================
    ELSEIF p_acao = 'AUTH.SESSAO.ASSERT' THEN

        SET v_id_sessao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sessao'));

        SELECT id_usuario, id_unidade, id_local, id_perfil
        INTO v_id_usuario, v_id_unidade, v_id_local, v_id_perfil
        FROM sessao_usuario
        WHERE id_sessao_usuario = v_id_sessao AND ativo = 1;

        IF v_id_usuario IS NULL THEN
            SET p_mensagem = 'SESSAO_INVALIDA';
            LEAVE proc;
        END IF;

        IF v_id_unidade IS NULL THEN
            SET p_mensagem = 'CONTEXTO_NAO_DEFINIDO';
            LEAVE proc;
        END IF;

        SET p_resultado = JSON_OBJECT(
            'id_usuario', v_id_usuario,
            'id_unidade', v_id_unidade,
            'id_local', v_id_local,
            'id_perfil', v_id_perfil
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'OK';

    -- ==========================================
    -- AUTH.LOGOUT.REQUEST
    -- ==========================================
    ELSEIF p_acao = 'AUTH.LOGOUT.REQUEST' THEN

        SET v_id_sessao = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_sessao'));

        UPDATE sessao_usuario
        SET 
            ativo = 0,
            revogado = 1,
            finalizado_em = NOW(6),
            motivo_finalizacao = 'LOGOUT'
        WHERE id_sessao_usuario = v_id_sessao;

        SET p_sucesso = TRUE;
        SET p_mensagem = 'LOGOUT_OK';

    ELSE
        SET p_mensagem = 'ACAO_INVALIDA';
    END IF;

END ;;
```

