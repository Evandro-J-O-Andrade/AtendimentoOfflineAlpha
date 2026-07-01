# sp_finalizar_senha

Objetivo: finalizar senha conforme definida no dump SQL do sistema.

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
- INSERT: auditoria_evento, senha_eventos
- UPDATE: senha
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- NOW

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- auditoria_evento
- evento
- senha_Eventos

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
- **Linha 5**: inicio do bloco de execucao.
- **Linha 6** (Comentario): Finaliza senha
- **Linha 7**: UPDATE senha
- **Linha 8**: atribuicao de valor Ã  variavel status.
- **Linha 9**: WHERE id = p_id_senha;
- **Linha 11** (Comentario): Auditoria
- **Linha 12**: Insere um novo registro na tabela auditoria_evento.
- **Linha 13**: VALUES (p_id_sessao_usuario, 'senha', p_id_senha, 'FINALIZE', NOW());
- **Linha 15** (Comentario): Evento semântico
- **Linha 16**: Insere um novo registro na tabela senha_eventos.
- **Linha 17**: VALUES (p_id_senha, p_id_sessao_usuario, 'SENHA_FINALIZADA', NOW());
- **Linha 19**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finalizar_senha`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_senha BIGINT
)
BEGIN
    -- Finaliza senha
    UPDATE senha
    SET status = 'FINALIZADO', finalizado_em = NOW()
    WHERE id = p_id_senha;

    -- Auditoria
    INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, criado_em)
    VALUES (p_id_sessao_usuario, 'senha', p_id_senha, 'FINALIZE', NOW());

    -- Evento semântico
    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, evento, criado_em)
    VALUES (p_id_senha, p_id_sessao_usuario, 'SENHA_FINALIZADA', NOW());

END ;;
```

