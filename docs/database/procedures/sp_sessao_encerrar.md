# sp_sessao_encerrar

Objetivo: sessao encerrar conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_motivo | VARCHAR(200) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: sessao_usuario
- INSERT: (nenhuma)
- UPDATE: sessao_usuario
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditoria_evento_registrar
- sp_sessao_assert

## Functions Utilizadas
- COALESCE
- CONCAT
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
- **Linha 5**: inicio do bloco de execucao.
- **Linha 6**: Declaracao de variavel local v_id_usuario.
- **Linha 8**: Invoca a procedure sp_sessao_assert.
- **Linha 10**: execucao de query SELECT para consulta de dados.
- **Linha 11**: INTO v_id_usuario
- **Linha 12**: FROM sessao_usuario su
- **Linha 13**: WHERE su.id_sessao_usuario = p_id_sessao_usuario;
- **Linha 15**: UPDATE sessao_usuario
- **Linha 16**: atribuicao de valor Ã  variavel ativo.
- **Linha 17**: encerrado_em = NOW(),
- **Linha 18**: token = NULL
- **Linha 19**: WHERE id_sessao_usuario = p_id_sessao_usuario;
- **Linha 21**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 22**: p_id_sessao_usuario,
- **Linha 23**: 'sessao_usuario',
- **Linha 24**: p_id_sessao_usuario,
- **Linha 25**: 'SESSAO_ENCERRADA',
- **Linha 26**: CONCAT('Motivo: ', COALESCE(p_motivo,'(n/a)')),
- **Linha 27**: v_id_usuario,
- **Linha 28**: 'sessao_usuario',
- **Linha 29**: v_id_usuario
- **Linha 30**: );
- **Linha 31**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_sessao_encerrar`(
    IN p_id_sessao_usuario BIGINT,
    IN p_motivo            VARCHAR(200)
)
BEGIN
    DECLARE v_id_usuario BIGINT;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario
      INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario;

    UPDATE sessao_usuario
       SET ativo = 0,
           encerrado_em = NOW(),
           token = NULL
     WHERE id_sessao_usuario = p_id_sessao_usuario;

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'sessao_usuario',
        p_id_sessao_usuario,
        'SESSAO_ENCERRADA',
        CONCAT('Motivo: ', COALESCE(p_motivo,'(n/a)')),
        v_id_usuario,
        'sessao_usuario',
        v_id_usuario
    );
END ;;
```

