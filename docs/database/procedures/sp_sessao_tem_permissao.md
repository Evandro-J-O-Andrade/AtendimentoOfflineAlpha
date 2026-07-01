# sp_sessao_tem_permissao

Objetivo: sessao tem permissao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_permissao | VARCHAR(100) | IN | |
| p_ok | TINYINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert
- sp_usuario_tem_permissao

## Functions Utilizadas
- (nenhuma)

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
- **Linha 7**: Declaracao de variavel local v_id_usuario.
- **Linha 9**: Invoca a procedure sp_sessao_assert.
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: INTO v_id_usuario
- **Linha 13**: FROM sessao_usuario su
- **Linha 14**: WHERE su.id_sessao_usuario = p_id_sessao_usuario;
- **Linha 16**: Invoca a procedure sp_usuario_tem_permissao.
- **Linha 17**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_tem_permissao`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_permissao         VARCHAR(100),
    OUT p_ok                TINYINT
)
BEGIN
    DECLARE v_id_usuario BIGINT;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario
      INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario;

    CALL sp_usuario_tem_permissao(v_id_usuario, p_permissao, p_ok);
END ;;
```

