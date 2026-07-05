# MD-estoque_saldo_central-colunas — Colunas

## Tabela: `estoque_saldo_central`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_saldo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local` | bigint | NOT NULL |
| `id_item` | bigint | NOT NULL |
| `id_lote` | bigint | NOT NULL |
| `qtd_fisica` | decimal(15,4) | NOT NULL DEFAULT '0.0000' |
| `qtd_reservada` | decimal(15,4) | NOT NULL DEFAULT '0.0000' |
| `qtd_projetada` | decimal(15,4) | GENERATED ALWAYS AS ((`qtd_fisica` - `qtd_reservada`)) STORED |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_saldo`),
UNIQUE KEY `uk_central_his` (`id_unidade`,`id_local`,`id_item`,`id_lote`),
KEY `idx_central_lock` (`id_item`,`id_local`,`id_lote`),
KEY `fk_central_lote` (`id_lote`),
CONSTRAINT `fk_central_item` FOREIGN KEY (`id_item`) REFERENCES `estoque_item` (`id_item`),
CONSTRAINT `fk_central_lote` FOREIGN KEY (`id_lote`) REFERENCES `estoque_lote` (`id_lote`),
CONSTRAINT `fk_estoque_saldo_central_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `estoque_saldo_central` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_saldo_central` ENABLE KEYS */;
