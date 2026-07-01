# sp_usuario_tem_permissao

Objetivo: usuario tem permissao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_permissao | VARCHAR(100) | IN | |
| p_ok | TINYINT | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: vw_usuario_permissoes
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IFNULL

## Views Utilizadas
- vw_usuario_permissoes

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
- **Linha 7**: Declaracao de variavel local v_ok.
- **Linha 9**: execucao de query SELECT para consulta de dados.
- **Linha 10**: INTO v_ok
- **Linha 11**: FROM vw_usuario_permissoes v
- **Linha 12**: WHERE v.id_usuario = p_id_usuario
- **Linha 14**: LIMIT 1;
- **Linha 16**: atribuicao de valor Ã  variavel p_ok.
- **Linha 17**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_tem_permissao`(
    IN  p_id_usuario BIGINT,
    IN  p_permissao  VARCHAR(100),
    OUT p_ok         TINYINT
)
BEGIN
    DECLARE v_ok INT DEFAULT 0;

    SELECT 1
      INTO v_ok
      FROM vw_usuario_permissoes v
     WHERE v.id_usuario = p_id_usuario
       AND v.permissao = p_permissao
     LIMIT 1;

    SET p_ok = IFNULL(v_ok, 0);
END ;;
```

