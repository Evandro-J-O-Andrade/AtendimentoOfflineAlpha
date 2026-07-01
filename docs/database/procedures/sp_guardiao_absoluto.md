# sp_guardiao_absoluto

Objetivo: guardiao absoluto conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_origem | VARCHAR(60) | IN | |

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
- COUNT
- IF
- SIGNAL

## Views Utilizadas
- (nenhuma)

## Eventos Gerados
- (nenhum)

## Tratamento de Erros

- Uso de SIGNAL/RESIGNAL para gerar Erros customizados.

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
- **Linha 8**: Declaracao de variavel local v_valido.
- **Linha 10**: execucao de query SELECT para consulta de dados.
- **Linha 11**: INTO v_valido
- **Linha 12**: FROM sessao_usuario
- **Linha 13**: WHERE id_sessao_usuario = p_id_sessao_usuario
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 17**: SIGNAL SQLSTATE '45000'
- **Linha 18**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 21**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_guardiao_absoluto`(
    IN p_id_sessao_usuario BIGINT,
    IN p_origem VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_valido INT DEFAULT 0;

    SELECT COUNT(1)
    INTO v_valido
    FROM sessao_usuario
    WHERE id_sessao_usuario = p_id_sessao_usuario
    AND ativo = 1;

    IF v_valido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sessão inválida no guardião absoluto';
    END IF;

END ;;
```

