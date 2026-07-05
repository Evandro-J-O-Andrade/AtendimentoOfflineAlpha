# MD-painel_evento_stream-colunas — Colunas

## Tabela: `painel_evento_stream`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio` | varchar(50) | NOT NULL |
| `tipo_evento` | varchar(50) | NOT NULL |
| `id_referencia` | bigint | NOT NULL |
| `id_painel` | bigint | DEFAULT NULL |
| `id_lane` | bigint | DEFAULT NULL |
| `id_local` | bigint | DEFAULT NULL |
| `payload` | json | NOT NULL |
| `processado` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_painel` (`id_painel`,`processado`),
KEY `idx_ref` (`id_referencia`),
KEY `idx_stream` (`processado`,`criado_em`)
/*!40000 ALTER TABLE `painel_evento_stream` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_evento_stream` ENABLE KEYS */;
