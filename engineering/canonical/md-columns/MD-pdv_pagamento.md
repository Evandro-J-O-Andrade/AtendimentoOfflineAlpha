# MD-pdv_pagamento-colunas — Colunas

## Tabela: `pdv_pagamento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pagamento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_venda` | bigint | NOT NULL |
| `forma` | enum('DINHEIRO','DEBITO','CREDITO','PIX','CONVENIO','OUTRO') | NOT NULL |
| `valor` | decimal(14,2) | NOT NULL |
| `nsu` | varchar(80) | DEFAULT NULL |
| `autorizacao` | varchar(80) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pagamento`),
KEY `ix_pag_venda` (`id_venda`),
CONSTRAINT `fk_pdv_pag_venda` FOREIGN KEY (`id_venda`) REFERENCES `pdv_venda` (`id_venda`) ON DELETE CASCADE ON UPDATE CASCADE
/*!40000 ALTER TABLE `pdv_pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_pagamento` ENABLE KEYS */;
