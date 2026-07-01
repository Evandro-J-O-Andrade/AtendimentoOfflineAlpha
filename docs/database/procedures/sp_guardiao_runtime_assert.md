# sp_guardiao_runtime_assert

Objetivo: guardiao runtime assert conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_contexto | VARCHAR(60) | IN | |
| p_recurso | VARCHAR(120) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: guardiao_acl_runtime
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_raise

## Functions Utilizadas
- CONCAT
- COUNT
- IF
- IFNULL

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
- **Linha 9**: Declaracao de variavel local v_ok.
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: INTO v_ok
- **Linha 13**: FROM guardiao_acl_runtime gac
- **Linha 14**: WHERE gac.id_usuario = p_id_usuario
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: Invoca a procedure sp_raise.
- **Linha 21**: 'SEM_PERMISSAO_RUNTIME',
- **Linha 22**: CONCAT('Usuario sem permissao para recurso: ', p_contexto, ' | ', p_recurso)
- **Linha 23**: );
- **Linha 24**: Estrutura condicional de controle de fluxo.
- **Linha 26**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_guardiao_runtime_assert`(
    IN p_id_usuario BIGINT,
    IN p_contexto VARCHAR(60),
    IN p_recurso VARCHAR(120)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_ok TINYINT DEFAULT 0;

    SELECT COUNT(1)
    INTO v_ok
    FROM guardiao_acl_runtime gac
    WHERE gac.id_usuario = p_id_usuario
      AND gac.contexto = p_contexto
      AND gac.recurso = p_recurso
      AND gac.permitido = 1;

    IF IFNULL(v_ok,0) = 0 THEN
        CALL sp_raise(
            'SEM_PERMISSAO_RUNTIME',
            CONCAT('Usuario sem permissao para recurso: ', p_contexto, ' | ', p_recurso)
        );
    END IF;

END ;;
```

