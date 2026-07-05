# MD-identificador_global_assistencial-colunas — Colunas

## Tabela: `identificador_global_assistencial`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_global` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_assistencial` | char(36) | NOT NULL |
| `tipo_entidade` | varchar(60) | NOT NULL |
| `hash_imutavel` | char(64) | NOT NULL |
| `origem_runtime` | varchar(120) | NOT NULL |
| `bloqueado` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_global`),
UNIQUE KEY `uk_global_uuid` (`uuid_assistencial`),
KEY `idx_global_tipo` (`tipo_entidade`)
/*!40000 ALTER TABLE `identificador_global_assistencial` DISABLE KEYS */;
/*!40000 ALTER TABLE `identificador_global_assistencial` ENABLE KEYS */;
