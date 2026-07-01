# sp_sessao_contexto_set

Objetivo: sessao contexto set conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_id_perfil | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: sessao_usuario
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
- **Linha 6**: fechamento da lista de Parametros.
- **Linha 7**: inicio do bloco de execucao.
- **Linha 9**: UPDATE sessao_usuario
- **Linha 10**: SET
- **Linha 11**: id_unidade = p_id_unidade,
- **Linha 12**: id_local   = p_id_local,
- **Linha 13**: id_perfil  = p_id_perfil
- **Linha 14**: WHERE id_sessao_usuario = p_id_sessao;
- **Linha 16**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_contexto_set`(
    IN p_id_sessao BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_id_perfil BIGINT
)
BEGIN

    UPDATE sessao_usuario
    SET 
        id_unidade = p_id_unidade,
        id_local   = p_id_local,
        id_perfil  = p_id_perfil
    WHERE id_sessao_usuario = p_id_sessao;

END ;;
```

