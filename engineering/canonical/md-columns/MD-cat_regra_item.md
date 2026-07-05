# MD-cat_regra_item-colunas — Colunas

## Tabela: `cat_regra_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cat_regra` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo_sigtap` | varchar(30) | DEFAULT NULL |
| `descricao` | varchar(255) | DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_cat_regra`),
UNIQUE KEY `uk_cat_regra_sigtap` (`codigo_sigtap`)
/*!40000 ALTER TABLE `cat_regra_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_regra_item` ENABLE KEYS */;
