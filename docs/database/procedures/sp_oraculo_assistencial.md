# sp_oraculo_assistencial

Objetivo: oraculo assistencial conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_runtime_device_id | VARCHAR(100) | IN | |
| p_dominio_fluxo | VARCHAR(50) | IN | |
| p_hash_snapshot | CHAR(64) | IN | |
| p_versao_protocolo | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: runtime_estado_sobrevivencia
- INSERT: atendimento_evento_ledger
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- JSON_OBJECT
- NOW

## Views Utilizadas
- v_modo
- v_status

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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local v_modo.
- **Linha 11**: Declaracao de variavel local v_status.
- **Linha 13**: execucao de query SELECT para consulta de dados.
- **Linha 14**: INTO v_modo
- **Linha 15**: FROM runtime_estado_sobrevivencia
- **Linha 16**: WHERE runtime_device_id = p_runtime_device_id;
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: atribuicao de valor Ã  variavel v_modo.
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 23**: atribuicao de valor Ã  variavel v_status.
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 26**: atribuicao de valor Ã  variavel v_status.
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 29**: atribuicao de valor Ã  variavel v_status.
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 32**: Insere um novo registro na tabela atendimento_evento_ledger.
- **Linha 33**: id_sessao_usuario,
- **Linha 34**: dominio_evento,
- **Linha 35**: codigo_evento,
- **Linha 36**: payload_evento
- **Linha 37**: fechamento da lista de Parametros.
- **Linha 38**: VALUES (
- **Linha 39**: NULL,
- **Linha 40**: 'ORACULO_ASSISTENCIAL',
- **Linha 41**: v_status,
- **Linha 42**: JSON_OBJECT(
- **Linha 43**: 'runtime_device', p_runtime_device_id,
- **Linha 44**: 'dominio_fluxo', p_dominio_fluxo,
- **Linha 45**: 'versao_protocolo', p_versao_protocolo,
- **Linha 46**: 'timestamp', NOW(6)
- **Linha 47**: fechamento da lista de Parametros.
- **Linha 48**: );
- **Linha 50**: execucao de query SELECT para consulta de dados.
- **Linha 52**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_oraculo_assistencial`(
    IN p_runtime_device_id VARCHAR(100),
    IN p_dominio_fluxo VARCHAR(50),
    IN p_hash_snapshot CHAR(64),
    IN p_versao_protocolo BIGINT
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_modo VARCHAR(50);
    DECLARE v_status VARCHAR(50);

    SELECT modo_operacao
    INTO v_modo
    FROM runtime_estado_sobrevivencia
    WHERE runtime_device_id = p_runtime_device_id;

    IF v_modo IS NULL THEN
        SET v_modo = 'NORMAL';
    END IF;

    IF v_modo = 'BLOQUEIO_SEGURANCA' THEN
        SET v_status = 'BLOQUEAR';

    ELSEIF p_hash_snapshot IS NULL THEN
        SET v_status = 'DEGRADAR_MODE';

    ELSE
        SET v_status = 'PERMITIR';
    END IF;

    INSERT INTO atendimento_evento_ledger (
        id_sessao_usuario,
        dominio_evento,
        codigo_evento,
        payload_evento
    )
    VALUES (
        NULL,
        'ORACULO_ASSISTENCIAL',
        v_status,
        JSON_OBJECT(
            'runtime_device', p_runtime_device_id,
            'dominio_fluxo', p_dominio_fluxo,
            'versao_protocolo', p_versao_protocolo,
            'timestamp', NOW(6)
        )
    );

    SELECT v_status AS oraculo_decisao;

END ;;
```

