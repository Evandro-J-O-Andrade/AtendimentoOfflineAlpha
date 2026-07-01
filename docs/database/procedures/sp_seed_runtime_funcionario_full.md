# sp_seed_runtime_funcionario_full

Objetivo: seed runtime funcionario full conforme definida no dump SQL do sistema.

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
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CONCAT
- MOD
- NOW

## Views Utilizadas
- v_tipo

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
- **Linha 5**: Declaracao de variavel local v_tipo.
- **Linha 7**: START TRANSACTION;
- **Linha 9**: Estrutura de repeticao/controle de loop.
- **Linha 11**: CASE (v_i MOD 10)
- **Linha 12**: WHEN 0 THEN SET v_tipo = 'MEDICO';
- **Linha 13**: WHEN 1 THEN SET v_tipo = 'ENFERMEIRO';
- **Linha 14**: WHEN 2 THEN SET v_tipo = 'TECNICO_ENFERMAGEM';
- **Linha 15**: WHEN 3 THEN SET v_tipo = 'RECEPCIONISTA';
- **Linha 16**: WHEN 4 THEN SET v_tipo = 'FARMACEUTICO';
- **Linha 17**: WHEN 5 THEN SET v_tipo = 'ADMINISTRATIVO';
- **Linha 18**: WHEN 6 THEN SET v_tipo = 'GESTOR';
- **Linha 19**: WHEN 7 THEN SET v_tipo = 'SUPORTE_TI';
- **Linha 20**: WHEN 8 THEN SET v_tipo = 'COORDENADOR';
- **Linha 21**: Estrutura condicional de controle de fluxo.
- **Linha 22**: END CASE;
- **Linha 24**: INSERT IGNORE INTO funcionario
- **Linha 25**: (
- **Linha 26**: id_pessoa,
- **Linha 27**: tipo_funcionario,
- **Linha 28**: cargo,
- **Linha 29**: departamento,
- **Linha 30**: matricula,
- **Linha 31**: ativo,
- **Linha 32**: criado_em
- **Linha 33**: fechamento da lista de Parametros.
- **Linha 34**: VALUES
- **Linha 35**: (
- **Linha 36**: v_i,
- **Linha 37**: v_tipo,
- **Linha 38**: CONCAT('CARGO_', v_tipo),
- **Linha 39**: CONCAT('DEP_', v_tipo),
- **Linha 40**: CONCAT('MAT_', LPAD(v_i,6,'0')),
- **Linha 41**: 1,
- **Linha 42**: NOW(6)
- **Linha 43**: );
- **Linha 45**: atribuicao de valor Ã  variavel v_i.
- **Linha 47**: END WHILE;
- **Linha 49**: COMMIT;
- **Linha 51**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_seed_runtime_funcionario_full`()
BEGIN

    DECLARE v_i INT DEFAULT 1;
    DECLARE v_tipo VARCHAR(50);

    START TRANSACTION;

    WHILE v_i <= 500 DO

        CASE (v_i MOD 10)
            WHEN 0 THEN SET v_tipo = 'MEDICO';
            WHEN 1 THEN SET v_tipo = 'ENFERMEIRO';
            WHEN 2 THEN SET v_tipo = 'TECNICO_ENFERMAGEM';
            WHEN 3 THEN SET v_tipo = 'RECEPCIONISTA';
            WHEN 4 THEN SET v_tipo = 'FARMACEUTICO';
            WHEN 5 THEN SET v_tipo = 'ADMINISTRATIVO';
            WHEN 6 THEN SET v_tipo = 'GESTOR';
            WHEN 7 THEN SET v_tipo = 'SUPORTE_TI';
            WHEN 8 THEN SET v_tipo = 'COORDENADOR';
            ELSE SET v_tipo = 'OUTRO';
        END CASE;

        INSERT IGNORE INTO funcionario
        (
            id_pessoa,
            tipo_funcionario,
            cargo,
            departamento,
            matricula,
            ativo,
            criado_em
        )
        VALUES
        (
            v_i,
            v_tipo,
            CONCAT('CARGO_', v_tipo),
            CONCAT('DEP_', v_tipo),
            CONCAT('MAT_', LPAD(v_i,6,'0')),
            1,
            NOW(6)
        );

        SET v_i = v_i + 1;

    END WHILE;

    COMMIT;

END ;;
```

