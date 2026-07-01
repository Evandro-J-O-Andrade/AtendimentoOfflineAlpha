# sp_fluxo_executor_matriz

Objetivo: fluxo executor matriz conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_estado_atual | VARCHAR(60) | IN | |
| p_evento | VARCHAR(60) | IN | |
| p_id_perfil | BIGINT | IN | |
| p_contexto | VARCHAR(50) | IN | |
| p_id_sistema | BIGINT | IN | |
| p_id_sessao_usuario | BIGINT | IN | |
| p_estado_destino | VARCHAR(60) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fluxo_transicao_matriz
- INSERT: auditoria_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- IF
- SIGNAL

## Views Utilizadas
- v_destino

## Eventos Gerados
- auditoria_evento
- evento

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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: SQL SECURITY INVOKER
- **Linha 11**: inicio do bloco de execucao.
- **Linha 13**: Declaracao de variavel local v_destino.
- **Linha 15**: /* ===============================
- **Linha 16**: Consulta determinística da matriz
- **Linha 17**: =============================== */
- **Linha 19**: execucao de query SELECT para consulta de dados.
- **Linha 20**: INTO v_destino
- **Linha 21**: FROM fluxo_transicao_matriz ftd
- **Linha 22**: WHERE ftd.estado_origem = p_estado_atual
- **Linha 28**: ORDER BY ftd.prioridade DESC
- **Linha 29**: LIMIT 1;
- **Linha 31**: Estrutura condicional de controle de fluxo.
- **Linha 33**: Insere um novo registro na tabela auditoria_evento.
- **Linha 34**: id_sessao_usuario,
- **Linha 35**: evento,
- **Linha 36**: sucesso,
- **Linha 37**: descricao
- **Linha 38**: fechamento da lista de Parametros.
- **Linha 39**: VALUES(
- **Linha 40**: p_id_sessao_usuario,
- **Linha 41**: 'TRANSICAO_BLOQUEADA',
- **Linha 42**: 0,
- **Linha 43**: CONCAT(
- **Linha 44**: 'Origem=',p_estado_atual,
- **Linha 45**: '|Evento=',p_evento,
- **Linha 46**: '|Perfil=',p_id_perfil
- **Linha 47**: fechamento da lista de Parametros.
- **Linha 48**: );
- **Linha 50**: SIGNAL SQLSTATE '45000'
- **Linha 51**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 53**: Estrutura condicional de controle de fluxo.
- **Linha 55**: atribuicao de valor Ã  variavel p_estado_destino.
- **Linha 57**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_executor_matriz`(
    IN p_estado_atual VARCHAR(60),
    IN p_evento VARCHAR(60),
    IN p_id_perfil BIGINT,
    IN p_contexto VARCHAR(50),
    IN p_id_sistema BIGINT,
    IN p_id_sessao_usuario BIGINT,
    OUT p_estado_destino VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_destino VARCHAR(60);

    /* ===============================
       Consulta determinística da matriz
    =============================== */

    SELECT ftd.estado_destino
    INTO v_destino
    FROM fluxo_transicao_matriz ftd
    WHERE ftd.estado_origem = p_estado_atual
      AND ftd.evento = p_evento
      AND ftd.id_perfil = p_id_perfil
      AND ftd.contexto = p_contexto
      AND ftd.id_sistema = p_id_sistema
      AND ftd.ativo = 1
    ORDER BY ftd.prioridade DESC
    LIMIT 1;

    IF v_destino IS NULL THEN

        INSERT INTO auditoria_evento(
            id_sessao_usuario,
            evento,
            sucesso,
            descricao
        )
        VALUES(
            p_id_sessao_usuario,
            'TRANSICAO_BLOQUEADA',
            0,
            CONCAT(
                'Origem=',p_estado_atual,
                '|Evento=',p_evento,
                '|Perfil=',p_id_perfil
            )
        );

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transição inválida pela matriz de fluxo';

    END IF;

    SET p_estado_destino = v_destino;

END ;;
```

