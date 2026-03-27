# FOREIGN KEYS - TABELAS ASSISTENCIAIS

**Data:** 27/03/2026  
**Fonte:** Dump20260326 (1).sql

---

## 1. ATENDIMENTO_ANAMNESE

```sql
CONSTRAINT `fk_atendimento_anamnese_entidade` FOREIGN KEY (`id_entidade`) 
REFERENCES `saas_entidade` (`id_entidade`)
```

---

## 2. ATENDIMENTO_BALANCO_HIDRICO

```sql
-- Não possui FKs definidas no dump
```

---

## 3. ATENDIMENTO_CHECAGEM

```sql
CONSTRAINT `fk_chec_presc` FOREIGN KEY (`id_prescricao`) 
REFERENCES `atendimento_prescricao` (`id`)
```

---

## 4. ATENDIMENTO_DESFECHO

```sql
-- Tabela não encontrada no dump
```

---

## 5. ATENDIMENTO_DIAGNOSTICO

```sql
-- Tabela não encontrada no dump
```

---

## 6. ATENDIMENTO_ESCALAS_RISCO

```sql
CONSTRAINT `fk_escala_atend` FOREIGN KEY (`id_atendimento`) 
REFERENCES `atendimento` (`id_atendimento`)
```

---

## 7. ATENDIMENTO_ESTADO_ATIVO

```sql
CONSTRAINT `fk_estado_local` FOREIGN KEY (`id_local_atual`) 
REFERENCES `local_operacional` (`id_local_operacional`)
```

---

## 8. ATENDIMENTO_EVENTO

```sql
CONSTRAINT `fk_atendimento_evento_entidade` FOREIGN KEY (`id_entidade`) 
REFERENCES `saas_entidade` (`id_entidade`)
```

---

## 9. ATENDIMENTO_EVENTO_LEDGER

```sql
-- Não possui FKs definidas no dump
```

---

## 10. ATENDIMENTO_EVOLUCAO

```sql
CONSTRAINT `fk_atendimento_evolucao_entidade` FOREIGN KEY (`id_entidade`) 
REFERENCES `saas_entidade` (`id_entidade`)
```

---

## 11. ATENDIMENTO_EXAME_FISICO

```sql
CONSTRAINT `fk_atendimento_exame_fisico_entidade` FOREIGN KEY (`id_entidade`) 
REFERENCES `saas_entidade` (`id_entidade`)
```

---

## 12. ATENDIMENTO_IDENTIDADE_FLUXO

```sql
-- Não possui FKs definidas no dump
```

---

## 13. ATENDIMENTO_MOVIMENTACAO

```sql
CONSTRAINT `atendimento_movimentacao_ibfk_1` FOREIGN KEY (`id_atendimento`) 
REFERENCES `atendimento` (`id_atendimento`),

CONSTRAINT `atendimento_movimentacao_ibfk_2` FOREIGN KEY (`id_usuario`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 14. ATENDIMENTO_OBSERVACAO

```sql
CONSTRAINT `atendimento_observacao_ibfk_1` FOREIGN KEY (`id_atendimento`) 
REFERENCES `atendimento` (`id_atendimento`),

CONSTRAINT `atendimento_observacao_ibfk_2` FOREIGN KEY (`id_leito`) 
REFERENCES `leito` (`id_leito`)
```

---

## 15. ATENDIMENTO_PEDIDOS_EXAME

```sql
CONSTRAINT `fk_pedido_tuss` FOREIGN KEY (`id_exame_tuss`) 
REFERENCES `tabela_tuss` (`codigo_tuss`)
```

---

## 16. ATENDIMENTO_PRE_HOSPITALAR

```sql
-- Tabela não encontrada no dump
```

---

## 17. ATENDIMENTO_PRESCRICAO

```sql
CONSTRAINT `fk_atendimento_prescricao_entidade` FOREIGN KEY (`id_entidade`) 
REFERENCES `saas_entidade` (`id_entidade`)
```

---

## 18. ATENDIMENTO_PROFISSIONAL

```sql
-- Não possui FKs definidas no dump
```

---

## 19. ATENDIMENTO_RECEPCAO

```sql
CONSTRAINT `atendimento_recepcao_ibfk_1` FOREIGN KEY (`id_atendimento`) 
REFERENCES `atendimento` (`id_atendimento`),

CONSTRAINT `atendimento_recepcao_ibfk_2` FOREIGN KEY (`id_recepcionista`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 20. ATENDIMENTO_SINAIS_VITAIS

```sql
CONSTRAINT `fk_sv_atendimento` FOREIGN KEY (`id_atendimento`) 
REFERENCES `atendimento` (`id_atendimento`)
```

---

## 21. ATENDIMENTO_SUMARIO_ALTA

```sql
CONSTRAINT `fk_sumario_atend` FOREIGN KEY (`id_atendimento`) 
REFERENCES `atendimento` (`id_atendimento`)
```

---

## 22. ATENDIMENTO_TRANSICAO_LEDGER

```sql
-- Não possui FKs definidas no dump
```

---

## 23. ATENDIMENTO_TRIAGEM

```sql
CONSTRAINT `fk_atendimento_triagem_entidade` FOREIGN KEY (`id_entidade`) 
REFERENCES `saas_entidade` (`id_entidade`)
```

---

## 24. ATENDIMENTO_VINCULO

```sql
-- Não possui FKs definidas no dump
```

---

## 25. GPAT_ATENDIMENTO

```sql
CONSTRAINT `fk_gpat_cliente` FOREIGN KEY (`id_cliente`) 
REFERENCES `cliente` (`id_cliente`),

CONSTRAINT `fk_gpat_prescritor_ext` FOREIGN KEY (`id_prescritor_externo`) 
REFERENCES `prescritor_externo` (`id_prescritor_externo`),

CONSTRAINT `fk_gpat_usuario_medico` FOREIGN KEY (`id_usuario_medico`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 26. FARM_ATENDIMENTO_EXTERNO

```sql
-- Não possui FKs definidas no dump
```

---

## 27. FARMACIA_ATENDIMENTO_EXTERNO_DISPENSACAO

```sql
CONSTRAINT `fk_faed_item` FOREIGN KEY (`id_item`) 
REFERENCES `farmacia_atendimento_externo_item` (`id_item`),

CONSTRAINT `fk_faed_local` FOREIGN KEY (`id_local_estoque`) 
REFERENCES `local_atendimento` (`id_local`),

CONSTRAINT `fk_faed_lote` FOREIGN KEY (`id_lote`) 
REFERENCES `farmaco_lote` (`id_lote`)
```

---

## 28. ASSISTENCIAL_CHECKPOINT_GLOBAL

```sql
-- Não possui FKs definidas no dump
```

---

## 29. ASSISTENCIAL_RUNTIME_PANEL

```sql
-- Não possui FKs definidas no dump
```

---

## 30. ASSISTENCIAL_RUNTIME_FEDERADO

```sql
-- Não possui FKs definidas no dump
```

---

## 31. ASSISTENCIAL_SIMULACAO_FUTURA

```sql
-- Não possui FKs definidas no dump
```

---

## 32. ASSISTENCIAL_SNAPSHOT_RUNTIME

```sql
-- Não possui FKs definidas no dump
```

---

## 33. ASSISTENCIAL_TELEMETRIA_RUNTIME

```sql
-- Não possui FKs definidas no dump
```

---

## 34. ASSISTENCIAL_WATCHDOG_FILA

```sql
-- Não possui FKs definidas no dump
```

---

## 35. INTERNACAO

```sql
CONSTRAINT `fk_internacao_leito` FOREIGN KEY (`id_leito`) 
REFERENCES `leito` (`id_leito`)
```

---

## 36. INTERNACAO_MEDICACAO_ADMINISTRACAO

```sql
CONSTRAINT `fk_ima_internacao` FOREIGN KEY (`id_internacao`) 
REFERENCES `internacao` (`id_internacao`),

CONSTRAINT `fk_ima_item` FOREIGN KEY (`id_internacao_prescricao_item`) 
REFERENCES `internacao_prescricao_item` (`id_internacao_prescricao_item`),

CONSTRAINT `fk_ima_usuario` FOREIGN KEY (`id_usuario_responsavel`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 37. INTERNACAO_MOVIMENTACAO

```sql
CONSTRAINT `fk_internacao_movimentacao_unidade` FOREIGN KEY (`id_unidade`) 
REFERENCES `unidade` (`id_unidade`),

CONSTRAINT `fk_mov_internacao` FOREIGN KEY (`id_internacao`) 
REFERENCES `internacao` (`id_internacao`)
```

---

## 38. INTERNACAO_PRESCRICAO

```sql
CONSTRAINT `fk_ip_internacao` FOREIGN KEY (`id_internacao`) 
REFERENCES `internacao` (`id_internacao`),

CONSTRAINT `fk_ip_usuario` FOREIGN KEY (`id_usuario_prescritor`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 39. INTERNACAO_PRESCRICAO_ITEM

```sql
CONSTRAINT `fk_ipi_prescricao` FOREIGN KEY (`id_internacao_prescricao`) 
REFERENCES `internacao_prescricao` (`id_internacao_prescricao`)
```

---

## 40. INTERNACAO_REGISTRO_ENFERMAGEM

```sql
CONSTRAINT `fk_ire_internacao` FOREIGN KEY (`id_internacao`) 
REFERENCES `internacao` (`id_internacao`),

CONSTRAINT `fk_ire_usuario` FOREIGN KEY (`id_usuario_responsavel`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 41. INTERNACAO_TURNO_REGISTRO

```sql
CONSTRAINT `fk_itr_internacao` FOREIGN KEY (`id_internacao`) 
REFERENCES `internacao` (`id_internacao`),

CONSTRAINT `fk_itr_usuario` FOREIGN KEY (`id_usuario_responsavel`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 42. ORDEM_ASSISTENCIAL

```sql
-- Não possui FKs definidas no dump
```

---

## 43. ORDEM_ASSISTENCIAL_ITEM

```sql
CONSTRAINT `fk_item_farmaco` FOREIGN KEY (`id_farmaco`) 
REFERENCES `farmaco` (`id_farmaco`),

CONSTRAINT `fk_item_ordem` FOREIGN KEY (`id_ordem`) 
REFERENCES `ordem_assistencial` (`id`)
```

---

## 44. ORDEM_ASSISTENCIAL_APRAZAMENTO

```sql
CONSTRAINT `fk_apraz_exec_local` FOREIGN KEY (`id_local_operacional_execucao`) 
REFERENCES `local_operacional` (`id_local_operacional`),

CONSTRAINT `fk_apraz_exec_user` FOREIGN KEY (`id_usuario_execucao`) 
REFERENCES `usuario` (`id_usuario`),

CONSTRAINT `fk_apraz_item` FOREIGN KEY (`id_item`) 
REFERENCES `ordem_assistencial_item` (`id_item`)
```

---

## 45. ORDEM_ASSISTENCIAL_EXECUCAO

```sql
CONSTRAINT `fk_exec_apraz` FOREIGN KEY (`id_aprazamento`) 
REFERENCES `ordem_assistencial_aprazamento` (`id_aprazamento`),

CONSTRAINT `fk_exec_item` FOREIGN KEY (`id_item`) 
REFERENCES `ordem_assistencial_item` (`id_item`)
```

---

## 46. PROTOCOLO_ASSISTENCIAL_GLOBAL

```sql
-- Não possui FKs definidas no dump
```

---

## 47. TRIAGEM

```sql
CONSTRAINT `triagem_ibfk_1` FOREIGN KEY (`id_atendimento`) 
REFERENCES `atendimento` (`id_atendimento`),

CONSTRAINT `triagem_ibfk_2` FOREIGN KEY (`id_risco`) 
REFERENCES `classificacao_risco` (`id_risco`),

CONSTRAINT `triagem_ibfk_3` FOREIGN KEY (`id_enfermeiro`) 
REFERENCES `usuario` (`id_usuario`)
```

---

## 48. REABERTURA_ATENDIMENTO

```sql
-- Não possui FKs definidas no dump
```

---

## 49. RETORNO_ATENDIMENTO

```sql
CONSTRAINT `retorno_atendimento_ibfk_1` FOREIGN KEY (`id_atendimento_origem`) 
REFERENCES `atendimento` (`id_atendimento`),

CONSTRAINT `retorno_atendimento_ibfk_2` FOREIGN KEY (`id_atendimento_retorno`) 
REFERENCES `atendimento` (`id_atendimento`)
```

---

## 50. FLUXO_ORQUESTRADOR_CANONICO

```sql
-- Não possui FKs definidas no dump
```

---

## RESUMO

| Categoria | Total Tabelas | Com FK | Sem FK |
|-----------|---------------|--------|--------|
| Atendimento_* | 24 | 17 | 7 |
| Assistencial_* | 7 | 0 | 7 |
| Internacao_* | 7 | 7 | 0 |
| Ordem_* | 4 | 4 | 0 |
| Outros | 8 | 3 | 5 |
| **TOTAL** | **50** | **31** | **19** |

---

## TABELAS COM FKs IDENTIFICADAS (31 tabelas)

1. **atendimento_anamnese** → saas_entidade
2. **atendimento_checagem** → atendimento_prescricao
3. **atendimento_escalas_risco** → atendimento
4. **atendimento_estado_ativo** → local_operacional
5. **atendimento_evento** → saas_entidade
6. **atendimento_evolucao** → saas_entidade
7. **atendimento_exame_fisico** → saas_entidade
8. **atendimento_movimentacao** → atendimento, usuario
9. **atendimento_observacao** → atendimento, leito
10. **atendimento_pedidos_exame** → tabela_tuss
11. **atendimento_prescricao** → saas_entidade
12. **atendimento_recepcao** → atendimento, usuario
13. **atendimento_sinais_vitais** → atendimento
14. **atendimento_sumario_alta** → atendimento
15. **atendimento_triagem** → saas_entidade
16. **gpat_atendimento** → cliente, prescritor_externo, usuario
17. **farmacia_atendimento_externo_dispensacao** → farmacia_atendimento_externo_item, local_atendimento, farmaco_lote
18. **internacao** → leito
19. **internacao_medicacao_administracao** → internacao, internacao_prescricao_item, usuario
20. **internacao_movimentacao** → unidade, internacao
21. **internacao_prescricao** → internacao, usuario
22. **internacao_prescricao_item** → internacao_prescricao
23. **internacao_registro_enfermagem** → internacao, usuario
24. **internacao_turno_registro** → internacao, usuario
25. **ordem_assistencial_item** → farmaco, ordem_assistencial
26. **ordem_assistencial_aprazamento** → local_operacional, usuario, ordem_assistencial_item
27. **ordem_assistencial_execucao** → ordem_assistencial_aprazamento, ordem_assistencial_item
28. **triagem** → atendimento, classificacao_risco, usuario
29. **retorno_atendimento** → atendimento (origem), atendimento (retorno)

---

## TABELAS SEM FK (19 tabelas)

1. atendimento_balanco_hidrico
2. atendimento_evento_ledger
3. atendimento_identidade_fluxo
4. atendimento_profissional
5. atendimento_transicao_ledger
6. atendimento_vinculo
7. farm_atendimento_externo
8. assistencial_checkpoint_global
9. assistencial_runtime_panel
10. assistencial_runtime_federado
11. assistencial_simulacao_futura
12. assistencial_snapshot_runtime
13. assistencial_telemetria_runtime
14. assistencial_watchdog_fila
15. ordem_assistencial
16. protocolo_assistencial_global
17. reabertura_atendimento
18. fluxo_orquestrador_canonico

---

## TABELAS NÃO ENCONTRADAS NO DUMP (3 tabelas)

1. atendimento_desfecho
2. atendimento_diagnostico
3. atendimento_pre_hospitalar

---

## PRINCIPAIS TABELAS REFERENCIADAS

| Tabela Referenciada | Quantidade de FKs |
|---------------------|-------------------|
| atendimento | 12 |
| usuario | 11 |
| saas_entidade | 7 |
| internacao | 6 |
| ordem_assistencial_item | 3 |
| leito | 2 |
| local_operacional | 2 |
| internacao_prescricao | 2 |
| internacao_prescricao_item | 2 |
| farmaco | 1 |
| cliente | 1 |
| prescritor_externo | 1 |
| tabela_tuss | 1 |
| classificacao_risco | 1 |
| unidade | 1 |
| farmacia_atendimento_externo_item | 1 |
| local_atendimento | 1 |
| farmaco_lote | 1 |
| farmacia_atendimento_externo_item | 1 |
| ordem_assistencial | 1 |
| ordem_assistencial_aprazamento | 1 |
