# sp_master_registrar_erro

Objetivo: master registrar erro conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_erro_catalogo | BIGINT | IN | |
| p_dominio | VARCHAR(50) | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_mensagem_erro | TEXT | IN | |
| p_stack_trace | JSON | IN | |
| p_payload_tentativa | JSON | IN | |
| p_uuid_transacao | CHAR(36) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: erro_evento
- INSERT: erro_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- IFNULL
- NOW
- UUID

## Views Utilizadas
- (nenhuma)

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
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: SQL SECURITY INVOKER
- **Linha 12**: main: BEGIN
- **Linha 13**: Declaracao de variavel local v_id_erro.
- **Linha 15** (Comentario): 1️⃣ Idempotência: verifica se já existe o registro com esse UUID
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 17**: execucao de query SELECT para consulta de dados.
- **Linha 18**: FROM erro_evento
- **Linha 19**: WHERE uuid_transacao = p_uuid_transacao
- **Linha 20**: LIMIT 1;
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 23** (Comentario): Já existe, sai sem inserir
- **Linha 24**: Estrutura de repeticao/controle de loop.
- **Linha 25**: Estrutura condicional de controle de fluxo.
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 28** (Comentario): 2️⃣ Inserção do evento de erro
- **Linha 29**: Insere um novo registro na tabela erro_evento.
- **Linha 30**: id_sessao_usuario,
- **Linha 31**: id_erro_catalogo,
- **Linha 32**: dominio,
- **Linha 33**: acao,
- **Linha 34**: mensagem_erro,
- **Linha 35**: stack_trace,
- **Linha 36**: payload_tentativa,
- **Linha 37**: uuid_transacao,
- **Linha 38**: criado_em
- **Linha 39**: ) VALUES (
- **Linha 40**: p_id_sessao,
- **Linha 41**: p_id_erro_catalogo,
- **Linha 42**: p_dominio,
- **Linha 43**: p_acao,
- **Linha 44**: p_mensagem_erro,
- **Linha 45**: p_stack_trace,
- **Linha 46**: p_payload_tentativa,
- **Linha 47**: Estrutura condicional de controle de fluxo.
- **Linha 48**: NOW(6)
- **Linha 49**: );
- **Linha 51**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_master_registrar_erro`(
    IN p_id_sessao BIGINT,
    IN p_id_erro_catalogo BIGINT,
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_mensagem_erro TEXT,
    IN p_stack_trace JSON,
    IN p_payload_tentativa JSON,
    IN p_uuid_transacao CHAR(36)
)
    SQL SECURITY INVOKER
main: BEGIN
    DECLARE v_id_erro BIGINT;

    -- 1️⃣ Idempotência: verifica se já existe o registro com esse UUID
    IF p_uuid_transacao IS NOT NULL THEN
        SELECT id_erro INTO v_id_erro
        FROM erro_evento
        WHERE uuid_transacao = p_uuid_transacao
        LIMIT 1;

        IF v_id_erro IS NOT NULL THEN
            -- Já existe, sai sem inserir
            LEAVE main;
        END IF;
    END IF;

    -- 2️⃣ Inserção do evento de erro
    INSERT INTO erro_evento (
        id_sessao_usuario,
        id_erro_catalogo,
        dominio,
        acao,
        mensagem_erro,
        stack_trace,
        payload_tentativa,
        uuid_transacao,
        criado_em
    ) VALUES (
        p_id_sessao,
        p_id_erro_catalogo,
        p_dominio,
        p_acao,
        p_mensagem_erro,
        p_stack_trace,
        p_payload_tentativa,
        IFNULL(p_uuid_transacao, UUID()),
        NOW(6)
    );

END ;;
```

