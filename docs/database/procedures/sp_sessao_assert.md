# sp_sessao_assert

Objetivo: sessao assert conforme definida no dump SQL do sistema.

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
- SELECT: perfil_permissao, permissao, sessao_usuario, usuario_perfil
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COUNT
- IF
- JSON_OBJECT
- NOW

## Views Utilizadas
- (nenhuma)

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
- **Linha 15**: Declaracao de variavel local v_id_unidade.
- **Linha 16**: Declaracao de variavel local v_id_local.
- **Linha 17**: Declaracao de variavel local v_id_perfil.
- **Linha 18**: Declaracao de variavel local v_expira_em.
- **Linha 19**: Declaracao de variavel local v_ativo.
- **Linha 21**: Declaracao de variavel local v_tem_permissao.
- **Linha 23**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 24**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 25**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 27** (Comentario): ==========================================
- **Linha 28** (Comentario): 1. VALIDAR SESSÃO
- **Linha 29** (Comentario): ==========================================
- **Linha 30**: SELECT
- **Linha 31**: id_usuario,
- **Linha 32**: id_unidade,
- **Linha 33**: id_local,
- **Linha 34**: id_perfil,
- **Linha 35**: expira_em,
- **Linha 36**: ativo
- **Linha 37**: INTO
- **Linha 38**: v_id_usuario,
- **Linha 39**: v_id_unidade,
- **Linha 40**: v_id_local,
- **Linha 41**: v_id_perfil,
- **Linha 42**: v_expira_em,
- **Linha 43**: v_ativo
- **Linha 44**: FROM sessao_usuario
- **Linha 45**: WHERE id_sessao_usuario = p_id_sessao
- **Linha 46**: LIMIT 1;
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 49**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 50**: Estrutura de repeticao/controle de loop.
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 53**: Estrutura condicional de controle de fluxo.
- **Linha 54**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 55**: Estrutura de repeticao/controle de loop.
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 58**: Estrutura condicional de controle de fluxo.
- **Linha 59**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 60**: Estrutura de repeticao/controle de loop.
- **Linha 61**: Estrutura condicional de controle de fluxo.
- **Linha 63** (Comentario): ==========================================
- **Linha 64** (Comentario): 2. VALIDAR CONTEXTO
- **Linha 65** (Comentario): ==========================================
- **Linha 66**: Estrutura condicional de controle de fluxo.
- **Linha 67**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 68**: Estrutura de repeticao/controle de loop.
- **Linha 69**: Estrutura condicional de controle de fluxo.
- **Linha 71** (Comentario): LOCAL pode ser NULL (modo silencioso)
- **Linha 72** (Comentario): não bloqueia execução
- **Linha 74** (Comentario): ==========================================
- **Linha 75** (Comentario): 3. VALIDAR PERMISSÃO (OPCIONAL)
- **Linha 76** (Comentario): ==========================================
- **Linha 77**: Estrutura condicional de controle de fluxo.
- **Linha 79**: execucao de query SELECT para consulta de dados.
- **Linha 80**: INTO v_tem_permissao
- **Linha 81**: FROM usuario_perfil up
- **Linha 82**: JOIN perfil_permissao pp ON pp.id_perfil = up.id_perfil
- **Linha 83**: JOIN permissao p ON p.id_permissao = pp.id_permissao
- **Linha 84**: WHERE up.id_usuario = v_id_usuario
- **Linha 87**: LIMIT 1;
- **Linha 89**: Estrutura condicional de controle de fluxo.
- **Linha 90**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 91**: Estrutura de repeticao/controle de loop.
- **Linha 92**: Estrutura condicional de controle de fluxo.
- **Linha 94**: Estrutura condicional de controle de fluxo.
- **Linha 96** (Comentario): ==========================================
- **Linha 97** (Comentario): 4. RESULTADO
- **Linha 98** (Comentario): ==========================================
- **Linha 99**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 100**: 'id_usuario', v_id_usuario,
- **Linha 101**: 'id_unidade', v_id_unidade,
- **Linha 102**: 'id_local', v_id_local,
- **Linha 103**: 'id_perfil', v_id_perfil,
- **Linha 104**: 'local_null', IF(v_id_local IS NULL, TRUE, FALSE),
- **Linha 105**: 'permissao_validada', IF(p_permissao IS NOT NULL, TRUE, FALSE)
- **Linha 106**: );
- **Linha 108**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 109**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 111**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_assert`(
    IN p_id_sessao BIGINT,
    IN p_permissao VARCHAR(150), -- opcional
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
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local BIGINT;
    DECLARE v_id_perfil BIGINT;
    DECLARE v_expira_em DATETIME;
    DECLARE v_ativo TINYINT;

    DECLARE v_tem_permissao INT DEFAULT 1;

    SET p_sucesso = FALSE;
    SET p_mensagem = '';
    SET p_resultado = JSON_OBJECT();

    -- ==========================================
    -- 1. VALIDAR SESSÃO
    -- ==========================================
    SELECT 
        id_usuario,
        id_unidade,
        id_local,
        id_perfil,
        expira_em,
        ativo
    INTO 
        v_id_usuario,
        v_id_unidade,
        v_id_local,
        v_id_perfil,
        v_expira_em,
        v_ativo
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SET p_mensagem = 'SESSAO_NAO_ENCONTRADA';
        LEAVE proc;
    END IF;

    IF v_ativo <> 1 THEN
        SET p_mensagem = 'SESSAO_INATIVA';
        LEAVE proc;
    END IF;

    IF v_expira_em < NOW() THEN
        SET p_mensagem = 'SESSAO_EXPIRADA';
        LEAVE proc;
    END IF;

    -- ==========================================
    -- 2. VALIDAR CONTEXTO
    -- ==========================================
    IF v_id_unidade IS NULL THEN
        SET p_mensagem = 'CONTEXTO_NAO_DEFINIDO';
        LEAVE proc;
    END IF;

    -- LOCAL pode ser NULL (modo silencioso)
    -- não bloqueia execução

    -- ==========================================
    -- 3. VALIDAR PERMISSÃO (OPCIONAL)
    -- ==========================================
    IF p_permissao IS NOT NULL THEN

        SELECT COUNT(*)
        INTO v_tem_permissao
        FROM usuario_perfil up
        JOIN perfil_permissao pp ON pp.id_perfil = up.id_perfil
        JOIN permissao p ON p.id_permissao = pp.id_permissao
        WHERE up.id_usuario = v_id_usuario
          AND p.codigo = p_permissao
          AND up.ativo = 1
        LIMIT 1;

        IF v_tem_permissao = 0 THEN
            SET p_mensagem = 'SEM_PERMISSAO';
            LEAVE proc;
        END IF;

    END IF;

    -- ==========================================
    -- 4. RESULTADO
    -- ==========================================
    SET p_resultado = JSON_OBJECT(
        'id_usuario', v_id_usuario,
        'id_unidade', v_id_unidade,
        'id_local', v_id_local,
        'id_perfil', v_id_perfil,
        'local_null', IF(v_id_local IS NULL, TRUE, FALSE),
        'permissao_validada', IF(p_permissao IS NOT NULL, TRUE, FALSE)
    );

    SET p_sucesso = TRUE;
    SET p_mensagem = 'OK';

END ;;
```

