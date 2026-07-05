# MD-lab_evento-colunas — Colunas

## Tabela: `lab_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pedido` | bigint | NOT NULL |
| `status_novo` | varchar(50) | DEFAULT NULL |
| `id_usuario` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_evento_lab_pedido` (`id_pedido`),
CONSTRAINT `fk_evento_lab_pedido` FOREIGN KEY (`id_pedido`) REFERENCES `lab_pedido` (`id_pedido`)
/*!40000 ALTER TABLE `lab_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `lab_evento` ENABLE KEYS */;
