# MD-tombstone_evento_assistencial-colunas — Colunas

## Tabela: `tombstone_evento_assistencial`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tombstone` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `evento` | varchar(60) | NOT NULL |
| `estado_cancelado` | varchar(60) | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `cancelado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_tombstone`),
UNIQUE KEY `uk_tombstone_evento` (`id_ffa`,`evento`),
KEY `idx_tombstone_lookup` (`id_ffa`,`evento`)
/*!40000 ALTER TABLE `tombstone_evento_assistencial` DISABLE KEYS */;
/*!40000 ALTER TABLE `tombstone_evento_assistencial` ENABLE KEYS */;
