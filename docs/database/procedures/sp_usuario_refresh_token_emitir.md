# sp_usuario_refresh_token_emitir

Objetivo: usuario refresh token emitir conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_token | VARCHAR(255) | IN | |
| p_expira_em | DATETIME | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: usuario_refresh_token
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

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
- **Linha 7**: Insere um novo registro na tabela usuario_refresh_token.
- **Linha 8**: id_usuario,
- **Linha 9**: token,
- **Linha 10**: expira_em,
- **Linha 11**: revogado
- **Linha 12**: fechamento da lista de Parametros.
- **Linha 13**: VALUES(
- **Linha 14**: p_id_usuario,
- **Linha 15**: p_token,
- **Linha 16**: p_expira_em,
- **Linha 17**: 0
- **Linha 18**: );
- **Linha 19**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_refresh_token_emitir`(
    IN p_id_usuario BIGINT,
    IN p_token VARCHAR(255),
    IN p_expira_em DATETIME
)
BEGIN
    INSERT INTO usuario_refresh_token(
        id_usuario,
        token,
        expira_em,
        revogado
    )
    VALUES(
        p_id_usuario,
        p_token,
        p_expira_em,
        0
    );
END ;;
```

