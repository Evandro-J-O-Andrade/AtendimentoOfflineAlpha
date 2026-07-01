# sp_executor_fila_runtime

Objetivo: executor fila runtime conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_id_referencia | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- IFNULL
- JSON_EXTRACT
- JSON_UNQUOTE
- NOW
- UPPER

## Views Utilizadas
- v_estado_destino

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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_id_usuario.
- **Linha 9**: Declaracao de variavel local v_id_unidade.
- **Linha 10**: Declaracao de variavel local v_estado_destino.
- **Linha 12** (Comentario): 2. Recupera contexto básico da sessão
- **Linha 13**: execucao de query SELECT para consulta de dados.
- **Linha 14**: FROM sessao_usuario
- **Linha 15**: WHERE id_sessao_usuario = p_id_sessao;
- **Linha 17** (Comentario): 3. Extrai destino se houver transição de estado
- **Linha 18**: atribuicao de valor Ã  variavel v_estado_destino.
- **Linha 20** (Comentario): 4. Roteamento de Ações de Fila
- **Linha 21**: CASE UPPER(p_acao)
- **Linha 23**: WHEN 'CHAMAR_SENHA' THEN
- **Linha 24**: Atualiza registros existentes na tabela senha.
- **Linha 25**: contexto_fluxo = IFNULL(v_estado_destino, 'CHAMADO'),
- **Linha 26**: ultima_atualizacao = NOW()
- **Linha 27**: WHERE id_senha = p_id_referencia;
- **Linha 29**: WHEN 'INICIAR_TRIAGEM' THEN
- **Linha 30**: Atualiza registros existentes na tabela senha.
- **Linha 31**: contexto_fluxo = 'EM_TRIAGEM',
- **Linha 32**: ultima_atualizacao = NOW()
- **Linha 33**: WHERE id_senha = p_id_referencia;
- **Linha 35**: WHEN 'FINALIZAR_TRIAGEM' THEN
- **Linha 36**: Atualiza registros existentes na tabela senha.
- **Linha 37**: contexto_fluxo = 'AGUARDANDO_MEDICO',
- **Linha 38**: ultima_atualizacao = NOW()
- **Linha 39**: WHERE id_senha = p_id_referencia;
- **Linha 41**: WHEN 'EVASAO' THEN
- **Linha 42**: Atualiza registros existentes na tabela senha.
- **Linha 43**: contexto_fluxo = 'EVADIDO',
- **Linha 44**: ativo = 0,
- **Linha 45**: ultima_atualizacao = NOW()
- **Linha 46**: WHERE id_senha = p_id_referencia;
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 49**: Estrutura condicional de controle de fluxo.
- **Linha 50**: Atualiza registros existentes na tabela senha.
- **Linha 51**: contexto_fluxo = v_estado_destino,
- **Linha 52**: ultima_atualizacao = NOW()
- **Linha 53**: WHERE id_senha = p_id_referencia;
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 55**: END CASE;
- **Linha 57**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_fila_runtime`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_estado_destino VARCHAR(50);

    -- 2. Recupera contexto básico da sessão
    SELECT id_usuario, id_unidade INTO v_id_usuario, v_id_unidade
    FROM sessao_usuario 
    WHERE id_sessao_usuario = p_id_sessao;

    -- 3. Extrai destino se houver transição de estado
    SET v_estado_destino = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.estado_destino'));

    -- 4. Roteamento de Ações de Fila
    CASE UPPER(p_acao)
        
        WHEN 'CHAMAR_SENHA' THEN
            UPDATE senha SET 
                contexto_fluxo = IFNULL(v_estado_destino, 'CHAMADO'),
                ultima_atualizacao = NOW()
            WHERE id_senha = p_id_referencia;

        WHEN 'INICIAR_TRIAGEM' THEN
            UPDATE senha SET 
                contexto_fluxo = 'EM_TRIAGEM',
                ultima_atualizacao = NOW()
            WHERE id_senha = p_id_referencia;

        WHEN 'FINALIZAR_TRIAGEM' THEN
            UPDATE senha SET 
                contexto_fluxo = 'AGUARDANDO_MEDICO',
                ultima_atualizacao = NOW()
            WHERE id_senha = p_id_referencia;
            
        WHEN 'EVASAO' THEN
            UPDATE senha SET 
                contexto_fluxo = 'EVADIDO',
                ativo = 0,
                ultima_atualizacao = NOW()
            WHERE id_senha = p_id_referencia;

        ELSE
            IF v_estado_destino IS NOT NULL THEN
                UPDATE senha SET 
                    contexto_fluxo = v_estado_destino,
                    ultima_atualizacao = NOW()
                WHERE id_senha = p_id_referencia;
            END IF;
    END CASE;

END ;;
```

