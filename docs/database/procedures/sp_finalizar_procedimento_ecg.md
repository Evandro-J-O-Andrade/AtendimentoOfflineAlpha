# sp_finalizar_procedimento_ecg

Objetivo: finalizar procedimento ecg conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_fila | BIGINT | IN | |
| p_resultado | TEXT | IN | |

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
- sp_finalizar_procedimento_geral

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
- **Linha 7**: Invoca a procedure sp_finalizar_procedimento_geral.
- **Linha 8**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_procedimento_ecg`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_fila           BIGINT,
    IN p_resultado         TEXT
)
BEGIN
    CALL sp_finalizar_procedimento_geral(p_id_sessao_usuario, p_id_fila, p_resultado);
END ;;
```

