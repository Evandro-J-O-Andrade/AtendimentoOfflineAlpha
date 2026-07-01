# sp_auditoria_evento_registrar

Objetivo: auditoria evento registrar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_entidade | VARCHAR(80) | IN | |
| p_id_entidade | BIGINT | IN | |
| p_acao | VARCHAR(80) | IN | |
| p_detalhe | TEXT | IN | |
| p_tabela | VARCHAR(50) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: auditoria_evento
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COALESCE
- IF

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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: Declaracao de parÃ¢metro.
- **Linha 9**: Declaracao de parÃ¢metro.
- **Linha 10**: fechamento da lista de Parametros.
- **Linha 11**: inicio do bloco de execucao.
- **Linha 12**: Declaracao de variavel local v_id_usuario.
- **Linha 14**: Estrutura condicional de controle de fluxo.
- **Linha 15**: atribuicao de valor Ã  variavel v_id_usuario.
- **Linha 16**: Estrutura condicional de controle de fluxo.
- **Linha 17**: execucao de query SELECT para consulta de dados.
- **Linha 18**: INTO v_id_usuario
- **Linha 19**: FROM sessao_usuario su
- **Linha 20**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 21**: LIMIT 1;
- **Linha 22**: Estrutura condicional de controle de fluxo.
- **Linha 24**: Insere um novo registro na tabela auditoria_evento.
- **Linha 25**: (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
- **Linha 26**: VALUES
- **Linha 27**: (p_id_sessao_usuario, p_entidade, p_id_entidade, p_acao, p_detalhe, v_id_usuario, p_tabela,
- **Linha 28**: COALESCE(p_id_usuario_espelho, v_id_usuario));
- **Linha 29**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_auditoria_evento_registrar`(
    IN p_id_sessao_usuario  BIGINT,
    IN p_entidade           VARCHAR(80),
    IN p_id_entidade        BIGINT,
    IN p_acao               VARCHAR(80),
    IN p_detalhe            TEXT,
    IN p_id_usuario_exec    BIGINT,     -- opcional (se NULL e houver sessão, será inferido)
    IN p_tabela             VARCHAR(50),
    IN p_id_usuario_espelho BIGINT      -- opcional
)
BEGIN
    DECLARE v_id_usuario BIGINT DEFAULT NULL;

    IF p_id_usuario_exec IS NOT NULL THEN
        SET v_id_usuario = p_id_usuario_exec;
    ELSEIF p_id_sessao_usuario IS NOT NULL THEN
        SELECT su.id_usuario
          INTO v_id_usuario
          FROM sessao_usuario su
         WHERE su.id_sessao_usuario = p_id_sessao_usuario
         LIMIT 1;
    END IF;

    INSERT INTO auditoria_evento
        (id_sessao_usuario, entidade, id_entidade, acao, detalhe, id_usuario, tabela, id_usuario_espelho)
    VALUES
        (p_id_sessao_usuario, p_entidade, p_id_entidade, p_acao, p_detalhe, v_id_usuario, p_tabela,
         COALESCE(p_id_usuario_espelho, v_id_usuario));
END ;;
```

