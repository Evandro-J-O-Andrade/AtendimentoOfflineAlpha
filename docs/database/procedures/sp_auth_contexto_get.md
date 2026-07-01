# sp_auth_contexto_get

Objetivo: auth contexto get conforme definida no dump SQL do sistema.

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
- SELECT: local, perfil, sessao_usuario, unidade, usuario_local, usuario_perfil, usuario_unidade
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COALESCE
- IF
- LEFT
- SIGNAL

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: nao detectado
- Commit: nao detectado

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: fechamento da lista de Parametros.
- **Linha 4**: inicio do bloco de execucao.
- **Linha 5**: Declaracao de variavel local v_id_usuario.
- **Linha 6**: Declaracao de variavel local v_id_entidade.
- **Linha 7**: Declaracao de variavel local v_id_unidade_atual.
- **Linha 8**: Declaracao de variavel local v_id_local_atual.
- **Linha 10** (Comentario): ==========================================
- **Linha 11** (Comentario): 1. VALIDAR SESSÃO
- **Linha 12** (Comentario): ==========================================
- **Linha 13**: execucao de query SELECT para consulta de dados.
- **Linha 14**: INTO v_id_usuario, v_id_entidade, v_id_unidade_atual, v_id_local_atual
- **Linha 15**: FROM sessao_usuario su
- **Linha 16**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 18**: LIMIT 1;
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 21**: SIGNAL SQLSTATE '45000'
- **Linha 22**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 23**: Estrutura condicional de controle de fluxo.
- **Linha 25** (Comentario): ==========================================
- **Linha 26** (Comentario): 2. UNIDADES
- **Linha 27** (Comentario): ==========================================
- **Linha 28**: execucao de query SELECT para consulta de dados.
- **Linha 29**: uu.id_unidade,
- **Linha 30**: un.nome AS nome_unidade
- **Linha 31**: FROM usuario_unidade uu
- **Linha 32**: INNER JOIN unidade un
- **Linha 33**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 35**: WHERE uu.id_usuario  = v_id_usuario
- **Linha 37**: ORDER BY un.nome;
- **Linha 39** (Comentario): ==========================================
- **Linha 40** (Comentario): 3. PERFIS
- **Linha 41** (Comentario): ==========================================
- **Linha 42**: execucao de query SELECT para consulta de dados.
- **Linha 43**: up.id_perfil,
- **Linha 44**: p.nome AS nome_perfil,
- **Linha 45**: up.id_unidade
- **Linha 46**: FROM usuario_perfil up
- **Linha 47**: INNER JOIN perfil p
- **Linha 48**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 50**: INNER JOIN usuario_unidade uu
- **Linha 51**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 54**: WHERE up.id_usuario  = v_id_usuario
- **Linha 56**: ORDER BY p.nome;
- **Linha 58** (Comentario): ==========================================
- **Linha 59** (Comentario): 4. LOCAIS / SALAS (com fallback "Não Definida")
- **Linha 60** (Comentario): ==========================================
- **Linha 61**: execucao de query SELECT para consulta de dados.
- **Linha 62**: COALESCE(ul.id_local, 0) AS id_sala,
- **Linha 63**: COALESCE(l.nome, 'Não Definida') AS nome_sala,
- **Linha 64**: ul.id_unidade
- **Linha 65**: FROM usuario_local ul
- **Linha 66**: LEFT JOIN local l
- **Linha 67**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 69**: INNER JOIN usuario_unidade uu
- **Linha 70**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 73**: WHERE ul.id_usuario  = v_id_usuario
- **Linha 75**: ORDER BY nome_sala;
- **Linha 77** (Comentario): ==========================================
- **Linha 78** (Comentario): 5. CONTEXTO ATUAL DA SESSÃO
- **Linha 79** (Comentario): ==========================================
- **Linha 80**: SELECT
- **Linha 81**: v_id_unidade_atual AS id_unidade_atual,
- **Linha 82**: v_id_local_atual   AS id_sala_atual;
- **Linha 84**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auth_contexto_get`(
    IN p_id_sessao_usuario BIGINT UNSIGNED
)
BEGIN
    DECLARE v_id_usuario  BIGINT UNSIGNED;
    DECLARE v_id_entidade BIGINT UNSIGNED;
    DECLARE v_id_unidade_atual BIGINT;
    DECLARE v_id_local_atual  BIGINT;

    -- ==========================================
    -- 1. VALIDAR SESSÃO
    -- ==========================================
    SELECT su.id_usuario, su.id_entidade, su.id_unidade, su.id_local
    INTO v_id_usuario, v_id_entidade, v_id_unidade_atual, v_id_local_atual
    FROM sessao_usuario su
    WHERE su.id_sessao_usuario = p_id_sessao_usuario
      AND su.id_entidade IS NOT NULL
    LIMIT 1;

    IF v_id_usuario IS NULL OR v_id_entidade IS NULL THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'SESSAO_INVALIDA_OU_SEM_TENANT';
    END IF;

    -- ==========================================
    -- 2. UNIDADES
    -- ==========================================
    SELECT DISTINCT
        uu.id_unidade,
        un.nome AS nome_unidade
    FROM usuario_unidade uu
    INNER JOIN unidade un
        ON un.id_unidade  = uu.id_unidade
       AND un.id_entidade = uu.id_entidade
    WHERE uu.id_usuario  = v_id_usuario
      AND uu.id_entidade = v_id_entidade
    ORDER BY un.nome;

    -- ==========================================
    -- 3. PERFIS
    -- ==========================================
    SELECT DISTINCT
        up.id_perfil,
        p.nome AS nome_perfil,
        up.id_unidade
    FROM usuario_perfil up
    INNER JOIN perfil p
        ON p.id_perfil   = up.id_perfil
       AND p.id_entidade = up.id_entidade
    INNER JOIN usuario_unidade uu
        ON uu.id_unidade  = up.id_unidade
       AND uu.id_usuario  = up.id_usuario
       AND uu.id_entidade = up.id_entidade
    WHERE up.id_usuario  = v_id_usuario
      AND up.id_entidade = v_id_entidade
    ORDER BY p.nome;

    -- ==========================================
    -- 4. LOCAIS / SALAS (com fallback "Não Definida")
    -- ==========================================
    SELECT DISTINCT
        COALESCE(ul.id_local, 0) AS id_sala,
        COALESCE(l.nome, 'Não Definida') AS nome_sala,
        ul.id_unidade
    FROM usuario_local ul
    LEFT JOIN local l
        ON l.id_local     = ul.id_local
       AND l.id_entidade  = ul.id_entidade
    INNER JOIN usuario_unidade uu
        ON uu.id_unidade  = ul.id_unidade
       AND uu.id_usuario  = ul.id_usuario
       AND uu.id_entidade = ul.id_entidade
    WHERE ul.id_usuario  = v_id_usuario
      AND ul.id_entidade = v_id_entidade
    ORDER BY nome_sala;

    -- ==========================================
    -- 5. CONTEXTO ATUAL DA SESSÃO
    -- ==========================================
    SELECT
        v_id_unidade_atual AS id_unidade_atual,
        v_id_local_atual   AS id_sala_atual;

END ;;
```

