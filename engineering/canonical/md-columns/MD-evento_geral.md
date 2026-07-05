# MD-evento_geral-colunas — Colunas

## Tabela: `evento_geral`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `dominio` | varchar(50) | NOT NULL |
| `tipo_evento` | varchar(100) | NOT NULL |
| `id_referencia` | bigint | DEFAULT NULL |
| `payload` | json | DEFAULT NULL |
| `metadata` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_usuario` (`id_usuario`),
KEY `idx_unidade` (`id_unidade`),
KEY `idx_dominio_tipo` (`dominio`,`tipo_evento`),
KEY `idx_referencia` (`id_referencia`),
CONSTRAINT `fk_evento_geral_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `evento_geral` DISABLE KEYS */;
/*!40000 ALTER TABLE `evento_geral` ENABLE KEYS */;
