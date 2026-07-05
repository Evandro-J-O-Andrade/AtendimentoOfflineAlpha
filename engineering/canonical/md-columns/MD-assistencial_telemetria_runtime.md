# MD-assistencial_telemetria_runtime-colunas — Colunas

## Tabela: `assistencial_telemetria_runtime`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_telemetria` | bigint | NOT NULL AUTO_INCREMENT |
| `componente` | varchar(60) | NOT NULL |
| `metrica` | varchar(60) | NOT NULL |
| `valor` | decimal(18,6) | NOT NULL |
| `unidade` | varchar(30) | DEFAULT NULL |
| `criticidade` | enum('INFO','WARNING','CRITICAL') | DEFAULT 'INFO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_telemetria`),
KEY `idx_telemetria_lookup` (`componente`,`metrica`,`criado_em`),
KEY `fk_assistencial_telemetria_runtime_atendimento` (`id_atendimento`),
KEY `idx_atr_ent` (`id_entidade`),
CONSTRAINT `fk_assistencial_telemetria_runtime_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_assistencial_telemetria_runtime_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `assistencial_telemetria_runtime` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_telemetria_runtime` ENABLE KEYS */;
