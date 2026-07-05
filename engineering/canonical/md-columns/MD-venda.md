# MD-venda-colunas — Colunas

## Tabela: `venda`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_venda` | bigint | NOT NULL AUTO_INCREMENT |
| `id_caixa` | bigint | NOT NULL |
| `id_cliente` | bigint | DEFAULT NULL |
| `origem` | enum('PDV_RUA','ATENDIMENTO_INTERNO') | NOT NULL DEFAULT 'PDV_RUA' |
| `status` | enum('ABERTA','PAGA','CANCELADA') | NOT NULL DEFAULT 'ABERTA' |
| `total_itens` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `total_desconto` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `total_final` | decimal(10,2) | NOT NULL DEFAULT '0.00' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `pago_em` | datetime | DEFAULT NULL |
| `cancelado_em` | datetime | DEFAULT NULL |
| `criado_por` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_venda`),
KEY `idx_venda_status` (`status`,`criado_em`),
KEY `fk_venda_caixa` (`id_caixa`),
KEY `fk_venda_cliente` (`id_cliente`),
KEY `fk_venda_criado_por` (`criado_por`),
CONSTRAINT `fk_venda_caixa` FOREIGN KEY (`id_caixa`) REFERENCES `caixa` (`id_caixa`),
CONSTRAINT `fk_venda_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
CONSTRAINT `fk_venda_criado_por` FOREIGN KEY (`criado_por`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `venda` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda` ENABLE KEYS */;
