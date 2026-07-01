# sp_executor_recepcao_abrir_atendimento

Objetivo: executor recepcao abrir atendimento conforme definida no dump SQL do sistema.

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
- INSERT: ffa
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- JSON_EXTRACT
- JSON_OBJECT
- LAST_INSERT_ID
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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local v_id_saas.
- **Linha 11**: Declaracao de variavel local v_id_unidade.
- **Linha 12**: Declaracao de variavel local v_id_usuario.
- **Linha 13**: Declaracao de variavel local v_id_paciente.
- **Linha 14**: Declaracao de variavel local v_id_ffa.
- **Linha 16** (Comentario): CONTEXTO
- **Linha 17**: execucao de query SELECT para consulta de dados.
- **Linha 18**: INTO v_id_saas, v_id_unidade, v_id_usuario
- **Linha 19**: FROM sessao_usuario
- **Linha 20**: WHERE id_sessao_usuario = p_id_sessao
- **Linha 21**: LIMIT 1;
- **Linha 23**: atribuicao de valor Ã  variavel v_id_paciente.
- **Linha 25** (Comentario): NEGÓCIO
- **Linha 26**: Insere um novo registro na tabela ffa.
- **Linha 27**: id_saas_entidade,
- **Linha 28**: id_unidade,
- **Linha 29**: id_paciente,
- **Linha 30**: contexto_fluxo,
- **Linha 31**: criado_em
- **Linha 32**: ) VALUES (
- **Linha 33**: v_id_saas,
- **Linha 34**: v_id_unidade,
- **Linha 35**: v_id_paciente,
- **Linha 36**: 'AGUARDANDO_TRIAGEM',
- **Linha 37**: NOW(6)
- **Linha 38**: );
- **Linha 40**: atribuicao de valor Ã  variavel v_id_ffa.
- **Linha 42** (Comentario): RETORNO
- **Linha 43**: execucao de query SELECT para consulta de dados.
- **Linha 44**: 'status','SUCCESS',
- **Linha 45**: 'id_ffa', v_id_ffa
- **Linha 46**: ) AS result;
- **Linha 48**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_recepcao_abrir_atendimento`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_saas BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_paciente BIGINT;
    DECLARE v_id_ffa BIGINT;

    -- CONTEXTO
    SELECT id_saas_entidade, id_unidade, id_usuario
    INTO v_id_saas, v_id_unidade, v_id_usuario
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
    LIMIT 1;

    SET v_id_paciente = JSON_EXTRACT(p_payload, '$.id_paciente');

    -- NEGÓCIO
    INSERT INTO ffa (
        id_saas_entidade,
        id_unidade,
        id_paciente,
        contexto_fluxo,
        criado_em
    ) VALUES (
        v_id_saas,
        v_id_unidade,
        v_id_paciente,
        'AGUARDANDO_TRIAGEM',
        NOW(6)
    );

    SET v_id_ffa = LAST_INSERT_ID();

    -- RETORNO
    SELECT JSON_OBJECT(
        'status','SUCCESS',
        'id_ffa', v_id_ffa
    ) AS result;

END ;;
```

