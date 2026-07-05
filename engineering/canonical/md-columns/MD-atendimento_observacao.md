# MD-atendimento_observacao-colunas — Colunas

## Tabela: `atendimento_observacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_obs` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `tipo` | enum('OBSERVACAO','INTERNACAO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_leito` | int | DEFAULT NULL |
| `data_inicio` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `data_fim` | datetime | DEFAULT NULL |
| `status` | enum('ATIVO','ALTA','TRANSFERIDO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'ATIVO' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_obs`),
UNIQUE KEY `uk_atendimento_obs` (`id_atendimento`),
KEY `id_leito` (`id_leito`),
KEY `idx_aobs_ent` (`id_entidade`),
CONSTRAINT `atendimento_observacao_ibfk_2` FOREIGN KEY (`id_leito`) REFERENCES `leito` (`id_leito`),
CONSTRAINT `fk_atendimento_observacao_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_atendimento_observacao_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `atendimento_observacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `atendimento_observacao` ENABLE KEYS */;
