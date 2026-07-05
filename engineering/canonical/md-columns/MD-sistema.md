# MD-sistema-colunas — Colunas

## Tabela: `sistema`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sistema` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(120) | NOT NULL |
| `codigo` | varchar(50) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_sistema`)
/*!40000 ALTER TABLE `sistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `sistema` ENABLE KEYS */;
