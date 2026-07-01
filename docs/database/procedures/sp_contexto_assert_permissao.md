# sp_contexto_assert_permissao

Objetivo: contexto assert permissao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_recurso | VARCHAR(100) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: perfil_permissao, sessao_usuario, usuario_contexto
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true

## Functions Utilizadas
- CONCAT
- COUNT

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
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Declaracao de variavel local v_count.
- **Linha 9**: execucao de query SELECT para consulta de dados.
- **Linha 10**: INTO v_count
- **Linha 11**: FROM sessao_usuario su
- **Linha 12**: JOIN usuario_contexto uc
- **Linha 13**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 17**: JOIN perfil_permissao pp
- **Linha 18**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 22**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 26**: v_count > 0,
- **Linha 27**: 'PERMISSAO_NEGADA',
- **Linha 28**: CONCAT('Sem permissão para ', p_acao, ' em ', p_recurso)
- **Linha 29**: );
- **Linha 31**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_contexto_assert_permissao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_acao VARCHAR(100),
    IN p_recurso VARCHAR(100)
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(1)
      INTO v_count
      FROM sessao_usuario su
      JOIN usuario_contexto uc
        ON uc.id_usuario = su.id_usuario
       AND uc.id_unidade = su.id_unidade
       AND uc.id_sistema = su.id_sistema
       AND uc.ativo = 1
      JOIN perfil_permissao pp
        ON pp.id_perfil = uc.id_perfil
       AND pp.acao = p_acao
       AND pp.recurso = p_recurso
       AND pp.ativo = 1
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativa = 1;

    CALL sp_assert_true(
        v_count > 0,
        'PERMISSAO_NEGADA',
        CONCAT('Sem permissão para ', p_acao, ' em ', p_recurso)
    );

END ;;
```

