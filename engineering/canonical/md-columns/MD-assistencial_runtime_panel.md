# MD-assistencial_runtime_panel-colunas — Colunas

## Tabela: `assistencial_runtime_panel`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_panel` | bigint | NOT NULL AUTO_INCREMENT |
| `health_score_runtime` | decimal(10,4) | DEFAULT '0.0000' |
| `backlog_federado` | int | DEFAULT '0' |
| `retry_rate` | decimal(10,4) | DEFAULT '0.0000' |
| `hash_hit_rate` | decimal(10,4) | DEFAULT '0.0000' |
| `tombstone_hit_rate` | decimal(10,4) | DEFAULT '0.0000' |
| `divergencia_edge_nucleo` | decimal(10,4) | DEFAULT '0.0000' |
| `estado_runtime` | varchar(60) | DEFAULT 'NORMAL' |
| `alerta_preventivo` | varchar(120) | DEFAULT NULL |
| `atualizado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_panel`),
UNIQUE KEY `uk_runtime_panel` (`id_panel`),
KEY `fk_assistencial_runtime_panel_atendimento` (`id_atendimento`),
KEY `idx_arp_ent` (`id_entidade`),
CONSTRAINT `fk_assistencial_runtime_panel_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_assistencial_runtime_panel_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `assistencial_runtime_panel` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_runtime_panel` ENABLE KEYS */;
