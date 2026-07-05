# MD-log_leitura_prontuario-colunas — Colunas

## Tabela: `log_leitura_prontuario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `motivo_acesso` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `log_leitura_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_leitura_prontuario` ENABLE KEYS */;
