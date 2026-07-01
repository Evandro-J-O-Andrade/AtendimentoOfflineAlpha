# sp_usuario_refresh_token_validar

Objetivo: usuario refresh token validar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_token | VARCHAR(255) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: usuario_refresh_token
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_not_null

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
- **Linha 3**: fechamento da lista de Parametros.
- **Linha 4**: inicio do bloco de execucao.
- **Linha 5**: Declaracao de variavel local v_id_usuario.
- **Linha 7**: execucao de query SELECT para consulta de dados.
- **Linha 8**: INTO v_id_usuario
- **Linha 9**: FROM usuario_refresh_token
- **Linha 10**: WHERE token = p_token
- **Linha 13**: LIMIT 1;
- **Linha 15**: Invoca a procedure sp_assert_not_null.
- **Linha 16**: v_id_usuario,
- **Linha 17**: 'TOKEN_INVALIDO',
- **Linha 18**: 'Refresh token inválido ou expirado'
- **Linha 19**: );
- **Linha 21**: execucao de query SELECT para consulta de dados.
- **Linha 22**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_refresh_token_validar`(
    IN p_token VARCHAR(255)
)
BEGIN
    DECLARE v_id_usuario BIGINT;

    SELECT id_usuario
      INTO v_id_usuario
      FROM usuario_refresh_token
     WHERE token = p_token
       AND revogado = 0
       AND expira_em > NOW()
     LIMIT 1;

    CALL sp_assert_not_null(
        v_id_usuario,
        'TOKEN_INVALIDO',
        'Refresh token inválido ou expirado'
    );

    SELECT v_id_usuario AS id_usuario;
END ;;
```

