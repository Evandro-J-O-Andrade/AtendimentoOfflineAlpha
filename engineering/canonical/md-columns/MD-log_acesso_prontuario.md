# MD-log_acesso_prontuario-colunas — Colunas

## Tabela: `log_acesso_prontuario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_atendimento` | bigint | NOT NULL |
| `ip_maquina` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_hora_acesso` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `modulo_acessado` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_lgpd_paciente` (`id_atendimento`)
/*!40000 ALTER TABLE `log_acesso_prontuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_acesso_prontuario` ENABLE KEYS */;
