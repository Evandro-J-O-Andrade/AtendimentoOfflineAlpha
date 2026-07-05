# MD-integracao_mensageria_externa-colunas — Colunas

## Tabela: `integracao_mensageria_externa`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `provedor_externo` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo_mensagem` | enum('HL7_ORU','HL7_ADT','FHIR_JSON') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_processamento` | enum('PENDENTE','PROCESSADO','ERRO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_recebimento` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `integracao_mensageria_externa` DISABLE KEYS */;
/*!40000 ALTER TABLE `integracao_mensageria_externa` ENABLE KEYS */;
