# sp_senha_nao_atendida

Objetivo: senha nao atendida conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: (nenhuma)
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar
- sp_sessao_assert

## Functions Utilizadas
- NOW

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- auditoria_evento
- evento

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: SQL SECURITY INVOKER
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Invoca a procedure sp_sessao_assert.
- **Linha 9**: UPDATE senha
- **Linha 10**: atribuicao de valor Ã  variavel status.
- **Linha 11**: nao_compareceu_em = NOW()
- **Linha 12**: WHERE id = p_id_senha;
- **Linha 14**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 15**: p_id_sessao_usuario,
- **Linha 16**: 'SENHA_NAO_ATENDIDA',
- **Linha 17**: 'senha',
- **Linha 18**: p_id_senha
- **Linha 19**: );
- **Linha 20**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_senha_nao_atendida`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
    SQL SECURITY INVOKER
BEGIN
    CALL sp_sessao_assert(p_id_sessao_usuario);

    UPDATE senha
    SET status = 'NAO_COMPARECEU',
        nao_compareceu_em = NOW()
    WHERE id = p_id_senha;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'SENHA_NAO_ATENDIDA',
        'senha',
        p_id_senha
    );
END ;;
```

