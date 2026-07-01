# sp_motor_manchester_runtime

Objetivo: motor manchester runtime conforme definida no dump SQL do sistema.

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
- SELECT: fluxo_transicao_matriz
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- JSON_EXTRACT
- JSON_UNQUOTE
- NOW
- TIMESTAMPDIFF

## Views Utilizadas
- v_now

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
- **Linha 2**: main: BEGIN
- **Linha 4**: Declaracao de variavel local v_now.
- **Linha 5**: atribuicao de valor Ã  variavel v_now.
- **Linha 7** (Comentario): =========================================
- **Linha 8** (Comentario): 1. ATUALIZA RISCO DINÂMICO (COM COLLATE)
- **Linha 9** (Comentario): =========================================
- **Linha 10**: UPDATE senha s
- **Linha 11**: JOIN fluxo_transicao_matriz f
- **Linha 12**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 15**: SET
- **Linha 16**: s.risco_dinamico = JSON_UNQUOTE(
- **Linha 17**: JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante')
- **Linha 18**: ),
- **Linha 19**: s.risco_dinamico_em = v_now,
- **Linha 20**: s.risco_dinamico_origem = 'SISTEMA'
- **Linha 21**: WHERE
- **Linha 22**: s.executado_em IS NULL
- **Linha 27**: MINUTE,
- **Linha 28**: s.criado_em,
- **Linha 29**: v_now
- **Linha 30**: ) >= JSON_EXTRACT(f.condicao_validacao, '$.tempo_max')
- **Linha 32**: s.risco_dinamico IS NULL
- **Linha 34**: JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante')
- **Linha 35**: fechamento da lista de Parametros.
- **Linha 36**: );
- **Linha 38** (Comentario): =========================================
- **Linha 39** (Comentario): 2. REPRIORIZAÇÃO INTELIGENTE
- **Linha 40** (Comentario): =========================================
- **Linha 41**: UPDATE senha
- **Linha 42**: atribuicao de valor Ã  variavel prioridade.
- **Linha 43**: CASE risco_dinamico
- **Linha 44**: WHEN 'VERMELHO' THEN 100
- **Linha 45**: WHEN 'LARANJA' THEN 80
- **Linha 46**: WHEN 'AMARELO' THEN 50
- **Linha 47**: WHEN 'VERDE' THEN 10
- **Linha 48**: Estrutura condicional de controle de fluxo.
- **Linha 49**: END
- **Linha 50**: WHERE
- **Linha 51**: executado_em IS NULL
- **Linha 56**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_motor_manchester_runtime`()
main: BEGIN

    DECLARE v_now DATETIME(6);
    SET v_now = NOW(6);

    -- =========================================
    -- 1. ATUALIZA RISCO DINÂMICO (COM COLLATE)
    -- =========================================
    UPDATE senha s
    JOIN fluxo_transicao_matriz f
      ON f.estado_origem COLLATE utf8mb4_0900_ai_ci = s.contexto_fluxo
     AND f.dominio_fluxo = 'FILA'
     AND f.ativo = 1
    SET
        s.risco_dinamico = JSON_UNQUOTE(
            JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante')
        ),
        s.risco_dinamico_em = v_now,
        s.risco_dinamico_origem = 'SISTEMA'
    WHERE
        s.executado_em IS NULL
        AND s.cancelado = 0
        AND s.nao_compareceu = 0
        AND JSON_EXTRACT(f.condicao_validacao, '$.tempo_max') IS NOT NULL
        AND TIMESTAMPDIFF(
            MINUTE,
            s.criado_em,
            v_now
        ) >= JSON_EXTRACT(f.condicao_validacao, '$.tempo_max')
        AND (
            s.risco_dinamico IS NULL
            OR s.risco_dinamico != JSON_UNQUOTE(
                JSON_EXTRACT(f.condicao_validacao, '$.risco_resultante')
            )
        );

    -- =========================================
    -- 2. REPRIORIZAÇÃO INTELIGENTE
    -- =========================================
    UPDATE senha
    SET prioridade =
        CASE risco_dinamico
            WHEN 'VERMELHO' THEN 100
            WHEN 'LARANJA' THEN 80
            WHEN 'AMARELO' THEN 50
            WHEN 'VERDE' THEN 10
            ELSE prioridade
        END
    WHERE
        executado_em IS NULL
        AND cancelado = 0
        AND nao_compareceu = 0
        AND risco_dinamico IS NOT NULL;

END ;;
```

