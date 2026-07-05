# MD-paciente_alertas-colunas — Colunas

## Tabela: `paciente_alertas`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `tipo_alerta` | enum('ALERGIA','COMORBIDADE','RISCO_INFECCAO','PRECAUCAO_CONTATO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `grau_severidade` | enum('BAIXO','MODERADO','ALTO','CRITICO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_registro` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `paciente_alertas` DISABLE KEYS */;
/*!40000 ALTER TABLE `paciente_alertas` ENABLE KEYS */;
