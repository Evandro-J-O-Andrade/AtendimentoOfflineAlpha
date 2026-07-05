# MD-fila_retorno-colunas — Colunas

## Tabela: `fila_retorno`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_fila` | bigint | NOT NULL |
| `retorno_em` | datetime | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `id_fila` (`id_fila`),
CONSTRAINT `fila_retorno_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
/*!40000 ALTER TABLE `fila_retorno` DISABLE KEYS */;
/*!40000 ALTER TABLE `fila_retorno` ENABLE KEYS */;
