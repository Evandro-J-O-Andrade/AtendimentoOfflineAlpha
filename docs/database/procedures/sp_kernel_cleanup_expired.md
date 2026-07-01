# sp_kernel_cleanup_expired

Objetivo: kernel cleanup expired conforme definida no dump SQL do sistema.

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
- SELECT: runtime_api_session_token, runtime_execution_queue, sessao_usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: runtime_api_session_token, runtime_execution_queue, sessao_usuario

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- DATE_SUB
- NOW
- ROW_COUNT

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
- **Linha 2**: SQL SECURITY INVOKER
- **Linha 3**: inicio do bloco de execucao.
- **Linha 4**: Declaracao de variavel local v_sessoes_removidas.
- **Linha 5**: Declaracao de variavel local v_tokens_removidos.
- **Linha 7** (Comentario): Remover sessões expiradas
- **Linha 8**: Remove registros da tabela sessao_usuario.
- **Linha 9**: atribuicao de valor Ã  variavel v_sessoes_removidas.
- **Linha 11** (Comentario): Remover tokens expirados
- **Linha 12**: Remove registros da tabela runtime_api_session_token.
- **Linha 13**: atribuicao de valor Ã  variavel v_tokens_removidos.
- **Linha 15** (Comentario): Limpar filas antigas
- **Linha 16**: Remove registros da tabela runtime_execution_queue.
- **Linha 17**: WHERE status IN ('CONCLUIDO', 'ERRO')
- **Linha 20**: SELECT
- **Linha 21**: v_sessoes_removidas AS sessoes_removidas,
- **Linha 22**: v_tokens_removidos AS tokens_removidos,
- **Linha 23**: NOW() AS cleanup_at;
- **Linha 25**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_kernel_cleanup_expired`()
    SQL SECURITY INVOKER
BEGIN
    DECLARE v_sessoes_removidas INT DEFAULT 0;
    DECLARE v_tokens_removidos INT DEFAULT 0;
    
    -- Remover sessões expiradas
    DELETE FROM sessao_usuario WHERE expira_em < NOW();
    SET v_sessoes_removidas = ROW_COUNT();
    
    -- Remover tokens expirados
    DELETE FROM runtime_api_session_token WHERE expira_em < NOW();
    SET v_tokens_removidos = ROW_COUNT();
    
    -- Limpar filas antigas
    DELETE FROM runtime_execution_queue 
    WHERE status IN ('CONCLUIDO', 'ERRO') 
    AND atualizado_em < DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    SELECT 
        v_sessoes_removidas AS sessoes_removidas,
        v_tokens_removidos AS tokens_removidos,
        NOW() AS cleanup_at;
    
END ;;
```

