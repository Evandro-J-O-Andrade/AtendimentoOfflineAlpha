# sp_criar_senha

Objetivo: criar senha conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local | BIGINT | IN | |
| p_prefixo | VARCHAR(10) | IN | |
| p_numero | INT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: (nenhuma)
- INSERT: auditoria_evento, senha, senha_eventos
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- LAST_INSERT_ID
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
- **Linha 4**: Declaracao de parÃ¢metro.
- **Linha 5**: Declaracao de parÃ¢metro.
- **Linha 6**: Declaracao de parÃ¢metro.
- **Linha 7**: Declaracao de parÃ¢metro.
- **Linha 8**: fechamento da lista de Parametros.
- **Linha 9**: inicio do bloco de execucao.
- **Linha 10**: Declaracao de variavel local v_id_senha.
- **Linha 12** (Comentario): Insere a senha no core
- **Linha 13**: Insere um novo registro na tabela senha.
- **Linha 14**: VALUES (p_id_sistema, p_id_unidade, p_id_local, p_prefixo, p_numero, NOW());
- **Linha 16**: atribuicao de valor Ã  variavel v_id_senha.
- **Linha 18** (Comentario): Auditoria
- **Linha 19**: Insere um novo registro na tabela auditoria_evento.
- **Linha 20**: VALUES (p_id_sessao_usuario, 'senha', v_id_senha, 'CREATE', NOW());
- **Linha 22** (Comentario): Evento semântico
- **Linha 23**: Insere um novo registro na tabela senha_eventos.
- **Linha 24**: VALUES (v_id_senha, p_id_sessao_usuario, 'SENHA_CRIADA', NOW());
- **Linha 26**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_criar_senha`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_sistema BIGINT,
    IN p_id_unidade BIGINT,
    IN p_id_local BIGINT,
    IN p_prefixo VARCHAR(10),
    IN p_numero INT
)
BEGIN
    DECLARE v_id_senha BIGINT;

    -- Insere a senha no core
    INSERT INTO senha (id_sistema, id_unidade, id_local, prefixo, numero, criado_em)
    VALUES (p_id_sistema, p_id_unidade, p_id_local, p_prefixo, p_numero, NOW());

    SET v_id_senha = LAST_INSERT_ID();

    -- Auditoria
    INSERT INTO auditoria_evento (id_sessao_usuario, entidade, id_entidade, acao, criado_em)
    VALUES (p_id_sessao_usuario, 'senha', v_id_senha, 'CREATE', NOW());

    -- Evento semântico
    INSERT INTO senha_eventos (id_senha, id_sessao_usuario, evento, criado_em)
    VALUES (v_id_senha, p_id_sessao_usuario, 'SENHA_CRIADA', NOW());

END ;;
```

