# sp_lab_protocolo_criar_ou_mapear

Objetivo: lab protocolo criar ou mapear conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_id_ffa | BIGINT | IN | |
| p_id_unidade | BIGINT | IN | |
| p_id_local_operacional | BIGINT | IN | |
| p_id_laboratorio | BIGINT | IN | |
| p_sistema_externo | VARCHAR(50) | IN | |
| p_codigo_externo | VARCHAR(80) | IN | |
| p_codigo_interno_manual | VARCHAR(50) | IN | |
| p_tipo_material | VARCHAR(50) | IN | |
| p_id_lab_protocolo | BIGINT | OUT | |
| p_codigo_amostra | VARCHAR(50) | OUT | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: lab_protocolo_interno
- INSERT: lab_protocolo_interno
- UPDATE: lab_protocolo_interno
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_assert_true
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_codigo_emitir_interno
- sp_codigo_mapear_externo
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- COALESCE
- CONCAT
- CURRENT_TIMESTAMP
- IF
- IFNULL
- JSON_OBJECT
- LAST_INSERT_ID
- NULLIF
- TRIM

## Views Utilizadas
- v_codigo_interno
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
- **Linha 13**: fechamento da lista de Parametros.
- **Linha 14**: main: BEGIN
- **Linha 15**: Declaracao de variavel local v_sqlstate.
- **Linha 16**: Declaracao de variavel local v_errno.
- **Linha 17**: Declaracao de variavel local v_msg.
- **Linha 19**: Declaracao de variavel local v_id_codigo.
- **Linha 20**: Declaracao de variavel local v_codigo_interno.
- **Linha 22**: Declaracao de variavel local EXIT.
- **Linha 23**: inicio do bloco de execucao.
- **Linha 24**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 25**: ROLLBACK;
- **Linha 26**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 27**: Invoca a procedure sp_raise.
- **Linha 28**: Fim do bloco da procedure.
- **Linha 30**: Invoca a procedure sp_sessao_assert.
- **Linha 31**: Invoca a procedure sp_assert_true.
- **Linha 33**: atribuicao de valor Ã  variavel p_id_lab_protocolo.
- **Linha 34**: atribuicao de valor Ã  variavel p_codigo_amostra.
- **Linha 36**: START TRANSACTION;
- **Linha 38** (Comentario): 1) resolve/cria código (com externo se vier)
- **Linha 39**: Estrutura condicional de controle de fluxo.
- **Linha 40**: Invoca a procedure sp_codigo_mapear_externo.
- **Linha 41**: p_id_sessao_usuario,
- **Linha 42**: 'LAB',
- **Linha 43**: p_sistema_externo,
- **Linha 44**: p_codigo_externo,
- **Linha 45**: p_id_unidade,
- **Linha 46**: p_id_local_operacional,
- **Linha 47**: p_id_laboratorio,
- **Linha 48**: p_codigo_interno_manual,
- **Linha 49**: p_id_ffa,
- **Linha 50**: NULL,
- **Linha 51**: NULL,
- **Linha 52**: NULL,
- **Linha 53**: NULL,
- **Linha 54**: NULL,
- **Linha 55**: JSON_OBJECT('tipo_material', p_tipo_material),
- **Linha 56**: v_id_codigo,
- **Linha 57**: v_codigo_interno
- **Linha 58**: );
- **Linha 59**: Estrutura condicional de controle de fluxo.
- **Linha 60**: Invoca a procedure sp_codigo_emitir_interno.
- **Linha 61**: p_id_sessao_usuario,
- **Linha 62**: 'LAB',
- **Linha 63**: p_id_unidade,
- **Linha 64**: p_id_local_operacional,
- **Linha 65**: p_id_laboratorio,
- **Linha 66**: p_codigo_interno_manual,
- **Linha 67**: p_id_ffa,
- **Linha 68**: NULL,
- **Linha 69**: NULL,
- **Linha 70**: NULL,
- **Linha 71**: NULL,
- **Linha 72**: NULL,
- **Linha 73**: JSON_OBJECT('tipo_material', p_tipo_material),
- **Linha 74**: v_id_codigo,
- **Linha 75**: v_codigo_interno
- **Linha 76**: );
- **Linha 77**: Estrutura condicional de controle de fluxo.
- **Linha 79** (Comentario): 2) garante registro lab_protocolo_interno (1 por FFA por padrão; se quiser múltiplas amostras, muda regra depois)
- **Linha 80**: execucao de query SELECT para consulta de dados.
- **Linha 81**: INTO p_id_lab_protocolo, p_codigo_amostra
- **Linha 82**: FROM lab_protocolo_interno
- **Linha 83**: WHERE id_ffa = p_id_ffa
- **Linha 84**: LIMIT 1
- **Linha 85**: FOR UPDATE;
- **Linha 87**: Estrutura condicional de controle de fluxo.
- **Linha 88**: Insere um novo registro na tabela lab_protocolo_interno.
- **Linha 89**: id_ffa, codigo_amostra, barcode, tipo_material, status_laboratorial, impresso,
- **Linha 90**: id_codigo_universal, sistema_externo, codigo_externo, coletado_em
- **Linha 91**: ) VALUES (
- **Linha 92**: p_id_ffa, v_codigo_interno, v_codigo_interno, p_tipo_material, 'COLETADO', 0,
- **Linha 93**: v_id_codigo,
- **Linha 94**: NULLIF(TRIM(p_sistema_externo),''),
- **Linha 95**: NULLIF(TRIM(p_codigo_externo),''),
- **Linha 96**: CURRENT_TIMESTAMP
- **Linha 97**: );
- **Linha 98**: atribuicao de valor Ã  variavel p_id_lab_protocolo.
- **Linha 99**: atribuicao de valor Ã  variavel p_codigo_amostra.
- **Linha 100**: Estrutura condicional de controle de fluxo.
- **Linha 101**: UPDATE lab_protocolo_interno
- **Linha 102**: atribuicao de valor Ã  variavel codigo_amostra.
- **Linha 103**: barcode = v_codigo_interno,
- **Linha 104**: tipo_material = COALESCE(p_tipo_material, tipo_material),
- **Linha 105**: id_codigo_universal = v_id_codigo,
- **Linha 106**: sistema_externo = NULLIF(TRIM(p_sistema_externo),''),
- **Linha 107**: codigo_externo  = NULLIF(TRIM(p_codigo_externo),''),
- **Linha 108**: atualizado_em = CURRENT_TIMESTAMP
- **Linha 109**: WHERE id = p_id_lab_protocolo;
- **Linha 110**: atribuicao de valor Ã  variavel p_codigo_amostra.
- **Linha 111**: Estrutura condicional de controle de fluxo.
- **Linha 113**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 114**: 'id_ffa', p_id_ffa,
- **Linha 115**: 'id_lab_protocolo', p_id_lab_protocolo,
- **Linha 116**: 'id_codigo', v_id_codigo,
- **Linha 117**: 'codigo_amostra', p_codigo_amostra,
- **Linha 118**: 'sistema_externo', NULLIF(TRIM(p_sistema_externo),''),
- **Linha 119**: 'codigo_externo', NULLIF(TRIM(p_codigo_externo),'')
- **Linha 120**: ));
- **Linha 122**: COMMIT;
- **Linha 123**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_lab_protocolo_criar_ou_mapear`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_id_ffa BIGINT,
    IN  p_id_unidade BIGINT,
    IN  p_id_local_operacional BIGINT,
    IN  p_id_laboratorio BIGINT,
    IN  p_sistema_externo VARCHAR(50),
    IN  p_codigo_externo VARCHAR(80),
    IN  p_codigo_interno_manual VARCHAR(50),
    IN  p_tipo_material VARCHAR(50),
    OUT p_id_lab_protocolo BIGINT,
    OUT p_codigo_amostra VARCHAR(50)
)
main: BEGIN
    DECLARE v_sqlstate VARCHAR(10);
    DECLARE v_errno INT;
    DECLARE v_msg TEXT;

    DECLARE v_id_codigo BIGINT;
    DECLARE v_codigo_interno VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_lab_protocolo_criar_ou_mapear', 'Falha lab protocolo');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_lab_protocolo_criar_ou_mapear | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    CALL sp_assert_true(p_id_ffa IS NOT NULL, 'PARAM', 'id_ffa é obrigatório.');

    SET p_id_lab_protocolo = NULL;
    SET p_codigo_amostra = NULL;

    START TRANSACTION;

    -- 1) resolve/cria código (com externo se vier)
    IF p_sistema_externo IS NOT NULL AND TRIM(p_sistema_externo) <> '' AND p_codigo_externo IS NOT NULL AND TRIM(p_codigo_externo) <> '' THEN
      CALL sp_codigo_mapear_externo(
        p_id_sessao_usuario,
        'LAB',
        p_sistema_externo,
        p_codigo_externo,
        p_id_unidade,
        p_id_local_operacional,
        p_id_laboratorio,
        p_codigo_interno_manual,
        p_id_ffa,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        JSON_OBJECT('tipo_material', p_tipo_material),
        v_id_codigo,
        v_codigo_interno
      );
    ELSE
      CALL sp_codigo_emitir_interno(
        p_id_sessao_usuario,
        'LAB',
        p_id_unidade,
        p_id_local_operacional,
        p_id_laboratorio,
        p_codigo_interno_manual,
        p_id_ffa,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        JSON_OBJECT('tipo_material', p_tipo_material),
        v_id_codigo,
        v_codigo_interno
      );
    END IF;

    -- 2) garante registro lab_protocolo_interno (1 por FFA por padrão; se quiser múltiplas amostras, muda regra depois)
    SELECT id, codigo_amostra
      INTO p_id_lab_protocolo, p_codigo_amostra
      FROM lab_protocolo_interno
     WHERE id_ffa = p_id_ffa
     LIMIT 1
     FOR UPDATE;

    IF p_id_lab_protocolo IS NULL THEN
      INSERT INTO lab_protocolo_interno(
        id_ffa, codigo_amostra, barcode, tipo_material, status_laboratorial, impresso,
        id_codigo_universal, sistema_externo, codigo_externo, coletado_em
      ) VALUES (
        p_id_ffa, v_codigo_interno, v_codigo_interno, p_tipo_material, 'COLETADO', 0,
        v_id_codigo,
        NULLIF(TRIM(p_sistema_externo),''),
        NULLIF(TRIM(p_codigo_externo),''),
        CURRENT_TIMESTAMP
      );
      SET p_id_lab_protocolo = LAST_INSERT_ID();
      SET p_codigo_amostra = v_codigo_interno;
    ELSE
      UPDATE lab_protocolo_interno
         SET codigo_amostra = v_codigo_interno,
             barcode = v_codigo_interno,
             tipo_material = COALESCE(p_tipo_material, tipo_material),
             id_codigo_universal = v_id_codigo,
             sistema_externo = NULLIF(TRIM(p_sistema_externo),''),
             codigo_externo  = NULLIF(TRIM(p_codigo_externo),''),
             atualizado_em = CURRENT_TIMESTAMP
       WHERE id = p_id_lab_protocolo;
      SET p_codigo_amostra = v_codigo_interno;
    END IF;

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'LAB_PROTOCOLO_CRIADO', JSON_OBJECT(
      'id_ffa', p_id_ffa,
      'id_lab_protocolo', p_id_lab_protocolo,
      'id_codigo', v_id_codigo,
      'codigo_amostra', p_codigo_amostra,
      'sistema_externo', NULLIF(TRIM(p_sistema_externo),''),
      'codigo_externo', NULLIF(TRIM(p_codigo_externo),'')
    ));

    COMMIT;
END ;;
```

