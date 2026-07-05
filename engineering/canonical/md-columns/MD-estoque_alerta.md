# MD-estoque_alerta-colunas — Colunas

## Tabela: `estoque_alerta`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_alerta` | bigint | NOT NULL AUTO_INCREMENT |
| `id_saldo` | bigint | NOT NULL |
| `tipo_alerta` | enum('BAIXO','CRITICO','VENCIMENTO_PROXIMO') | NOT NULL |
| `gerado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `resolvido` | tinyint(1) | DEFAULT '0' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_alerta`),
KEY `fk_alerta_saldo` (`id_saldo`),
CONSTRAINT `fk_alerta_saldo` FOREIGN KEY (`id_saldo`) REFERENCES `estoque_produto_saldo` (`id_saldo`)
/*!40000 ALTER TABLE `estoque_alerta` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_alerta` ENABLE KEYS */;
