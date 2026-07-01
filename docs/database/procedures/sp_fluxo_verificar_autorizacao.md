# sp_fluxo_verificar_autorizacao

Objetivo: fluxo verificar autorizacao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_usuario | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: vw_usuario_permissoes
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
- vw_usuario_permissoes

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
- **Linha 9**: Declaracao de variavel local v_permitido.
- **Linha 11**: execucao de query SELECT para consulta de dados.
- **Linha 12**: INTO v_permitido
- **Linha 13**: FROM vw_usuario_permissoes vp
- **Linha 14**: WHERE vp.id_usuario = p_id_usuario
- **Linha 19**: Estrutura condicional de controle de fluxo.
- **Linha 20**: SIGNAL SQLSTATE '45000'
- **Linha 21**: atribuicao de valor Ã  variavel MESSAGE_TEXT.
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 24**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fluxo_verificar_autorizacao`(
    IN p_id_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_nome_procedure VARCHAR(150)
)
    SQL SECURITY INVOKER
BEGIN

    DECLARE v_permitido INT DEFAULT 0;

    SELECT COUNT(1)
    INTO v_permitido
    FROM vw_usuario_permissoes vp
    WHERE vp.id_usuario = p_id_usuario
      AND vp.id_sistema = p_id_sistema
      AND vp.nome_procedure = p_nome_procedure
      AND vp.permitido = 1;

    IF v_permitido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Acesso negado ao fluxo operacional';
    END IF;

END ;;
```

