# sp_master_query_dispatcher

Objetivo: master query dispatcher conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_modulo | VARCHAR(50) | IN | |
| p_filtro | JSON | IN | |
| p_resultado | JSON | OUT | |
| p_sucesso | BOOLEAN | OUT | |
| p_mensagem | TEXT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: atendimento_evento, atendimento_triagem, ffa, paciente, sessao_usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- CONCAT
- IF
- IFNULL
- JSON_ARRAY
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW
- TIMESTAMPDIFF

## Views Utilizadas
- v_result_tmp
- v_sql_exec

## Eventos Gerados
- evento

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: SQL SECURITY INVOKER
- **Linha 10**: main: BEGIN
- **Linha 12** (Comentario): 1. Declarações
- **Linha 13**: Declaracao de variavel local v_id_usuario.
- **Linha 14**: Declaracao de variavel local v_id_unidade.
- **Linha 15**: Declaracao de variavel local v_sql.
- **Linha 17** (Comentario): Inicializa saída
- **Linha 18**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 19**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 20**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 22** (Comentario): 2. Validação de sessão
- **Linha 23**: execucao de query SELECT para consulta de dados.
- **Linha 24**: INTO v_id_usuario, v_id_unidade
- **Linha 25**: FROM sessao_usuario
- **Linha 26**: WHERE id_sessao_usuario = p_id_sessao
- **Linha 28**: LIMIT 1;
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 31**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 32**: Estrutura de repeticao/controle de loop.
- **Linha 33**: Estrutura condicional de controle de fluxo.
- **Linha 35** (Comentario): 3. Dispatch por módulo
- **Linha 36**: CASE p_modulo
- **Linha 38**: WHEN 'PACIENTE' THEN
- **Linha 39**: atribuicao de valor Ã  variavel v_sql.
- **Linha 40**: 'SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
- **Linha 41**: '  "id", p.id_paciente, ',
- **Linha 42**: '  "nome", p.nome, ',
- **Linha 43**: '  "cpf", p.cpf, ',
- **Linha 44**: '  "nascimento", p.data_nascimento',
- **Linha 45**: ')), JSON_ARRAY()) FROM paciente p WHERE 1=1 ',
- **Linha 46**: Estrutura condicional de controle de fluxo.
- **Linha 47**: CONCAT(' AND p.nome LIKE "%', JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.nome')),'%"'),''),
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 49**: CONCAT(' AND p.cpf="', JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.cpf')),'"'),'')
- **Linha 50**: );
- **Linha 52**: WHEN 'PACIENTE_TIMELINE' THEN
- **Linha 53**: atribuicao de valor Ã  variavel v_sql.
- **Linha 54**: 'SELECT JSON_OBJECT(',
- **Linha 55**: '  "id_ffa", f.id_ffa, ',
- **Linha 56**: '  "paciente", p.nome, ',
- **Linha 57**: '  "status_atual", f.contexto_fluxo, ',
- **Linha 58**: '  "abertura_ficha", f.criado_em, ',
- **Linha 59**: '  "triagem", (SELECT IFNULL(JSON_OBJECT(',
- **Linha 60**: '       "classificacao", t.classificacao_risco, ',
- **Linha 61**: '       "cor", t.cor_referencia, ',
- **Linha 62**: '       "pa", t.pressao_arterial, ',
- **Linha 63**: '       "temp", t.temperatura, ',
- **Linha 64**: '       "queixa", t.queixa_principal',
- **Linha 65**: '     ), JSON_OBJECT()) FROM atendimento_triagem t WHERE t.id_ffa=f.id_ffa LIMIT 1), ',
- **Linha 66**: '  "eventos", (SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
- **Linha 67**: '       "data", e.criado_em, ',
- **Linha 68**: '       "tipo", e.tipo_evento, ',
- **Linha 69**: '       "descricao", e.descricao',
- **Linha 70**: '     )), JSON_ARRAY()) FROM atendimento_evento e WHERE e.id_ffa=f.id_ffa)',
- **Linha 71**: ') FROM ffa f JOIN paciente p ON p.id_paciente=f.id_paciente ',
- **Linha 72**: 'WHERE f.id_ffa=', CAST(JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.id_ffa')) AS UNSIGNED)
- **Linha 73**: );
- **Linha 75**: WHEN 'TRIAGEM' THEN
- **Linha 76**: atribuicao de valor Ã  variavel v_sql.
- **Linha 77**: 'SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
- **Linha 78**: '  "id_ffa", f.id_ffa, ',
- **Linha 79**: '  "paciente", p.nome, ',
- **Linha 80**: '  "hora_chegada", f.criado_em, ',
- **Linha 81**: '  "tempo_espera_min", TIMESTAMPDIFF(MINUTE,f.criado_em,NOW())',
- **Linha 82**: ')), JSON_ARRAY()) FROM ffa f JOIN paciente p ON p.id_paciente=f.id_paciente ',
- **Linha 83**: 'WHERE f.contexto_fluxo="AGUARDANDO_TRIAGEM" AND f.id_unidade=', v_id_unidade
- **Linha 84**: );
- **Linha 86**: WHEN 'FILA_ESPERA' THEN
- **Linha 87**: atribuicao de valor Ã  variavel v_sql.
- **Linha 88**: 'SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
- **Linha 89**: '  "id_ffa", f.id_ffa, ',
- **Linha 90**: '  "paciente", p.nome, ',
- **Linha 91**: '  "status", f.contexto_fluxo, ',
- **Linha 92**: '  "espera_minutos", TIMESTAMPDIFF(MINUTE,f.criado_em,NOW())',
- **Linha 93**: ')), JSON_ARRAY()) FROM ffa f JOIN paciente p ON p.id_paciente=f.id_paciente ',
- **Linha 94**: 'WHERE f.id_unidade=', v_id_unidade,' AND f.ativo=1'
- **Linha 95**: );
- **Linha 97**: Estrutura condicional de controle de fluxo.
- **Linha 98**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 99**: Estrutura de repeticao/controle de loop.
- **Linha 100**: END CASE;
- **Linha 102** (Comentario): 4. Execução dinâmica
- **Linha 103**: SET @v_sql_exec = CONCAT(v_sql, ' INTO @v_result_tmp');
- **Linha 104**: PREPARE stmt FROM @v_sql_exec;
- **Linha 105**: EXECUTE stmt;
- **Linha 106**: DEALLOCATE PREPARE stmt;
- **Linha 108**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 109**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 110**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 112**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_query_dispatcher`(
    IN p_id_sessao BIGINT,
    IN p_modulo VARCHAR(50),
    IN p_filtro JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT
)
    SQL SECURITY INVOKER
main: BEGIN

    -- 1. Declarações
    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_sql TEXT;

    -- Inicializa saída
    SET p_sucesso = FALSE;
    SET p_resultado = JSON_ARRAY();
    SET p_mensagem = '';

    -- 2. Validação de sessão
    SELECT id_usuario, id_unidade
    INTO v_id_usuario, v_id_unidade
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao
      AND ativo = 1
    LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SET p_mensagem = 'SESSAO_INVALIDA_OU_EXPIRADA';
        LEAVE main;
    END IF;

    -- 3. Dispatch por módulo
    CASE p_modulo

        WHEN 'PACIENTE' THEN
            SET v_sql = CONCAT(
                'SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
                '  "id", p.id_paciente, ',
                '  "nome", p.nome, ',
                '  "cpf", p.cpf, ',
                '  "nascimento", p.data_nascimento',
                ')), JSON_ARRAY()) FROM paciente p WHERE 1=1 ',
                IF(JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.nome'))<>'null',
                   CONCAT(' AND p.nome LIKE "%', JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.nome')),'%"'),''),
                IF(JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.cpf'))<>'null',
                   CONCAT(' AND p.cpf="', JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.cpf')),'"'),'')
            );

        WHEN 'PACIENTE_TIMELINE' THEN
            SET v_sql = CONCAT(
                'SELECT JSON_OBJECT(',
                '  "id_ffa", f.id_ffa, ',
                '  "paciente", p.nome, ',
                '  "status_atual", f.contexto_fluxo, ',
                '  "abertura_ficha", f.criado_em, ',
                '  "triagem", (SELECT IFNULL(JSON_OBJECT(',
                '       "classificacao", t.classificacao_risco, ',
                '       "cor", t.cor_referencia, ',
                '       "pa", t.pressao_arterial, ',
                '       "temp", t.temperatura, ',
                '       "queixa", t.queixa_principal',
                '     ), JSON_OBJECT()) FROM atendimento_triagem t WHERE t.id_ffa=f.id_ffa LIMIT 1), ',
                '  "eventos", (SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
                '       "data", e.criado_em, ',
                '       "tipo", e.tipo_evento, ',
                '       "descricao", e.descricao',
                '     )), JSON_ARRAY()) FROM atendimento_evento e WHERE e.id_ffa=f.id_ffa)',
                ') FROM ffa f JOIN paciente p ON p.id_paciente=f.id_paciente ',
                'WHERE f.id_ffa=', CAST(JSON_UNQUOTE(JSON_EXTRACT(p_filtro,'$.id_ffa')) AS UNSIGNED)
            );

        WHEN 'TRIAGEM' THEN
            SET v_sql = CONCAT(
                'SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
                '  "id_ffa", f.id_ffa, ',
                '  "paciente", p.nome, ',
                '  "hora_chegada", f.criado_em, ',
                '  "tempo_espera_min", TIMESTAMPDIFF(MINUTE,f.criado_em,NOW())',
                ')), JSON_ARRAY()) FROM ffa f JOIN paciente p ON p.id_paciente=f.id_paciente ',
                'WHERE f.contexto_fluxo="AGUARDANDO_TRIAGEM" AND f.id_unidade=', v_id_unidade
            );

        WHEN 'FILA_ESPERA' THEN
            SET v_sql = CONCAT(
                'SELECT IFNULL(JSON_ARRAYAGG(JSON_OBJECT(',
                '  "id_ffa", f.id_ffa, ',
                '  "paciente", p.nome, ',
                '  "status", f.contexto_fluxo, ',
                '  "espera_minutos", TIMESTAMPDIFF(MINUTE,f.criado_em,NOW())',
                ')), JSON_ARRAY()) FROM ffa f JOIN paciente p ON p.id_paciente=f.id_paciente ',
                'WHERE f.id_unidade=', v_id_unidade,' AND f.ativo=1'
            );

        ELSE
            SET p_mensagem = 'MODULO_QUERY_INVALIDO';
            LEAVE main;
    END CASE;

    -- 4. Execução dinâmica
    SET @v_sql_exec = CONCAT(v_sql, ' INTO @v_result_tmp');
    PREPARE stmt FROM @v_sql_exec;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET p_resultado = IFNULL(@v_result_tmp, JSON_ARRAY());
    SET p_sucesso = TRUE;
    SET p_mensagem = 'QUERY_OK';

END ;;
```

