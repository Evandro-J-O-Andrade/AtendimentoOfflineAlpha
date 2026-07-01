# sp_kernel_writer_lock

Objetivo: kernel writer lock conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_uuid_runtime | CHAR(36) | IN | |
| p_lock_id | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: runtime_kernel_locks
- INSERT: runtime_kernel_locks
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COUNT
- DATE_ADD
- IF
- LAST_INSERT_ID
- NOW
- SIGNAL

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

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
- **Linha 5**: inicio do bloco de execucao.
- **Linha 6**: Declaracao de variavel local v_lock_exists.
- **Linha 8**: execucao de query SELECT para consulta de dados.
- **Linha 9**: INTO v_lock_exists
- **Linha 10**: FROM runtime_kernel_locks
- **Linha 11**: WHERE uuid_runtime = p_uuid_runtime
- **Linha 14**: Estrutura condicional de controle de fluxo.
- **Linha 15**: SIGNAL SQLSTATE '45000'
- **Linha 16**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 19**: Insere um novo registro na tabela runtime_kernel_locks.
- **Linha 20**: (uuid_runtime,locked_by,acquired_at,expires_at)
- **Linha 21**: VALUES
- **Linha 22**: (p_uuid_runtime,CONNECTION_ID(),
- **Linha 23**: NOW(6),
- **Linha 24**: DATE_ADD(NOW(6),INTERVAL 60 SECOND));
- **Linha 26**: atribuicao de valor Ã  variavel p_lock_id.
- **Linha 27**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_kernel_writer_lock`(
    IN p_uuid_runtime CHAR(36),
    OUT p_lock_id BIGINT
)
BEGIN
    DECLARE v_lock_exists INT;

    SELECT COUNT(*)
    INTO v_lock_exists
    FROM runtime_kernel_locks
    WHERE uuid_runtime = p_uuid_runtime
      AND expires_at > NOW(6);

    IF v_lock_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='RUNTIME_LOCK_ALREADY_HELD';
    END IF;

    INSERT INTO runtime_kernel_locks
    (uuid_runtime,locked_by,acquired_at,expires_at)
    VALUES
    (p_uuid_runtime,CONNECTION_ID(),
     NOW(6),
     DATE_ADD(NOW(6),INTERVAL 60 SECOND));

    SET p_lock_id = LAST_INSERT_ID();
END ;;
```

