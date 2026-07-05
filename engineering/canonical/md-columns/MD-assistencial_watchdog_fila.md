# MD-assistencial_watchdog_fila-colunas — Colunas

## Tabela: `assistencial_watchdog_fila`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_watchdog` | bigint | NOT NULL AUTO_INCREMENT |
| `unidade` | varchar(100) | NOT NULL |
| `backlog_eventos` | int | DEFAULT '0' |
| `taxa_retry` | decimal(10,4) | DEFAULT '0.0000' |
| `estado_runtime` | enum('NORMAL','ATENCAO','SATURADO') | DEFAULT 'NORMAL' |
| `atualizado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_watchdog`),
UNIQUE KEY `uk_watchdog_unidade` (`unidade`),
KEY `fk_assistencial_watchdog_fila_atendimento` (`id_atendimento`),
KEY `idx_awf_ent` (`id_entidade`),
CONSTRAINT `fk_assistencial_watchdog_fila_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_assistencial_watchdog_fila_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `assistencial_watchdog_fila` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_watchdog_fila` ENABLE KEYS */;
