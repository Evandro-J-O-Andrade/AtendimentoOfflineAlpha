# sp_master_admin_gerenciar_usuarios

Objetivo: master admin gerenciar usuarios conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: permissao, sessao_usuario, usuario, usuario_permissao
- INSERT: auditoria_usuario, usuario, usuario_permissao
- UPDATE: usuario
- DELETE: usuario_permissao

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- CONCAT
- IF
- IFNULL
- JSON_ARRAY
- JSON_EXTRACT
- JSON_LENGTH
- JSON_UNQUOTE
- LAST_INSERT_ID
- NOW
- NULLIF
- SIGNAL

## Views Utilizadas
- v_login
- v_nome
- v_senha

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
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: main: BEGIN
- **Linha 8** (Comentario): ==========================================
- **Linha 9** (Comentario): 1. DECLARAÇÕES (Sempre no topo)
- **Linha 10** (Comentario): ==========================================
- **Linha 11**: Declaracao de variavel local v_id_usuario_executor.
- **Linha 12**: Declaracao de variavel local v_id_usuario_alvo.
- **Linha 13**: Declaracao de variavel local v_login.
- **Linha 14**: Declaracao de variavel local v_nome.
- **Linha 15**: Declaracao de variavel local v_senha.
- **Linha 16**: Declaracao de variavel local v_permissoes.
- **Linha 17**: Declaracao de variavel local i.
- **Linha 18**: Declaracao de variavel local n.
- **Linha 19**: Declaracao de variavel local v_perm_id.
- **Linha 21** (Comentario): ==========================================
- **Linha 22** (Comentario): 2. CONTEXTO E SEGURANÇA
- **Linha 23** (Comentario): ==========================================
- **Linha 24**: execucao de query SELECT para consulta de dados.
- **Linha 25**: FROM sessao_usuario
- **Linha 26**: WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 29**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: SESSAO_INVALIDA';
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 32** (Comentario): ==========================================
- **Linha 33** (Comentario): 3. EXECUÇÃO DA AÇÃO
- **Linha 34** (Comentario): ==========================================
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 36**: SELECT
- **Linha 37**: u.id_usuario,
- **Linha 38**: u.login,
- **Linha 39**: u.nome,
- **Linha 40**: u.tipo_usuario,
- **Linha 41**: u.ativo,
- **Linha 42**: Estrutura condicional de controle de fluxo.
- **Linha 43**: (SELECT JSON_ARRAYAGG(p.codigo)
- **Linha 44**: FROM usuario_permissao up
- **Linha 45**: JOIN permissao p ON p.id_permissao = up.id_permissao
- **Linha 46**: WHERE up.id_usuario = u.id_usuario
- **Linha 47**: ), JSON_ARRAY()
- **Linha 48**: ) AS permissoes
- **Linha 49**: FROM usuario u
- **Linha 50**: WHERE u.tipo_usuario IN ('ADM', 'TI');
- **Linha 52**: Estrutura condicional de controle de fluxo.
- **Linha 53** (Comentario): Extração Segura
- **Linha 54**: atribuicao de valor Ã  variavel v_id_usuario_alvo.
- **Linha 55**: atribuicao de valor Ã  variavel v_login.
- **Linha 56**: atribuicao de valor Ã  variavel v_nome.
- **Linha 57**: atribuicao de valor Ã  variavel v_senha.
- **Linha 58**: atribuicao de valor Ã  variavel v_permissoes.
- **Linha 60** (Comentario): Validação Básica
- **Linha 61**: Estrutura condicional de controle de fluxo.
- **Linha 62**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: DADOS_OBRIGATORIOS_AUSENTES';
- **Linha 63**: Estrutura condicional de controle de fluxo.
- **Linha 65** (Comentario): UPSERT Lógica
- **Linha 66**: Estrutura condicional de controle de fluxo.
- **Linha 67**: Insere um novo registro na tabela usuario.
- **Linha 68**: VALUES (v_login, v_nome, v_senha, 'ADM', 1, NOW(6));
- **Linha 69**: atribuicao de valor Ã  variavel v_id_usuario_alvo.
- **Linha 70**: Estrutura condicional de controle de fluxo.
- **Linha 71**: UPDATE usuario
- **Linha 72**: atribuicao de valor Ã  variavel login.
- **Linha 73**: nome = v_nome,
- **Linha 74**: senha = IF(v_senha IS NOT NULL AND v_senha <> '', v_senha, senha),
- **Linha 75**: atualizado_em = NOW(6)
- **Linha 76**: WHERE id_usuario = v_id_usuario_alvo;
- **Linha 77**: Estrutura condicional de controle de fluxo.
- **Linha 79** (Comentario): ==========================================
- **Linha 80** (Comentario): 4. SINCRONIZAÇÃO DE PERMISSÕES (LOOP)
- **Linha 81** (Comentario): ==========================================
- **Linha 82**: Remove registros da tabela usuario_permissao.
- **Linha 84**: atribuicao de valor Ã  variavel n.
- **Linha 85**: atribuicao de valor Ã  variavel i.
- **Linha 87**: Estrutura de repeticao/controle de loop.
- **Linha 88**: atribuicao de valor Ã  variavel v_perm_id.
- **Linha 90** (Comentario): Inserção segura só se existir na tabela permissao
- **Linha 91**: Estrutura condicional de controle de fluxo.
- **Linha 92**: Insere um novo registro na tabela usuario_permissao.
- **Linha 93**: VALUES (v_id_usuario_alvo, v_perm_id);
- **Linha 94**: Estrutura condicional de controle de fluxo.
- **Linha 96**: atribuicao de valor Ã  variavel i.
- **Linha 97**: END WHILE;
- **Linha 99** (Comentario): ==========================================
- **Linha 100** (Comentario): 5. LEDGER DE AUDITORIA
- **Linha 101** (Comentario): ==========================================
- **Linha 102**: Insere um novo registro na tabela auditoria_usuario.
- **Linha 103**: id_usuario_executor, id_usuario_alvo, acao, payload_snapshot, criado_em
- **Linha 104**: fechamento da lista de Parametros.
- **Linha 105**: VALUES (
- **Linha 106**: v_id_usuario_executor, v_id_usuario_alvo, p_acao, p_payload, NOW(6)
- **Linha 107**: );
- **Linha 109**: Estrutura condicional de controle de fluxo.
- **Linha 110**: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: ACAO_INVALIDA';
- **Linha 111**: Estrutura condicional de controle de fluxo.
- **Linha 113**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_admin_gerenciar_usuarios`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(50),        -- 'LISTAR' ou 'CRIAR_ATUALIZAR'
    IN p_payload JSON             -- JSON com dados do usuário
)
    SQL SECURITY INVOKER
main: BEGIN
    -- ==========================================
    -- 1. DECLARAÇÕES (Sempre no topo)
    -- ==========================================
    DECLARE v_id_usuario_executor BIGINT;
    DECLARE v_id_usuario_alvo BIGINT;
    DECLARE v_login VARCHAR(100);
    DECLARE v_nome VARCHAR(150);
    DECLARE v_senha VARCHAR(255);
    DECLARE v_permissoes JSON;
    DECLARE i INT DEFAULT 0;
    DECLARE n INT DEFAULT 0;
    DECLARE v_perm_id BIGINT;

    -- ==========================================
    -- 2. CONTEXTO E SEGURANÇA
    -- ==========================================
    SELECT id_usuario INTO v_id_usuario_executor 
    FROM sessao_usuario 
    WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    IF v_id_usuario_executor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: SESSAO_INVALIDA';
    END IF;

    -- ==========================================
    -- 3. EXECUÇÃO DA AÇÃO
    -- ==========================================
    IF p_acao = 'LISTAR' THEN
        SELECT 
            u.id_usuario, 
            u.login, 
            u.nome, 
            u.tipo_usuario, 
            u.ativo,
            IFNULL(
                (SELECT JSON_ARRAYAGG(p.codigo) 
                 FROM usuario_permissao up 
                 JOIN permissao p ON p.id_permissao = up.id_permissao
                 WHERE up.id_usuario = u.id_usuario
                ), JSON_ARRAY()
            ) AS permissoes
        FROM usuario u
        WHERE u.tipo_usuario IN ('ADM', 'TI');

    ELSEIF p_acao = 'CRIAR_ATUALIZAR' THEN
        -- Extração Segura
        SET v_id_usuario_alvo = CAST(NULLIF(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_usuario')), '') AS UNSIGNED);
        SET v_login           = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.login'));
        SET v_nome            = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.nome'));
        SET v_senha           = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.senha'));
        SET v_permissoes      = JSON_EXTRACT(p_payload, '$.permissoes');

        -- Validação Básica
        IF v_login IS NULL OR v_nome IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: DADOS_OBRIGATORIOS_AUSENTES';
        END IF;

        -- UPSERT Lógica
        IF v_id_usuario_alvo IS NULL THEN
            INSERT INTO usuario (login, nome, senha, tipo_usuario, ativo, criado_em)
            VALUES (v_login, v_nome, v_senha, 'ADM', 1, NOW(6));
            SET v_id_usuario_alvo = LAST_INSERT_ID();
        ELSE
            UPDATE usuario
            SET login = v_login,
                nome = v_nome,
                senha = IF(v_senha IS NOT NULL AND v_senha <> '', v_senha, senha),
                atualizado_em = NOW(6)
            WHERE id_usuario = v_id_usuario_alvo;
        END IF;

        -- ==========================================
        -- 4. SINCRONIZAÇÃO DE PERMISSÕES (LOOP)
        -- ==========================================
        DELETE FROM usuario_permissao WHERE id_usuario = v_id_usuario_alvo;

        SET n = JSON_LENGTH(v_permissoes);
        SET i = 0;

        WHILE i < n DO
            SET v_perm_id = CAST(JSON_UNQUOTE(JSON_EXTRACT(v_permissoes, CONCAT('$[', i, ']'))) AS UNSIGNED);

            -- Inserção segura só se existir na tabela permissao
            IF EXISTS (SELECT 1 FROM permissao WHERE id_permissao = v_perm_id) THEN
                INSERT INTO usuario_permissao (id_usuario, id_permissao)
                VALUES (v_id_usuario_alvo, v_perm_id);
            END IF;

            SET i = i + 1;
        END WHILE;

        -- ==========================================
        -- 5. LEDGER DE AUDITORIA
        -- ==========================================
        INSERT INTO auditoria_usuario (
            id_usuario_executor, id_usuario_alvo, acao, payload_snapshot, criado_em
        )
        VALUES (
            v_id_usuario_executor, v_id_usuario_alvo, p_acao, p_payload, NOW(6)
        );

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_MASTER: ACAO_INVALIDA';
    END IF;

END ;;
```

