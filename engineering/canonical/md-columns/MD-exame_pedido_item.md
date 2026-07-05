# MD-exame_pedido_item-colunas — Colunas

## Tabela: `exame_pedido_item`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_item` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pedido` | bigint | NOT NULL |
| `codigo_procedimento` | varchar(20) | DEFAULT NULL |
| `nome_exame` | varchar(150) | DEFAULT NULL |
| `material` | varchar(50) | DEFAULT NULL |
| `valor_custo` | decimal(10,2) | DEFAULT '0.00' |
| `valor_venda` | decimal(10,2) | DEFAULT '0.00' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_item`),
KEY `fk_item_pedido` (`id_pedido`),
CONSTRAINT `fk_item_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `exame_pedido` (`id_pedido`)
/*!40000 ALTER TABLE `exame_pedido_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame_pedido_item` ENABLE KEYS */;
