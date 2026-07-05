# MD-cidade-colunas — Colunas

## Tabela: `cidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_cidade` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(150) | NOT NULL |
| `estado` | varchar(10) | NOT NULL |
| `codigo_ibge` | varchar(10) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_cidade`),
KEY `idx_cidade_entidade` (`id_entidade`),
KEY `idx_cidade_ibge` (`codigo_ibge`),
CONSTRAINT `fk_cidade_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `cidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `cidade` ENABLE KEYS */;
