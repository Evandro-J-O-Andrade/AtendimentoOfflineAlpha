# sp_patch_log

Objetivo: patch log conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_patch_nome | VARCHAR(120) | IN | |
| p_status_execucao | VARCHAR(20) | IN | |
| p_detalhes | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: schema_patch_execucao
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
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Insere um novo registro na tabela schema_patch_execucao.
- **Linha 8**: patch_nome,
- **Linha 9**: status_execucao,
- **Linha 10**: detalhes
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: VALUES (
- **Linha 13**: p_patch_nome,
- **Linha 14**: p_status_execucao,
- **Linha 15**: p_detalhes
- **Linha 16**: );
- **Linha 17**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_patch_log`(
    IN p_patch_nome VARCHAR(120),
    IN p_status_execucao VARCHAR(20),
    IN p_detalhes JSON
)
BEGIN
    INSERT INTO schema_patch_execucao (
        patch_nome,
        status_execucao,
        detalhes
    )
    VALUES (
        p_patch_nome,
        p_status_execucao,
        p_detalhes
    );
END ;;
```

