# sp_painel_config_set

Objetivo: painel config set conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_painel | BIGINT | IN | |
| p_chave | VARCHAR(80) | IN | |
| p_valor_bool | TINYINT | IN | |
| p_valor_int | INT | IN | |
| p_valor_decimal | DECIMAL(12,4) | IN | |
| p_valor_text | TEXT | IN | |
| p_valor_json | JSON | IN | |
| p_valor_enum | VARCHAR(80) | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: painel, painel_config_def, sessao_usuario
- INSERT: painel_config
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- JSON_CONTAINS
- LENGTH
- NOW
- TRIM

## Views Utilizadas
- v_sqlstate
- v_tipo
- v_valor_decimal
- v_valor_enum

## Eventos Gerados
- auditoria_evento
- evento

## Tratamento de Erros

- HANDLER de erro declarado (SQLEXCEPTION/SQLWARNING/NOT FOUND).

## Transacoes
- TRY/CATCH: nao aplicavel (MySQL usa DECLARE HANDLER, nao TRY/CATCH nativo)
- Rollback: Sim
- Commit: Sim

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
- **Linha 10**: Declaracao de parÃ¢metro.
- **Linha 11**: fechamento da lista de Parametros.
- **Linha 12**: main: BEGIN
- **Linha 13**: Declaracao de variavel local v_id_usuario.
- **Linha 14**: Declaracao de variavel local v_tipo.
- **Linha 15**: Declaracao de variavel local v_enum_opcoes.
- **Linha 17**: Declaracao de variavel local v_valor_bool.
- **Linha 18**: Declaracao de variavel local v_valor_int.
- **Linha 19**: Declaracao de variavel local v_valor_decimal.
- **Linha 20**: Declaracao de variavel local v_valor_text.
- **Linha 21**: Declaracao de variavel local v_valor_json.
- **Linha 22**: Declaracao de variavel local v_valor_enum.
- **Linha 24**: Declaracao de variavel local v_sqlstate.
- **Linha 25**: Declaracao de variavel local v_errno.
- **Linha 26**: Declaracao de variavel local v_msg.
- **Linha 28**: Declaracao de variavel local EXIT.
- **Linha 29**: inicio do bloco de execucao.
- **Linha 30**: GET DIAGNOSTICS CONDITION 1
- **Linha 31**: v_sqlstate = RETURNED_SQLSTATE,
- **Linha 32**: v_errno    = MYSQL_ERRNO,
- **Linha 33**: v_msg      = MESSAGE_TEXT;
- **Linha 35**: SET @diag_sqlstate = v_sqlstate;
- **Linha 36**: SET @diag_errno    = v_errno;
- **Linha 37**: SET @diag_msg      = v_msg;
- **Linha 39**: ROLLBACK;
- **Linha 40**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 41**: Invoca a procedure sp_raise.
- **Linha 42**: 'ROTINA=sp_painel_config_set | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
- **Linha 43**: ' | ERRNO=',IFNULL(v_errno,0),
- **Linha 44**: ' | MSG=',IFNULL(v_msg,'(n/a)'),
- **Linha 45**: ' | CTX=Falha ao setar config'
- **Linha 46**: ));
- **Linha 47**: Fim do bloco da procedure.
- **Linha 49**: Invoca a procedure sp_sessao_assert.
- **Linha 51**: execucao de query SELECT para consulta de dados.
- **Linha 52**: INTO v_id_usuario
- **Linha 53**: FROM sessao_usuario su
- **Linha 54**: WHERE su.id_sessao_usuario = p_id_sessao_usuario
- **Linha 56**: LIMIT 1;
- **Linha 58**: Invoca a procedure sp_assert_true.
- **Linha 59**: Invoca a procedure sp_assert_true.
- **Linha 61**: Invoca a procedure sp_assert_true.
- **Linha 62**: EXISTS (SELECT 1 FROM painel p WHERE p.id_painel = p_id_painel),
- **Linha 63**: 'NOT_FOUND',
- **Linha 64**: 'Painel não encontrado.'
- **Linha 65**: );
- **Linha 67**: execucao de query SELECT para consulta de dados.
- **Linha 68**: INTO v_tipo, v_enum_opcoes
- **Linha 69**: FROM painel_config_def d
- **Linha 70**: WHERE d.chave = p_chave COLLATE utf8mb4_0900_ai_ci
- **Linha 72**: LIMIT 1;
- **Linha 74**: Invoca a procedure sp_assert_true.
- **Linha 76** (Comentario): Copia valores de entrada para variáveis locais e zera conforme o tipo
- **Linha 77**: atribuicao de valor Ã  variavel v_valor_bool.
- **Linha 78**: atribuicao de valor Ã  variavel v_valor_int.
- **Linha 79**: atribuicao de valor Ã  variavel v_valor_decimal.
- **Linha 80**: atribuicao de valor Ã  variavel v_valor_text.
- **Linha 81**: atribuicao de valor Ã  variavel v_valor_json.
- **Linha 82**: atribuicao de valor Ã  variavel v_valor_enum.
- **Linha 84**: Estrutura condicional de controle de fluxo.
- **Linha 85**: Invoca a procedure sp_assert_true.
- **Linha 86**: atribuicao de valor Ã  variavel v_valor_int.
- **Linha 87**: atribuicao de valor Ã  variavel v_valor_decimal.
- **Linha 88**: atribuicao de valor Ã  variavel v_valor_text.
- **Linha 89**: atribuicao de valor Ã  variavel v_valor_json.
- **Linha 90**: atribuicao de valor Ã  variavel v_valor_enum.
- **Linha 92**: Estrutura condicional de controle de fluxo.
- **Linha 93**: Invoca a procedure sp_assert_true.
- **Linha 94**: atribuicao de valor Ã  variavel v_valor_bool.
- **Linha 95**: atribuicao de valor Ã  variavel v_valor_decimal.
- **Linha 96**: atribuicao de valor Ã  variavel v_valor_text.
- **Linha 97**: atribuicao de valor Ã  variavel v_valor_json.
- **Linha 98**: atribuicao de valor Ã  variavel v_valor_enum.
- **Linha 100**: Estrutura condicional de controle de fluxo.
- **Linha 101**: Invoca a procedure sp_assert_true.
- **Linha 102**: atribuicao de valor Ã  variavel v_valor_bool.
- **Linha 103**: atribuicao de valor Ã  variavel v_valor_int.
- **Linha 104**: atribuicao de valor Ã  variavel v_valor_text.
- **Linha 105**: atribuicao de valor Ã  variavel v_valor_json.
- **Linha 106**: atribuicao de valor Ã  variavel v_valor_enum.
- **Linha 108**: Estrutura condicional de controle de fluxo.
- **Linha 109**: Invoca a procedure sp_assert_true.
- **Linha 110**: atribuicao de valor Ã  variavel v_valor_bool.
- **Linha 111**: atribuicao de valor Ã  variavel v_valor_int.
- **Linha 112**: atribuicao de valor Ã  variavel v_valor_decimal.
- **Linha 113**: atribuicao de valor Ã  variavel v_valor_json.
- **Linha 114**: atribuicao de valor Ã  variavel v_valor_enum.
- **Linha 116**: Estrutura condicional de controle de fluxo.
- **Linha 117**: Invoca a procedure sp_assert_true.
- **Linha 118**: atribuicao de valor Ã  variavel v_valor_bool.
- **Linha 119**: atribuicao de valor Ã  variavel v_valor_int.
- **Linha 120**: atribuicao de valor Ã  variavel v_valor_decimal.
- **Linha 121**: atribuicao de valor Ã  variavel v_valor_text.
- **Linha 122**: atribuicao de valor Ã  variavel v_valor_enum.
- **Linha 124**: Estrutura condicional de controle de fluxo.
- **Linha 125**: Invoca a procedure sp_assert_true.
- **Linha 126**: Estrutura condicional de controle de fluxo.
- **Linha 127**: Invoca a procedure sp_assert_true.
- **Linha 128**: JSON_CONTAINS(v_enum_opcoes, JSON_QUOTE(v_valor_enum), '$'),
- **Linha 129**: 'PARAM',
- **Linha 130**: CONCAT('valor_enum inválido: ', v_valor_enum)
- **Linha 131**: );
- **Linha 132**: Estrutura condicional de controle de fluxo.
- **Linha 133**: atribuicao de valor Ã  variavel v_valor_bool.
- **Linha 134**: atribuicao de valor Ã  variavel v_valor_int.
- **Linha 135**: atribuicao de valor Ã  variavel v_valor_decimal.
- **Linha 136**: atribuicao de valor Ã  variavel v_valor_text.
- **Linha 137**: atribuicao de valor Ã  variavel v_valor_json.
- **Linha 139**: Estrutura condicional de controle de fluxo.
- **Linha 140**: Invoca a procedure sp_raise.
- **Linha 141**: Estrutura condicional de controle de fluxo.
- **Linha 143**: START TRANSACTION;
- **Linha 145**: Insere um novo registro na tabela painel_config.
- **Linha 146**: id_painel, chave,
- **Linha 147**: valor_bool, valor_int, valor_decimal, valor_text, valor_json, valor_enum,
- **Linha 148**: atualizado_em, id_sessao_usuario, id_usuario
- **Linha 149**: ) VALUES (
- **Linha 150**: p_id_painel, p_chave,
- **Linha 151**: v_valor_bool, v_valor_int, v_valor_decimal, v_valor_text, v_valor_json, v_valor_enum,
- **Linha 152**: NOW(), p_id_sessao_usuario, v_id_usuario
- **Linha 153**: fechamento da lista de Parametros.
- **Linha 154**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 155**: valor_bool       = VALUES(valor_bool),
- **Linha 156**: valor_int        = VALUES(valor_int),
- **Linha 157**: valor_decimal    = VALUES(valor_decimal),
- **Linha 158**: valor_text       = VALUES(valor_text),
- **Linha 159**: valor_json       = VALUES(valor_json),
- **Linha 160**: valor_enum       = VALUES(valor_enum),
- **Linha 161**: atualizado_em    = VALUES(atualizado_em),
- **Linha 162**: id_sessao_usuario= VALUES(id_sessao_usuario),
- **Linha 163**: id_usuario       = VALUES(id_usuario);
- **Linha 165**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 166**: p_id_sessao_usuario,
- **Linha 167**: 'PAINEL',
- **Linha 168**: p_id_painel,
- **Linha 169**: 'CONFIG_SET',
- **Linha 170**: CONCAT('chave=',p_chave,' | tipo=',v_tipo),
- **Linha 171**: NULL,
- **Linha 172**: 'painel_config',
- **Linha 173**: NULL
- **Linha 174**: );
- **Linha 176**: COMMIT;
- **Linha 177**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_painel_config_set`(
    IN p_id_sessao_usuario BIGINT,
    IN p_id_painel         BIGINT,
    IN p_chave             VARCHAR(80),
    IN p_valor_bool        TINYINT,
    IN p_valor_int         INT,
    IN p_valor_decimal     DECIMAL(12,4),
    IN p_valor_text        TEXT,
    IN p_valor_json        JSON,
    IN p_valor_enum        VARCHAR(80)
)
main: BEGIN
    DECLARE v_id_usuario BIGINT;
    DECLARE v_tipo VARCHAR(10);
    DECLARE v_enum_opcoes JSON;

    DECLARE v_valor_bool TINYINT;
    DECLARE v_valor_int INT;
    DECLARE v_valor_decimal DECIMAL(12,4);
    DECLARE v_valor_text TEXT;
    DECLARE v_valor_json JSON;
    DECLARE v_valor_enum VARCHAR(80);

    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_sqlstate = RETURNED_SQLSTATE,
            v_errno    = MYSQL_ERRNO,
            v_msg      = MESSAGE_TEXT;

        SET @diag_sqlstate = v_sqlstate;
        SET @diag_errno    = v_errno;
        SET @diag_msg      = v_msg;

        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_painel_config_set', CONCAT('Falha ao setar config: ', IFNULL(p_chave,'(null)')));
        CALL sp_raise('ERRO_SQL', CONCAT(
            'ROTINA=sp_painel_config_set | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),
            ' | ERRNO=',IFNULL(v_errno,0),
            ' | MSG=',IFNULL(v_msg,'(n/a)'),
            ' | CTX=Falha ao setar config'
        ));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);

    SELECT su.id_usuario
      INTO v_id_usuario
      FROM sessao_usuario su
     WHERE su.id_sessao_usuario = p_id_sessao_usuario
       AND su.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(p_id_painel IS NOT NULL, 'PARAM', 'id_painel é obrigatório.');
    CALL sp_assert_true(p_chave IS NOT NULL AND LENGTH(TRIM(p_chave)) > 0, 'PARAM', 'chave é obrigatória.');

    CALL sp_assert_true(
        EXISTS (SELECT 1 FROM painel p WHERE p.id_painel = p_id_painel),
        'NOT_FOUND',
        'Painel não encontrado.'
    );

    SELECT d.tipo_valor, d.enum_opcoes_json
      INTO v_tipo, v_enum_opcoes
      FROM painel_config_def d
     WHERE d.chave = p_chave COLLATE utf8mb4_0900_ai_ci
       AND d.ativo = 1
     LIMIT 1;

    CALL sp_assert_true(v_tipo IS NOT NULL, 'NOT_FOUND', CONCAT('Chave não cadastrada/ativa em painel_config_def: ', p_chave));

    -- Copia valores de entrada para variáveis locais e zera conforme o tipo
    SET v_valor_bool    = p_valor_bool;
    SET v_valor_int     = p_valor_int;
    SET v_valor_decimal = p_valor_decimal;
    SET v_valor_text    = p_valor_text;
    SET v_valor_json    = p_valor_json;
    SET v_valor_enum    = p_valor_enum;

    IF v_tipo = 'BOOL' THEN
        CALL sp_assert_true(v_valor_bool IS NOT NULL, 'PARAM', 'valor_bool obrigatório para chave BOOL.');
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'INT' THEN
        CALL sp_assert_true(v_valor_int IS NOT NULL, 'PARAM', 'valor_int obrigatório para chave INT.');
        SET v_valor_bool = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'DECIMAL' THEN
        CALL sp_assert_true(v_valor_decimal IS NOT NULL, 'PARAM', 'valor_decimal obrigatório para chave DECIMAL.');
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'TEXT' THEN
        CALL sp_assert_true(v_valor_text IS NOT NULL, 'PARAM', 'valor_text obrigatório para chave TEXT.');
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_json = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'JSON' THEN
        CALL sp_assert_true(v_valor_json IS NOT NULL, 'PARAM', 'valor_json obrigatório para chave JSON.');
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_enum = NULL;

    ELSEIF v_tipo = 'ENUM' THEN
        CALL sp_assert_true(v_valor_enum IS NOT NULL AND LENGTH(TRIM(v_valor_enum)) > 0, 'PARAM', 'valor_enum obrigatório para chave ENUM.');
        IF v_enum_opcoes IS NOT NULL THEN
            CALL sp_assert_true(
                JSON_CONTAINS(v_enum_opcoes, JSON_QUOTE(v_valor_enum), '$'),
                'PARAM',
                CONCAT('valor_enum inválido: ', v_valor_enum)
            );
        END IF;
        SET v_valor_bool = NULL;
        SET v_valor_int = NULL;
        SET v_valor_decimal = NULL;
        SET v_valor_text = NULL;
        SET v_valor_json = NULL;

    ELSE
        CALL sp_raise('PARAM', CONCAT('tipo_valor inválido em painel_config_def: ', IFNULL(v_tipo,'(null)')));
    END IF;

    START TRANSACTION;

    INSERT INTO painel_config(
        id_painel, chave,
        valor_bool, valor_int, valor_decimal, valor_text, valor_json, valor_enum,
        atualizado_em, id_sessao_usuario, id_usuario
    ) VALUES (
        p_id_painel, p_chave,
        v_valor_bool, v_valor_int, v_valor_decimal, v_valor_text, v_valor_json, v_valor_enum,
        NOW(), p_id_sessao_usuario, v_id_usuario
    )
    ON DUPLICATE KEY UPDATE
        valor_bool       = VALUES(valor_bool),
        valor_int        = VALUES(valor_int),
        valor_decimal    = VALUES(valor_decimal),
        valor_text       = VALUES(valor_text),
        valor_json       = VALUES(valor_json),
        valor_enum       = VALUES(valor_enum),
        atualizado_em    = VALUES(atualizado_em),
        id_sessao_usuario= VALUES(id_sessao_usuario),
        id_usuario       = VALUES(id_usuario);

    CALL sp_auditoria_evento_registrar(
        p_id_sessao_usuario,
        'PAINEL',
        p_id_painel,
        'CONFIG_SET',
        CONCAT('chave=',p_chave,' | tipo=',v_tipo),
        NULL,
        'painel_config',
        NULL
    );

    COMMIT;
END ;;
```

