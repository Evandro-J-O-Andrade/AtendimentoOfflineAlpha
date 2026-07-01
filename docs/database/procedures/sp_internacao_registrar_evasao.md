# sp_internacao_registrar_evasao

Objetivo: internacao registrar evasao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_internacao | BIGINT | IN | |
| p_detalhe | TEXT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: internacao_movimentacao
- UPDATE: internacao
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_sessao_assert

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
- Commit: Sim

## Logica Linha por Linha

- **Linha 1**: Definicao da procedure com o definer.
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Invoca a procedure sp_sessao_assert.
- **Linha 9**: START TRANSACTION;
- **Linha 10** (Comentario): Atualiza a internação para o status de EVASAO
- **Linha 11**: Atualiza registros existentes na tabela internacao.
- **Linha 12**: status = 'EVASAO',
- **Linha 13**: data_fim = NOW()
- **Linha 14**: WHERE id_internacao = p_id_internacao;
- **Linha 16** (Comentario): Mantém o histórico na tabela de eventos de movimentação/internação
- **Linha 17**: Insere um novo registro na tabela internacao_movimentacao.
- **Linha 18**: execucao de query SELECT para consulta de dados.
- **Linha 19**: FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 21**: COMMIT;
- **Linha 22**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_internacao_registrar_evasao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_internacao BIGINT,
    IN p_detalhe TEXT
)
BEGIN
    CALL sp_sessao_assert(p_id_sessao_usuario);
    
    START TRANSACTION;
        -- Atualiza a internação para o status de EVASAO
        UPDATE internacao SET 
            status = 'EVASAO', 
            data_fim = NOW() 
        WHERE id_internacao = p_id_internacao;

        -- Mantém o histórico na tabela de eventos de movimentação/internação
        INSERT INTO internacao_movimentacao (id_internacao, tipo_movimentacao, data_movimentacao, id_usuario, id_sessao_usuario, observacao)
        SELECT p_id_internacao, 'EVASAO', NOW(), id_usuario, p_id_sessao_usuario, p_detalhe
        FROM sessao_usuario WHERE id_sessao_usuario = p_id_sessao_usuario;

    COMMIT;
END ;;
```

