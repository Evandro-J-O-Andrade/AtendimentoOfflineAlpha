# sp_ledger_evento_log

Objetivo: ledger evento log conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_uuid_transacao | CHAR(36) | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_estado_origem | VARCHAR(50) | IN | |
| p_estado_destino | VARCHAR(50) | IN | |
| p_payload | JSON | IN | |
| p_status | VARCHAR(20) | IN | |
| p_mensagem | VARCHAR(500) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: atendimento_evento_ledger
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- NOW

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- evento
- ledger_evento

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
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: inicio do bloco de execucao.
- **Linha 13**: Insere um novo registro na tabela atendimento_evento_ledger.
- **Linha 14**: uuid_transacao, id_usuario, id_perfil, acao,
- **Linha 15**: estado_origem, estado_destino, payload,
- **Linha 16**: status_evento, mensagem, created_at
- **Linha 17**: ) VALUES (
- **Linha 18**: p_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
- **Linha 19**: p_estado_origem, p_estado_destino, p_payload,
- **Linha 20**: p_status, p_mensagem, NOW(6)
- **Linha 21**: );
- **Linha 22**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ledger_evento_log`(
    IN p_uuid_transacao CHAR(36),
    IN p_id_usuario BIGINT,
    IN p_id_perfil BIGINT,
    IN p_acao VARCHAR(100),
    IN p_estado_origem VARCHAR(50),
    IN p_estado_destino VARCHAR(50),
    IN p_payload JSON,
    IN p_status VARCHAR(20),
    IN p_mensagem VARCHAR(500)
)
BEGIN
    INSERT INTO atendimento_evento_ledger (
        uuid_transacao, id_usuario, id_perfil, acao,
        estado_origem, estado_destino, payload,
        status_evento, mensagem, created_at
    ) VALUES (
        p_uuid_transacao, p_id_usuario, p_id_perfil, p_acao,
        p_estado_origem, p_estado_destino, p_payload,
        p_status, p_mensagem, NOW(6)
    );
END ;;
```

