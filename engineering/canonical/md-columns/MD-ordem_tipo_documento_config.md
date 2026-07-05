# MD-ordem_tipo_documento_config-colunas — Colunas

## Tabela: `ordem_tipo_documento_config`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `tipo_ordem` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `tipo_documento` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `somente_controlado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `somente_nao_controlado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`tipo_ordem`,`tipo_documento`),
KEY `fk_ordem_doc_tipo` (`tipo_documento`),
CONSTRAINT `fk_ordem_doc_tipo` FOREIGN KEY (`tipo_documento`) REFERENCES `documento_tipo_config` (`codigo`)
/*!40000 ALTER TABLE `ordem_tipo_documento_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `ordem_tipo_documento_config` ENABLE KEYS */;
