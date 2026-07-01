# sp_local_operacional_seed_padrao

Objetivo: local operacional seed padrao conforme definida no dump SQL do sistema.

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
- SELECT: (nenhuma)
- INSERT: local_operacional
- UPDATE: (nenhuma)
- DELETE: (nenhuma)

## Chamadas para outras Procedures
- (nenhuma)

## Functions Utilizadas
- COALESCE
- CURRENT_TIMESTAMP
- NULLIF

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
- **Linha 6** (Comentario): UPSERT helper: atualiza sala somente se estiver NULL/vazia
- **Linha 7** (Comentario): Observação: este seed é "vendável" (códigos canônicos) e pode ser reexecutado.
- **Linha 9** (Comentario): ========== RECEPÇÃO (guichês) ==========
- **Linha 10**: Insere um novo registro na tabela local_operacional.
- **Linha 11**: VALUES
- **Linha 12**: (p_id_unidade,p_id_sistema,'REC01','Recepção - Guichê 1','RECEPCAO','1',1,1,1,0),
- **Linha 13**: (p_id_unidade,p_id_sistema,'REC02','Recepção - Guichê 2','RECEPCAO','2',1,1,1,0),
- **Linha 14**: (p_id_unidade,p_id_sistema,'REC03','Recepção - Guichê 3','RECEPCAO','3',1,1,1,0),
- **Linha 15**: (p_id_unidade,p_id_sistema,'REC04','Recepção - Guichê 4','RECEPCAO','4',1,1,1,0),
- **Linha 16**: (p_id_unidade,p_id_sistema,'RECEPCAO_ND','[NAO DEFINIDA] RECEPÇÃO','RECEPCAO',NULL,1,0,0,1)
- **Linha 17**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 18**: nome = VALUES(nome),
- **Linha 19**: tipo = VALUES(tipo),
- **Linha 20**: sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
- **Linha 21**: ativo = VALUES(ativo),
- **Linha 22**: exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
- **Linha 23**: gera_tts_publico = VALUES(gera_tts_publico),
- **Linha 24**: eh_nao_definida = VALUES(eh_nao_definida),
- **Linha 25**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 27** (Comentario): ========== TRIAGEM (salas) ==========
- **Linha 28**: Insere um novo registro na tabela local_operacional.
- **Linha 29**: VALUES
- **Linha 30**: (p_id_unidade,p_id_sistema,'TRI01','Triagem - Sala 1','TRIAGEM','1',1,1,1,0),
- **Linha 31**: (p_id_unidade,p_id_sistema,'TRI02','Triagem - Sala 2','TRIAGEM','2',1,1,1,0),
- **Linha 32**: (p_id_unidade,p_id_sistema,'TRI03','Triagem - Sala 3','TRIAGEM','3',1,1,1,0),
- **Linha 33**: (p_id_unidade,p_id_sistema,'TRI04','Triagem - Sala 4','TRIAGEM','4',1,1,1,0),
- **Linha 34**: (p_id_unidade,p_id_sistema,'TRIAGEM_ND','[NAO DEFINIDA] TRIAGEM','TRIAGEM',NULL,1,0,0,1)
- **Linha 35**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 36**: nome = VALUES(nome),
- **Linha 37**: tipo = VALUES(tipo),
- **Linha 38**: sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
- **Linha 39**: ativo = VALUES(ativo),
- **Linha 40**: exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
- **Linha 41**: gera_tts_publico = VALUES(gera_tts_publico),
- **Linha 42**: eh_nao_definida = VALUES(eh_nao_definida),
- **Linha 43**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 45** (Comentario): ========== MÉDICO CLÍNICO ==========
- **Linha 46**: Insere um novo registro na tabela local_operacional.
- **Linha 47**: VALUES
- **Linha 48**: (p_id_unidade,p_id_sistema,'CLI01','Clínico - Sala 1','MEDICO_CLINICO','1',1,1,1,0),
- **Linha 49**: (p_id_unidade,p_id_sistema,'CLI02','Clínico - Sala 2','MEDICO_CLINICO','2',1,1,1,0),
- **Linha 50**: (p_id_unidade,p_id_sistema,'CLI03','Clínico - Sala 3','MEDICO_CLINICO','3',1,1,1,0),
- **Linha 51**: (p_id_unidade,p_id_sistema,'CLI04','Clínico - Sala 4','MEDICO_CLINICO','4',1,1,1,0),
- **Linha 52**: (p_id_unidade,p_id_sistema,'CLI05','Clínico - Sala 5','MEDICO_CLINICO','5',1,1,1,0),
- **Linha 53**: (p_id_unidade,p_id_sistema,'MEDICO_CLINICO_ND','[NAO DEFINIDA] CLÍNICO','MEDICO_CLINICO',NULL,1,0,0,1)
- **Linha 54**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 55**: nome = VALUES(nome),
- **Linha 56**: tipo = VALUES(tipo),
- **Linha 57**: sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
- **Linha 58**: ativo = VALUES(ativo),
- **Linha 59**: exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
- **Linha 60**: gera_tts_publico = VALUES(gera_tts_publico),
- **Linha 61**: eh_nao_definida = VALUES(eh_nao_definida),
- **Linha 62**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 64** (Comentario): ========== MÉDICO PEDIÁTRICO ==========
- **Linha 65**: Insere um novo registro na tabela local_operacional.
- **Linha 66**: VALUES
- **Linha 67**: (p_id_unidade,p_id_sistema,'PED01','Pediatria - Sala 1','MEDICO_PEDIATRICO','1',1,1,1,0),
- **Linha 68**: (p_id_unidade,p_id_sistema,'PED02','Pediatria - Sala 2','MEDICO_PEDIATRICO','2',1,1,1,0),
- **Linha 69**: (p_id_unidade,p_id_sistema,'PED03','Pediatria - Sala 3','MEDICO_PEDIATRICO','3',1,1,1,0),
- **Linha 70**: (p_id_unidade,p_id_sistema,'PED04','Pediatria - Sala 4','MEDICO_PEDIATRICO','4',1,1,1,0),
- **Linha 71**: (p_id_unidade,p_id_sistema,'MEDICO_PEDIATRICO_ND','[NAO DEFINIDA] PEDIATRIA','MEDICO_PEDIATRICO',NULL,1,0,0,1)
- **Linha 72**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 73**: nome = VALUES(nome),
- **Linha 74**: tipo = VALUES(tipo),
- **Linha 75**: sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
- **Linha 76**: ativo = VALUES(ativo),
- **Linha 77**: exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
- **Linha 78**: gera_tts_publico = VALUES(gera_tts_publico),
- **Linha 79**: eh_nao_definida = VALUES(eh_nao_definida),
- **Linha 80**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 82** (Comentario): ========== MEDICAÇÃO (ADULTO) ==========
- **Linha 83**: Insere um novo registro na tabela local_operacional.
- **Linha 84**: VALUES
- **Linha 85**: (p_id_unidade,p_id_sistema,'MED01','Medicação - Sala 1','MEDICACAO','1',1,1,1,0),
- **Linha 86**: (p_id_unidade,p_id_sistema,'MED02','Medicação - Sala 2','MEDICACAO','2',1,1,1,0),
- **Linha 87**: (p_id_unidade,p_id_sistema,'MED03','Medicação - Sala 3','MEDICACAO','3',1,1,1,0),
- **Linha 88**: (p_id_unidade,p_id_sistema,'MED04','Medicação - Sala 4','MEDICACAO','4',1,1,1,0),
- **Linha 89**: (p_id_unidade,p_id_sistema,'MEDICACAO_ND','[NAO DEFINIDA] MEDICAÇÃO','MEDICACAO',NULL,1,0,0,1)
- **Linha 90**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 91**: nome = VALUES(nome),
- **Linha 92**: tipo = VALUES(tipo),
- **Linha 93**: sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
- **Linha 94**: ativo = VALUES(ativo),
- **Linha 95**: exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
- **Linha 96**: gera_tts_publico = VALUES(gera_tts_publico),
- **Linha 97**: eh_nao_definida = VALUES(eh_nao_definida),
- **Linha 98**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 101** (Comentario): ========== MEDICAÇÃO (PEDIÁTRICA / ALA INFANTIL) ==========
- **Linha 102** (Comentario): Observação: usamos códigos MEDPxx para diferenciar ala/painel; o tipo permanece MEDICACAO (enum canônico).
- **Linha 103**: Insere um novo registro na tabela local_operacional.
- **Linha 104**: VALUES
- **Linha 105**: (p_id_unidade,p_id_sistema,'MEDP01','Medicação Pediátrica - Sala 1','MEDICACAO','P1',1,1,1,0),
- **Linha 106**: (p_id_unidade,p_id_sistema,'MEDP02','Medicação Pediátrica - Sala 2','MEDICACAO','P2',1,1,1,0),
- **Linha 107**: (p_id_unidade,p_id_sistema,'MEDP03','Medicação Pediátrica - Sala 3','MEDICACAO','P3',1,1,1,0),
- **Linha 108**: (p_id_unidade,p_id_sistema,'MEDP04','Medicação Pediátrica - Sala 4','MEDICACAO','P4',1,1,1,0),
- **Linha 109**: (p_id_unidade,p_id_sistema,'MEDICACAO_PEDI_ND','[NAO DEFINIDA] MEDICAÇÃO PEDIÁTRICA','MEDICACAO',NULL,1,0,0,1)
- **Linha 110**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 111**: nome = VALUES(nome),
- **Linha 112**: tipo = VALUES(tipo),
- **Linha 113**: sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
- **Linha 114**: ativo = VALUES(ativo),
- **Linha 115**: exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
- **Linha 116**: gera_tts_publico = VALUES(gera_tts_publico),
- **Linha 117**: eh_nao_definida = VALUES(eh_nao_definida),
- **Linha 118**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 120** (Comentario): ========== RX ==========
- **Linha 121**: Insere um novo registro na tabela local_operacional.
- **Linha 122**: VALUES
- **Linha 123**: (p_id_unidade,p_id_sistema,'RX01','Raio-X - Sala 1','RX','1',1,1,1,0),
- **Linha 124**: (p_id_unidade,p_id_sistema,'RX02','Raio-X - Sala 2','RX','2',1,1,1,0),
- **Linha 125**: (p_id_unidade,p_id_sistema,'RX_ND','[NAO DEFINIDA] RAIO-X','RX',NULL,1,0,0,1)
- **Linha 126**: Atualiza o registro se a chave unica jÃ¡ existir (UPSERT).
- **Linha 127**: nome = VALUES(nome),
- **Linha 128**: tipo = VALUES(tipo),
- **Linha 129**: sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
- **Linha 130**: ativo = VALUES(ativo),
- **Linha 131**: exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
- **Linha 132**: gera_tts_publico = VALUES(gera_tts_publico),
- **Linha 133**: eh_nao_definida = VALUES(eh_nao_definida),
- **Linha 134**: atualizado_em = CURRENT_TIMESTAMP;
- **Linha 136**: Fim do bloco da procedure.

### Codigo Fonte Completo

```sql
CREATE DEFINER=`pa_owner`@`%` PROCEDURE `sp_local_operacional_seed_padrao`(
    IN p_id_unidade BIGINT,
    IN p_id_sistema BIGINT
)
BEGIN
    -- UPSERT helper: atualiza sala somente se estiver NULL/vazia
    -- Observação: este seed é "vendável" (códigos canônicos) e pode ser reexecutado.

    -- ========== RECEPÇÃO (guichês) ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'REC01','Recepção - Guichê 1','RECEPCAO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'REC02','Recepção - Guichê 2','RECEPCAO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'REC03','Recepção - Guichê 3','RECEPCAO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'REC04','Recepção - Guichê 4','RECEPCAO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'RECEPCAO_ND','[NAO DEFINIDA] RECEPÇÃO','RECEPCAO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== TRIAGEM (salas) ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'TRI01','Triagem - Sala 1','TRIAGEM','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRI02','Triagem - Sala 2','TRIAGEM','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRI03','Triagem - Sala 3','TRIAGEM','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRI04','Triagem - Sala 4','TRIAGEM','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'TRIAGEM_ND','[NAO DEFINIDA] TRIAGEM','TRIAGEM',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== MÉDICO CLÍNICO ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'CLI01','Clínico - Sala 1','MEDICO_CLINICO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI02','Clínico - Sala 2','MEDICO_CLINICO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI03','Clínico - Sala 3','MEDICO_CLINICO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI04','Clínico - Sala 4','MEDICO_CLINICO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'CLI05','Clínico - Sala 5','MEDICO_CLINICO','5',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICO_CLINICO_ND','[NAO DEFINIDA] CLÍNICO','MEDICO_CLINICO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== MÉDICO PEDIÁTRICO ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'PED01','Pediatria - Sala 1','MEDICO_PEDIATRICO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'PED02','Pediatria - Sala 2','MEDICO_PEDIATRICO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'PED03','Pediatria - Sala 3','MEDICO_PEDIATRICO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'PED04','Pediatria - Sala 4','MEDICO_PEDIATRICO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICO_PEDIATRICO_ND','[NAO DEFINIDA] PEDIATRIA','MEDICO_PEDIATRICO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    -- ========== MEDICAÇÃO (ADULTO) ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'MED01','Medicação - Sala 1','MEDICACAO','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MED02','Medicação - Sala 2','MEDICACAO','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MED03','Medicação - Sala 3','MEDICACAO','3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MED04','Medicação - Sala 4','MEDICACAO','4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICACAO_ND','[NAO DEFINIDA] MEDICAÇÃO','MEDICACAO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

    
    -- ========== MEDICAÇÃO (PEDIÁTRICA / ALA INFANTIL) ==========
    -- Observação: usamos códigos MEDPxx para diferenciar ala/painel; o tipo permanece MEDICACAO (enum canônico).
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'MEDP01','Medicação Pediátrica - Sala 1','MEDICACAO','P1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDP02','Medicação Pediátrica - Sala 2','MEDICACAO','P2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDP03','Medicação Pediátrica - Sala 3','MEDICACAO','P3',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDP04','Medicação Pediátrica - Sala 4','MEDICACAO','P4',1,1,1,0),
      (p_id_unidade,p_id_sistema,'MEDICACAO_PEDI_ND','[NAO DEFINIDA] MEDICAÇÃO PEDIÁTRICA','MEDICACAO',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

-- ========== RX ==========
    INSERT INTO local_operacional (id_unidade,id_sistema,codigo,nome,tipo,sala,ativo,exibe_em_painel_publico,gera_tts_publico,eh_nao_definida)
    VALUES
      (p_id_unidade,p_id_sistema,'RX01','Raio-X - Sala 1','RX','1',1,1,1,0),
      (p_id_unidade,p_id_sistema,'RX02','Raio-X - Sala 2','RX','2',1,1,1,0),
      (p_id_unidade,p_id_sistema,'RX_ND','[NAO DEFINIDA] RAIO-X','RX',NULL,1,0,0,1)
    ON DUPLICATE KEY UPDATE
      nome = VALUES(nome),
      tipo = VALUES(tipo),
      sala = COALESCE(NULLIF(local_operacional.sala,''), VALUES(sala)),
      ativo = VALUES(ativo),
      exibe_em_painel_publico = VALUES(exibe_em_painel_publico),
      gera_tts_publico = VALUES(gera_tts_publico),
      eh_nao_definida = VALUES(eh_nao_definida),
      atualizado_em = CURRENT_TIMESTAMP;

END ;;
```

