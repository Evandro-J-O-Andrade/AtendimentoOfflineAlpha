# sp_codigo_mapear_externo

Objetivo: codigo mapear externo conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_dominio | ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | IN | |
| p_sistema_externo | VARCHAR(50) | IN | |
| p_codigo_externo | VARCHAR(80) | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_id_laboratorio | BIGINT | IN | |
| p_codigo_interno_manual | VARCHAR(50) | IN | |
| p_id_ffa | BIGINT | IN | |
| p_id_senha | BIGINT | IN | |
| p_id_paciente | BIGINT | IN | |
| p_id_produto | INT | IN | |
| p_id_usuario | BIGINT | IN | |
| p_id_cliente | BIGINT | IN | |
| p_payload | JSON | IN | |
| p_id_codigo | BIGINT | OUT | |
| p_codigo_interno | VARCHAR(50) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: codigo_externo_map, codigo_universal
- INSERT: codigo_externo_map
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_codigo_emitir_interno
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- IF
- IFNULL
- JSON_OBJECT
- TRIM

## Views Utilizadas
- v_sqlstate

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
- **Linha 11**: Declaracao de parÃ¢metro.
- **Linha 12**: Declaracao de parÃ¢metro.
- **Linha 13**: Declaracao de parÃ¢metro.
- **Linha 14**: Declaracao de parÃ¢metro.
- **Linha 15**: Declaracao de parÃ¢metro.
- **Linha 16**: Declaracao de parÃ¢metro.
- **Linha 17**: Declaracao de parÃ¢metro.
- **Linha 18**: Declaracao de parÃ¢metro.
- **Linha 19**: fechamento da lista de Parametros.
- **Linha 20**: main: BEGIN
- **Linha 21**: Declaracao de variavel local v_sqlstate.
- **Linha 22**: Declaracao de variavel local v_errno.
- **Linha 23**: Declaracao de variavel local v_msg.
- **Linha 25**: Declaracao de variavel local v_id_codigo_existente.
- **Linha 27**: Declaracao de variavel local EXIT.
- **Linha 28**: inicio do bloco de execucao.
- **Linha 29**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 30**: ROLLBACK;
- **Linha 31**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 32**: Invoca a procedure sp_raise.
- **Linha 33**: Fim do bloco da procedure.
- **Linha 35**: Invoca a procedure sp_sessao_assert.
- **Linha 36**: Invoca a procedure sp_assert_true.
- **Linha 37**: Invoca a procedure sp_assert_true.
- **Linha 39**: atribuicao de valor Ã  variavel p_id_codigo.
- **Linha 40**: atribuicao de valor Ã  variavel p_codigo_interno.
- **Linha 42**: START TRANSACTION;
- **Linha 44** (Comentario): se já existe mapeamento, devolve
- **Linha 45**: execucao de query SELECT para consulta de dados.
- **Linha 46**: INTO v_id_codigo_existente
- **Linha 47**: FROM codigo_externo_map m
- **Linha 48**: WHERE m.dominio = p_dominio
- **Linha 51**: LIMIT 1
- **Linha 52**: FOR UPDATE;
- **Linha 54**: Estrutura condicional de controle de fluxo.
- **Linha 55**: execucao de query SELECT para consulta de dados.
- **Linha 56**: INTO p_id_codigo, p_codigo_interno
- **Linha 57**: FROM codigo_universal c
- **Linha 58**: WHERE c.id_codigo = v_id_codigo_existente
- **Linha 59**: LIMIT 1;
- **Linha 61**: COMMIT;
- **Linha 62**: Estrutura de repeticao/controle de loop.
- **Linha 63**: Estrutura condicional de controle de fluxo.
- **Linha 65** (Comentario): não existe: cria interno (AUTO ou MANUAL)
- **Linha 66**: Invoca a procedure sp_codigo_emitir_interno.
- **Linha 67**: p_id_sessao_usuario,
- **Linha 68**: p_dominio,
- **Linha 69**: p_id_unidade,
- **Linha 70**: p_id_local_operacional,
- **Linha 71**: p_id_laboratorio,
- **Linha 72**: p_codigo_interno_manual,
- **Linha 73**: p_id_ffa,
- **Linha 74**: p_id_senha,
- **Linha 75**: p_id_paciente,
- **Linha 76**: p_id_produto,
- **Linha 77**: p_id_usuario,
- **Linha 78**: p_id_cliente,
- **Linha 79**: p_payload,
- **Linha 80**: p_id_codigo,
- **Linha 81**: p_codigo_interno
- **Linha 82**: );
- **Linha 84**: Insere um novo registro na tabela codigo_externo_map.
- **Linha 85**: id_codigo, dominio, sistema_externo, codigo_externo, modo_cadastro, observacao, payload, id_sessao_usuario
- **Linha 86**: ) VALUES (
- **Linha 87**: p_id_codigo, p_dominio, TRIM(p_sistema_externo), TRIM(p_codigo_externo),
- **Linha 88**: 'MANUAL', NULL, NULL, p_id_sessao_usuario
- **Linha 89**: );
- **Linha 91**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 92**: 'dominio', p_dominio,
- **Linha 93**: 'sistema_externo', TRIM(p_sistema_externo),
- **Linha 94**: 'codigo_externo', TRIM(p_codigo_externo),
- **Linha 95**: 'id_codigo', p_id_codigo,
- **Linha 96**: 'codigo_interno', p_codigo_interno
- **Linha 97**: ));
- **Linha 99**: COMMIT;
- **Linha 100**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_mapear_externo`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_dominio ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO'),
    IN  p_sistema_externo VARCHAR(50),
    IN  p_codigo_externo VARCHAR(80),
    IN  p_id_unidade BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_id_laboratorio BIGINT,
    IN  p_codigo_interno_manual VARCHAR(50),
    IN  p_id_ffa BIGINT,
    IN  p_id_senha BIGINT,
    IN  p_id_paciente BIGINT,
    IN  p_id_produto INT,
    IN  p_id_usuario BIGINT,
    IN  p_id_cliente BIGINT,
    IN  p_payload JSON,
    OUT p_id_codigo BIGINT,
    OUT p_codigo_interno VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo_existente BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_mapear_externo', 'Falha ao mapear código externo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_mapear_externo | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_sistema_externo IS NOT NULL AND TRIM(p_sistema_externo) <> '', 'PARAM', 'sistema_externo é obrigatório.');
    CALL sp_assert_true(p_codigo_externo IS NOT NULL AND TRIM(p_codigo_externo) <> '', 'PARAM', 'codigo_externo é obrigatório.');

    SET p_id_codigo = NULL;
    SET p_codigo_interno = NULL;

    START TRANSACTION;

    -- se já existe mapeamento, devolve
    SELECT m.id_codigo
      INTO v_id_codigo_existente
      FROM codigo_externo_map m
     WHERE m.dominio = p_dominio
       AND m.sistema_externo = TRIM(p_sistema_externo)
       AND m.codigo_externo = TRIM(p_codigo_externo)
     LIMIT 1
     FOR UPDATE;

    IF v_id_codigo_existente IS NOT NULL THEN
        SELECT c.id_codigo, c.codigo_interno
          INTO p_id_codigo, p_codigo_interno
          FROM codigo_universal c
         WHERE c.id_codigo = v_id_codigo_existente
         LIMIT 1;

        COMMIT;
        LEAVE main;
    END IF;

    -- não existe: cria interno (AUTO ou MANUAL)
    CALL sp_codigo_emitir_interno(
      p_id_sessao_usuario,
      p_dominio,
      p_id_unidade,
      p_id_local_operacional,
      p_id_laboratorio,
      p_codigo_interno_manual,
      p_id_ffa,
      p_id_senha,
      p_id_paciente,
      p_id_produto,
      p_id_usuario,
      p_id_cliente,
      p_payload,
      p_id_codigo,
      p_codigo_interno
    );

    INSERT INTO codigo_externo_map(
      id_codigo, dominio, sistema_externo, codigo_externo, modo_cadastro, observacao, payload, id_sessao_usuario
    ) VALUES (
      p_id_codigo, p_dominio, TRIM(p_sistema_externo), TRIM(p_codigo_externo),
      'MANUAL', NULL, NULL, p_id_sessao_usuario
    );

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_EXTERNO_MAPEADO', JSON_OBJECT(
      'dominio', p_dominio,
      'sistema_externo', TRIM(p_sistema_externo),
      'codigo_externo', TRIM(p_codigo_externo),
      'id_codigo', p_id_codigo,
      'codigo_interno', p_codigo_interno
    ));

    COMMIT;
END ;;
```

