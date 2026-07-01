# sp_seed_runtime_assistencial

Objetivo: seed runtime assistencial conforme definida no dump SQL do sistema.

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
- SELECT: (nenhuma)
- INSERT: runtime_estado_sobrevivencia
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- NOW
- UUID

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
- **Linha 2**: inicio do bloco de execucao.
- **Linha 4**: Insere um novo registro na tabela runtime_estado_sobrevivencia.
- **Linha 5**: (
- **Linha 6**: runtime_device_id,
- **Linha 7**: modo_operacao,
- **Linha 8**: estado_runtime,
- **Linha 9**: ultimo_ping,
- **Linha 10**: ativo
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: VALUES
- **Linha 13**: (
- **Linha 14**: UUID(),
- **Linha 15**: 'TESTE_CARGA',
- **Linha 16**: 'ONLINE',
- **Linha 17**: NOW(6),
- **Linha 18**: 1
- **Linha 19**: fechamento da lista de Parametros.
- **Linha 20**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 21**: ultimo_ping = NOW(6);
- **Linha 23**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_runtime_assistencial`()
BEGIN

    INSERT INTO runtime_estado_sobrevivencia
    (
        runtime_device_id,
        modo_operacao,
        estado_runtime,
        ultimo_ping,
        ativo
    )
    VALUES
    (
        UUID(),
        'TESTE_CARGA',
        'ONLINE',
        NOW(6),
        1
    )
    ON DUPLICATE KEY UPDATE
        ultimo_ping = NOW(6);

END ;;
```

