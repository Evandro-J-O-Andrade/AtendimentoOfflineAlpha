# MD-estoque_movimentacao-colunas — Colunas

## Tabela: `estoque_movimentacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_movimentacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_saldo` | bigint | NOT NULL |
| `tipo_movimento` | enum('ENTRADA','SAIDA','AJUSTE','TRANSFERENCIA','RESERVA','LIBERACAO_RESERVA') | NOT NULL |
| `origem_modulo` | enum('FARMACIA','FATURAMENTO','TI','MANUTENCAO','GASO','FISIO','SUTURA','CUIDADOS','OUTRO') | NOT NULL |
| `id_origem` | bigint | DEFAULT NULL |
| `quantidade` | decimal(14,3) | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `confirmado` | tinyint(1) | NOT NULL DEFAULT '0' |
| `confirmado_em` | datetime | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_movimentacao`),
KEY `fk_mov_saldo` (`id_saldo`),
CONSTRAINT `fk_mov_saldo` FOREIGN KEY (`id_saldo`) REFERENCES `estoque_produto_saldo` (`id_saldo`)
/*!40000 ALTER TABLE `estoque_movimentacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_movimentacao` ENABLE KEYS */;
