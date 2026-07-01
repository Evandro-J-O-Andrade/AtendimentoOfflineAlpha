# sp_recepcao_complementar_e_abrir_ffa

Objetivo: recepcao complementar e abrir ffa conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_id_paciente | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: atendimento_estado_ativo, atendimento_ffa
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

## Functions Utilizadas
- LAST_INSERT_ID
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
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 8**: Declaracao de variavel local v_id_ffa.
- **Linha 10**: Invoca a procedure sp_sessao_assert.
- **Linha 12**: START TRANSACTION;
- **Linha 14**: Insere um novo registro na tabela atendimento_ffa.
- **Linha 15**: id_paciente,
- **Linha 16**: id_sessao_abertura,
- **Linha 17**: criado_em
- **Linha 18**: fechamento da lista de Parametros.
- **Linha 19**: VALUES (
- **Linha 20**: p_id_paciente,
- **Linha 21**: p_id_sessao_usuario,
- **Linha 22**: NOW()
- **Linha 23**: );
- **Linha 25**: atribuicao de valor Ã  variavel v_id_ffa.
- **Linha 27**: UPDATE senha
- **Linha 28**: atribuicao de valor Ã  variavel id_ffa.
- **Linha 29**: status = 'CONCLUIDA',
- **Linha 30**: finalizada_em = NOW()
- **Linha 31**: WHERE id = p_id_senha;
- **Linha 33**: Insere um novo registro na tabela atendimento_estado_ativo.
- **Linha 34**: id_ffa,
- **Linha 35**: estado_atual,
- **Linha 36**: atualizado_em
- **Linha 37**: fechamento da lista de Parametros.
- **Linha 38**: VALUES (
- **Linha 39**: v_id_ffa,
- **Linha 40**: 'AGUARDANDO_TRIAGEM',
- **Linha 41**: NOW()
- **Linha 42**: );
- **Linha 44**: COMMIT;
- **Linha 45**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_recepcao_complementar_e_abrir_ffa`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT,
    IN p_id_paciente BIGINT
)
    SQL SECURITY INVOKER
BEGIN
    DECLARE v_id_ffa BIGINT;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    START TRANSACTION;

    INSERT INTO atendimento_ffa (
        id_paciente,
        id_sessao_abertura,
        criado_em
    )
    VALUES (
        p_id_paciente,
        p_id_sessao_usuario,
        NOW()
    );

    SET v_id_ffa = LAST_INSERT_ID();

    UPDATE senha
    SET id_ffa = v_id_ffa,
        status = 'CONCLUIDA',
        finalizada_em = NOW()
    WHERE id = p_id_senha;

    INSERT INTO atendimento_estado_ativo (
        id_ffa,
        estado_atual,
        atualizado_em
    )
    VALUES (
        v_id_ffa,
        'AGUARDANDO_TRIAGEM',
        NOW()
    );

    COMMIT;
END ;;
```

