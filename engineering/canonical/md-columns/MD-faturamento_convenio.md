# MD-faturamento_convenio-colunas — Colunas

## Tabela: `faturamento_convenio`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `id_convenio` | int | NOT NULL |
| `numero_guia` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `valor_total` | decimal(12,2) | DEFAULT NULL |
| `status_guia` | enum('ABERTA','ENVIADA','PAGA','GLOSADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ABERTA' |
| `data_emissao` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `faturamento_convenio` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_convenio` ENABLE KEYS */;
