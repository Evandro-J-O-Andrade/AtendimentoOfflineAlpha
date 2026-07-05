# MD-unidade-colunas — Colunas

## Tabela: `unidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_unidade` | bigint | unsigned NOT NULL AUTO_INCREMENT |
| `id_entidade` | bigint | unsigned NOT NULL |
| `id_cidade` | bigint | DEFAULT NULL |
| `nome` | varchar(200) | DEFAULT NULL |
| `tipo` | varchar(100) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |

---

## Índices

PRIMARY KEY (`id_unidade`),
KEY `idx_unidade_entidade` (`id_entidade`),
KEY `idx_unidade_cidade` (`id_cidade`),
CONSTRAINT `fk_unidade_cidade` FOREIGN KEY (`id_cidade`) REFERENCES `cidade` (`id_cidade`),
CONSTRAINT `fk_unidade_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `unidade` ENABLE KEYS */;
