# sp_emitir_evento_manchester

Objetivo: emitir evento manchester conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| - | - | - | nenhum parÃ¢metro declarado. |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: senha
- INSERT: painel_consumo_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- NOW

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
- **Linha 2**: inicio do bloco de execucao.
- **Linha 4**: Insere um novo registro na tabela painel_consumo_evento.
- **Linha 5**: origem,
- **Linha 6**: id_evento,
- **Linha 7**: painel_tipo,
- **Linha 8**: id_local_operacional,
- **Linha 9**: consumido_em
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: SELECT
- **Linha 12**: 'FILA_OPERACIONAL_EVENTO',
- **Linha 13**: s.id_senha,
- **Linha 14**: 'MANCHESTER',
- **Linha 15**: s.id_local,
- **Linha 16**: NOW()
- **Linha 17**: FROM senha s
- **Linha 18**: WHERE s.risco_dinamico_em >= NOW() - INTERVAL 5 SECOND;
- **Linha 20**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_emitir_evento_manchester`()
BEGIN

    INSERT INTO painel_consumo_evento (
        origem,
        id_evento,
        painel_tipo,
        id_local_operacional,
        consumido_em
    )
    SELECT 
        'FILA_OPERACIONAL_EVENTO',
        s.id_senha,
        'MANCHESTER',
        s.id_local,
        NOW()
    FROM senha s
    WHERE s.risco_dinamico_em >= NOW() - INTERVAL 5 SECOND;

END ;;
```

