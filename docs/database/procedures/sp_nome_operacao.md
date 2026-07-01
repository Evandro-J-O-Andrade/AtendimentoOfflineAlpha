# sp_nome_operacao

Objetivo: nome operacao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_payload | JSON | IN | |
| p_sucesso | BOOLEAN | OUT | |
| p_mensagem | TEXT | OUT | |
| p_resultado | JSON | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- IF
- JSON_OBJECT

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
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: proc: BEGIN
- **Linha 13**: Declaracao de variavel local v_id_usuario.
- **Linha 15** (Comentario): validar sessão
- **Linha 16**: execucao de query SELECT para consulta de dados.
- **Linha 17**: INTO v_id_usuario
- **Linha 18**: FROM sessao_usuario
- **Linha 19**: WHERE id_sessao_usuario = p_id_sessao_usuario
- **Linha 21**: LIMIT 1;
- **Linha 23**: Estrutura condicional de controle de fluxo.
- **Linha 24**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 25**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 26**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 27**: Estrutura de repeticao/controle de loop.
- **Linha 28**: Estrutura condicional de controle de fluxo.
- **Linha 30** (Comentario): exemplo de retorno
- **Linha 31**: atribuicao de valor Ã  variavel p_sucesso.
- **Linha 32**: atribuicao de valor Ã  variavel p_mensagem.
- **Linha 33**: atribuicao de valor Ã  variavel p_resultado.
- **Linha 35**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nome_operacao`(

    IN p_id_sessao_usuario BIGINT,
    IN p_payload JSON,

    OUT p_sucesso BOOLEAN,
    OUT p_mensagem TEXT,
    OUT p_resultado JSON

)
proc: BEGIN

    DECLARE v_id_usuario BIGINT;

    -- validar sessão
    SELECT id_usuario
    INTO v_id_usuario
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao_usuario
      AND ativo = 1
    LIMIT 1;

    IF v_id_usuario IS NULL THEN
        SET p_sucesso = 0;
        SET p_mensagem = 'Sessao invalida';
        SET p_resultado = NULL;
        LEAVE proc;
    END IF;

    -- exemplo de retorno
    SET p_sucesso = 1;
    SET p_mensagem = 'Operacao executada';
    SET p_resultado = JSON_OBJECT('usuario', v_id_usuario);

END ;;
```

