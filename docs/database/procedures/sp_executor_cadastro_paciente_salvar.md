# sp_executor_cadastro_paciente_salvar

Objetivo: executor cadastro paciente salvar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao | BIGINT | IN | |
| p_acao | VARCHAR(100) | IN | |
| p_id_referencia | BIGINT | IN | |
| p_payload | JSON | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: paciente
- UPDATE: paciente
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- JSON_EXTRACT
- JSON_OBJECT
- JSON_UNQUOTE
- LAST_INSERT_ID
- NOW

## Views Utilizadas
- v_cpf
- v_nome

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
- **Linha 7**: SQL SECURITY INVOKER
- **Linha 8**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local v_nome.
- **Linha 11**: Declaracao de variavel local v_cpf.
- **Linha 13**: atribuicao de valor Ã  variavel v_nome.
- **Linha 14**: atribuicao de valor Ã  variavel v_cpf.
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 18**: Insere um novo registro na tabela paciente.
- **Linha 19**: nome,
- **Linha 20**: cpf,
- **Linha 21**: criado_em
- **Linha 22**: ) VALUES (
- **Linha 23**: v_nome,
- **Linha 24**: v_cpf,
- **Linha 25**: NOW(6)
- **Linha 26**: );
- **Linha 28**: atribuicao de valor Ã  variavel p_id_referencia.
- **Linha 30**: Estrutura condicional de controle de fluxo.
- **Linha 32**: UPDATE paciente
- **Linha 33**: atribuicao de valor Ã  variavel nome.
- **Linha 34**: cpf = v_cpf,
- **Linha 35**: atualizado_em = NOW(6)
- **Linha 36**: WHERE id_paciente = p_id_referencia;
- **Linha 38**: Estrutura condicional de controle de fluxo.
- **Linha 40**: execucao de query SELECT para consulta de dados.
- **Linha 41**: 'status','SUCCESS',
- **Linha 42**: 'id_paciente', p_id_referencia
- **Linha 43**: ) AS result;
- **Linha 45**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_executor_cadastro_paciente_salvar`(
    IN p_id_sessao BIGINT,
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_nome VARCHAR(120);
    DECLARE v_cpf VARCHAR(20);

    SET v_nome = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.nome'));
    SET v_cpf  = JSON_UNQUOTE(JSON_EXTRACT(p_payload, '$.cpf'));

    IF p_id_referencia IS NULL OR p_id_referencia = 0 THEN

        INSERT INTO paciente (
            nome,
            cpf,
            criado_em
        ) VALUES (
            v_nome,
            v_cpf,
            NOW(6)
        );

        SET p_id_referencia = LAST_INSERT_ID();

    ELSE

        UPDATE paciente
        SET nome = v_nome,
            cpf = v_cpf,
            atualizado_em = NOW(6)
        WHERE id_paciente = p_id_referencia;

    END IF;

    SELECT JSON_OBJECT(
        'status','SUCCESS',
        'id_paciente', p_id_referencia
    ) AS result;

END ;;
```

