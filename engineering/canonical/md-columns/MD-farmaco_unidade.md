# MD-farmaco_unidade-colunas — Colunas

## Tabela: `farmaco_unidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_farmaco` | bigint | NOT NULL |
| `id_cidade` | bigint | NOT NULL |
| `cota_minima` | int | NOT NULL DEFAULT '0' |
| `cota_maxima` | int | DEFAULT NULL |
| `atualizado_por` | bigint | NOT NULL |
| `atualizado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_farmaco`,`id_cidade`),
CONSTRAINT `fk_fu_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`)
/*!40000 ALTER TABLE `farmaco_unidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmaco_unidade` ENABLE KEYS */;
