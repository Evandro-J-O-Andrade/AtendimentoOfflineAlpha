# MD-cliente-colunas — Colunas

## Tabela: `cliente`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cliente` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(255) | NOT NULL |
| `documento` | varchar(30) | DEFAULT NULL |
| `telefone` | varchar(30) | DEFAULT NULL |
| `email` | varchar(150) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_cliente`),
UNIQUE KEY `uk_cliente_doc` (`documento`),
KEY `idx_cliente_nome` (`nome`)
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
