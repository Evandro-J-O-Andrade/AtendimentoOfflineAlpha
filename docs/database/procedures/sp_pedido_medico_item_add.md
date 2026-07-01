# sp_pedido_medico_item_add

Objetivo: pedido medico item add conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_pedido_medico | BIGINT | IN | |
| p_tipo_item | VARCHAR(20) | IN | |
| p_descricao | VARCHAR(500) | IN | |
| p_codigo_sigtap | VARCHAR(30) | IN | |
| p_competencia | CHAR(6) | IN | |
| p_exige_cat | TINYINT | IN | |
| p_exige_sinan | TINYINT | IN | |
| p_id_pedido_item | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: cat_regra_item, sus_sigtap_procedimento
- INSERT: pedido_medico_item
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CHAR_LENGTH
- CONCAT
- IF
- IFNULL
- LAST_INSERT_ID

## Views Utilizadas
- v_sqlstate

## Eventos Gerados
- auditoria_evento
- evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: main: BEGIN
- **Linha 13**: Declaracao de variavel local v_sqlstate.
- **Linha 14**: Declaracao de variavel local v_errno.
- **Linha 15**: Declaracao de variavel local v_msg.
- **Linha 17**: Declaracao de variavel local v_exige_cat_calc.
- **Linha 18**: Declaracao de variavel local v_exige_sinan_calc.
- **Linha 20**: Declaracao de variavel local EXIT.
- **Linha 21**: inicio do bloco de execucao.
- **Linha 22**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 23**: ROLLBACK;
- **Linha 24**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 25**: Invoca a procedure sp_raise.
- **Linha 26**: Fim do bloco da procedure.
- **Linha 28**: atribuicao de valor Ã  variavel p_id_pedido_item.
- **Linha 30**: Invoca a procedure sp_sessao_assert.
- **Linha 31**: Invoca a procedure sp_assert_true.
- **Linha 32**: Invoca a procedure sp_assert_true.
- **Linha 34**: START TRANSACTION;
- **Linha 36**: Estrutura condicional de controle de fluxo.
- **Linha 37**: execucao de query SELECT para consulta de dados.
- **Linha 38**: FROM cat_regra_item r
- **Linha 39**: WHERE r.codigo_sigtap = p_codigo_sigtap
- **Linha 41**: LIMIT 1;
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 44**: atribuicao de valor Ã  variavel v_exige_cat_calc.
- **Linha 45**: Estrutura condicional de controle de fluxo.
- **Linha 47**: Estrutura condicional de controle de fluxo.
- **Linha 48**: execucao de query SELECT para consulta de dados.
- **Linha 49**: INTO v_exige_cat_calc
- **Linha 50**: FROM sus_sigtap_procedimento s
- **Linha 51**: WHERE s.codigo = p_codigo_sigtap
- **Linha 53**: LIMIT 1;
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 55**: atribuicao de valor Ã  variavel v_exige_cat_calc.
- **Linha 56**: Estrutura condicional de controle de fluxo.
- **Linha 57**: Estrutura condicional de controle de fluxo.
- **Linha 59**: Estrutura condicional de controle de fluxo.
- **Linha 60**: execucao de query SELECT para consulta de dados.
- **Linha 61**: INTO v_exige_sinan_calc
- **Linha 62**: FROM sus_sigtap_procedimento s
- **Linha 63**: WHERE s.codigo = p_codigo_sigtap
- **Linha 65**: LIMIT 1;
- **Linha 66**: Estrutura condicional de controle de fluxo.
- **Linha 67**: atribuicao de valor Ã  variavel v_exige_sinan_calc.
- **Linha 68**: Estrutura condicional de controle de fluxo.
- **Linha 69**: Estrutura condicional de controle de fluxo.
- **Linha 70**: Estrutura condicional de controle de fluxo.
- **Linha 72**: Insere um novo registro na tabela pedido_medico_item.
- **Linha 73**: id_pedido_medico, tipo_item, status,
- **Linha 74**: codigo_sigtap, competencia_sigtap,
- **Linha 75**: descricao, exige_cat, exige_sinan
- **Linha 76**: ) VALUES (
- **Linha 77**: p_id_pedido_medico,
- **Linha 78**: p_tipo_item,
- **Linha 79**: 'PENDENTE',
- **Linha 80**: p_codigo_sigtap,
- **Linha 81**: p_competencia,
- **Linha 82**: p_descricao,
- **Linha 83**: CASE WHEN p_exige_cat IS NOT NULL THEN p_exige_cat ELSE v_exige_cat_calc END,
- **Linha 84**: CASE WHEN p_exige_sinan IS NOT NULL THEN p_exige_sinan ELSE v_exige_sinan_calc END
- **Linha 85**: );
- **Linha 87**: atribuicao de valor Ã  variavel p_id_pedido_item.
- **Linha 89**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 91**: COMMIT;
- **Linha 92**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pedido_medico_item_add`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_pedido_medico  BIGINT,
    IN  p_tipo_item         VARCHAR(20),
    IN  p_descricao         VARCHAR(500),
    IN  p_codigo_sigtap     VARCHAR(30),
    IN  p_competencia       CHAR(6),
    IN  p_exige_cat         TINYINT,
    IN  p_exige_sinan       TINYINT,
    OUT p_id_pedido_item    BIGINT
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_exige_cat_calc TINYINT DEFAULT 0;
    DECLARE v_exige_sinan_calc TINYINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_pedido_medico_item_add', 'Falha ao inserir item do pedido');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_pedido_medico_item_add | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    SET p_id_pedido_item = NULL;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_pedido_medico IS NOT NULL, 'PARAM', 'id_pedido_medico é obrigatório.');
    CALL sp_assert_true(p_tipo_item IS NOT NULL, 'PARAM', 'tipo_item é obrigatório.');

    START TRANSACTION;

    IF p_codigo_sigtap IS NOT NULL AND CHAR_LENGTH(p_codigo_sigtap) > 0 THEN
        SELECT 1 INTO v_exige_cat_calc
          FROM cat_regra_item r
         WHERE r.codigo_sigtap = p_codigo_sigtap
           AND r.ativo = 1
         LIMIT 1;

        IF v_exige_cat_calc IS NULL THEN
            SET v_exige_cat_calc = 0;
        END IF;

        IF v_exige_cat_calc = 0 AND p_competencia IS NOT NULL THEN
            SELECT IFNULL(s.exige_cat_default,0)
              INTO v_exige_cat_calc
              FROM sus_sigtap_procedimento s
             WHERE s.codigo = p_codigo_sigtap
               AND s.competencia = p_competencia
             LIMIT 1;
            IF v_exige_cat_calc IS NULL THEN
                SET v_exige_cat_calc = 0;
            END IF;
        END IF;

        IF p_competencia IS NOT NULL THEN
            SELECT IFNULL(s.exige_sinan_default,0)
              INTO v_exige_sinan_calc
              FROM sus_sigtap_procedimento s
             WHERE s.codigo = p_codigo_sigtap
               AND s.competencia = p_competencia
             LIMIT 1;
            IF v_exige_sinan_calc IS NULL THEN
                SET v_exige_sinan_calc = 0;
            END IF;
        END IF;
    END IF;

    INSERT INTO pedido_medico_item (
        id_pedido_medico, tipo_item, status,
        codigo_sigtap, competencia_sigtap,
        descricao, exige_cat, exige_sinan
    ) VALUES (
        p_id_pedido_medico,
        p_tipo_item,
        'PENDENTE',
        p_codigo_sigtap,
        p_competencia,
        p_descricao,
        CASE WHEN p_exige_cat IS NOT NULL THEN p_exige_cat ELSE v_exige_cat_calc END,
        CASE WHEN p_exige_sinan IS NOT NULL THEN p_exige_sinan ELSE v_exige_sinan_calc END
    );

    SET p_id_pedido_item = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'PEDIDO_MEDICO_ITEM_ADD', 'pedido_medico_item', p_id_pedido_item);

    COMMIT;
END ;;
```

