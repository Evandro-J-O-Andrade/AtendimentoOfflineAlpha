# MD-atendimento_sumario_alta-colunas — Colunas

## Tabela: `atendimento_sumario_alta`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_medico_alta` | bigint | NOT NULL |
| `motivo_internacao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `resumo_clinico` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `procedimentos_realizados` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `orientacoes_pos_alta` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `medicamentos_receitados` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `data_alta` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `assinatura_hash` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `uk_sumario_atend` (`id_atendimento`),
KEY `idx_asumal_ent` (`id_entidade`),
CONSTRAINT `fk_atendimento_sumario_alta_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_sumario_alta_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_sumario_alta` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_sumario_alta` ENABLE KEYS */;
