# sp_auth_contexto_set

Objetivo: auth contexto set conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario, usuario_local, usuario_perfil, usuario_unidade
- INSERT: auditoria_evento, usuario_contexto
- UPDATE: sessao_usuario
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COUNT
- IF
- JSON_OBJECT
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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_id_usuario.
- **Linha 9**: Declaracao de variavel local v_id_entidade.
- **Linha 10**: Declaracao de variavel local v_exists.
- **Linha 12** (Comentario): ==========================================
- **Linha 13** (Comentario): 1. VALIDAR SESSÃO + TENANT
- **Linha 14** (Comentario): ==========================================
- **Linha 15**: execucao de query SELECT para consulta de dados.
- **Linha 16**: INTO v_id_usuario, v_id_entidade
- **Linha 17**: FROM sessao_usuario su
- **Linha 18**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 20**: LIMIT 1;
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 23**: SIGNAL SQLSTATE '45000'
- **Linha 24**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 27** (Comentario): ==========================================
- **Linha 28** (Comentario): 2. VALIDAR UNIDADE
- **Linha 29** (Comentario): ==========================================
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: FROM usuario_unidade uu
- **Linha 32**: WHERE uu.id_usuario  = v_id_usuario
- **Linha 36**: Estrutura condicional de controle de fluxo.
- **Linha 37**: SIGNAL SQLSTATE '45000'
- **Linha 38**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 39**: Estrutura condicional de controle de fluxo.
- **Linha 41** (Comentario): ==========================================
- **Linha 42** (Comentario): 3. VALIDAR PERFIL
- **Linha 43** (Comentario): ==========================================
- **Linha 44**: execucao de query SELECT para consulta de dados.
- **Linha 45**: FROM usuario_perfil up
- **Linha 46**: WHERE up.id_usuario  = v_id_usuario
- **Linha 51**: Estrutura condicional de controle de fluxo.
- **Linha 52**: SIGNAL SQLSTATE '45000'
- **Linha 53**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 56** (Comentario): ==========================================
- **Linha 57** (Comentario): 4. VALIDAR LOCAL (com fallback "Não Definida" se necessário)
- **Linha 58** (Comentario): ==========================================
- **Linha 59**: Estrutura condicional de controle de fluxo.
- **Linha 60**: atribuicao de valor Ã  variavel p_id_local.
- **Linha 61**: Estrutura condicional de controle de fluxo.
- **Linha 62**: execucao de query SELECT para consulta de dados.
- **Linha 63**: FROM usuario_local ul
- **Linha 64**: WHERE ul.id_usuario  = v_id_usuario
- **Linha 69**: Estrutura condicional de controle de fluxo.
- **Linha 70**: SIGNAL SQLSTATE '45000'
- **Linha 71**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 72**: Estrutura condicional de controle de fluxo.
- **Linha 73**: Estrutura condicional de controle de fluxo.
- **Linha 75** (Comentario): ==========================================
- **Linha 76** (Comentario): 5. ATUALIZAR CONTEXTO DA SESSÃO
- **Linha 77** (Comentario): ==========================================
- **Linha 78**: UPDATE sessao_usuario
- **Linha 79**: atribuicao de valor Ã  variavel id_unidade.
- **Linha 80**: id_local       = p_id_local,
- **Linha 81**: atualizado_em  = NOW(6)
- **Linha 82**: WHERE id_sessao_usuario = p_id_sessao_usuario
- **Linha 85** (Comentario): ==========================================
- **Linha 86** (Comentario): 6. PERSISTIR CONTEXTO (SNAPSHOT)
- **Linha 87** (Comentario): ==========================================
- **Linha 88**: Insere um novo registro na tabela usuario_contexto.
- **Linha 89**: id_usuario,
- **Linha 90**: id_entidade,
- **Linha 91**: id_unidade,
- **Linha 92**: id_perfil,
- **Linha 93**: id_local,
- **Linha 94**: criado_em
- **Linha 95**: ) VALUES (
- **Linha 96**: v_id_usuario,
- **Linha 97**: v_id_entidade,
- **Linha 98**: p_id_unidade,
- **Linha 99**: p_id_perfil,
- **Linha 100**: p_id_local,
- **Linha 101**: NOW(6)
- **Linha 102**: );
- **Linha 104** (Comentario): ==========================================
- **Linha 105** (Comentario): 7. AUDITORIA ATIVA
- **Linha 106** (Comentario): ==========================================
- **Linha 107**: Insere um novo registro na tabela auditoria_evento.
- **Linha 108**: id_sessao_usuario,
- **Linha 109**: tipo_evento,
- **Linha 110**: entidade,
- **Linha 111**: entidade_id,
- **Linha 112**: payload,
- **Linha 113**: criado_em
- **Linha 114**: ) VALUES (
- **Linha 115**: p_id_sessao_usuario,
- **Linha 116**: 'CONTEXT_SET',
- **Linha 117**: 'sessao_usuario',
- **Linha 118**: p_id_sessao_usuario,
- **Linha 119**: JSON_OBJECT(
- **Linha 120**: 'id_usuario', v_id_usuario,
- **Linha 121**: 'id_entidade', v_id_entidade,
- **Linha 122**: 'id_unidade', p_id_unidade,
- **Linha 123**: 'id_perfil', p_id_perfil,
- **Linha 124**: 'id_local', p_id_local
- **Linha 125**: ),
- **Linha 126**: NOW(6)
- **Linha 127**: );
- **Linha 129**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_set`(
    IN p_id_sessao_usuario BIGINT UNSIGNED,
    IN p_id_unidade        BIGINT UNSIGNED,
    IN p_id_perfil         BIGINT UNSIGNED,
    IN p_id_local          BIGINT UNSIGNED
)
BEGIN
    DECLARE v_id_usuario   BIGINT UNSIGNED;
    DECLARE v_id_entidade  BIGINT UNSIGNED;
    DECLARE v_exists       INT;

    -- ==========================================
    -- 1. VALIDAR SESSÃO + TENANT
    -- ==========================================
    SELECT su.id_usuario, su.id_entidade
    INTO v_id_usuario, v_id_entidade
    FROM sessao_usuario su
    WHERE su.id_sessao_usuario = p_id_sessao_usuario
      AND su.id_entidade IS NOT NULL
    LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_entidade IS NULL THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'SESSAO_INVALIDA_OU_SEM_TENANT';
    END IF;

    -- ==========================================
    -- 2. VALIDAR UNIDADE
    -- ==========================================
    SELECT COUNT(*) INTO v_exists
    FROM usuario_unidade uu
    WHERE uu.id_usuario  = v_id_usuario
      AND uu.id_unidade  = p_id_unidade
      AND uu.id_entidade = v_id_entidade;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'USUARIO_NAO_VINCULADO_UNIDADE';
    END IF;

    -- ==========================================
    -- 3. VALIDAR PERFIL
    -- ==========================================
    SELECT COUNT(*) INTO v_exists
    FROM usuario_perfil up
    WHERE up.id_usuario  = v_id_usuario
      AND up.id_perfil   = p_id_perfil
      AND up.id_unidade  = p_id_unidade
      AND up.id_entidade = v_id_entidade;

    IF v_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'PERFIL_INVALIDO_PARA_UNIDADE';
    END IF;

    -- ==========================================
    -- 4. VALIDAR LOCAL (com fallback "Não Definida" se necessário)
    -- ==========================================
    IF p_id_local IS NULL THEN
        SET p_id_local = 0; -- 0 = "Não Definida"
    ELSE
        SELECT COUNT(*) INTO v_exists
        FROM usuario_local ul
        WHERE ul.id_usuario  = v_id_usuario
          AND ul.id_local    = p_id_local
          AND ul.id_unidade  = p_id_unidade
          AND ul.id_entidade = v_id_entidade;

        IF v_exists = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'LOCAL_INVALIDO_PARA_UNIDADE';
        END IF;
    END IF;

    -- ==========================================
    -- 5. ATUALIZAR CONTEXTO DA SESSÃO
    -- ==========================================
    UPDATE sessao_usuario
    SET id_unidade     = p_id_unidade,
        id_local       = p_id_local,
        atualizado_em  = NOW(6)
    WHERE id_sessao_usuario = p_id_sessao_usuario
      AND id_entidade       = v_id_entidade;

    -- ==========================================
    -- 6. PERSISTIR CONTEXTO (SNAPSHOT)
    -- ==========================================
    INSERT INTO usuario_contexto (
        id_usuario,
        id_entidade,
        id_unidade,
        id_perfil,
        id_local,
        criado_em
    ) VALUES (
        v_id_usuario,
        v_id_entidade,
        p_id_unidade,
        p_id_perfil,
        p_id_local,
        NOW(6)
    );

    -- ==========================================
    -- 7. AUDITORIA ATIVA
    -- ==========================================
    INSERT INTO auditoria_evento (
        id_sessao_usuario,
        tipo_evento,
        entidade,
        entidade_id,
        payload,
        criado_em
    ) VALUES (
        p_id_sessao_usuario,
        'CONTEXT_SET',
        'sessao_usuario',
        p_id_sessao_usuario,
        JSON_OBJECT(
            'id_usuario', v_id_usuario,
            'id_entidade', v_id_entidade,
            'id_unidade', p_id_unidade,
            'id_perfil', p_id_perfil,
            'id_local', p_id_local
        ),
        NOW(6)
    );

END ;;
```

