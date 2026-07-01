# sp_executor_assistencial_evolucao_salvar

Objetivo: executor assistencial evolucao salvar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: atendimento_evolucao
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- IFNULL
- JSON_EXTRACT
- JSON_UNQUOTE
- NOW

## Views Utilizadas
- v_tipo_prof

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
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 9** (Comentario): 1. DECLARAÇÕES DE APOIO
- **Linha 10**: Declaracao de variavel local v_id_usuario.
- **Linha 11**: Declaracao de variavel local v_tipo_prof.
- **Linha 13** (Comentario): 2. BUSCA O USUÁRIO DA SESSÃO (Contexto)
- **Linha 14**: execucao de query SELECT para consulta de dados.
- **Linha 15**: FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;
- **Linha 17** (Comentario): Define o tipo de profissional (pode vir no payload ou ser fixo)
- **Linha 18**: atribuicao de valor Ã  variavel v_tipo_prof.
- **Linha 20** (Comentario): 3. INSERÇÃO NA TABELA REFATORADA
- **Linha 21** (Comentario): Note que id_atendimento, id_saas_entidade e id_unidade já vêm no payload pelo Dispatcher
- **Linha 22**: Insere um novo registro na tabela atendimento_evolucao.
- **Linha 23**: id_saas_entidade,
- **Linha 24**: id_unidade,
- **Linha 25**: id_ffa,
- **Linha 26**: id_atendimento,
- **Linha 27**: id_usuario,
- **Linha 28**: id_sessao_usuario,
- **Linha 29**: tipo_profissional,
- **Linha 30**: texto_evolucao,
- **Linha 31**: ip_origem,
- **Linha 32**: device_info,
- **Linha 33**: criado_em
- **Linha 34**: ) VALUES (
- **Linha 35**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED),
- **Linha 36**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED),
- **Linha 37**: p_id_referencia,
- **Linha 38**: CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento')) AS UNSIGNED),
- **Linha 39**: v_id_usuario,
- **Linha 40**: p_id_sessao,
- **Linha 41**: v_tipo_prof,
- **Linha 42**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.texto')),
- **Linha 43**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem')),
- **Linha 44**: JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info')),
- **Linha 45**: NOW(6)
- **Linha 46**: );
- **Linha 48**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_assistencial_evolucao_salvar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT, -- id_ffa
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN
    -- 1. DECLARAÇÕES DE APOIO
    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo_prof VARCHAR(20);

    -- 2. BUSCA O USUÁRIO DA SESSÃO (Contexto)
    SELECT id_usuario INTO v_id_usuario 
    FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao LIMIT 1;

    -- Define o tipo de profissional (pode vir no payload ou ser fixo)
    SET v_tipo_prof = IFNULL(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.tipo_profissional')), 'OUTROS');

    -- 3. INSERÇÃO NA TABELA REFATORADA
    -- Note que id_atendimento, id_saas_entidade e id_unidade já vêm no payload pelo Dispatcher
    INSERT INTO atendimento_evolucao (
        id_saas_entidade,
        id_unidade,
        id_ffa,
        id_atendimento,
        id_usuario,
        id_sessao_usuario,
        tipo_profissional,
        texto_evolucao,
        ip_origem,
        device_info,
        criado_em
    ) VALUES (
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_saas_entidade')) AS UNSIGNED),
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_unidade')) AS UNSIGNED),
        p_id_referencia,
        CAST(JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.id_atendimento')) AS UNSIGNED),
        v_id_usuario,
        p_id_sessao,
        v_tipo_prof,
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.texto')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.ip_origem')),
        JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.device_info')),
        NOW(6)
    );

END ;;
```

