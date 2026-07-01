# sp_kernel_runtime_heartbeat

Objetivo: kernel runtime heartbeat conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_uuid_runtime | VARCHAR(36) | IN | |
| p_id_dispositivo | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: runtime_api_session_token, sessao_usuario
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- NOW
- SIGNAL
- TIMESTAMPDIFF

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
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_expira_em.
- **Linha 9**: Declaracao de variavel local v_id_usuario.
- **Linha 11** (Comentario): Validar parâmetros
- **Linha 12**: Estrutura condicional de controle de fluxo.
- **Linha 13**: SIGNAL SQLSTATE '45000'
- **Linha 14**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 15**: Estrutura condicional de controle de fluxo.
- **Linha 17** (Comentario): Buscar informações da sessão
- **Linha 18**: execucao de query SELECT para consulta de dados.
- **Linha 19**: FROM sessao_usuario
- **Linha 20**: WHERE id_sessao_usuario = p_id_sessao;
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 23**: SIGNAL SQLSTATE '45000'
- **Linha 24**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 27** (Comentario): Verificar se expirou
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 29**: SIGNAL SQLSTATE '45000'
- **Linha 30**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 33** (Comentario): Atualizar último acesso na sessão
- **Linha 34**: UPDATE sessao_usuario
- **Linha 35**: atribuicao de valor Ã  variavel ultimo_acesso.
- **Linha 36**: WHERE id_sessao_usuario = p_id_sessao;
- **Linha 38** (Comentario): Atualizar heartbeat no token API se existir
- **Linha 39**: Estrutura condicional de controle de fluxo.
- **Linha 40**: UPDATE runtime_api_session_token
- **Linha 41**: atribuicao de valor Ã  variavel ultimo_acesso.
- **Linha 42**: WHERE uuid_runtime = p_uuid_runtime
- **Linha 44**: Estrutura condicional de controle de fluxo.
- **Linha 46** (Comentario): Retornar status
- **Linha 47**: SELECT
- **Linha 48**: p_id_sessao AS id_sessao,
- **Linha 49**: v_id_usuario AS id_usuario,
- **Linha 50**: v_expira_em AS expira_em,
- **Linha 51**: 'ATIVO' AS status,
- **Linha 52**: TIMESTAMPDIFF(SECOND, NOW(), v_expira_em) AS segundos_restantes,
- **Linha 53**: NOW() AS heartbeat_at;
- **Linha 55**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_kernel_runtime_heartbeat`(
    IN p_id_sessao BIGINT,
    IN p_uuid_runtime VARCHAR(36),
    IN p_id_dispositivo BIGINT
)
    SQL SECURITY INVOKER
BEGIN
    DECLARE v_expira_em DATETIME;
    DECLARE v_id_usuario BIGINT;
    
    -- Validar parâmetros
    IF p_id_sessao IS NULL OR p_id_sessao = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID_SESSAO_OBRIGATORIO';
    END IF;
    
    -- Buscar informações da sessão
    SELECT id_usuario, expira_em INTO v_id_usuario, v_expira_em
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao;
    
    IF v_id_usuario IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SESSAO_NAO_ENCONTRADA';
    END IF;
    
    -- Verificar se expirou
    IF v_expira_em < NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'SESSAO_EXPIRADA';
    END IF;
    
    -- Atualizar último acesso na sessão
    UPDATE sessao_usuario
    SET ultimo_acesso = NOW()
    WHERE id_sessao_usuario = p_id_sessao;
    
    -- Atualizar heartbeat no token API se existir
    IF p_uuid_runtime IS NOT NULL THEN
        UPDATE runtime_api_session_token
        SET ultimo_acesso = NOW()
        WHERE uuid_runtime = p_uuid_runtime
        AND ativo = 1;
    END IF;
    
    -- Retornar status
    SELECT 
        p_id_sessao AS id_sessao,
        v_id_usuario AS id_usuario,
        v_expira_em AS expira_em,
        'ATIVO' AS status,
        TIMESTAMPDIFF(SECOND, NOW(), v_expira_em) AS segundos_restantes,
        NOW() AS heartbeat_at;
    
END ;;
```

