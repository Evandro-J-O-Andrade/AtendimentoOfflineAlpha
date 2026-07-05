# MD-reabertura_atendimento-colunas — Colunas

## Tabela: `reabertura_atendimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_reabertura` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `motivo` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_reabertura`),
KEY `idx_ffa` (`id_ffa`),
KEY `fk_reabertura_atendimento_atendimento` (`id_atendimento`),
KEY `idx_reab_ent` (`id_entidade`),
CONSTRAINT `fk_reabertura_atendimento_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_reabertura_atendimento_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `reabertura_atendimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `reabertura_atendimento` ENABLE KEYS */;
