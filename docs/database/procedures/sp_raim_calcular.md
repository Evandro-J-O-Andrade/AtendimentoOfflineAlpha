# sp_raim_calcular

Objetivo: raim calcular conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sistema | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: assistencial_runtime_federado, atendimento, fila_operacional, leito
- INSERT: assistencial_raim_metric
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- AVG
- COUNT
- IFNULL

## Views Utilizadas
- v_backlog
- v_evasao
- v_fila
- v_leito
- v_score

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
- **Linha 3**: fechamento da lista de Parametros.
- **Linha 4**: SQL SECURITY INVOKER
- **Linha 5**: inicio do bloco de execucao.
- **Linha 7**: Declaracao de variavel local v_fila.
- **Linha 8**: Declaracao de variavel local v_evasao.
- **Linha 9**: Declaracao de variavel local v_leito.
- **Linha 10**: Declaracao de variavel local v_backlog.
- **Linha 11**: Declaracao de variavel local v_score.
- **Linha 13**: /* Coleta métricas runtime assistenciais */
- **Linha 15**: execucao de query SELECT para consulta de dados.
- **Linha 16**: FROM fila_operacional
- **Linha 17**: WHERE id_sistema = p_id_sistema
- **Linha 20**: execucao de query SELECT para consulta de dados.
- **Linha 21**: INTO v_evasao
- **Linha 22**: FROM atendimento
- **Linha 23**: WHERE id_sistema = p_id_sistema;
- **Linha 25**: execucao de query SELECT para consulta de dados.
- **Linha 26**: FROM leito
- **Linha 27**: WHERE id_sistema = p_id_sistema
- **Linha 30**: execucao de query SELECT para consulta de dados.
- **Linha 31**: FROM assistencial_runtime_federado
- **Linha 32**: WHERE id_sistema = p_id_sistema
- **Linha 35**: /* Score simplificado RAIM */
- **Linha 37**: atribuicao de valor Ã  variavel v_score.
- **Linha 38**: (0.25 * IFNULL(v_fila,0)) +
- **Linha 39**: (0.25 * IFNULL(v_evasao,0)) +
- **Linha 40**: (0.25 * IFNULL(v_leito,0)) +
- **Linha 41**: (0.25 * IFNULL(v_backlog,0));
- **Linha 43**: /* Salva métrica observacional */
- **Linha 45**: Insere um novo registro na tabela assistencial_raim_metric.
- **Linha 46**: id_sistema,
- **Linha 47**: fila_pressao,
- **Linha 48**: taxa_evasao,
- **Linha 49**: saturacao_leito,
- **Linha 50**: backlog_runtime,
- **Linha 51**: score_raim,
- **Linha 52**: alerta_recomendacao
- **Linha 53**: fechamento da lista de Parametros.
- **Linha 54**: VALUES(
- **Linha 55**: p_id_sistema,
- **Linha 56**: v_fila,
- **Linha 57**: v_evasao,
- **Linha 58**: v_leito,
- **Linha 59**: v_backlog,
- **Linha 60**: v_score,
- **Linha 61**: CASE
- **Linha 62**: WHEN v_score > 80 THEN 'ALTA PRESSAO ASSISTENCIAL'
- **Linha 63**: WHEN v_score > 50 THEN 'ATENCAO OPERACIONAL'
- **Linha 64**: Estrutura condicional de controle de fluxo.
- **Linha 65**: END
- **Linha 66**: );
- **Linha 68**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_raim_calcular`(
    IN p_id_sistema BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_fila DECIMAL(10,4);
    DECLARE v_evasao DECIMAL(10,4);
    DECLARE v_leito DECIMAL(10,4);
    DECLARE v_backlog DECIMAL(10,4);
    DECLARE v_score DECIMAL(10,4);

    /* Coleta métricas runtime assistenciais */

    SELECT COUNT(*) INTO v_fila
    FROM fila_operacional
    WHERE id_sistema = p_id_sistema
    AND status IN ('CHAMANDO','EM_ESPERA');

    SELECT AVG(CASE WHEN status='EVASAO' THEN 1 ELSE 0 END)
    INTO v_evasao
    FROM atendimento
    WHERE id_sistema = p_id_sistema;

    SELECT COUNT(*) INTO v_leito
    FROM leito
    WHERE id_sistema = p_id_sistema
    AND status = 'OCUPADO';

    SELECT COUNT(*) INTO v_backlog
    FROM assistencial_runtime_federado
    WHERE id_sistema = p_id_sistema
    AND sincronizado = 0;

    /* Score simplificado RAIM */

    SET v_score =
        (0.25 * IFNULL(v_fila,0)) +
        (0.25 * IFNULL(v_evasao,0)) +
        (0.25 * IFNULL(v_leito,0)) +
        (0.25 * IFNULL(v_backlog,0));

    /* Salva métrica observacional */

    INSERT INTO assistencial_raim_metric(
        id_sistema,
        fila_pressao,
        taxa_evasao,
        saturacao_leito,
        backlog_runtime,
        score_raim,
        alerta_recomendacao
    )
    VALUES(
        p_id_sistema,
        v_fila,
        v_evasao,
        v_leito,
        v_backlog,
        v_score,
        CASE
            WHEN v_score > 80 THEN 'ALTA PRESSAO ASSISTENCIAL'
            WHEN v_score > 50 THEN 'ATENCAO OPERACIONAL'
            ELSE 'REDE ESTAVEL'
        END
    );

END ;;
```

