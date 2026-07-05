# MD-cat_evento-colunas — Colunas

## Tabela: `cat_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cat_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_cat` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `evento` | varchar(50) | NOT NULL |
| `payload_json` | json | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_cat_evento`),
KEY `ix_cat_evento_cat` (`id_cat`),
KEY `ix_cat_evento_evt` (`evento`)
/*!40000 ALTER TABLE `cat_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_evento` ENABLE KEYS */;
