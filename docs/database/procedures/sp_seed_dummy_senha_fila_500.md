# sp_seed_dummy_senha_fila_500

Objetivo: seed dummy senha fila 500 conforme definida no dump SQL do sistema.

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
- INSERT: senha
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
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: inicio do bloco de execucao.
- **Linha 4**: Declaracao de variavel local v_i.
- **Linha 6**: START TRANSACTION;
- **Linha 8**: Estrutura de repeticao/controle de loop.
- **Linha 10**: Insere um novo registro na tabela senha.
- **Linha 11**: (
- **Linha 12**: numero,
- **Linha 13**: prefixo,
- **Linha 14**: status,
- **Linha 15**: ativo,
- **Linha 16**: criado_em
- **Linha 17**: fechamento da lista de Parametros.
- **Linha 18**: VALUES
- **Linha 19**: (
- **Linha 20**: v_i,
- **Linha 21**: 'TMP',
- **Linha 22**: 'AGUARDANDO',
- **Linha 23**: 1,
- **Linha 24**: NOW(6)
- **Linha 25**: fechamento da lista de Parametros.
- **Linha 26**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 27**: numero = VALUES(numero);
- **Linha 29**: atribuicao de valor Ã  variavel v_i.
- **Linha 31**: END WHILE;
- **Linha 33**: COMMIT;
- **Linha 35**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_dummy_senha_fila_500`()
BEGIN

    DECLARE v_i INT DEFAULT 1;

    START TRANSACTION;

    WHILE v_i <= 500 DO

        INSERT INTO senha
        (
            numero,
            prefixo,
            status,
            ativo,
            criado_em
        )
        VALUES
        (
            v_i,
            'TMP',
            'AGUARDANDO',
            1,
            NOW(6)
        )
        ON DUPLICATE KEY UPDATE
            numero = VALUES(numero);

        SET v_i = v_i + 1;

    END WHILE;

    COMMIT;

END ;;
```

