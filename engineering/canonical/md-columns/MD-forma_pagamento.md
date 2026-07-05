# MD-forma_pagamento-colunas — Colunas

## Tabela: `forma_pagamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_forma_pagamento` | int | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(30) | NOT NULL |
| `descricao` | varchar(80) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_forma_pagamento`),
UNIQUE KEY `uk_fp_codigo` (`codigo`)
/*!40000 ALTER TABLE `forma_pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `forma_pagamento` ENABLE KEYS */;
