# MD-pdv_venda-colunas — Colunas

## Tabela: `pdv_venda`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_venda` | bigint | NOT NULL AUTO_INCREMENT |
| `id_estoque_local` | bigint | NOT NULL |
| `id_cliente` | bigint | DEFAULT NULL |
| `id_codigo_universal` | bigint | DEFAULT NULL |
| `codigo` | varchar(60) | DEFAULT NULL |
| `barcode` | varchar(60) | DEFAULT NULL |
| `status` | enum('ABERTA','PAGA','CANCELADA') | NOT NULL DEFAULT 'ABERTA' |
| `total_bruto` | decimal(14,2) | NOT NULL DEFAULT '0.00' |
| `desconto` | decimal(14,2) | NOT NULL DEFAULT '0.00' |
| `total_liquido` | decimal(14,2) | NOT NULL DEFAULT '0.00' |
| `id_sessao_usuario` | bigint | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `pago_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_venda`),
KEY `ix_venda_status` (`status`),
KEY `ix_venda_cliente` (`id_cliente`),
KEY `fk_pdv_venda_local` (`id_estoque_local`),
KEY `fk_pdv_venda_sessao` (`id_sessao_usuario`),
KEY `fk_pdv_venda_codigo` (`id_codigo_universal`),
CONSTRAINT `fk_pdv_venda_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT `fk_pdv_venda_codigo` FOREIGN KEY (`id_codigo_universal`) REFERENCES `codigo_universal` (`id_codigo`) ON DELETE SET NULL ON UPDATE CASCADE,
CONSTRAINT `fk_pdv_venda_local` FOREIGN KEY (`id_estoque_local`) REFERENCES `estoque_local` (`id_estoque_local`) ON DELETE RESTRICT ON UPDATE CASCADE
/*!40000 ALTER TABLE `pdv_venda` DISABLE KEYS */;
/*!40000 ALTER TABLE `pdv_venda` ENABLE KEYS */;
