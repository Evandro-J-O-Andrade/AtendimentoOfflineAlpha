# sp_acl_registrar_evento

Objetivo: acl registrar evento conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |
| p_evento | VARCHAR(50) | IN | |
| p_sucesso | TINYINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: usuario_sistema_acl_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- (nenhuma)

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
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
- **Linha 7**: fechamento da lista de Parametros.
- **Linha 8**: SQL SECURITY INVOKER
- **Linha 9**: inicio do bloco de execucao.
- **Linha 11**: Insere um novo registro na tabela usuario_sistema_acl_evento.
- **Linha 12**: (
- **Linha 13**: id_usuario,
- **Linha 14**: id_sistema,
- **Linha 15**: id_perfil,
- **Linha 16**: evento,
- **Linha 17**: sucesso
- **Linha 18**: fechamento da lista de Parametros.
- **Linha 19**: VALUES
- **Linha 20**: (
- **Linha 21**: p_id_usuario,
- **Linha 22**: p_id_sistema,
- **Linha 23**: p_id_perfil,
- **Linha 24**: p_evento,
- **Linha 25**: p_sucesso
- **Linha 26**: );
- **Linha 28**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_acl_registrar_evento`(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_id_perfil BIGINT,
    IN p_evento VARCHAR(50),
    IN p_sucesso TINYINT
)
    SQL SECURITY INVOKER
BEGIN

    INSERT INTO usuario_sistema_acl_evento
    (
        id_usuario,
        id_sistema,
        id_perfil,
        evento,
        sucesso
    )
    VALUES
    (
        p_id_usuario,
        p_id_sistema,
        p_id_perfil,
        p_evento,
        p_sucesso
    );

END ;;
```

