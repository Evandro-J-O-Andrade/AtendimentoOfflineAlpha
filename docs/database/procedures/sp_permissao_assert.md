# sp_permissao_assert

Objetivo: permissao assert conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_permissao | VARCHAR(100) | IN | |

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
- sp_sessao_tem_permissao

## Functions Utilizadas
- CONCAT
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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: inicio do bloco de execucao.
- **Linha 6**: Declaracao de variavel local v_ok.
- **Linha 8**: Invoca a procedure sp_sessao_tem_permissao.
- **Linha 10**: Estrutura condicional de controle de fluxo.
- **Linha 11**: Invoca a procedure sp_raise.
- **Linha 12**: Estrutura condicional de controle de fluxo.
- **Linha 13**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_permissao_assert`(
    IN p_id_sessao_usuario BIGINT,
    IN p_permissao         VARCHAR(100)
)
BEGIN
    DECLARE v_ok TINYINT DEFAULT 0;

    CALL sp_sessao_tem_permissao(p_id_sessao_usuario, p_permissao, v_ok);

    IF IFNULL(v_ok, 0) = 0 THEN
        CALL sp_raise('SEM_PERMISSAO', CONCAT('Permissão necessária: ', p_permissao));
    END IF;
END ;;
```

