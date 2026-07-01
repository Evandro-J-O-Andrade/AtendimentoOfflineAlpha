# sp_reconciliar_runtime

Objetivo: reconciliar runtime conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_uuid_evento | CHAR(36) | IN | |
| p_hash | CHAR(64) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: runtime_sync_log
- INSERT: (nenhuma)
- UPDATE: runtime_sync_log
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- SIGNAL

## Views Utilizadas
- v_hash

## Eventos Gerados
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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_hash.
- **Linha 10**: execucao de query SELECT para consulta de dados.
- **Linha 11**: INTO v_hash
- **Linha 12**: FROM runtime_sync_log
- **Linha 13**: WHERE uuid_evento = p_uuid_evento
- **Linha 14**: LIMIT 1;
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 17**: SIGNAL SQLSTATE '45000'
- **Linha 18**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 21**: UPDATE runtime_sync_log
- **Linha 22**: atribuicao de valor Ã  variavel sincronizado.
- **Linha 23**: WHERE uuid_evento = p_uuid_evento;
- **Linha 25**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reconciliar_runtime`(
    IN p_uuid_evento CHAR(36),
    IN p_hash CHAR(64)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_hash CHAR(64);

    SELECT hash_payload
    INTO v_hash
    FROM runtime_sync_log
    WHERE uuid_evento = p_uuid_evento
    LIMIT 1;

    IF v_hash <> p_hash THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inconsistencia deterministica detectada';
    END IF;

    UPDATE runtime_sync_log
    SET sincronizado = TRUE
    WHERE uuid_evento = p_uuid_evento;

END ;;
```

