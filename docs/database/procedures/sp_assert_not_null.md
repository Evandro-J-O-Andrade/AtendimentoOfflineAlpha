# sp_assert_not_null

Objetivo: assert not null conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_valor | TEXT | IN | |
| p_codigo | VARCHAR(50) | IN | |
| p_mensagem | VARCHAR(4000) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_raise

## Functions Utilizadas
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
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Estrutura condicional de controle de fluxo.
- **Linha 8**: Invoca a procedure sp_raise.
- **Linha 9**: Estrutura condicional de controle de fluxo.
- **Linha 10**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_assert_not_null`(
    IN p_valor    TEXT,
    IN p_codigo   VARCHAR(50),
    IN p_mensagem VARCHAR(4000)
)
BEGIN
    IF p_valor IS NULL THEN
        CALL sp_raise(IFNULL(p_codigo,'PARAM'), IFNULL(p_mensagem,'Valor obrigatório (NULL).'));
    END IF;
END ;;
```

