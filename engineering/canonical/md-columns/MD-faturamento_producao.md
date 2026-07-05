# MD-faturamento_producao-colunas — Colunas

## Tabela: `faturamento_producao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `codigo_procedimento` | varchar(10) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `cbo_profissional` | varchar(6) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `status_faturamento` | enum('PENDENTE','PROCESSADO','GLOSADO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDENTE' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `faturamento_producao` DISABLE KEYS */;
/*!40000 ALTER TABLE `faturamento_producao` ENABLE KEYS */;
