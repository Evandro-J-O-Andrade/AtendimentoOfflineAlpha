# MD-estoque_movimento-colunas — Colunas

## Tabela: `estoque_movimento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_movimento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_item` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_origem` | bigint | DEFAULT NULL |
| `id_local_destino` | bigint | DEFAULT NULL |
| `id_lote` | bigint | NOT NULL |
| `tipo_movimento` | enum('ENTRADA','SAIDA','TRANSFERENCIA','CONSUMO','VENDA','AJUSTE') | NOT NULL |
| `quantidade` | decimal(15,4) | NOT NULL |
| `hash_duplicidade` | char(64) | DEFAULT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_movimento`),
UNIQUE KEY `hash_duplicidade` (`hash_duplicidade`),
KEY `fk_estq_mov_item_ref` (`id_item`),
KEY `fk_estq_mov_lote_ref` (`id_lote`),
KEY `fk_estoque_movimento_unidade` (`id_unidade`),
CONSTRAINT `fk_estoque_movimento_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_estq_mov_item_ref` FOREIGN KEY (`id_item`) REFERENCES `estoque_item` (`id_item`),
CONSTRAINT `fk_estq_mov_lote_ref` FOREIGN KEY (`id_lote`) REFERENCES `estoque_lote` (`id_lote`)
/*!40000 ALTER TABLE `estoque_movimento` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_movimento` ENABLE KEYS */;
