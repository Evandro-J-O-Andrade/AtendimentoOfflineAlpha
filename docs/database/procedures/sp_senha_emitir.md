# sp_senha_emitir

Objetivo: senha emitir conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_tipo_atendimento | VARCHAR(20) | IN | |
| p_origem | VARCHAR(20) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: senha
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- NOW

## Views Utilizadas
- (nenhuma)

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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 9**: Declaracao de variavel local v_id_usuario.
- **Linha 10**: Declaracao de variavel local v_id_unidade.
- **Linha 11**: Declaracao de variavel local v_id_local.
- **Linha 13** (Comentario): 1️⃣ Validar sessão (lei do core)
- **Linha 14**: Invoca a procedure sp_sessao_assert.
- **Linha 16** (Comentario): 2️⃣ Obter contexto
- **Linha 17**: execucao de query SELECT para consulta de dados.
- **Linha 18**: INTO v_id_usuario, v_id_unidade, v_id_local
- **Linha 19**: FROM sessao_usuario
- **Linha 20**: WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 22** (Comentario): 3️⃣ Inserir na entidade fundadora
- **Linha 23**: Insere um novo registro na tabela senha.
- **Linha 24**: codigo,
- **Linha 25**: tipo_atendimento,
- **Linha 26**: origem,
- **Linha 27**: id_unidade,
- **Linha 28**: id_local_operacional,
- **Linha 29**: status,
- **Linha 30**: criado_em
- **Linha 31**: fechamento da lista de Parametros.
- **Linha 32**: VALUES (
- **Linha 33**: NULL,
- **Linha 34**: p_tipo_atendimento,
- **Linha 35**: p_origem,
- **Linha 36**: v_id_unidade,
- **Linha 37**: v_id_local,
- **Linha 38**: 'AGUARDANDO',
- **Linha 39**: NOW(6)
- **Linha 40**: );
- **Linha 42**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_emitir`(
    IN p_id_sessao_usuario BIGINT,
    IN p_tipo_atendimento  VARCHAR(20),
    IN p_origem            VARCHAR(20)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_id_usuario BIGINT;
    DECLARE v_id_unidade BIGINT;
    DECLARE v_id_local   BIGINT;

    -- 1️⃣ Validar sessão (lei do core)
    CALL sp_sessao_assert(p_id_sessao_usuario);

    -- 2️⃣ Obter contexto
    SELECT id_usuario, id_unidade, id_local
    INTO v_id_usuario, v_id_unidade, v_id_local
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao_usuario;

    -- 3️⃣ Inserir na entidade fundadora
    INSERT INTO senha (
        codigo,
        tipo_atendimento,
        origem,
        id_unidade,
        id_local_operacional,
        status,
        criado_em
    )
    VALUES (
        NULL,
        p_tipo_atendimento,
        p_origem,
        v_id_unidade,
        v_id_local,
        'AGUARDANDO',
        NOW(6)
    );

END ;;
```

