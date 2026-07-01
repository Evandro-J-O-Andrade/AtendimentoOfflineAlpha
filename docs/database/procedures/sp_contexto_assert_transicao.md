# sp_contexto_assert_transicao

Objetivo: contexto assert transicao conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_estado_origem | VARCHAR(50) | IN | |
| p_estado_destino | VARCHAR(50) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: fluxo_transicao_matriz, sessao_usuario, usuario_contexto
- INSERT: (nenhuma)
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true

## Functions Utilizadas
- CONCAT
- COUNT

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
- **Linha 2**: Declaracao de parÃ¢metro.
- **Linha 3**: Declaracao de parÃ¢metro.
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: fechamento da lista de Parametros.
- **Linha 6**: inicio do bloco de execucao.
- **Linha 7**: Declaracao de variavel local v_count.
- **Linha 9**: execucao de query SELECT para consulta de dados.
- **Linha 10**: INTO v_count
- **Linha 11**: FROM sessao_usuario su
- **Linha 12**: JOIN usuario_contexto uc
- **Linha 13**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 17**: JOIN fluxo_transicao_matriz ftm
- **Linha 18**: CondiÃ§Ã£o de chave ou Tratamento de duplicidade.
- **Linha 22**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 25**: Invoca a procedure sp_assert_true.
- **Linha 26**: v_count > 0,
- **Linha 27**: 'TRANSICAO_NAO_PERMITIDA',
- **Linha 28**: CONCAT('Perfil não pode transicionar de ',
- **Linha 29**: p_estado_origem,
- **Linha 30**: ' para ',
- **Linha 31**: p_estado_destino)
- **Linha 32**: );
- **Linha 34**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_contexto_assert_transicao`(
    IN p_id_sessao_usuario BIGINT,
    IN p_estado_origem VARCHAR(50),
    IN p_estado_destino VARCHAR(50)
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(1)
      INTO v_count
      FROM sessao_usuario su
      JOIN usuario_contexto uc
        ON uc.id_usuario = su.id_usuario
       AND uc.id_unidade = su.id_unidade
       AND uc.id_sistema = su.id_sistema
       AND uc.ativo = 1
      JOIN fluxo_transicao_matriz ftm
        ON ftm.perfil_requerido = uc.id_perfil
       AND ftm.estado_origem = p_estado_origem
       AND ftm.estado_destino = p_estado_destino
       AND ftm.ativo = 1
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativa = 1;

    CALL sp_assert_true(
        v_count > 0,
        'TRANSICAO_NAO_PERMITIDA',
        CONCAT('Perfil não pode transicionar de ', 
               p_estado_origem, 
               ' para ', 
               p_estado_destino)
    );

END ;;
```

