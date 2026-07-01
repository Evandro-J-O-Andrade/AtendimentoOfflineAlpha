# sp_painel_seed_especialidades

Objetivo: painel seed especialidades conforme definida no dump SQL do sistema.

## Parametros
| Nome | Tipo | Direcao | Descricao |
|------|------|---------|-----------|
| p_id_unidade | BIGINT | IN | |
| p_id_sistema | BIGINT | IN | |

## Retorno

Procedure sem valor de Retorno explicito (procedimento SQL).

## Validacoes

- Validacoes implementadas diretamente no corpo da procedure via queries SELECT INTO e verificaÃ§Ãµes de contagem/condicao.

## Regras de Negocio

- Regras implicitas na Logica da procedure, verificadas via relacionamentos entre tabelas e restricoes em clausulas WHERE e JOIN.

## tabelas Utilizadas
- SELECT: DUAL, painel, painel_lane
- INSERT: painel, painel_config, painel_lane
- UPDATE: (nenhuma)
- DELETE: painel_lane

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- CURRENT_TIMESTAMP
- JSON_ARRAY

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
- **Linha 4**: fechamento da lista de Parametros.
- **Linha 5**: inicio do bloco de execucao.
- **Linha 6**: Declaracao de variavel local v_id.
- **Linha 8** (Comentario): Helper: cria painel se não existir (por código) e retorna id
- **Linha 9** (Comentario): OBS: tipo='PAINEL' (uso público). Se quiser painel interno, crie outro tipo mais tarde.
- **Linha 10** (Comentario): Recepção Adulto
- **Linha 11**: Insere um novo registro na tabela painel.
- **Linha 12**: execucao de query SELECT para consulta de dados.
- **Linha 13**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RECEPCAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 14**: execucao de query SELECT para consulta de dados.
- **Linha 16**: Insere um novo registro na tabela painel_config.
- **Linha 17**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('REC01','REC02','REC03','REC04'), NULL, NULL)
- **Linha 18**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 20** (Comentario): lanes (adulto + prioritário)
- **Linha 21**: Remove registros da tabela painel_lane.
- **Linha 22**: Insere um novo registro na tabela painel_lane.
- **Linha 24** (Comentario): Recepção Pedi
- **Linha 25**: Insere um novo registro na tabela painel.
- **Linha 26**: execucao de query SELECT para consulta de dados.
- **Linha 27**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RECEPCAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 28**: execucao de query SELECT para consulta de dados.
- **Linha 30**: Insere um novo registro na tabela painel_config.
- **Linha 31**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('REC01','REC02','REC03','REC04'), NULL, NULL)
- **Linha 32**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 34**: Remove registros da tabela painel_lane.
- **Linha 35**: Insere um novo registro na tabela painel_lane.
- **Linha 37** (Comentario): Triagem Adulto
- **Linha 38**: Insere um novo registro na tabela painel.
- **Linha 39**: execucao de query SELECT para consulta de dados.
- **Linha 40**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_TRIAGEM_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 41**: execucao de query SELECT para consulta de dados.
- **Linha 43**: Insere um novo registro na tabela painel_config.
- **Linha 44**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('TRI01','TRI02','TRI03','TRI04'), NULL, NULL)
- **Linha 45**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 47**: Remove registros da tabela painel_lane.
- **Linha 48**: Insere um novo registro na tabela painel_lane.
- **Linha 50** (Comentario): Triagem Pedi
- **Linha 51**: Insere um novo registro na tabela painel.
- **Linha 52**: execucao de query SELECT para consulta de dados.
- **Linha 53**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_TRIAGEM_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 54**: execucao de query SELECT para consulta de dados.
- **Linha 56**: Insere um novo registro na tabela painel_config.
- **Linha 57**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('TRI01','TRI02','TRI03','TRI04'), NULL, NULL)
- **Linha 58**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 60**: Remove registros da tabela painel_lane.
- **Linha 61**: Insere um novo registro na tabela painel_lane.
- **Linha 63** (Comentario): Médico Clínico
- **Linha 64**: Insere um novo registro na tabela painel.
- **Linha 65**: execucao de query SELECT para consulta de dados.
- **Linha 66**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICO_CLINICO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 67**: execucao de query SELECT para consulta de dados.
- **Linha 69**: Insere um novo registro na tabela painel_config.
- **Linha 70**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('CLI01','CLI02','CLI03','CLI04','CLI05'), NULL, NULL)
- **Linha 71**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 73**: Remove registros da tabela painel_lane.
- **Linha 74**: Insere um novo registro na tabela painel_lane.
- **Linha 76** (Comentario): Médico Pediátrico
- **Linha 77**: Insere um novo registro na tabela painel.
- **Linha 78**: execucao de query SELECT para consulta de dados.
- **Linha 79**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 80**: execucao de query SELECT para consulta de dados.
- **Linha 82**: Insere um novo registro na tabela painel_config.
- **Linha 83**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('PED01','PED02','PED03','PED04'), NULL, NULL)
- **Linha 84**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 86**: Remove registros da tabela painel_lane.
- **Linha 87**: Insere um novo registro na tabela painel_lane.
- **Linha 89** (Comentario): Medicação Adulto
- **Linha 90**: Insere um novo registro na tabela painel.
- **Linha 91**: execucao de query SELECT para consulta de dados.
- **Linha 92**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICACAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 93**: execucao de query SELECT para consulta de dados.
- **Linha 95**: Insere um novo registro na tabela painel_config.
- **Linha 96**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('MED01','MED02','MED03','MED04'), NULL, NULL)
- **Linha 97**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 99**: Remove registros da tabela painel_lane.
- **Linha 100**: Insere um novo registro na tabela painel_lane.
- **Linha 102** (Comentario): Medicação Pedi
- **Linha 103**: Insere um novo registro na tabela painel.
- **Linha 104**: execucao de query SELECT para consulta de dados.
- **Linha 105**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICACAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 106**: execucao de query SELECT para consulta de dados.
- **Linha 108**: Insere um novo registro na tabela painel_config.
- **Linha 109**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('MEDP01','MEDP02','MEDP03','MEDP04'), NULL, NULL)
- **Linha 110**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 112**: Remove registros da tabela painel_lane.
- **Linha 113**: Insere um novo registro na tabela painel_lane.
- **Linha 115** (Comentario): RX (sem filtro de lane)
- **Linha 116**: Insere um novo registro na tabela painel.
- **Linha 117**: execucao de query SELECT para consulta de dados.
- **Linha 118**: WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RX' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
- **Linha 119**: execucao de query SELECT para consulta de dados.
- **Linha 121**: Insere um novo registro na tabela painel_config.
- **Linha 122**: VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('RX01','RX02'), NULL, NULL)
- **Linha 123**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 125** (Comentario): opcional: não seta painel_lane -> mostra todas as lanes
- **Linha 127**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_painel_seed_especialidades`(
    IN p_id_unidade BIGINT,
    IN p_id_sistema BIGINT
)
BEGIN
    DECLARE v_id BIGINT;

    -- Helper: cria painel se não existir (por código) e retorna id
    -- OBS: tipo='PAINEL' (uso público). Se quiser painel interno, crie outro tipo mais tarde.
    -- Recepção Adulto
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_RECEPCAO_ADULTO','PAINEL','Recepção - Adulto',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RECEPCAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_RECEPCAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('REC01','REC02','REC03','REC04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    -- lanes (adulto + prioritário)
    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Recepção Pedi
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_RECEPCAO_PEDI','PAINEL','Recepção - Pediátrico',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RECEPCAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_RECEPCAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('REC01','REC02','REC03','REC04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- Triagem Adulto
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_TRIAGEM_ADULTO','PAINEL','Triagem - Adulto',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_TRIAGEM_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_TRIAGEM_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('TRI01','TRI02','TRI03','TRI04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Triagem Pedi
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_TRIAGEM_PEDI','PAINEL','Triagem - Pediátrico',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_TRIAGEM_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_TRIAGEM_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('TRI01','TRI02','TRI03','TRI04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- Médico Clínico
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICO_CLINICO','PAINEL','Médico - Clínico',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICO_CLINICO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICO_CLINICO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('CLI01','CLI02','CLI03','CLI04','CLI05'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Médico Pediátrico
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICO_PEDI','PAINEL','Médico - Pediatria',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('PED01','PED02','PED03','PED04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- Medicação Adulto
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICACAO_ADULTO','PAINEL','Medicação - Adulto',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICACAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICACAO_ADULTO' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('MED01','MED02','MED03','MED04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'ADULTO'),(v_id,'PRIORITARIO');

    -- Medicação Pedi
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_MEDICACAO_PEDI','PAINEL','Medicação - Pediátrica',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_MEDICACAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_MEDICACAO_PEDI' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('MEDP01','MEDP02','MEDP03','MEDP04'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    DELETE FROM painel_lane WHERE id_painel=v_id;
    INSERT INTO painel_lane(id_painel,lane) VALUES (v_id,'PEDIATRICO'),(v_id,'PRIORITARIO');

    -- RX (sem filtro de lane)
    INSERT INTO painel (codigo,tipo,nome,id_unidade,id_sistema,ativo,intervalo_segundos)
    SELECT 'PAINEL_RX','PAINEL','Raio-X',p_id_unidade,p_id_sistema,1,5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM painel WHERE codigo='PAINEL_RX' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema);
    SELECT id_painel INTO v_id FROM painel WHERE codigo='PAINEL_RX' AND id_unidade=p_id_unidade AND id_sistema=p_id_sistema LIMIT 1;

    INSERT INTO painel_config(id_painel,chave,valor_json,id_usuario,id_sessao_usuario)
    VALUES (v_id,'FILTRO_LOCAIS_CODIGOS_JSON', JSON_ARRAY('RX01','RX02'), NULL, NULL)
    ON DUPLICATE KEY UPDATE valor_json=VALUES(valor_json), atualizado_em=CURRENT_TIMESTAMP;

    -- opcional: não seta painel_lane -> mostra todas as lanes

END ;;
```

