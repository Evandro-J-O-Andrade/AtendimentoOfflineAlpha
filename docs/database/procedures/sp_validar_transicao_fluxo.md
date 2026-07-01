# sp_validar_transicao_fluxo

Objetivo: validar transicao fluxo conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_fluxo_origem | BIGINT | IN | |
| p_fluxo_destino | BIGINT | IN | |
| p_acao | VARCHAR(60) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fluxo_transicao_matriz
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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: SQL SECURITY INVOKER
- **Linha 7**: inicio do bloco de execucao.
- **Linha 9**: Declaracao de variavel local v_count.
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: INTO v_count
- **Linha 13**: FROM fluxo_transicao_matriz
- **Linha 14**: WHERE fluxo_origem = p_fluxo_origem
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: SIGNAL SQLSTATE '45000'
- **Linha 21**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 24**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validar_transicao_fluxo`(
    IN p_fluxo_origem BIGINT,
    IN p_fluxo_destino BIGINT,
    IN p_acao VARCHAR(60)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_count INT;

    SELECT COUNT(*)
    INTO v_count
    FROM fluxo_transicao_matriz
    WHERE fluxo_origem = p_fluxo_origem
      AND fluxo_destino = p_fluxo_destino
      AND acao_permitida = p_acao
      AND ativo = TRUE;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transicao nao permitida pela matriz deterministica';
    END IF;

END ;;
```

