# MD-assistencial_checkpoint_global-colunas — Colunas

## Tabela: `assistencial_checkpoint_global`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_checkpoint` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `estado_snapshot` | varchar(60) | NOT NULL |
| `quorum_valido` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_checkpoint`),
UNIQUE KEY `uk_checkpoint_ffa` (`id_ffa`),
KEY `fk_assistencial_checkpoint_global_atendimento` (`id_atendimento`),
KEY `idx_acg_ent` (`id_entidade`),
CONSTRAINT `fk_assistencial_checkpoint_global_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_assistencial_checkpoint_global_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `assistencial_checkpoint_global` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_checkpoint_global` ENABLE KEYS */;
