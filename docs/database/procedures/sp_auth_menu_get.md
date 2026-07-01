# sp_auth_menu_get

Objetivo: auth menu get conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
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
- SELECT: perfil_permissao, permissao, permissao_local, sessao_usuario
- INSERT: menu_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COALESCE
- IF
- JSON_OBJECT
- LEFT
- NOW

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_id_usuario.
- **Linha 9**: Declaracao de variavel local v_id_perfil.
- **Linha 10**: Declaracao de variavel local v_id_unidade.
- **Linha 11**: Declaracao de variavel local v_id_local.
- **Linha 12**: Declaracao de variavel local v_id_entidade.
- **Linha 13**: Declaracao de variavel local v_ativo.
- **Linha 14**: Declaracao de variavel local v_erro_msg.
- **Linha 16** (Comentario): Handler de erro SQL
- **Linha 17**: Declaracao de variavel local EXIT.
- **Linha 18**: inicio do bloco de execucao.
- **Linha 19**: GET DIAGNOSTICS CONDITION 1 v_erro_msg = MESSAGE_TEXT;
- **Linha 20**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 21**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 22**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 23**: Insere um novo registro na tabela menu_evento.
- **Linha 24**: VALUES (p_id_sessao, 0, v_erro_msg, NOW());
- **Linha 25**: Fim do bloco da procedure.
- **Linha 27** (Comentario): Inicialização
- **Linha 28**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 29**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 30**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 32**: sp_exit_block: BEGIN
- **Linha 34** (Comentario): 1. Recuperar contexto completo da sessão
- **Linha 35**: execucao de query SELECT para consulta de dados.
- **Linha 36**: INTO v_id_usuario, v_id_perfil, v_id_unidade, v_id_local, v_id_entidade, v_ativo
- **Linha 37**: FROM sessao_usuario
- **Linha 38**: WHERE id_sessao_usuario = p_id_sessao
- **Linha 40**: LIMIT 1;
- **Linha 42** (Comentario): Validações
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 44**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 45**: Estrutura de repeticao/controle de loop.
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 49**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 50**: Estrutura de repeticao/controle de loop.
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 53**: Estrutura condicional de controle de fluxo.
- **Linha 54**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 55**: Estrutura de repeticao/controle de loop.
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58** (Comentario): 2. Montar menu dinâmico completo
- **Linha 59**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 60**: execucao de query SELECT para consulta de dados.
- **Linha 61**: 'modulos', JSON_ARRAYAGG(
- **Linha 62**: JSON_OBJECT(
- **Linha 63**: 'modulo', modulos.modulo,
- **Linha 64**: 'nome', modulos.nome,
- **Linha 65**: 'icone', modulos.icone,
- **Linha 66**: 'ordem', modulos.ordem,
- **Linha 67**: 'flags', JSON_OBJECT(
- **Linha 68**: 'ativo', modulos.flag_ativo,
- **Linha 69**: 'externo', modulos.flag_externo,
- **Linha 70**: 'restrito', modulos.flag_restrito
- **Linha 71**: ),
- **Linha 72**: 'acoes', modulos.acoes
- **Linha 73**: fechamento da lista de Parametros.
- **Linha 74**: fechamento da lista de Parametros.
- **Linha 75**: fechamento da lista de Parametros.
- **Linha 76**: FROM (
- **Linha 77**: SELECT
- **Linha 78**: m.modulo,
- **Linha 79**: m.nome,
- **Linha 80**: m.icone,
- **Linha 81**: m.ordem,
- **Linha 82**: m.flag_ativo,
- **Linha 83**: m.flag_externo,
- **Linha 84**: m.flag_restrito,
- **Linha 85**: (
- **Linha 86**: execucao de query SELECT para consulta de dados.
- **Linha 87**: JSON_OBJECT(
- **Linha 88**: 'codigo', a.codigo,
- **Linha 89**: 'nome', a.nome,
- **Linha 90**: 'sp', a.nome_procedure,
- **Linha 91**: 'ordem', a.ordem
- **Linha 92**: fechamento da lista de Parametros.
- **Linha 93**: fechamento da lista de Parametros.
- **Linha 94**: FROM (
- **Linha 95**: execucao de query SELECT para consulta de dados.
- **Linha 96**: FROM permissao p
- **Linha 97**: JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
- **Linha 98**: LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
- **Linha 99**: WHERE pp.id_perfil = v_id_perfil
- **Linha 104**: ORDER BY p.ordem, p.nome
- **Linha 105**: ) AS a
- **Linha 106**: ) AS acoes
- **Linha 107**: FROM (
- **Linha 108**: execucao de query SELECT para consulta de dados.
- **Linha 109**: p.modulo,
- **Linha 110**: p.modulo AS nome,
- **Linha 111**: COALESCE(p.icone, 'default') AS icone,
- **Linha 112**: COALESCE(p.ordem, 999) AS ordem,
- **Linha 113**: COALESCE(p.flag_ativo, 1) AS flag_ativo,
- **Linha 114**: COALESCE(p.flag_externo, 0) AS flag_externo,
- **Linha 115**: COALESCE(p.flag_restrito, 0) AS flag_restrito
- **Linha 116**: FROM permissao p
- **Linha 117**: JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
- **Linha 118**: LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
- **Linha 119**: WHERE pp.id_perfil = v_id_perfil
- **Linha 123**: ORDER BY p.ordem, p.modulo
- **Linha 124**: ) AS m
- **Linha 125**: ) AS modulos
- **Linha 126**: );
- **Linha 128**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 129**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 131** (Comentario): 3. Auditoria de sucesso
- **Linha 132**: Insere um novo registro na tabela menu_evento.
- **Linha 133**: VALUES (p_id_sessao, 1, 'MENU_OK', NOW());
- **Linha 135**: END sp_exit_block;
- **Linha 137**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_menu_get`(
    IN p_id_sessao BIGINT,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_entidade BIGINT;
    DECLARE v_ativo TINYINT;
    DECLARE v_erro_msg TEXT;

    -- Handler de erro SQL
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_erro_msg = MESSAGE_TEXT;
        SET p_resultado = JSON_OBJECT('erro', TRUE, 'mensagem', v_erro_msg);
        SET p_sucesso = FALSE;
        SET p_mensagem = 'ERRO_MENU';
        INSERT INTO menu_evento(id_sessao_usuario, sucesso, mensagem, criado_em)
        VALUES (p_id_sessao, 0, v_erro_msg, NOW());
    END;

    -- Inicialização
    SET p_sucesso = FALSE;
    SET p_mensagem = '';
    SET p_resultado = JSON_OBJECT();

    sp_exit_block: BEGIN

        -- 1. Recuperar contexto completo da sessão
        SELECT id_usuario, id_perfil, id_unidade, id_local, id_entidade, ativo
        INTO v_id_usuario, v_id_perfil, v_id_unidade, v_id_local, v_id_entidade, v_ativo
        FROM sessao_usuario
        WHERE id_sessao_usuario = p_id_sessao
          AND id_entidade IS NOT NULL
        LIMIT 1;

        -- Validações
        IF v_id_usuario IS NULL THEN
            SET p_mensagem = 'SESSAO_INVALIDA';
            LEAVE sp_exit_block;
        END IF;

        IF v_ativo <> 1 THEN
            SET p_mensagem = 'SESSAO_INATIVA';
            LEAVE sp_exit_block;
        END IF;

        IF v_id_unidade IS NULL OR v_id_perfil IS NULL OR v_id_local IS NULL THEN
            SET p_mensagem = 'CONTEXTO_NAO_DEFINIDO';
            LEAVE sp_exit_block;
        END IF;

        -- 2. Montar menu dinâmico completo
        SET p_resultado = (
            SELECT JSON_OBJECT(
                'modulos', JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'modulo', modulos.modulo,
                        'nome', modulos.nome,
                        'icone', modulos.icone,
                        'ordem', modulos.ordem,
                        'flags', JSON_OBJECT(
                            'ativo', modulos.flag_ativo,
                            'externo', modulos.flag_externo,
                            'restrito', modulos.flag_restrito
                        ),
                        'acoes', modulos.acoes
                    )
                )
            )
            FROM (
                SELECT
                    m.modulo,
                    m.nome,
                    m.icone,
                    m.ordem,
                    m.flag_ativo,
                    m.flag_externo,
                    m.flag_restrito,
                    (
                        SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                                'codigo', a.codigo,
                                'nome', a.nome,
                                'sp', a.nome_procedure,
                                'ordem', a.ordem
                            )
                        )
                        FROM (
                            SELECT p.codigo, p.nome, p.nome_procedure, p.ordem
                            FROM permissao p
                            JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                            LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
                            WHERE pp.id_perfil = v_id_perfil
                              AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
                              AND p.modulo = m.modulo
                              AND p.ativo = 1
                              AND p.id_entidade = v_id_entidade
                            ORDER BY p.ordem, p.nome
                        ) AS a
                    ) AS acoes
                FROM (
                    SELECT DISTINCT
                        p.modulo,
                        p.modulo AS nome,
                        COALESCE(p.icone, 'default') AS icone,
                        COALESCE(p.ordem, 999) AS ordem,
                        COALESCE(p.flag_ativo, 1) AS flag_ativo,
                        COALESCE(p.flag_externo, 0) AS flag_externo,
                        COALESCE(p.flag_restrito, 0) AS flag_restrito
                    FROM permissao p
                    JOIN perfil_permissao pp ON pp.id_permissao = p.id_permissao
                    LEFT JOIN permissao_local pl ON pl.id_permissao = p.id_permissao
                    WHERE pp.id_perfil = v_id_perfil
                      AND (pl.id_local IS NULL OR pl.id_local = v_id_local)
                      AND p.ativo = 1
                      AND p.id_entidade = v_id_entidade
                    ORDER BY p.ordem, p.modulo
                ) AS m
            ) AS modulos
        );

        SET p_sucesso = TRUE;
        SET p_mensagem = 'MENU_OK';

        -- 3. Auditoria de sucesso
        INSERT INTO menu_evento(id_sessao_usuario, sucesso, mensagem, criado_em)
        VALUES (p_id_sessao, 1, 'MENU_OK', NOW());

    END sp_exit_block;

END ;;
```

