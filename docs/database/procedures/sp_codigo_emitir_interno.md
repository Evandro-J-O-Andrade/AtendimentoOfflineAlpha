# sp_codigo_emitir_interno

Objetivo: codigo emitir interno conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_sessao_usuario | BIGINT | IN | |
| p_dominio | ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO') | IN | |
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
- SELECT: protocolo_sequencia
- INSERT: codigo_universal, protocolo_emissao, protocolo_sequencia
- UPDATE: protocolo_sequencia
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- sp_auditar_erro_sql
- sp_auditoria_evento_registrar
- sp_codigo_prefixo_resolver
- sp_raise
- sp_sessao_assert

## Functions Utilizadas
- CONCAT
- CURRENT_DATE
- CURRENT_TIMESTAMP
- IF
- IFNULL
- JSON_OBJECT
- LAST_INSERT_ID
- TRIM

## Views Utilizadas
- v_chave_seq
- v_codigo
- v_prefixo_5
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
- **Linha 17**: fechamento da lista de Parametros.
- **Linha 18**: main: BEGIN
- **Linha 19**: Declaracao de variavel local v_sqlstate.
- **Linha 20**: Declaracao de variavel local v_errno.
- **Linha 21**: Declaracao de variavel local v_msg.
- **Linha 23**: Declaracao de variavel local v_prefixo_5.
- **Linha 24**: Declaracao de variavel local v_chave_seq.
- **Linha 25**: Declaracao de variavel local v_seq.
- **Linha 26**: Declaracao de variavel local v_codigo.
- **Linha 28**: Declaracao de variavel local EXIT.
- **Linha 29**: inicio do bloco de execucao.
- **Linha 30**: GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
- **Linha 31**: ROLLBACK;
- **Linha 32**: Invoca a procedure sp_auditar_erro_sql.
- **Linha 33**: Invoca a procedure sp_raise.
- **Linha 34**: Fim do bloco da procedure.
- **Linha 36**: Invoca a procedure sp_sessao_assert.
- **Linha 37**: atribuicao de valor Ã  variavel p_id_codigo.
- **Linha 38**: atribuicao de valor Ã  variavel p_codigo_interno.
- **Linha 40**: START TRANSACTION;
- **Linha 42** (Comentario): modo MANUAL: usa o código recebido e garante unicidade
- **Linha 43**: Estrutura condicional de controle de fluxo.
- **Linha 44**: atribuicao de valor Ã  variavel v_codigo.
- **Linha 46**: Insere um novo registro na tabela codigo_universal.
- **Linha 47**: dominio, prefixo_5, sequencia, codigo_interno, barcode, origem_interno,
- **Linha 48**: id_ffa,id_senha,id_paciente,id_produto,id_usuario,id_cliente,
- **Linha 49**: status,payload,id_sessao_usuario
- **Linha 50**: ) VALUES (
- **Linha 51**: p_dominio, NULL, NULL, v_codigo, v_codigo, 'MANUAL',
- **Linha 52**: p_id_ffa,p_id_senha,p_id_paciente,p_id_produto,p_id_usuario,p_id_cliente,
- **Linha 53**: 'ATIVO', p_payload, p_id_sessao_usuario
- **Linha 54**: );
- **Linha 56**: atribuicao de valor Ã  variavel p_id_codigo.
- **Linha 57**: atribuicao de valor Ã  variavel p_codigo_interno.
- **Linha 59**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 60**: 'dominio', p_dominio,
- **Linha 61**: 'modo', 'MANUAL',
- **Linha 62**: 'id_codigo', p_id_codigo,
- **Linha 63**: 'codigo_interno', p_codigo_interno
- **Linha 64**: ));
- **Linha 66**: COMMIT;
- **Linha 67**: Estrutura de repeticao/controle de loop.
- **Linha 68**: Estrutura condicional de controle de fluxo.
- **Linha 70** (Comentario): modo AUTO: resolve prefixo e gera sequencia via protocolo_sequencia (chave = DOMINIO|PREFIXO)
- **Linha 71**: Invoca a procedure sp_codigo_prefixo_resolver.
- **Linha 73**: atribuicao de valor Ã  variavel v_chave_seq.
- **Linha 75** (Comentario): garante linha
- **Linha 76**: Insere um novo registro na tabela protocolo_sequencia.
- **Linha 77**: VALUES(v_chave_seq, 0)
- **Linha 78**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 80** (Comentario): incrementa e trava
- **Linha 81**: execucao de query SELECT para consulta de dados.
- **Linha 82**: FROM protocolo_sequencia
- **Linha 83**: WHERE chave = v_chave_seq
- **Linha 84**: FOR UPDATE;
- **Linha 86**: atribuicao de valor Ã  variavel v_seq.
- **Linha 88**: UPDATE protocolo_sequencia
- **Linha 89**: atribuicao de valor Ã  variavel ultimo_numero.
- **Linha 90**: atualizado_em = CURRENT_TIMESTAMP
- **Linha 91**: WHERE chave = v_chave_seq;
- **Linha 93** (Comentario): formato NNNNN-0000 (seq com 4 dígitos)
- **Linha 94**: atribuicao de valor Ã  variavel v_codigo.
- **Linha 96**: Insere um novo registro na tabela codigo_universal.
- **Linha 97**: dominio, prefixo_5, sequencia, codigo_interno, barcode, origem_interno,
- **Linha 98**: id_ffa,id_senha,id_paciente,id_produto,id_usuario,id_cliente,
- **Linha 99**: status,payload,id_sessao_usuario
- **Linha 100**: ) VALUES (
- **Linha 101**: p_dominio, v_prefixo_5, v_seq, v_codigo, v_codigo, 'AUTO',
- **Linha 102**: p_id_ffa,p_id_senha,p_id_paciente,p_id_produto,p_id_usuario,p_id_cliente,
- **Linha 103**: 'ATIVO', p_payload, p_id_sessao_usuario
- **Linha 104**: );
- **Linha 106**: atribuicao de valor Ã  variavel p_id_codigo.
- **Linha 107**: atribuicao de valor Ã  variavel p_codigo_interno.
- **Linha 109** (Comentario): também registra em protocolo_emissao para relatórios/compatibilidade
- **Linha 110**: Insere um novo registro na tabela protocolo_emissao.
- **Linha 111**: VALUES(
- **Linha 112**: p_dominio,
- **Linha 113**: v_chave_seq,
- **Linha 114**: v_codigo,
- **Linha 115**: YEAR(CURRENT_DATE),
- **Linha 116**: CURRENT_DATE,
- **Linha 117**: p_id_sessao_usuario,
- **Linha 118**: p_id_usuario,
- **Linha 119**: p_id_paciente,
- **Linha 120**: p_id_ffa,
- **Linha 121**: p_id_senha,
- **Linha 122**: p_id_cliente,
- **Linha 123**: p_id_codigo
- **Linha 124**: );
- **Linha 126**: Invoca a procedure sp_auditoria_evento_registrar.
- **Linha 127**: 'dominio', p_dominio,
- **Linha 128**: 'modo', 'AUTO',
- **Linha 129**: 'id_codigo', p_id_codigo,
- **Linha 130**: 'codigo_interno', p_codigo_interno,
- **Linha 131**: 'prefixo_5', v_prefixo_5,
- **Linha 132**: 'sequencia', v_seq
- **Linha 133**: ));
- **Linha 135**: COMMIT;
- **Linha 136**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_codigo_emitir_interno`(
    IN  p_id_sessao_usuario BIGINT,
    IN  p_dominio ENUM('LAB','FARMACIA','ESTOQUE','FATURAMENTO','RH','PATRIMONIO','OUTRO'),
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

    DECLARE v_prefixo_5 CHAR(5);
    DECLARE v_chave_seq VARCHAR(80);
    DECLARE v_seq INT;
    DECLARE v_codigo VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_sqlstate = RETURNED_SQLSTATE, v_errno = MYSQL_ERRNO, v_msg = MESSAGE_TEXT;
        ROLLBACK;
        CALL sp_auditar_erro_sql(p_id_sessao_usuario, 'sp_codigo_emitir_interno', 'Falha ao emitir código interno');
        CALL sp_raise('ERRO_SQL', CONCAT('ROTINA=sp_codigo_emitir_interno | SQLSTATE=',IFNULL(v_sqlstate,'(n/a)'),' | ERRNO=',IFNULL(v_errno,0),' | MSG=',IFNULL(v_msg,'(n/a)')));
    END;

    CALL sp_sessao_assert(p_id_sessao_usuario);
    SET p_id_codigo = NULL;
    SET p_codigo_interno = NULL;

    START TRANSACTION;

    -- modo MANUAL: usa o código recebido e garante unicidade
    IF p_codigo_interno_manual IS NOT NULL AND TRIM(p_codigo_interno_manual) <> '' THEN
        SET v_codigo = TRIM(p_codigo_interno_manual);

        INSERT INTO codigo_universal(
          dominio, prefixo_5, sequencia, codigo_interno, barcode, origem_interno,
          id_ffa,id_senha,id_paciente,id_produto,id_usuario,id_cliente,
          status,payload,id_sessao_usuario
        ) VALUES (
          p_dominio, NULL, NULL, v_codigo, v_codigo, 'MANUAL',
          p_id_ffa,p_id_senha,p_id_paciente,p_id_produto,p_id_usuario,p_id_cliente,
          'ATIVO', p_payload, p_id_sessao_usuario
        );

        SET p_id_codigo = LAST_INSERT_ID();
        SET p_codigo_interno = v_codigo;

        CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_INTERNO_EMITIDO', JSON_OBJECT(
          'dominio', p_dominio,
          'modo', 'MANUAL',
          'id_codigo', p_id_codigo,
          'codigo_interno', p_codigo_interno
        ));

        COMMIT;
        LEAVE main;
    END IF;

    -- modo AUTO: resolve prefixo e gera sequencia via protocolo_sequencia (chave = DOMINIO|PREFIXO)
    CALL sp_codigo_prefixo_resolver(p_id_sessao_usuario, p_dominio, p_id_unidade, p_id_local_operacional, p_id_laboratorio, v_prefixo_5);

    SET v_chave_seq = CONCAT('CODIGO|', p_dominio, '|', v_prefixo_5);

    -- garante linha
    INSERT INTO protocolo_sequencia(chave, ultimo_numero)
    VALUES(v_chave_seq, 0)
    ON DUPLICATE KEY UPDATE atualizado_em = CURRENT_TIMESTAMP;

    -- incrementa e trava
    SELECT ultimo_numero INTO v_seq
      FROM protocolo_sequencia
     WHERE chave = v_chave_seq
     FOR UPDATE;

    SET v_seq = v_seq + 1;

    UPDATE protocolo_sequencia
       SET ultimo_numero = v_seq,
           atualizado_em = CURRENT_TIMESTAMP
     WHERE chave = v_chave_seq;

    -- formato NNNNN-0000 (seq com 4 dígitos)
    SET v_codigo = CONCAT(v_prefixo_5, '-', LPAD(v_seq, 4, '0'));

    INSERT INTO codigo_universal(
      dominio, prefixo_5, sequencia, codigo_interno, barcode, origem_interno,
      id_ffa,id_senha,id_paciente,id_produto,id_usuario,id_cliente,
      status,payload,id_sessao_usuario
    ) VALUES (
      p_dominio, v_prefixo_5, v_seq, v_codigo, v_codigo, 'AUTO',
      p_id_ffa,p_id_senha,p_id_paciente,p_id_produto,p_id_usuario,p_id_cliente,
      'ATIVO', p_payload, p_id_sessao_usuario
    );

    SET p_id_codigo = LAST_INSERT_ID();
    SET p_codigo_interno = v_codigo;

    -- também registra em protocolo_emissao para relatórios/compatibilidade
    INSERT INTO protocolo_emissao(tipo, chave, codigo, ano, data_ref, id_sessao_usuario, id_usuario, id_paciente, id_ffa, id_senha, id_cliente, id_codigo_universal)
    VALUES(
      p_dominio,
      v_chave_seq,
      v_codigo,
      YEAR(CURRENT_DATE),
      CURRENT_DATE,
      p_id_sessao_usuario,
      p_id_usuario,
      p_id_paciente,
      p_id_ffa,
      p_id_senha,
      p_id_cliente,
      p_id_codigo
    );

    CALL sp_auditoria_evento_registrar(p_id_sessao_usuario, 'CODIGO_INTERNO_EMITIDO', JSON_OBJECT(
      'dominio', p_dominio,
      'modo', 'AUTO',
      'id_codigo', p_id_codigo,
      'codigo_interno', p_codigo_interno,
      'prefixo_5', v_prefixo_5,
      'sequencia', v_seq
    ));

    COMMIT;
END ;;
```

