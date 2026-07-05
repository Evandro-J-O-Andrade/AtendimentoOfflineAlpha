# MD-venda_pagamento-colunas — Colunas

## Tabela: `venda_pagamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_venda_pagamento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_venda` | bigint | NOT NULL |
| `id_forma_pagamento` | int | NOT NULL |
| `valor` | decimal(10,2) | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_venda_pagamento`),
KEY `idx_vp_venda` (`id_venda`),
KEY `fk_vp_forma` (`id_forma_pagamento`),
CONSTRAINT `fk_vp_forma` FOREIGN KEY (`id_forma_pagamento`) REFERENCES `forma_pagamento` (`id_forma_pagamento`),
CONSTRAINT `fk_vp_venda` FOREIGN KEY (`id_venda`) REFERENCES `venda` (`id_venda`)
/*!40000 ALTER TABLE `venda_pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda_pagamento` ENABLE KEYS */;
