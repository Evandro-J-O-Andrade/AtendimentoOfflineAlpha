# sp_usuario_criar_contexto

Objetivo: usuario criar contexto conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_login | VARCHAR(60) | IN | |
| p_id_sistema | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: usuario
- INSERT: usuario_contexto
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_usuario_vincular_local
- sp_usuario_vincular_sistema
- sp_usuario_vincular_unidade

## Functions Utilizadas
- IF
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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: inicio do bloco de execucao.
- **Linha 9**: Declaracao de variavel local v_id_usuario.
- **Linha 11** (Comentario): Busca ID do usuário
- **Linha 12**: execucao de query SELECT para consulta de dados.
- **Linha 13**: FROM usuario
- **Linha 14**: WHERE login = p_login
- **Linha 15**: LIMIT 1;
- **Linha 17**: Estrutura condicional de controle de fluxo.
- **Linha 18**: execucao de query SELECT para consulta de dados.
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20** (Comentario): Vincula ao sistema
- **Linha 21**: Invoca a procedure sp_usuario_vincular_sistema.
- **Linha 23** (Comentario): Vincula à unidade
- **Linha 24**: Invoca a procedure sp_usuario_vincular_unidade.
- **Linha 26** (Comentario): Vincula ao local
- **Linha 27**: Invoca a procedure sp_usuario_vincular_local.
- **Linha 29** (Comentario): Cria contexto
- **Linha 30**: Insere um novo registro na tabela usuario_contexto.
- **Linha 31**: id_usuario,
- **Linha 32**: id_sistema,
- **Linha 33**: id_unidade,
- **Linha 34**: id_local_operacional,
- **Linha 35**: id_perfil,
- **Linha 36**: ativo,
- **Linha 37**: criado_em
- **Linha 38**: ) VALUES (
- **Linha 39**: v_id_usuario,
- **Linha 40**: p_id_sistema,
- **Linha 41**: p_id_unidade,
- **Linha 42**: p_id_local_operacional,
- **Linha 43**: p_id_perfil,
- **Linha 44**: 1,
- **Linha 45**: NOW()
- **Linha 46**: fechamento da lista de Parametros.
- **Linha 47**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 48**: id_sistema = VALUES(id_sistema),
- **Linha 49**: id_unidade = VALUES(id_unidade),
- **Linha 50**: id_local_operacional = VALUES(id_local_operacional),
- **Linha 51**: id_perfil = VALUES(id_perfil),
- **Linha 52**: ativo = 1;
- **Linha 54**: execucao de query SELECT para consulta de dados.
- **Linha 55**: Estrutura condicional de controle de fluxo.
- **Linha 56**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_criar_contexto`(
    IN p_login VARCHAR(60),
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local_operacional BIGINT,
    IN p_id_perfil BIGINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;
    
    -- Busca ID do usuário
    SELECT id_usuario INTO v_id_usuario
    FROM usuario
    WHERE login = p_login
    LIMIT 1;
    
    IF v_id_usuario IS NULL THEN
        SELECT 'USUARIO_NAO_ENCONTRADO' as erro;
    ELSE
        -- Vincula ao sistema
        CALL sp_usuario_vincular_sistema(v_id_usuario, p_id_sistema, p_id_perfil);
        
        -- Vincula à unidade
        CALL sp_usuario_vincular_unidade(v_id_usuario, p_id_unidade);
        
        -- Vincula ao local
        CALL sp_usuario_vincular_local(v_id_usuario, p_id_local_operacional);
        
        -- Cria contexto
        INSERT INTO usuario_contexto (
            id_usuario,
            id_sistema,
            id_unidade,
            id_local_operacional,
            id_perfil,
            ativo,
            criado_em
        ) VALUES (
            v_id_usuario,
            p_id_sistema,
            p_id_unidade,
            p_id_local_operacional,
            p_id_perfil,
            1,
            NOW()
        )
        ON DUPLICATE KEY UPDATE
            id_sistema = VALUES(id_sistema),
            id_unidade = VALUES(id_unidade),
            id_local_operacional = VALUES(id_local_operacional),
            id_perfil = VALUES(id_perfil),
            ativo = 1;
        
        SELECT 'SUCESSO' as resultado, v_id_usuario as id_usuario;
    END IF;
END ;;
```

