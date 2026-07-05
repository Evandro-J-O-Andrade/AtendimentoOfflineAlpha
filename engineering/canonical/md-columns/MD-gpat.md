# MD-gpat-colunas — Colunas

## Tabela: `gpat`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_gpat` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `id_codigo_universal` | bigint | NOT NULL |
| `codigo_gpat` | varchar(50) | NOT NULL |
| `barcode_gpat` | varchar(60) | NOT NULL |
| `origem` | enum('AUTO','MANUAL') | NOT NULL DEFAULT 'AUTO' |
| `observacao` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `atualizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_gpat`),
UNIQUE KEY `uk_gpat_ffa` (`id_ffa`),
UNIQUE KEY `uk_gpat_codigo` (`codigo_gpat`),
UNIQUE KEY `uk_gpat_codigo_universal` (`id_codigo_universal`)
/*!40000 ALTER TABLE `gpat` DISABLE KEYS */;
/*!40000 ALTER TABLE `gpat` ENABLE KEYS */;
