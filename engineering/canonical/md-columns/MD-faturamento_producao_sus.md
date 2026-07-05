# MD-faturamento_producao_sus-colunas — Colunas

## Tabela: `faturamento_producao_sus`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_sigtap` | int | NOT NULL |
| `cbo_profissional` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `cns_paciente` | varchar(15) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_producao` | date | DEFAULT NULL |
| `status_remessa` | enum('PENDENTE','ENVIADO','REJEITADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_sus_atend` (`id_atendimento`)
/*!40000 ALTER TABLE `faturamento_producao_sus` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_producao_sus` ENABLE KEYS */;
