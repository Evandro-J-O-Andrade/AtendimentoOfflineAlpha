# MD-coordenador_estado_global-colunas — Colunas

## Tabela: `coordenador_estado_global`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_coordenacao` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_runtime` | char(36) | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `estado_atual` | varchar(80) | NOT NULL |
| `hash_estado` | char(64) | NOT NULL |
| `payload_snapshot` | json | DEFAULT NULL |
| `bloqueado` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_coordenacao`),
KEY `idx_coord_uuid` (`uuid_runtime`),
KEY `idx_coord_estado` (`estado_atual`),
KEY `fk_coordenador_estado_global_unidade` (`id_unidade`),
KEY `fk_coordenador_estado_global_entidade` (`id_entidade`),
CONSTRAINT `fk_coordenador_estado_global_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_coordenador_estado_global_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `coordenador_estado_global` DISABLE KEYS */;
/*!40000 ALTER TABLE `coordenador_estado_global` ENABLE KEYS */;
