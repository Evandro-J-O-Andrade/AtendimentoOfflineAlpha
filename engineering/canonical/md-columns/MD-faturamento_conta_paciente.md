# MD-faturamento_conta_paciente-colunas — Colunas

## Tabela: `faturamento_conta_paciente`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_convenio` | int | NOT NULL |
| `status_conta` | enum('ABERTA','FECHADA','FATURADA','PAGA','GLOSADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTA' |
| `valor_total` | decimal(12,2) | DEFAULT '0.00' |
| `numero_guia_principal` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_fechamento` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_conta_atend` (`id_atendimento`)
/*!40000 ALTER TABLE `faturamento_conta_paciente` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_conta_paciente` ENABLE KEYS */;
