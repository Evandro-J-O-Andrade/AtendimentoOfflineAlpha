# sp_runtime_escudo_total

Objetivo: runtime escudo total conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_runtime_device_id | VARCHAR(100) | IN | |
| p_hash_snapshot | CHAR(64) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: runtime_estado_sobrevivencia
- INSERT: runtime_estado_sobrevivencia
- UPDATE: runtime_estado_sobrevivencia
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- NOW

## Views Utilizadas
- v_modo

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_modo.
- **Linha 10**: execucao de query SELECT para consulta de dados.
- **Linha 11**: INTO v_modo
- **Linha 12**: FROM runtime_estado_sobrevivencia
- **Linha 13**: WHERE runtime_device_id = p_runtime_device_id;
- **Linha 15**: Estrutura condicional de controle de fluxo.
- **Linha 17**: Insere um novo registro na tabela runtime_estado_sobrevivencia.
- **Linha 18**: runtime_device_id,
- **Linha 19**: modo_operacao,
- **Linha 20**: hash_snapshot_runtime
- **Linha 21**: fechamento da lista de Parametros.
- **Linha 22**: VALUES (
- **Linha 23**: p_runtime_device_id,
- **Linha 24**: 'NORMAL',
- **Linha 25**: p_hash_snapshot
- **Linha 26**: );
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 30**: UPDATE runtime_estado_sobrevivencia
- **Linha 31**: atribuicao de valor Ã  variavel hash_snapshot_runtime.
- **Linha 32**: ultima_sincronizacao = NOW(6)
- **Linha 33**: WHERE runtime_device_id = p_runtime_device_id;
- **Linha 35**: Estrutura condicional de controle de fluxo.
- **Linha 37**: execucao de query SELECT para consulta de dados.
- **Linha 39**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_runtime_escudo_total`(
    IN p_runtime_device_id VARCHAR(100),
    IN p_hash_snapshot CHAR(64)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_modo VARCHAR(50);

    SELECT modo_operacao
    INTO v_modo
    FROM runtime_estado_sobrevivencia
    WHERE runtime_device_id = p_runtime_device_id;

    IF v_modo IS NULL THEN

        INSERT INTO runtime_estado_sobrevivencia (
            runtime_device_id,
            modo_operacao,
            hash_snapshot_runtime
        )
        VALUES (
            p_runtime_device_id,
            'NORMAL',
            p_hash_snapshot
        );

    ELSE

        UPDATE runtime_estado_sobrevivencia
        SET hash_snapshot_runtime = p_hash_snapshot,
            ultima_sincronizacao = NOW(6)
        WHERE runtime_device_id = p_runtime_device_id;

    END IF;

    SELECT 'ESCUDO_TOTAL_ATIVO' AS status_escudo;

END ;;
```

