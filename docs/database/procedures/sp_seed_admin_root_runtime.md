# sp_seed_admin_root_runtime

Objetivo: seed admin root runtime conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: perfil, usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- NOW
- SHA2

## Views Utilizadas
- v_login
- v_senha

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
- **Linha 2**: inicio do bloco de execucao.
- **Linha 4**: Declaracao de variavel local v_login.
- **Linha 5**: Declaracao de variavel local v_senha.
- **Linha 7** (Comentario): Criar usuário root
- **Linha 8**: INSERT IGNORE INTO usuario
- **Linha 9**: (
- **Linha 10**: login,
- **Linha 11**: senha_hash,
- **Linha 12**: ativo,
- **Linha 13**: criado_em
- **Linha 14**: fechamento da lista de Parametros.
- **Linha 15**: VALUES
- **Linha 16**: (
- **Linha 17**: v_login,
- **Linha 18**: SHA2(v_senha,256),
- **Linha 19**: 1,
- **Linha 20**: NOW(6)
- **Linha 21**: );
- **Linha 23** (Comentario): Criar perfil root global
- **Linha 24**: INSERT IGNORE INTO perfil
- **Linha 25**: (
- **Linha 26**: nome,
- **Linha 27**: ativo,
- **Linha 28**: criado_em
- **Linha 29**: fechamento da lista de Parametros.
- **Linha 30**: VALUES
- **Linha 31**: (
- **Linha 32**: 'ROOT_ADMIN',
- **Linha 33**: 1,
- **Linha 34**: NOW(6)
- **Linha 35**: );
- **Linha 37** (Comentario): Vincular usuário ao perfil root
- **Linha 38**: INSERT IGNORE INTO usuario_sistema
- **Linha 39**: (
- **Linha 40**: id_usuario,
- **Linha 41**: id_sistema,
- **Linha 42**: id_perfil,
- **Linha 43**: ativo,
- **Linha 44**: data_vinculo
- **Linha 45**: fechamento da lista de Parametros.
- **Linha 46**: SELECT
- **Linha 47**: u.id_usuario,
- **Linha 48**: 1,
- **Linha 49**: p.id_perfil,
- **Linha 50**: 1,
- **Linha 51**: NOW(6)
- **Linha 52**: FROM usuario u
- **Linha 53**: CROSS JOIN perfil p
- **Linha 54**: WHERE u.login = v_login
- **Linha 57**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_admin_root_runtime`()
BEGIN

    DECLARE v_login VARCHAR(80) DEFAULT 'evandro.andrade';
    DECLARE v_senha VARCHAR(255) DEFAULT '@An29070818';

    -- Criar usuário root
    INSERT IGNORE INTO usuario
    (
        login,
        senha_hash,
        ativo,
        criado_em
    )
    VALUES
    (
        v_login,
        SHA2(v_senha,256),
        1,
        NOW(6)
    );

    -- Criar perfil root global
    INSERT IGNORE INTO perfil
    (
        nome,
        ativo,
        criado_em
    )
    VALUES
    (
        'ROOT_ADMIN',
        1,
        NOW(6)
    );

    -- Vincular usuário ao perfil root
    INSERT IGNORE INTO usuario_sistema
    (
        id_usuario,
        id_sistema,
        id_perfil,
        ativo,
        data_vinculo
    )
    SELECT
        u.id_usuario,
        1,
        p.id_perfil,
        1,
        NOW(6)
    FROM usuario u
    CROSS JOIN perfil p
    WHERE u.login = v_login
    AND p.nome = 'ROOT_ADMIN';

END ;;
```

