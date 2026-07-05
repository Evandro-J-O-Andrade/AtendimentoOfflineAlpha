# MD-enfermagem_aprazamento-colunas — Colunas

## Tabela: `enfermagem_aprazamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `medicamento` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `via_administracao` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `frequencia` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `horario_previsto` | datetime | NOT NULL |
| `horario_executado` | datetime | DEFAULT NULL |
| `id_usuario_execucao` | bigint | DEFAULT NULL |
| `status` | enum('AGUARDANDO','REALIZADO','ATRASADO','SUSPENSO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'AGUARDANDO' |
| `observacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_apraz_atend` (`id_atendimento`),
KEY `idx_apraz_hora` (`horario_previsto`)
/*!40000 ALTER TABLE `enfermagem_aprazamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `enfermagem_aprazamento` ENABLE KEYS */;
