# sp_usuario_log_acesso_registrar

Objetivo: usuario log acesso registrar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_entidade | BIGINT | IN | |
| p_ip | VARCHAR(45) | IN | |
| p_user_agent | VARCHAR(255) | IN | |
| p_sucesso | TINYINT(1) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: usuario_log_acesso
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
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: inicio do bloco de execucao.
- **Linha 9**: Insere um novo registro na tabela usuario_log_acesso.
- **Linha 10**: id_usuario,
- **Linha 11**: id_entidade,
- **Linha 12**: ip,
- **Linha 13**: user_agent,
- **Linha 14**: sucesso
- **Linha 15**: fechamento da lista de Parametros.
- **Linha 16**: VALUES(
- **Linha 17**: p_id_usuario,
- **Linha 18**: p_id_entidade,
- **Linha 19**: p_ip,
- **Linha 20**: p_user_agent,
- **Linha 21**: p_sucesso
- **Linha 22**: );
- **Linha 23**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_log_acesso_registrar`(
    IN p_id_usuario BIGINT,
    IN p_id_entidade BIGINT,
    IN p_ip VARCHAR(45),
    IN p_user_agent VARCHAR(255),
    IN p_sucesso TINYINT(1)
)
BEGIN
    INSERT INTO usuario_log_acesso(
        id_usuario,
        id_entidade,
        ip,
        user_agent,
        sucesso
    )
    VALUES(
        p_id_usuario,
        p_id_entidade,
        p_ip,
        p_user_agent,
        p_sucesso
    );
END ;;
```

