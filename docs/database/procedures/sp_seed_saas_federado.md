# sp_seed_saas_federado

Objetivo: seed saas federado conforme definida no dump SQL do sistema.

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
- INSERT: saas_entidade
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- NOW

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
- **Linha 4**: Insere um novo registro na tabela saas_entidade.
- **Linha 5**: (
- **Linha 6**: nome,
- **Linha 7**: ativo,
- **Linha 8**: criado_em
- **Linha 9**: fechamento da lista de Parametros.
- **Linha 10**: VALUES
- **Linha 11**: (
- **Linha 12**: 'ENTIDADE_TESTE_GLOBAL',
- **Linha 13**: 1,
- **Linha 14**: NOW(6)
- **Linha 15**: fechamento da lista de Parametros.
- **Linha 16**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 17**: nome = VALUES(nome);
- **Linha 19**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_saas_federado`()
BEGIN

    INSERT INTO saas_entidade
    (
        nome,
        ativo,
        criado_em
    )
    VALUES
    (
        'ENTIDADE_TESTE_GLOBAL',
        1,
        NOW(6)
    )
    ON DUPLICATE KEY UPDATE
        nome = VALUES(nome);

END ;;
```

