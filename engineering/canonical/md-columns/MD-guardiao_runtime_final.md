# MD-guardiao_runtime_final-colunas — Colunas

## Tabela: `guardiao_runtime_final`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_guardiao` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_runtime` | char(36) | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `hash_contexto` | char(64) | NOT NULL |
| `estado_permitido` | tinyint(1) | DEFAULT '1' |
| `motivo_bloqueio` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_guardiao`),
KEY `idx_guardiao_uuid` (`uuid_runtime`),
KEY `idx_guardiao_estado` (`estado_permitido`),
KEY `fk_guardiao_runtime_final_unidade` (`id_unidade`),
KEY `fk_guardiao_runtime_final_entidade` (`id_entidade`),
CONSTRAINT `fk_guardiao_runtime_final_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_guardiao_runtime_final_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `guardiao_runtime_final` DISABLE KEYS */;
/*!40000 ALTER TABLE `guardiao_runtime_final` ENABLE KEYS */;
