# MD-estoque_lote-colunas — Colunas

## Tabela: `estoque_lote`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_lote` | bigint | NOT NULL AUTO_INCREMENT |
| `id_item` | bigint | NOT NULL |
| `numero_lote` | varchar(100) | NOT NULL |
| `data_validade` | date | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_lote`),
KEY `fk_lote_item` (`id_item`),
CONSTRAINT `fk_lote_item` FOREIGN KEY (`id_item`) REFERENCES `estoque_item` (`id_item`)
/*!40000 ALTER TABLE `estoque_lote` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_lote` ENABLE KEYS */;
