# MD-pdv_cliente-colunas — Colunas

## Tabela: `pdv_cliente`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cliente` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(255) | NOT NULL |
| `documento` | varchar(30) | DEFAULT NULL |
| `telefone` | varchar(40) | DEFAULT NULL |
| `email` | varchar(120) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_cliente`),
KEY `ix_cliente_doc` (`documento`)
/*!40000 ALTER TABLE `pdv_cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_cliente` ENABLE KEYS */;
