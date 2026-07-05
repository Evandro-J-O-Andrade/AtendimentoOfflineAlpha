# MD-assistencial_runtime_federado-colunas — Colunas

## Tabela: `assistencial_runtime_federado`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_snapshot` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sistema` | bigint | NOT NULL |
| `hash_runtime` | char(64) | DEFAULT NULL |
| `payload_json` | json | DEFAULT NULL |
| `sincronizado` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_snapshot`),
KEY `idx_runtime_federado` (`id_sistema`,`sincronizado`),
KEY `fk_assistencial_runtime_federado_atendimento` (`id_atendimento`),
KEY `idx_arf_ent` (`id_entidade`),
CONSTRAINT `fk_assistencial_runtime_federado_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_assistencial_runtime_federado_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `assistencial_runtime_federado` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_runtime_federado` ENABLE KEYS */;
