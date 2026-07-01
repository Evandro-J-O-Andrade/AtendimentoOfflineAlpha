# sp_worker_atendimento

Objetivo: worker atendimento conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_queue | BIGINT | IN | |
| p_uuid_execution | CHAR(36) | IN | |
| p_id_tenant | BIGINT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_payload | JSON | IN | |
| p_resultado | JSON | OUT | |
| p_sucesso | BOOLEAN | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: atendimento, runtime_execution_queue
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- NOW

## Views Utilizadas
- v_acao

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
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: inicio do bloco de execucao.
- **Linha 12**: Declaracao de variavel local v_id.
- **Linha 13**: Declaracao de variavel local v_acao.
- **Linha 15**: atribuicao de valor Ã  variavel v_id.
- **Linha 16**: atribuicao de valor Ã  variavel v_acao.
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 20**: UPDATE atendimento
- **Linha 21**: atribuicao de valor Ã  variavel status.
- **Linha 22**: updated_at=NOW(6)
- **Linha 23**: WHERE id_atendimento=v_id;
- **Linha 25**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 26**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 30**: UPDATE atendimento
- **Linha 31**: atribuicao de valor Ã  variavel status.
- **Linha 32**: updated_at=NOW(6)
- **Linha 33**: WHERE id_atendimento=v_id;
- **Linha 35**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 36**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 39**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 40**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 43**: UPDATE runtime_execution_queue
- **Linha 44**: atribuicao de valor Ã  variavel status.
- **Linha 45**: finished_at=NOW(6),
- **Linha 46**: result_payload=p_resultado
- **Linha 47**: WHERE id_queue=p_id_queue;
- **Linha 49**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_worker_atendimento`(
    IN p_id_queue BIGINT,
    IN p_uuid_execution CHAR(36),
    IN p_id_tenant BIGINT,
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_payload JSON,
    OUT p_resultado JSON,
    OUT p_sucesso BOOLEAN
)
BEGIN
    DECLARE v_id BIGINT;
    DECLARE v_acao VARCHAR(50);

    SET v_id = JSON_UNQUOTE(JSON_EXTRACT(p_payload,'$.id_atendimento'));
    SET v_acao = JSON_UNQUOTE(JSON_EXTRACT(p_payload,'$.acao'));

    IF v_acao = 'INICIAR' THEN

        UPDATE atendimento
        SET status='EM_ANDAMENTO',
            updated_at=NOW(6)
        WHERE id_atendimento=v_id;

        SET p_resultado=JSON_OBJECT('status','INICIADO');
        SET p_sucesso=TRUE;

    ELSEIF v_acao='TRANSICIONAR' THEN

        UPDATE atendimento
        SET status=JSON_UNQUOTE(JSON_EXTRACT(p_payload,'$.novo_status')),
            updated_at=NOW(6)
        WHERE id_atendimento=v_id;

        SET p_resultado=JSON_OBJECT('status','TRANSICIONADO');
        SET p_sucesso=TRUE;

    ELSE
        SET p_resultado=JSON_OBJECT('erro','ACAO_DESCONHECIDA');
        SET p_sucesso=FALSE;
    END IF;

    UPDATE runtime_execution_queue
    SET status=IF(p_sucesso,'CONCLUIDO','FALHOU'),
        finished_at=NOW(6),
        result_payload=p_resultado
    WHERE id_queue=p_id_queue;

END ;;
```

