# sp_sessao_abrir

Objetivo: sessao abrir conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_token | TEXT | IN | |
| p_ip_acesso | VARCHAR(45) | IN | |
| p_user_agent | TEXT | IN | |
| p_expira_em | DATETIME | IN | |
| p_id_sessao_usuario | BIGINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: local_operacional, sistema, unidade, usuario
- INSERT: sessao_usuario
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar
- sp_raise

## Functions Utilizadas
- CONCAT
- IF
- LAST_INSERT_ID
- NOW

## Views Utilizadas
- (nenhuma)

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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: inicio do bloco de execucao.
- **Linha 13** (Comentario): valida FKs básicas (para erro mais claro do que 1452)
- **Linha 14**: Estrutura condicional de controle de fluxo.
- **Linha 15**: Invoca a procedure sp_raise.
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 18**: Estrutura condicional de controle de fluxo.
- **Linha 19**: Invoca a procedure sp_raise.
- **Linha 20**: Estrutura condicional de controle de fluxo.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 23**: Invoca a procedure sp_raise.
- **Linha 24**: Estrutura condicional de controle de fluxo.
- **Linha 26**: Estrutura condicional de controle de fluxo.
- **Linha 27**: Invoca a procedure sp_raise.
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 30**: Insere um novo registro na tabela sessao_usuario.
- **Linha 31**: (id_usuario, id_sistema, id_unidade, id_local_operacional, token, ip_acesso, user_agent, iniciado_em, expira_em, ativo)
- **Linha 32**: VALUES
- **Linha 33**: (p_id_usuario, p_id_sistema, p_id_unidade, p_id_local_operacional, p_token, p_ip_acesso, p_user_agent, NOW(), p_expira_em, 1);
- **Linha 35**: atribuicao de valor Ã  variavel p_id_sessao_usuario.
- **Linha 37**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 38**: p_id_sessao_usuario,
- **Linha 39**: 'sessao_usuario',
- **Linha 40**: p_id_sessao_usuario,
- **Linha 41**: 'SESSAO_ABERTA',
- **Linha 42**: CONCAT('Sessão aberta para usuario=', p_id_usuario, ' sistema=', p_id_sistema, ' unidade=', p_id_unidade, ' local=', p_id_local_operacional),
- **Linha 43**: p_id_usuario,
- **Linha 44**: 'sessao_usuario',
- **Linha 45**: p_id_usuario
- **Linha 46**: );
- **Linha 47**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_abrir`(
    IN  p_id_usuario          BIGINT,
    IN  p_id_sistema          BIGINT,
    IN  p_id_unidade          BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_token               TEXT,
    IN  p_ip_acesso           VARCHAR(45),
    IN  p_user_agent          TEXT,
    IN  p_expira_em           DATETIME,
    OUT p_id_sessao_usuario   BIGINT
)
BEGIN
    -- valida FKs básicas (para erro mais claro do que 1452)
    IF NOT EXISTS (SELECT 1 FROM usuario u WHERE u.id_usuario = p_id_usuario AND u.ativo = 1) THEN
        CALL sp_raise('USUARIO_INVALIDO', CONCAT('Usuário inexistente/inativo: ', p_id_usuario));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM sistema s WHERE s.id_sistema = p_id_sistema) THEN
        CALL sp_raise('SISTEMA_INVALIDO', CONCAT('Sistema inexistente: ', p_id_sistema));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM unidade un WHERE un.id_unidade = p_id_unidade) THEN
        CALL sp_raise('UNIDADE_INVALIDA', CONCAT('Unidade inexistente: ', p_id_unidade));
    END IF;

    IF NOT EXISTS (SELECT 1 FROM local_operacional lo WHERE lo.id_local_operacional = p_id_local_operacional) THEN
        CALL sp_raise('LOCAL_INVALIDO', CONCAT('Local operacional inexistente: ', p_id_local_operacional));
    END IF;

    INSERT INTO sessao_usuario
        (id_usuario, id_sistema, id_unidade, id_local_operacional, token, ip_acesso, user_agent, iniciado_em, expira_em, ativo)
    VALUES
        (p_id_usuario, p_id_sistema, p_id_unidade, p_id_local_operacional, p_token, p_ip_acesso, p_user_agent, NOW(), p_expira_em, 1);

    SET p_id_sessao_usuario = LAST_INSERT_ID();

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'sessao_usuario',
        p_id_sessao_usuario,
        'SESSAO_ABERTA',
        CONCAT('Sessão aberta para usuario=', p_id_usuario, ' sistema=', p_id_sistema, ' unidade=', p_id_unidade, ' local=', p_id_local_operacional),
        p_id_usuario,
        'sessao_usuario',
        p_id_usuario
    );
END ;;
```

