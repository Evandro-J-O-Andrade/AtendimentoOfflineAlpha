# sp_seed_dummy_paciente_500

Objetivo: seed dummy paciente 500 conforme definida no dump SQL do sistema.

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
- INSERT: paciente
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
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
- **Linha 10**: Insere um novo registro na tabela paciente.
- **Linha 11**: (
- **Linha 12**: nome,
- **Linha 13**: ativo,
- **Linha 14**: criado_em
- **Linha 15**: fechamento da lista de Parametros.
- **Linha 16**: VALUES
- **Linha 17**: (
- **Linha 18**: CONCAT('PACIENTE_SEED_', v_i),
- **Linha 19**: 1,
- **Linha 20**: NOW(6)
- **Linha 21**: fechamento da lista de Parametros.
- **Linha 22**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 23**: nome = VALUES(nome);
- **Linha 25**: atribuicao de valor Ã  variavel v_i.
- **Linha 27**: END WHILE;
- **Linha 29**: COMMIT;
- **Linha 31**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_dummy_paciente_500`()
BEGIN

    DECLARE v_i INT DEFAULT 1;

    START TRANSACTION;

    WHILE v_i <= 500 DO

        INSERT INTO paciente
        (
            nome,
            ativo,
            criado_em
        )
        VALUES
        (
            CONCAT('PACIENTE_SEED_', v_i),
            1,
            NOW(6)
        )
        ON DUPLICATE KEY UPDATE
        nome = VALUES(nome);

        SET v_i = v_i + 1;

    END WHILE;

    COMMIT;

END ;;
```

