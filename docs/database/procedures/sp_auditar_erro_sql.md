# sp_auditar_erro_sql

Objetivo: auditar erro sql conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_rotina | VARCHAR(128) | IN | |
| p_contexto | VARCHAR(4000) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: information_schema
- INSERT: auditoria_erro, auditoria_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CAST
- CONCAT
- IF
- IFNULL
- LOG
- NOW

## Views Utilizadas
- v_sqlstate

## Eventos Gerados
- auditoria_evento
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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Declaracao de variavel local v_sqlstate.
- **Linha 8**: Declaracao de variavel local v_errno.
- **Linha 9**: Declaracao de variavel local v_msg.
- **Linha 11** (Comentario): Preferir variáveis populadas pelo EXIT HANDLER da rotina chamadora
- **Linha 12**: Estrutura condicional de controle de fluxo.
- **Linha 13**: atribuicao de valor Ã  variavel v_sqlstate.
- **Linha 14**: Estrutura condicional de controle de fluxo.
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 17**: atribuicao de valor Ã  variavel v_errno.
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 21**: atribuicao de valor Ã  variavel v_msg.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 24** (Comentario): Limpa para não vazar para próximas chamadas
- **Linha 25**: SET @diag_sqlstate = NULL;
- **Linha 26**: SET @diag_errno    = NULL;
- **Linha 27**: SET @diag_msg      = NULL;
- **Linha 29** (Comentario): Log dedicado (não pode falhar por FK)
- **Linha 30**: Insere um novo registro na tabela auditoria_erro.
- **Linha 31**: id_sessao_usuario,
- **Linha 32**: rotina,
- **Linha 33**: `sqlstate`,
- **Linha 34**: `errno`,
- **Linha 35**: mensagem,
- **Linha 36**: contexto,
- **Linha 37**: criado_em
- **Linha 38**: ) VALUES (
- **Linha 39**: p_id_sessao_usuario,
- **Linha 40**: p_rotina,
- **Linha 41**: Estrutura condicional de controle de fluxo.
- **Linha 42**: Estrutura condicional de controle de fluxo.
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 44**: p_contexto,
- **Linha 45**: NOW()
- **Linha 46**: );
- **Linha 48** (Comentario): Log genérico em auditoria_evento, se existir (mantém trilha transversal)
- **Linha 49**: Estrutura condicional de controle de fluxo.
- **Linha 50**: execucao de query SELECT para consulta de dados.
- **Linha 51**: FROM information_schema.tables
- **Linha 52**: WHERE table_schema = DATABASE()
- **Linha 54**: ) THEN
- **Linha 55**: Insere um novo registro na tabela auditoria_evento.
- **Linha 56**: id_sessao_usuario,
- **Linha 57**: entidade,
- **Linha 58**: id_entidade,
- **Linha 59**: acao,
- **Linha 60**: detalhe,
- **Linha 61**: criado_em
- **Linha 62**: ) VALUES (
- **Linha 63**: p_id_sessao_usuario,
- **Linha 64**: 'SQL',
- **Linha 65**: NULL,
- **Linha 66**: 'ERRO_SQL',
- **Linha 67**: CONCAT(
- **Linha 68**: 'ROTINA=', IFNULL(p_rotina,'(n/a)'),
- **Linha 69**: ' | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
- **Linha 70**: ' | ERRNO=', IFNULL(v_errno,0),
- **Linha 71**: ' | MSG=', IFNULL(v_msg,'(n/a)'),
- **Linha 72**: ' | CTX=', IFNULL(p_contexto,'(n/a)')
- **Linha 73**: ),
- **Linha 74**: NOW()
- **Linha 75**: );
- **Linha 76**: Estrutura condicional de controle de fluxo.
- **Linha 77**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditar_erro_sql`(
    IN p_id_sessao_usuario BIGINT,
    IN p_rotina VARCHAR(128),
    IN p_contexto VARCHAR(4000)
)
BEGIN
    DECLARE v_sqlstate VARCHAR(10) DEFAULT NULL;
    DECLARE v_errno INT DEFAULT NULL;
    DECLARE v_msg TEXT DEFAULT NULL;

    -- Preferir variáveis populadas pelo EXIT HANDLER da rotina chamadora
    IF @diag_sqlstate IS NOT NULL AND @diag_sqlstate <> '' THEN
        SET v_sqlstate = @diag_sqlstate;
    END IF;

    IF @diag_errno IS NOT NULL AND @diag_errno <> 0 THEN
        SET v_errno = CAST(@diag_errno AS SIGNED);
    END IF;

    IF @diag_msg IS NOT NULL AND @diag_msg <> '' THEN
        SET v_msg = @diag_msg;
    END IF;

    -- Limpa para não vazar para próximas chamadas
    SET @diag_sqlstate = NULL;
    SET @diag_errno    = NULL;
    SET @diag_msg      = NULL;

    -- Log dedicado (não pode falhar por FK)
    INSERT INTO auditoria_erro(
        id_sessao_usuario,
        rotina,
        `sqlstate`,
        `errno`,
        mensagem,
        contexto,
        criado_em
    ) VALUES (
        p_id_sessao_usuario,
        p_rotina,
        IFNULL(v_sqlstate,'(n/a)'),
        IFNULL(v_errno,0),
        IFNULL(v_msg,'(n/a)'),
        p_contexto,
        NOW()
    );

    -- Log genérico em auditoria_evento, se existir (mantém trilha transversal)
    IF EXISTS (
        SELECT 1
          FROM information_schema.tables
         WHERE table_schema = DATABASE()
           AND table_name = 'auditoria_evento'
    ) THEN
        INSERT INTO auditoria_evento(
            id_sessao_usuario,
            entidade,
            id_entidade,
            acao,
            detalhe,
            criado_em
        ) VALUES (
            p_id_sessao_usuario,
            'SQL',
            NULL,
            'ERRO_SQL',
            CONCAT(
                'ROTINA=', IFNULL(p_rotina,'(n/a)'),
                ' | SQLSTATE=', IFNULL(v_sqlstate,'(n/a)'),
                ' | ERRNO=', IFNULL(v_errno,0),
                ' | MSG=', IFNULL(v_msg,'(n/a)'),
                ' | CTX=', IFNULL(p_contexto,'(n/a)')
            ),
            NOW()
        );
    END IF;
END ;;
```

